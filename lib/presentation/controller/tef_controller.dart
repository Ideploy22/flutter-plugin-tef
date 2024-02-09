import 'dart:async';
import 'dart:convert';

import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_response.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/constants.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/tef_global_response.dart';
import 'package:flutter_plugin_tef_integration/domain/use_case/get_configuration.dart';
import 'package:flutter_plugin_tef_integration/domain/use_case/save_configuration.dart';
import 'package:ideploy_package/ideploy_package.dart';

@lazySingleton
class TefController {
  final GetConfigurationUseCase _getConfigurationUseCase;
  final SaveConfigurationUseCase _saveConfigurationUseCase;

  TefController({
    required GetConfigurationUseCase getConfigurationUseCase,
    required SaveConfigurationUseCase saveConfigurationUseCase,
  })  : _getConfigurationUseCase = getConfigurationUseCase,
        _saveConfigurationUseCase = saveConfigurationUseCase;

  final StreamController<ConfigureTEFResponse> _configurationStreamController =
      StreamController<ConfigureTEFResponse>.broadcast();
  Stream<ConfigureTEFResponse> get configureStream =>
      _configurationStreamController.stream;

  Future<ConfigureTEFEntity?> getConfigurationData() async {
    final EitherOf<Failure, ConfigureTEFEntity?> response =
        await _getConfigurationUseCase.call();
    return response.get((_) => null, (ConfigureTEFEntity? data) => data);
  }

  void _handleConfigureEvents(Map<String, dynamic> json) {
    final ConfigureTEFResponse response = ConfigureTEFResponse(
      type: TefResponseType.values.firstWhere(
        (TefResponseType element) => element.what == json['what'],
        orElse: () => TefResponseType.unknown,
      ),
      message: (json['message'] ?? '').split(' - ')[0],
    );

    print('[RESPONSE]: ${response.type} - ${response.message}');
    _configurationStreamController.add(response);
  }

  Future<void> handleEvent(String event) async {
    final Map<String, dynamic> json = jsonDecode(event);
    final TEFEvent tefEvent = TEFEvent.values.firstWhere(
        (TEFEvent event) => event.name == json['type'],
        orElse: () => TEFEvent.unknown);

    final Map<TEFEvent, Function()> callToAction = <TEFEvent, Function()>{
      TEFEvent.configure: () => _handleConfigureEvents(json['data']),
    };

    if (callToAction[tefEvent] != null) {
      callToAction[tefEvent]!();
    }
  }
}
