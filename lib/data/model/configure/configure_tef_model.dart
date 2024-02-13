import 'package:flutter_plugin_tef_integration/domain/entities/configure/configure_tef_entity.dart';
import 'package:ideploy_package/ideploy_package.dart';

part 'configure_tef_model.g.dart';
part 'configure_tef_model.mapper.dart';

@JsonSerializable(anyMap: true)
class ConfigureTEFModel extends ConfigureTEFEntity {
  ConfigureTEFModel({
    required super.applicationName,
    required super.applicationVersion,
    required super.document,
    required super.pinPadText,
  });

  factory ConfigureTEFModel.fromJson(Map<String, dynamic> json) =>
      _$ConfigureTEFModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigureTEFModelToJson(this);

  factory ConfigureTEFModel.fromEntity(ConfigureTEFEntity entity) =>
      _$ConfigureTEFModelFromEntity(entity);

  ConfigureTEFEntity toEntity() => _$ConfigureTEFModelToEntity(this);
}
