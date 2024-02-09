import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_entity.dart';

abstract class TefDataSource {
  Future<ConfigureTEFEntity?> getConfigurations();
  Future<void> saveCredentials(ConfigureTEFEntity data);
}
