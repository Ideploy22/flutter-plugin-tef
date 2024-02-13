import 'dart:convert';

class ConfigureTEFEntity {
  final String applicationName;
  final String applicationVersion;
  final String pinPadText;
  final String document;

  ConfigureTEFEntity({
    required this.applicationName,
    required this.applicationVersion,
    required this.document,
    required this.pinPadText,
  });

  String toRequest() {
    return jsonEncode({
      'applicationName': applicationName,
      'applicationVersion': applicationVersion,
      'pinPadText': pinPadText,
      'document': document,
    });
  }
}
