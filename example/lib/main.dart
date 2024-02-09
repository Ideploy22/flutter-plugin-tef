import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure_tef_response.dart';
import 'package:flutter_plugin_tef_integration/flutter_plugin_tef_integration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _tefPlugin = FlutterPluginTefIntegration();

  StreamSubscription<ConfigureTEFResponse>? configSubs;
  List<ConfigureTEFResponse> configResponses = [];

  @override
  void initState() {
    super.initState();
    initializeTef();
    initPlatformState();
    listenConfigData();
  }

  @override
  void dispose() {
    configSubs?.cancel();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _tefPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text('Running on: $_platformVersion\n'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed(),
                  child: const Text('Configure'),
                ),
                ElevatedButton(
                  onPressed: () => _clearMessages(),
                  child: const Text('Clear Messages'),
                ),
                Expanded(
                  child: ListView(
                    children: configResponses
                        .map((entry) =>
                            Text('${entry.type.name} - ${entry.message}'))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onPressed() async {
    await _tefPlugin.configure(
      ConfigureTEFEntity(
        applicationName: 'App test',
        applicationVersion: '101',
        document: '49.984.096/0002-69',
        pinPadText: 'Flutter TEF',
      ),
    );
  }

  void initializeTef() async {
    await _tefPlugin.initialize();
  }

  void listenConfigData() {
    _tefPlugin.configureStream.listen((event) {
      setState(() {
        configResponses = [...configResponses, event];
      });
    });
  }

  _clearMessages() {
    setState(() {
      configResponses = [];
    });
  }
}
