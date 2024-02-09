import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_response.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment_data_entity.dart';
import 'package:flutter_plugin_tef_integration/flutter_plugin_tef_integration.dart';
import 'package:flutter_plugin_tef_integration/flutter_plugin_tef_integration_method_channel.dart';
import 'package:flutter_plugin_tef_integration/flutter_plugin_tef_integration_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPluginTefIntegrationPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPluginTefIntegrationPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> configure(ConfigureTEFEntity params) => Future.value();

  @override
  Future<void> pay(PaymentDataEntity data) => Future.value();

  @override
  Future<void> initialize() => Future.value();

  @override
  Stream<ConfigureTEFResponse> get configureStream =>
      throw UnimplementedError();
}

void main() {
  final FlutterPluginTefIntegrationPlatform initialPlatform =
      FlutterPluginTefIntegrationPlatform.instance;

  test('$MethodChannelFlutterPluginTefIntegration is the default instance', () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelFlutterPluginTefIntegration>());
  });

  test('getPlatformVersion', () async {
    FlutterPluginTefIntegration flutterPluginTefIntegrationPlugin =
        FlutterPluginTefIntegration();
    MockFlutterPluginTefIntegrationPlatform fakePlatform =
        MockFlutterPluginTefIntegrationPlatform();
    FlutterPluginTefIntegrationPlatform.instance = fakePlatform;

    expect(await flutterPluginTefIntegrationPlugin.getPlatformVersion(), '42');
  });
}
