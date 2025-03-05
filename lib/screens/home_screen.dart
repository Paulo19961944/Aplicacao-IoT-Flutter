import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String broker = "test.mosquitto.org"; // Altere para o seu broker
  final String topicCommand = "esp32/led/command";
  final String topicStatus = "esp32/led/status";

  late MqttServerClient client;
  bool isConnected = false;
  String ledStatus = "Desconhecido";

  @override
  void initState() {
    super.initState();
    _connectToBroker();
  }

  Future<void> _connectToBroker() async {
    client = MqttServerClient(broker, '');
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Erro na conexão MQTT: $e');
      setState(() {
        isConnected = false;
      });
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      setState(() {
        isConnected = true;
      });

      client.subscribe(topicStatus, MqttQos.atMostOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final MqttPublishMessage message = messages[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);

        setState(() {
          ledStatus = payload;
        });
      });
    }
  }

  void _onConnected() {
    print('Conectado ao broker MQTT!');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Conectado ao Broker com Sucesso!')),
    );
  }

  void _onDisconnected() {
    print('Desconectado do broker MQTT.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Desconectado do Broker!')),
    );
  }

  void _onSubscribed(String topic) {
    print('Inscrito no tópico: $topic');
  }

  void _publishMessage(String message) {
    if (isConnected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topicCommand, MqttQos.atMostOnce, builder.payload!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: Não conectado ao broker')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aplicativo IoT")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Seja Bem-Vindo", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Icon(Icons.account_circle, size: 100),
            SizedBox(height: 20),
            Text("Status do LED: $ledStatus", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _publishMessage("ON"),
              child: Text("Acender LED", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _publishMessage("OFF"),
              child: Text("Apagar LED", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
