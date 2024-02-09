// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configure_tef_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigureTEFModel _$ConfigureTEFModelFromJson(Map json) => ConfigureTEFModel(
      applicationName: json['applicationName'] as String,
      applicationVersion: json['applicationVersion'] as String,
      document: json['document'] as String,
      pinPadText: json['pinPadText'] as String,
    );

Map<String, dynamic> _$ConfigureTEFModelToJson(ConfigureTEFModel instance) =>
    <String, dynamic>{
      'applicationName': instance.applicationName,
      'applicationVersion': instance.applicationVersion,
      'pinPadText': instance.pinPadText,
      'document': instance.document,
    };
