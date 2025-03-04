# Controle de LEDs via MQTT com Flutter e ESP32

## Descrição
Este projeto permite controlar LEDs remotamente via MQTT usando um app Flutter e um ESP32. O ESP32 recebe comandos do app via Wi-Fi e aciona os LEDs conectados.<br></br>

## Tecnologias Utilizadas
**Flutter →** Interface do usuário e conexão MQTT.
**MQTT →** Protocolo de comunicação (suporte para Mosquitto, HiveMQ, EMQX).
**ESP32 →** Microcontrolador responsável pelo acionamento dos LEDs.<br></br>

## Arquitetura do Sistema
1️⃣ O Flutter se conecta ao broker MQTT.<br></br>
2️⃣ O usuário liga/desliga LEDs pelo app.<br></br>
3️⃣ O ESP32 recebe o comando via MQTT e aciona o LED.<br></br>
4️⃣ O ESP32 publica o status do LED de volta no MQTT.<br></br>
5️⃣ O app exibe o status em tempo real.<br></br>

## Recursos do Aplicativo
✔️ Conexão MQTT com autenticação.<br></br>
✔️ Controle de LED via app Flutter.<br></br>
✔️ Status do LED em tempo real.<br></br>
✔️ Interface responsiva e moderna.<br></br>
✔️ Logs da comunicação MQTT para debug.<br></br>

## Tópicos MQTT
| Tópico               | Descrição                                                  |
|----------------------|------------------------------------------------------------|
| esp32/led/command     | Flutter envia comando (ON ou OFF).                         |
| esp32/led/status      | ESP32 publica estado atual do LED (ON ou OFF).             |


<br></br>
### Código ESP32 (Exemplo com PubSubClient)
```cpp
    #include <WiFi.h>
    #include <PubSubClient.h>

    const char* ssid = "SEU_WIFI";
    const char* password = "SUA_SENHA";
    const char* mqtt_server = "BROKER_MQTT";

    WiFiClient espClient;
    PubSubClient client(espClient);
    const int ledPin = 2;

    void setup() {
    pinMode(ledPin, OUTPUT);
    WiFi.begin(ssid, password);
    client.setServer(mqtt_server, 1883);
    client.setCallback(callback);
    }

    void callback(char* topic, byte* payload, unsigned int length) {
    String message;
    for (int i = 0; i < length; i++) message += (char)payload[i];
    
    if (String(topic) == "esp32/led/command") {
        if (message == "ON") digitalWrite(ledPin, HIGH);
        else if (message == "OFF") digitalWrite(ledPin, LOW);
        client.publish("esp32/led/status", digitalRead(ledPin) ? "ON" : "OFF");
    }
    }

    void loop() {
    if (!client.connected()) reconnect();
    client.loop();
    }
```
<br></br>
### Instalação
1️⃣ Configurar o ESP32:

**- Instale as bibliotecas WiFi.h e PubSubClient.h no Arduino IDE.**
**- Modifique SSID, senha e endereço do broker MQTT.**
**- Compile e envie para o ESP32.**

2️⃣ Configurar o Flutter:

**- Instale flutter_mqtt_client no pubspec.yaml.**
**- Configure os tópicos MQTT no app.**
**- Rode o projeto:**
```bash
    flutter run
```
<br></br>
### Possíveis Expansões
🚀 Controle de múltiplos LEDs e sensores.<br></br>
🚀 Conexão com Google Firebase para controle remoto global.<br></br>
🚀 Adicionar gráficos em tempo real com dados IoT.<br></br>