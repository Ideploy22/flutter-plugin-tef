import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_entity.dart';
import 'package:ideploy_package/ideploy_package.dart';

abstract class TefRepository {
  Future<EitherOf<Failure, ConfigureTEFEntity?>> getConfigurationData();

  Future<EitherOf<Failure, VoidSuccess>> saveConfigurationData(
      ConfigureTEFEntity data);
}
