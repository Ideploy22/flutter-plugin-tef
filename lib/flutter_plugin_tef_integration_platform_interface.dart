import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_response.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment_data_entity.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_plugin_tef_integration_method_channel.dart';

abstract class FlutterPluginTefIntegrationPlatform extends PlatformInterface {
  FlutterPluginTefIntegrationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPluginTefIntegrationPlatform _instance =
      MethodChannelFlutterPluginTefIntegration();

  static FlutterPluginTefIntegrationPlatform get instance => _instance;

  static set instance(FlutterPluginTefIntegrationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<ConfigureTEFResponse> get configureStream => throw UnimplementedError(
      'configure stream response has not been implemented.');

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initialize() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> configure(ConfigureTEFEntity params) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> pay(PaymentDataEntity data) {
    throw UnimplementedError('initialize() has not been implemented.');
  }
}
