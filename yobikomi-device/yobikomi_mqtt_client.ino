#include <WiFi.h>
#include <PubSubClient.h>

const char ssid[] = "wifi-ssid";
const char pass[] = "wifi-password";
const char mqttBroker[] = "34.84.177.33";
const int mqttPort = 1883;
const char mqttUser[] = "mqtt-user";
const char mqttPassword[] = "mqtt-pwd";
const char topic[] = "device-event";

WiFiClient net;
PubSubClient client(net);

unsigned long lastMillis = 0;

void blinkBehavior() {
  digitalWrite(33, HIGH);
  delay(100);
  digitalWrite(33, LOW);
}

void connect() {
  blinkBehavior();
  Serial.print("checking wifi...");
  while (WiFi.status() != WL_CONNECTED) {
    blinkBehavior();
    Serial.print(".");
    delay(1000);
  }
  digitalWrite(33, HIGH);

  client.setServer(mqttBroker, mqttPort);
  Serial.print("\nconnecting...");
  while (!client.connected()) {
    String clientId = getMacAddr();
    if(client.connect(clientId.c_str(), mqttUser, mqttPassword)) {
      client.setKeepAlive(5);
      client.subscribe(topic);
      client.setCallback(subscribeTopic);
      break;
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
  Serial.println("\nconnected!");
  client.loop();
}

void subscribeTopic(char* topic, byte* payload, unsigned int length) {
  Serial.print("receive topic: ");
  Serial.println(topic);

  digitalWrite(15, HIGH);
  delay(1000);
  digitalWrite(15, LOW);
}

String getMacAddr()
{
    byte mac[6];
    char buf[50];
    WiFi.macAddress(mac);
    sprintf(buf, "%02x%02x%02x%02x%02x%02x", mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
    return String(buf);
}

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, pass);

  pinMode(15, OUTPUT);
  digitalWrite(15, LOW);

  pinMode(33, OUTPUT);
  digitalWrite(33, LOW);

  connect();
}

void loop() {
  delay(10);  // <- fixes some issues with WiFi stability

  if (!client.connected()) {
    connect();
  }
  client.loop();
}
