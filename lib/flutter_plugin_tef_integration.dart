import 'package:flutter_plugin_tef_integration/domain/entities/common/tef_response.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/payment_data_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/tef_payment_response.dart';
import 'package:ideploy_package/ideploy_package.dart';

import 'flutter_plugin_tef_integration_platform_interface.dart';

class FlutterPluginTefIntegration {
  Stream<TEFResponseEntity> get configureStream =>
      FlutterPluginTefIntegrationPlatform.instance.configureStream;

  Stream<TEFPaymentResponseEntity> get paymentStream =>
      FlutterPluginTefIntegrationPlatform.instance.paymentStream;

  Future<String?> getPlatformVersion() {
    return FlutterPluginTefIntegrationPlatform.instance.getPlatformVersion();
  }

  Future<void> initialize() {
    return FlutterPluginTefIntegrationPlatform.instance.initialize();
  }

  Future<EitherOf<Failure, VoidSuccess>> configure(ConfigureTEFEntity params) {
    return FlutterPluginTefIntegrationPlatform.instance.configure(params);
  }

  Future<EitherOf<Failure, ConfigureTEFEntity?>> getConfigurationData() {
    return FlutterPluginTefIntegrationPlatform.instance.getConfigurationData();
  }

  Future<void> pay(PaymentDataEntity data) {
    return FlutterPluginTefIntegrationPlatform.instance.pay(data);
  }
}
