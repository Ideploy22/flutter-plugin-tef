import 'package:flutter_plugin_tef_integration/domain/entities/configure/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/payment_response.dart';
import 'package:ideploy_package/ideploy_package.dart';

abstract class TefRepository {
  Future<EitherOf<Failure, ConfigureTEFEntity?>> getConfigurationData();

  Future<EitherOf<Failure, VoidSuccess>> saveConfigurationData(
      ConfigureTEFEntity data);

  EitherOf<Failure, PaymentResponseEntity> getPaymentResponseFromString(
      String data);
}
