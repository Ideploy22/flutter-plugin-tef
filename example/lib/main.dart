import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/common/tef_response.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/configure/configure_tef_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/payment_data_entity.dart';
import 'package:flutter_plugin_tef_integration/domain/entities/payment/tef_payment_response.dart';
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

  StreamSubscription<TEFResponseEntity>? configSubs;
  List<TEFResponseEntity> configResponses = [];
  List<TEFPaymentResponseEntity> paymentResponses = [];

  @override
  void initState() {
    super.initState();
    initializeTef();
    initPlatformState();
    listenConfiguration();
    listenPayment();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => _payWithCredit(),
                      child: const Text('Credit'),
                    ),
                    ElevatedButton(
                      onPressed: () => _payWithDebit(),
                      child: const Text('Debit'),
                    ),
                    ElevatedButton(
                      onPressed: () => _payWithPIX(),
                      child: const Text('PIX'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _clearMessages(),
                  child: const Text('Clear Messages'),
                ),
                configResponses.isNotEmpty
                    ? Expanded(
                        child: ListView(
                          children: configResponses
                              .map((entry) =>
                                  Text('${entry.type.name} - ${entry.message}'))
                              .toList(),
                        ),
                      )
                    : const SizedBox(),
                paymentResponses.isNotEmpty
                    ? Expanded(
                        child: ListView(
                          children: paymentResponses
                              .map(
                                (entry) => Text(
                                  '${entry.type.name} - ${entry.message} ${entry.receipt != null ? '${entry.receipt?.authorization}' : ''}',
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : const SizedBox(),
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
        pinPadText: 'Bistro TEF',
      ),
    );
  }

  void initializeTef() async {
    await _tefPlugin.initialize();
  }

  _clearMessages() {
    setState(() {
      configResponses = [];
      paymentResponses = [];
    });
  }

  void _payWithCredit() {
    _tefPlugin.pay(
      PaymentDataEntity.credit(
        valueCents: 10,
        operationType: OperationType.inCash,
      ),
    );
  }

  void _payWithDebit() {
    _tefPlugin.pay(
      PaymentDataEntity.debit(valueCents: 10),
    );
  }

  void _payWithPIX() {
    _tefPlugin.pay(
      PaymentDataEntity.pix(valueCents: 10),
    );
  }

  void listenConfiguration() {
    _tefPlugin.configureStream.listen((event) {
      setState(() {
        configResponses = [...configResponses, event];
      });
    });
  }

  void listenPayment() {
    _tefPlugin.paymentStream.listen((event) {
      setState(() {
        paymentResponses = [...paymentResponses, event];
      });
    });
  }
}
