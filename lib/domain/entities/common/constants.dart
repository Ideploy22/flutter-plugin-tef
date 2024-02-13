enum TefConstants {
  nameSpace('br.ideploy.tef.integration.flutter_plugin_tef_integration'),
  methods('methods'),
  eventChannelId('events');

  final String value;

  const TefConstants(this.value);
}

enum TEFEvent {
  configure('configure'),
  pay('pay'),
  unknown('unknown');

  final String event;
  const TEFEvent(this.event);
}
