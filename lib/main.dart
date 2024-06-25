import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:lembrete_3g/local_notification.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exemplo Connectivity Simples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExemploSimples(title: 'Exemplo Connectivity'),
    );
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ExemploSimples extends StatefulWidget {
  final String title;

  const ExemploSimples({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _ExemploSimplesState createState() => _ExemploSimplesState();
}

class _ExemploSimplesState extends State<ExemploSimples> {
  String _connection = "";
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    LocalNotification.initialize(flutterLocalNotificationsPlugin);

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Text(
            _connection,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ));
  }

  void _updateStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.mobile) {
      updateText("3G/4G");
      print('trocou');
      const int timeout = 5;
      final date = DateTime.now().add(const Duration(seconds: timeout));

      Timer(
          const Duration(seconds: timeout),
          () => _connectivity.checkConnectivity().then((connectivityResult) {
                if (connectivityResult == ConnectivityResult.mobile) {
                  _updateStatus(connectivityResult);
                }
              }));

      var id = new Random().nextInt(100);
      LocalNotification.showBigTextNotification(
          id: id,
          title: 'Lembra dessa merda',
          body: 'Seu 3g jaja vai pro brejo',
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
          date: date);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      updateText("Wi-Fi\n");
    } else {
      updateText("Não Conectado!");
    }
  }

  void updateText(String texto) {
    setState(() {
      _connection = texto;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
