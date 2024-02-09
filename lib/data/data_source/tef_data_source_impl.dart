import 'package:flutter_plugin_tef_integration/data/data_source/tef_data_source.dart';
import 'package:flutter_plugin_tef_integration/data/model/configure_tef_model.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_entity.dart';
import 'package:ideploy_package/ideploy_package.dart';

@Injectable(as: TefDataSource)
class TefDataSourceImpl implements TefDataSource {
  final HiveInterface _hive;

  TefDataSourceImpl({required HiveInterface hive}) : _hive = hive;

  Future<void> _openBox() async {
    if (!Hive.isBoxOpen('pos_integration_box')) {
      await Hive.initFlutter();
      await Hive.openBox('pos_integration_box');
    }
  }

  @override
  Future<ConfigureTEFEntity?> getConfigurations() async {
    try {
      await _openBox();
      final json = await _hive.box('pos_integration_box').get('configuration');
      if (json == null) {
        return null;
      }

      return ConfigureTEFModel.fromJson(Map.from(json)).toEntity();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> saveCredentials(ConfigureTEFEntity data) async {
    try {
      await _openBox();
      final credentialModel = ConfigureTEFModel.fromEntity(data);
      await Hive.box('pos_integration_box')
          .put('configuration', credentialModel.toJson());
    } catch (error) {
      rethrow;
    }
  }
}
