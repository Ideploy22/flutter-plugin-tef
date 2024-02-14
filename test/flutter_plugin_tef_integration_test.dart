import 'package:flutter_plugin_tef_integration/domain/entities/common/tef_response.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/payment_data_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/tef_payment_response.dart';
import 'package:flutter_plugin_tef_integration/flutter_plugin_tef_integration.dart';
import 'package:flutter_plugin_tef_integration/flutter_plugin_tef_integration_method_channel.dart';
import 'package:flutter_plugin_tef_integration/flutter_plugin_tef_integration_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ideploy_package/domain/entities/either_of/either_of.dart';
import 'package:ideploy_package/domain/entities/failure/failure.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPluginTefIntegrationPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPluginTefIntegrationPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<EitherOf<Failure, VoidSuccess>> configure(ConfigureTEFEntity params) =>
      Future.value(resolve(voidSuccess));

  @override
  Future<void> pay(PaymentDataEntity data) => Future.value();

  @override
  Future<void> initialize() => Future.value();

  @override
  Stream<TEFResponseEntity> get configureStream => throw UnimplementedError();

  @override
  Stream<TEFPaymentResponseEntity> get paymentStream =>
      throw UnimplementedError();

  @override
  Future<EitherOf<Failure, ConfigureTEFEntity?>> getConfigurationData() =>
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
    final FlutterPluginTefIntegration flutterPluginTefIntegrationPlugin =
        FlutterPluginTefIntegration();
    final MockFlutterPluginTefIntegrationPlatform fakePlatform =
        MockFlutterPluginTefIntegrationPlatform();
    FlutterPluginTefIntegrationPlatform.instance = fakePlatform;

    expect(await flutterPluginTefIntegrationPlugin.getPlatformVersion(), '42');
  });
}
