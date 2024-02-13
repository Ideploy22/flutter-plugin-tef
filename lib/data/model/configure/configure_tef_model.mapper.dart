part of 'configure_tef_model.dart';

ConfigureTEFModel _$ConfigureTEFModelFromEntity(ConfigureTEFEntity entity) =>
    ConfigureTEFModel(
      applicationName: entity.applicationName,
      applicationVersion: entity.applicationVersion,
      document: entity.document,
      pinPadText: entity.pinPadText,
    );

ConfigureTEFEntity _$ConfigureTEFModelToEntity(ConfigureTEFModel model) =>
    ConfigureTEFEntity(
      applicationName: model.applicationName,
      applicationVersion: model.applicationVersion,
      document: model.document,
      pinPadText: model.pinPadText,
    );
