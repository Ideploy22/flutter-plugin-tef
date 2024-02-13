import 'package:flutter_plugin_tef_integration/domain/entities/configure/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/payment_response.dart';

abstract class TefDataSource {
  Future<ConfigureTEFEntity?> getConfigurations();
  Future<void> saveCredentials(ConfigureTEFEntity data);
  PaymentResponseEntity getPaymentResponseFromString(String data);
}
