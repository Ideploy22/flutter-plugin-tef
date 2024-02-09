import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_tef_integration/di/injectable.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_response.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment_data_entity.dart';
import 'package:flutter_plugin_tef_integration/presentation/controller/tef_controller.dart';

import 'di/injectable.dart' as di;
import 'domain/entities/constants.dart';
import 'flutter_plugin_tef_integration_platform_interface.dart';

class MethodChannelFlutterPluginTefIntegration
    extends FlutterPluginTefIntegrationPlatform {
  @visibleForTesting
  final MethodChannel methodChannel = MethodChannel(
    '${TefConstants.nameSpace.value}/${TefConstants.methods.value}',
  );

  @visibleForTesting
  EventChannel eventChannel = EventChannel(
    '${TefConstants.nameSpace.value}/${TefConstants.eventChannelId.value}',
  );

  void _initializeLocatorIfNeeded() async {
    if (!locator.isRegistered<TefController>()) {
      di.init();
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  void _mapEventToState(dynamic data) {
    if (data.runtimeType == String) {
      print('***************************');
      print(data);
      print('***************************\n\n');

      _initializeLocatorIfNeeded();
      final TefController posController = locator<TefController>();
      posController.handleEvent(data);
    }
  }

  @override
  Future<void> initialize() async {
    _initializeLocatorIfNeeded();
    eventChannel
        .receiveBroadcastStream()
        .listen((dynamic event) => _mapEventToState(event));
  }

  @override
  Future<void> configure(ConfigureTEFEntity params) async {
    _initializeLocatorIfNeeded();
    await methodChannel.invokeMethod<String>('configure', params.toRequest());
  }

  @override
  Future<void> pay(PaymentDataEntity data) async {
    await methodChannel.invokeMethod<String>('pay', data.toRequest());
  }

  @override
  Stream<ConfigureTEFResponse> get configureStream {
    _initializeLocatorIfNeeded();
    return locator<TefController>().configureStream;
  }
}
