import 'package:flutter_plugin_tef_integration/domain/entities/tef_global_response.dart';

class ConfigureTEFResponse {
  final TefResponseType type;
  final String message;

  ConfigureTEFResponse({
    required this.type,
    required this.message,
  });

  bool get doneWithSuccess =>
      type == TefResponseType.done && !message.contains('CANCELADA');
}
