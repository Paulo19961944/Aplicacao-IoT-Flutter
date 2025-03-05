import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MqttServerClient client;

  // Função para conectar ao Broker MQTT
  Future<void> _connectToBroker() async {
    client = MqttServerClient('test.mosquitto.org', 'flutter_client');
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;

    try {
      await client.connect();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conectado ao Broker com Sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha na conexão')),
      );
    }
  }

  // Função chamada quando desconectar do broker
  void _onDisconnected() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Desconectado do Broker')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Página Inicial")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Seja Bem Vindo", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Icon(Icons.account_circle, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _connectToBroker,
              child: Text("Conectar"),
            ),
          ],
        ),
      ),
    );
  }
}
