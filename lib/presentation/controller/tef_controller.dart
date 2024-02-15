import 'dart:async';
import 'dart:convert';

import 'package:flutter_plugin_tef_integration/domain/entities/common/constants.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/common/tef_response.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/payment_response.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/tef_payment_response.dart';
import 'package:flutter_plugin_tef_integration/domain/use_case/configuration/get_configuration.dart';
import 'package:flutter_plugin_tef_integration/domain/use_case/configuration/save_configuration.dart';
import 'package:flutter_plugin_tef_integration/domain/use_case/payment/payment_response_from_string.dart';
import 'package:ideploy_package/ideploy_package.dart';

@lazySingleton
class TefController {
  final GetConfigurationUseCase _getConfigurationUseCase;
  final SaveConfigurationUseCase _saveConfigurationUseCase;
  final GetPaymentResponseFromStringUseCase
      _getPaymentResponseFromStringUseCase;

  TefController({
    required GetConfigurationUseCase getConfigurationUseCase,
    required SaveConfigurationUseCase saveConfigurationUseCase,
    required GetPaymentResponseFromStringUseCase
        getPaymentResponseFromStringUseCase,
  })  : _getConfigurationUseCase = getConfigurationUseCase,
        _saveConfigurationUseCase = saveConfigurationUseCase,
        _getPaymentResponseFromStringUseCase =
            getPaymentResponseFromStringUseCase;

  final StreamController<TEFResponseEntity> _configurationStreamController =
      StreamController<TEFResponseEntity>.broadcast();

  Stream<TEFResponseEntity> get configureStream =>
      _configurationStreamController.stream;

  final StreamController<TEFPaymentResponseEntity> _paymentStreamController =
      StreamController<TEFPaymentResponseEntity>.broadcast();

  Stream<TEFPaymentResponseEntity> get paymentStream =>
      _paymentStreamController.stream;

  Future<ConfigureTEFEntity?> getConfigurationData() async {
    final EitherOf<Failure, ConfigureTEFEntity?> response =
        await _getConfigurationUseCase.call();
    return response.get((_) => null, (ConfigureTEFEntity? data) => data);
  }

  Future<void> saveConfigData(ConfigureTEFEntity data) async {
    final EitherOf<Failure, VoidSuccess> response =
        await _saveConfigurationUseCase.call(data);
    return response.get((_) => throw TefFailure(), (_) => null);
  }

  void _handleConfigureEvents(Map<String, dynamic> json) {
    final TEFResponseEntity response = TEFResponseEntity(
      type: TefResponseType.values.firstWhere(
        (TefResponseType element) => element.what == json['what'],
        orElse: () => TefResponseType.unknown,
      ),
      message: json['message'] ?? '',
    );

    _configurationStreamController.add(response);
  }

  void _handlePaymentEvents(Map<String, dynamic> json) {
    final TefResponseType type = TefResponseType.values.firstWhere(
      (TefResponseType element) => element.what == json['what'],
      orElse: () => TefResponseType.unknown,
    );

    late final TEFPaymentResponseEntity response;
    if (type == TefResponseType.finish) {
      final EitherOf<Failure, PaymentResponseEntity> paymentReceiptResponse =
          _getPaymentResponseFromStringUseCase.call(json['message']);
      paymentReceiptResponse.get((Failure reject) => null,
          (PaymentResponseEntity receipt) {
        response = TEFPaymentResponseEntity(
          type: type,
          message: receipt.message,
          receipt: receipt,
        );
      });
    } else {
      response = TEFPaymentResponseEntity(
        type: type,
        message: json['message'] ?? '',
      );
    }

    _paymentStreamController.add(response);
  }

  Future<void> handleEvent(String event) async {
    final Map<String, dynamic> json = jsonDecode(event);
    final TEFEvent tefEvent = TEFEvent.values.firstWhere(
        (TEFEvent event) => event.name == json['type'],
        orElse: () => TEFEvent.unknown);

    final Map<TEFEvent, Function()> callToAction = <TEFEvent, Function()>{
      TEFEvent.configure: () => _handleConfigureEvents(json['data']),
      TEFEvent.pay: () => _handlePaymentEvents(json['data']),
    };

    if (callToAction[tefEvent] != null) {
      callToAction[tefEvent]!();
    }
  }
}
