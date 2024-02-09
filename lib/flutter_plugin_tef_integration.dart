import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_response.dart';

import 'flutter_plugin_tef_integration_platform_interface.dart';

class FlutterPluginTefIntegration {
  Stream<ConfigureTEFResponse> get configureStream =>
      FlutterPluginTefIntegrationPlatform.instance.configureStream;

  Future<String?> getPlatformVersion() {
    return FlutterPluginTefIntegrationPlatform.instance.getPlatformVersion();
  }

  Future<void> initialize() {
    return FlutterPluginTefIntegrationPlatform.instance.initialize();
  }

  Future<void> configure(ConfigureTEFEntity params) {
    return FlutterPluginTefIntegrationPlatform.instance.configure(params);
  }
}
