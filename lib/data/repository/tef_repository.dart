import 'package:flutter_plugin_tef_integration/data/data_source/tef_data_source.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/payment_response.dart';
import 'package:flutter_plugin_tef_integration/domain/repository/tef_repository.dart';
import 'package:ideploy_package/ideploy_package.dart';

@Injectable(as: TefRepository)
class TefRepositoryImpl implements TefRepository {
  final TefDataSource _dataSource;

  TefRepositoryImpl({required TefDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<EitherOf<Failure, ConfigureTEFEntity?>> getConfigurationData() async {
    try {
      final ConfigureTEFEntity? credentials =
          await _dataSource.getConfigurations();
      return resolve(credentials);
    } catch (error) {
      return reject(TefFailure());
    }
  }

  @override
  Future<EitherOf<Failure, VoidSuccess>> saveConfigurationData(
      ConfigureTEFEntity data) async {
    try {
      await _dataSource.saveCredentials(data);
      return resolve(voidSuccess);
    } catch (error) {
      return reject(PosFailure());
    }
  }

  @override
  EitherOf<Failure, PaymentResponseEntity> getPaymentResponseFromString(
      String data) {
    try {
      return resolve(_dataSource.getPaymentResponseFromString(data));
    } catch (error) {
      return reject(PosFailure());
    }
  }
}
