#include <Arduino.h>
#include <WiFi.h>
#include <esp_now.h>
#include <esp_wifi.h>
#include <esp_idf_version.h>
#include "esp_sntp.h"
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <time.h>

// === CONFIGURATION CONSTANTS ===
const uint32_t SERIAL_BAUD = 115200;
const char GATEWAY_ID[16] = "GW_ESP32_MAIN";
const char WIFI_SSID[] = "show";
const char WIFI_PASS[] = "12345678";
const char GW_AP_SSID[] = "CLUCKNET_GW_AP";
const char AWS_ENDPOINT[] = "a17exdzqte0iob-ats.iot.eu-north-1.amazonaws.com";
const uint16_t AWS_PORT = 8883;
const uint32_t NET_RETRY_INTERVAL_MS = 5000;
const uint32_t HEALTH_PUBLISH_INTERVAL_MS = 10000;
const char NTP_SERVER[] = "pool.ntp.org";
const uint32_t WIFI_RETRY_INTERVAL_MS = 15000;
const int MQTT_BUFFER_SIZE = 1024;
uint32_t lastHeartbeat = 0;

// === TLS CERTIFICATES ===
const char AWS_ROOT_CA[] PROGMEM = R"(
-----BEGIN CERTIFICATE-----
MIIDQTCCAimgAwIBAgITBmyfz5m/jAo54vB4ikPmljZbyjANBgkqhkiG9w0BAQsF
ADA5MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRkwFwYDVQQDExBBbWF6
b24gUm9vdCBDQSAxMB4XDTE1MDUyNjAwMDAwMFoXDTM4MDExNzAwMDAwMFowOTEL
MAkGA1UEBhMCVVMxDzANBgNVBAoTBkFtYXpvbjEZMBcGA1UEAxMQQW1hem9uIFJv
b3QgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALJ4gHHKeNXj
ca9HgFB0fW7Y14h29Jlo91ghYPl0hAEvrAIthtOgQ3pOsqTQNroBvo3bSMgHFzZM
9O6II8c+6zf1tRn4SWiw3te5djgdYZ6k/oI2peVKVuRF4fn9tBb6dNqcmzU5L/qw
IFAGbHrQgLKm+a/sRxmPUDgH3KKHOVj4utWp+UhnMJbulHheb4mjUcAwhmahRWa6
VOujw5H5SNz/0egwLX0tdHA114gk957EWW67c4cX8jJGKLhD+rcdqsq08p8kDi1L
93FcXmn/6pUCyziKrlA4b9v7LWIbxcceVOF34GfID5yHI9Y/QCB/IIDEgEw+OyQm
jgSubJrIqg0CAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMC
AYYwHQYDVR0OBBYEFIQYzIU07LwMlJQuCFmcx7IQTgoIMA0GCSqGSIb3DQEBCwUA
A4IBAQCY8jdaQZChGsV2USggNiMOruYou6r4lK5IpDB/G/wkjUu0yKGX9rbxenDI
U5PMCCjjmCXPI6T53iHTfIUJrU6adTrCC2qJeHZERxhlbI1Bjjt/msv0tadQ1wUs
N+gDS63pYaACbvXy8MWy7Vu33PqUXHeeE6V/Uq2V8viTO96LXFvKWlJbYK8U90vv
o/ufQJVtMVT8QtPHRh8jrdkPSHCa2XV4cdFyQzR1bldZwgJcJmApzyMZFo6IQ6XU
5MsI+yMRQ+hDKXJioaldXgjUkK642M4UwtBV8ob2xJNDd2ZhwLnoQdeXeGADbkpy
rqXRfboQnoZsG4q5WTP468SQvvG5
-----END CERTIFICATE-----
)";

const char AWS_CLIENT_CERT[] PROGMEM = R"(
-----BEGIN CERTIFICATE-----
MIIDWTCCAkGgAwIBAgIUYAJ/zb/o0Ur4gZqIp0rVN4oIGmMwDQYJKoZIhvcNAQEL
BQAwTTFLMEkGA1UECwxCQW1hem9uIFdlYiBTZXJ2aWNlcyBPPUFtYXpvbi5jb20g
SW5jLiBMPVNlYXR0bGUgU1Q9V2FzaGluZ3RvbiBDPVVTMB4XDTI2MDYwNjA3NTUy
OFoXDTQ5MTIzMTIzNTk1OVowHjEcMBoGA1UEAwwTQVdTIElvVCBDZXJ0aWZpY2F0
ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMxTYB4KiRj/64M3QWFg
xcW6SXC9FUVwDt2BzuLr1as8WyqotsHWt/Igj6YyaRu769e4t4J0K49Ijjwpjmga
l8yUBTs59p6cEv2njCmo5k3Tut60XFQnH9G/P47lgg6SviQRIAsLCaJKbfdTdQX+
477OE14QrGnbXAsfbz9LnzjUk174eTWG43JjD+NbkWRq8wsjZgG0JoJFa8ctt9IZ
m0ego6mx/agUJyoYzbn3xe3ydyvSpYmuAROAtIQOAP4SxI2Xs6wz6daYOXknPpwx
+3Iq7EPlgLZ3sdFgNoQ+vmqFGbBTqwtnRVtjpTcLwOAeTWm/7wFMpFB8uIFbW2Af
xo0CAwEAAaNgMF4wHwYDVR0jBBgwFoAUklJ0eJhkJ3uhq6FYJcQ7ZbxvXN4wHQYD
VR0OBBYEFNCRYCnkYq1luVWOQ5UEnOTim/26MAwGA1UdEwEB/wQCMAAwDgYDVR0P
AQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4IBAQBlAX5LvTmORSJo6wBR79vZustP
IG3ZaRdoXEtU1Q692YmPY7N74XpO+eWUeug+oGiPdSMgsbVQk5sNuEKlrdq98Kh8
73j7aJtdjerEk+ZIvZXDWbn/np7WrPfzlcczs0Gsj4nRQQBAkDD9PYlXv6yDGBXv
Kl8Mo+Px1vhf8o3pdu1i6FxXCH6nQocWdGGFvzgV92Mu+BVNVjBJU9M3Mq9dZoLv
RkmB/7rVhPOPh/hPJkW5J1JOuRkytocysnJRhXT8su4QtOWv1HIgI5KngYKwZiNI
5rq4sJKEdDgrP9XiOoETrElje4cuyH+blH4iAafj0ULMCi8y53Y8YENEjE6a
-----END CERTIFICATE-----
)";

const char AWS_PRIVATE_KEY[] PROGMEM = R"(
-----BEGIN RSA PRIVATE KEY-----
MIIEpgIBAAKCAQEAzFNgHgqJGP/rgzdBYWDFxbpJcL0VRXAO3YHO4uvVqzxbKqi2
wda38iCPpjJpG7vr17i3gnQrj0iOPCmOaBqXzJQFOzn2npwS/aeMKajmTdO63rRc
VCcf0b8/juWCDpK+JBEgCwsJokpt91N1Bf7jvs4TXhCsadtcCx9vP0ufONSTXvh5
NYbjcmMP41uRZGrzCyNmAbQmgkVrxy230hmbR6CjqbH9qBQnKhjNuffF7fJ3K9Kl
ia4BE4C0hA4A/hLEjZezrDPp1pg5eSc+nDH7cirsQ+WAtnex0WA2hD6+aoUZsFOr
C2dFW2OlNwvA4B5Nab/vAUykUHy4gVtbYB/GjQIDAQABAoIBAQCJymAzYh96gHuu
jYDFzqEQ6sPEB39kyGD9+CAw36HETHuelRBKQCbkXhkBl1VSorQ1UhhPHVCS2/cv
k0a55dUg3WF5w2kRJWeZL3hST9if+3012qO5DHlk1XhjQVsnwMYBRJs7V0Iz88Wc
2Oc+F9o2PnrJIK1k5c14osY/BRxnEZ47IFs3xTxdyrEGrUBOVy5e8knyI0NIL1sp
inm7rIY66FPodhjIwf5cypIomBv87KThR4pcEC6tOL0Zes529p6eJmm1LM/TYvoH
upAS+/6kmG7o9v2TvoTtIl+OJwTCJSPZ6BCOiiVxHw0AI29DHmH3qLL3pCzzbDne
lnzpOsTxAoGBAPvGl97vAnTBOLHfezPVF99KxS8fyriVCAOUmf+MzXrnkA7Vrk74
6gpcQNGs11IrwstEGf6IV8mBRp/27ZHK3nwmAbMF3CS8IyekScIRrjZM61pznMY+
d7jswQr3/hofgRQvc49cj0k8z8csvSmj8FaTHcFSrbOfa3tmFfpqqDoPAoGBAM/A
+oEQ+E1nMNCyQpwwfqG4z5nQV6N5hBnbMf63fKHlaegeNvjy/R9WKvACCeG3D6n4
kCd1ljIGio7H4phimk/uJgZr3x7WdjJedyvJTcClrquX2vWsmBlyv2UZD9pjGdvZ
o2mz7OJEOaf3oT1qTO+BSOQd7qPRShDn7N/Ea0GjAoGBAL0cAGyBZ33ct8Hak0Zu
Uzzzg0IPBgw4XEmcL0NkNd6P2YNa+k705Y2cl08mHKDqn6hfYYruS8ndoPd72Bs+
nnfvcC1QRHcPHPSkkIYFE65Tfh91YRcCSpiKs8CSXriuWxyXO5w9sJ4Y4BPBRd/l
9BqC68GOYUvefTO1jOKHhA3/AoGBALvXyKgaJ+gUfVa1VvTSBC1FZK+2aQcuP/sA
7dtZHB9lxrRRXXMKgUNsLbaEoVqsokUUsYJ8Fyl0MKOYp5EQ1mWe9lKoBj1ju8sf
DrFQejTNmXkc/KVVQNEBp3xJhMP5BtB5n/9a57xN47Ozet6E1rtXMgjP543HFijj
CpHojvHxAoGBAJH3/leyU4WwcNLwgUyI4I0WDk9ayVgT13k/JAVHEeuM+Jpw0nzd
VHW+ZooU+BIQ8SXLTIHSDOgc4FpyNOdC0XsY/OnW/0aWIFlRZ7uOCnKP4HvVNlSy
H748LMKhA6LOVIuhGym/ekqqQqu5kP9zKFn8nxS4GgUA3S5DdOgRMGTJ
-----END RSA PRIVATE KEY-----
)";

// === ESP-NOW PACKETS ===
enum PacketType : uint8_t {
  PACKET_TELEMETRY      = 1,
  PACKET_ALERT          = 2,
  PACKET_THRESHOLD_SYNC = 3,
  PACKET_ACK            = 4
};

#pragma pack(push, 1)
struct TelemetryPacket {
  uint8_t  packetType;
  uint32_t zoneId;
  char     deviceId[16];
  uint32_t timestamp;
  float    temp;
  float    hum;
  float    nh3;
  float    lpg;
  char     status[12];
};

struct AlertPacket {
  uint8_t  packetType;
  uint32_t zoneId;
  char     deviceId[16];
  uint32_t timestamp;
  float    value;
  float    threshold;
  char     alertType[16];
  char     status[16];
  bool     buzzerActive;
  int      servoAngle;
};

struct ThresholdPacket {
  uint8_t  packetType;
  uint32_t zoneId;
  uint32_t timestamp;
  float    tempUpper;
  float    tempLower;
  float    humUpper;
  float    humLower;
  float    nh3Max;
  float    lpgMax;
};

struct AckPacket {
  uint8_t  packetType;
  uint32_t zoneId;
  char     deviceId[16];
  uint32_t timestamp;
  char     ackEvent[24];
  bool     success;
};
#pragma pack(pop)

struct EdgeNodeMap {
  uint32_t zoneId;
  uint8_t  macAddress[6];
  bool     registered;
  uint32_t lastSeenSec;
};

// === GLOBAL STATE ===
WiFiClientSecure secureClient;
PubSubClient mqttClient(secureClient);

static const int MAX_EDGE_NODES = 10;
EdgeNodeMap edgeNodes[MAX_EDGE_NODES];
int edgeNodeCount = 0;

uint32_t lastHealthTime = 0;
uint32_t lastWifiRetryTime = 0;
uint32_t lastMqttRetryTime = 0;
uint32_t lastDebugTime = 0;

// === OUTBOUND BUFFERS ===
TelemetryPacket telemetryQueue[100];
int telemetryHead = 0;
int telemetryTail = 0;
int telemetryCount = 0;

AlertPacket alertQueue[20];
int alertHead = 0;
int alertTail = 0;
int alertCount = 0;

AckPacket ackQueue[20];
int ackHead = 0;
int ackTail = 0;
int ackCount = 0;

void telemetryPush(const TelemetryPacket &p) {
  if (telemetryCount == 100) {
    telemetryHead = (telemetryHead + 1) % 100;
    telemetryCount--;
  }
  telemetryQueue[telemetryTail] = p;
  telemetryTail = (telemetryTail + 1) % 100;
  telemetryCount++;
}

bool telemetryPop(TelemetryPacket &p) {
  if (telemetryCount == 0) {
    return false;
  }
  p = telemetryQueue[telemetryHead];
  telemetryHead = (telemetryHead + 1) % 100;
  telemetryCount--;
  return true;
}

int telemetryPending() {
  return telemetryCount;
}

void alertPush(const AlertPacket &p) {
  if (alertCount == 20) {
    alertHead = (alertHead + 1) % 20;
    alertCount--;
  }
  alertQueue[alertTail] = p;
  alertTail = (alertTail + 1) % 20;
  alertCount++;
}

bool alertPop(AlertPacket &p) {
  if (alertCount == 0) {
    return false;
  }
  p = alertQueue[alertHead];
  alertHead = (alertHead + 1) % 20;
  alertCount--;
  return true;
}

int alertPending() {
  return alertCount;
}

void ackPush(const AckPacket &p) {
  if (ackCount == 20) {
    ackHead = (ackHead + 1) % 20;
    ackCount--;
  }
  ackQueue[ackTail] = p;
  ackTail = (ackTail + 1) % 20;
  ackCount++;
}

bool ackPop(AckPacket &p) {
  if (ackCount == 0) {
    return false;
  }
  p = ackQueue[ackHead];
  ackHead = (ackHead + 1) % 20;
  ackCount--;
  return true;
}

int ackPending() {
  return ackCount;
}

// === UTILITY HELPERS ===
float round2(float value) {
  return roundf(value * 100.0f) / 100.0f;
}

void makeTopic(char *topic, size_t len, const char *pattern, uint32_t zoneId) {
  snprintf(topic, len, pattern, zoneId);
}

uint32_t topicZoneId(const char *topic) {
  const char *p = topic;
  int slashCount = 0;
  const char *start = nullptr;
  const char *end = nullptr;
  while (*p) {
    if (*p == '/') {
      slashCount++;
      if (slashCount == 2) {
        start = p + 1;
      } else if (slashCount == 3) {
        end = p;
        break;
      }
    }
    p++;
  }
  if (start == nullptr || end == nullptr || end <= start) {
    return 0;
  }
  char zoneBuf[12] = {};
  size_t n = min((size_t)(end - start), sizeof(zoneBuf) - 1);
  memcpy(zoneBuf, start, n);
  return (uint32_t)strtoul(zoneBuf, nullptr, 10);
}

// === EDGE NODE REGISTRY ===
void ensureEdgePeer(const uint8_t *mac) {
  if (esp_now_is_peer_exist(mac)) {
    return;
  }
  esp_now_peer_info_t peer = {};
  memcpy(peer.peer_addr, mac, 6);
  peer.channel = 0;
  peer.ifidx = WIFI_IF_AP;
  peer.encrypt = false;
  esp_err_t result = esp_now_add_peer(&peer);
  Serial.printf("[GW] Add edge peer: %s\n", result == ESP_OK ? "OK" : "FAILED");
}

void registerOrUpdateEdge(uint32_t zoneId, const uint8_t *mac) {
  uint32_t nowSec = millis() / 1000;
  for (int i = 0; i < edgeNodeCount; i++) {
    if (memcmp(edgeNodes[i].macAddress, mac, 6) == 0) {
      edgeNodes[i].zoneId = zoneId;
      edgeNodes[i].lastSeenSec = nowSec;
      edgeNodes[i].registered = true;
      ensureEdgePeer(mac);
      return;
    }
  }

  if (edgeNodeCount < MAX_EDGE_NODES) {
    edgeNodes[edgeNodeCount].zoneId = zoneId;
    memcpy(edgeNodes[edgeNodeCount].macAddress, mac, 6);
    edgeNodes[edgeNodeCount].registered = true;
    edgeNodes[edgeNodeCount].lastSeenSec = nowSec;
    ensureEdgePeer(mac);
    edgeNodeCount++;
    Serial.printf("[GW] Registered edge zone %lu\n", (unsigned long)zoneId);
  }
}

const uint8_t* findMacByZone(uint32_t zoneId) {
  for (int i = 0; i < edgeNodeCount; i++) {
    if (edgeNodes[i].registered && edgeNodes[i].zoneId == zoneId) {
      return edgeNodes[i].macAddress;
    }
  }
  return nullptr;
}

bool sendThresholdToEdge(uint32_t zoneId, const ThresholdPacket &packet) {
  const uint8_t *mac = findMacByZone(zoneId);
  if (mac == nullptr) {
    Serial.printf("[GW] No edge registered for zone %lu\n", (unsigned long)zoneId);
    return false;
  }
  esp_err_t result = esp_now_send(mac, (const uint8_t *)&packet, sizeof(packet));
  Serial.printf("[GW] Threshold send zone %lu: %s\n", (unsigned long)zoneId, result == ESP_OK ? "OK" : "FAILED");
  return result == ESP_OK;
}

// === MQTT PUBLISH FUNCTIONS ===
bool publishTelemetry(const TelemetryPacket &t) {
  char topic[96];
  makeTopic(topic, sizeof(topic), "clucknet/zones/%lu/telemetry", t.zoneId);

  StaticJsonDocument<512> doc;
  doc["zoneId"] = t.zoneId;
  doc["deviceId"] = t.deviceId;
  doc["timestamp"] = t.timestamp;
  JsonObject metrics = doc.createNestedObject("metrics");
  metrics["temp"] = round2(t.temp);
  metrics["hum"] = round2(t.hum);
  metrics["nh3"] = round2(t.nh3);
  metrics["lpg"] = round2(t.lpg);
  doc["deviceStatus"] = t.status;

  char payload[512];
  serializeJson(doc, payload, sizeof(payload));

  Serial.println();
  Serial.println("===== MQTT TELEMETRY =====");
  Serial.printf(
      "Topic : %s\n",
      topic
  );
  Serial.printf(
      "Temp  : %.2f\n",
      t.temp
  );
  Serial.printf(
      "Hum   : %.2f\n",
      t.hum
  );
  Serial.printf(
      "NH3   : %.2f\n",
      t.nh3
  );
  Serial.printf(
      "LPG   : %.2f\n",
      t.lpg
  );

  bool ok = mqttClient.publish(topic, payload, false);

  Serial.printf(
      "Publish Result : %s\n",
      ok ? "SUCCESS" : "FAILED"
  );
  Serial.println("==========================");

  if (!ok) {
    telemetryPush(t);
  }
  return ok;
}

bool publishAlert(const AlertPacket &a) {
  char topic[96];
  makeTopic(topic, sizeof(topic), "clucknet/zones/%lu/alerts", a.zoneId);

  StaticJsonDocument<512> doc;
  doc["zoneId"] = a.zoneId;
  doc["deviceId"] = a.deviceId;
  doc["timestamp"] = a.timestamp;
  doc["alertType"] = a.alertType;
  doc["triggerValue"] = round2(a.value);
  doc["thresholdLimit"] = round2(a.threshold);
  doc["deviceStatus"] = a.status;
  JsonObject actuators = doc.createNestedObject("actuators");
  actuators["buzzer"] = a.buzzerActive;
  actuators["servoAngle"] = a.servoAngle;

  char payload[512];
  serializeJson(doc, payload, sizeof(payload));

  Serial.println();
  Serial.println("======= MQTT ALERT =======");
  Serial.printf(
      "Topic : %s\n",
      topic
  );
  Serial.printf(
      "Type  : %s\n",
      a.alertType
  );
  Serial.printf(
      "Value : %.2f\n",
      a.value
  );
  Serial.printf(
      "Limit : %.2f\n",
      a.threshold
  );

  bool ok = mqttClient.publish(topic, payload, false);

  Serial.printf(
    "Publish Result : %s\n",
    ok ? "SUCCESS" : "FAILED"
  );
  Serial.println("==========================");

  if (!ok) {
    alertPush(a);
  }
  return ok;
}

bool publishAck(const AckPacket &a) {
  char topic[96];
  makeTopic(topic, sizeof(topic), "clucknet/zones/%lu/acks", a.zoneId);

  StaticJsonDocument<384> doc;
  doc["zoneId"] = a.zoneId;
  doc["deviceId"] = a.deviceId;
  doc["timestamp"] = a.timestamp;
  doc["ackEvent"] = a.ackEvent;
  doc["status"] = a.success ? "SUCCESS" : "FAILURE";

  char payload[384];
  serializeJson(doc, payload, sizeof(payload));
  bool ok = mqttClient.publish(topic, payload, false);
  if (!ok) {
    ackPush(a);
  }
  return ok;
}

bool publishHealth(uint32_t uptime, int rssi, uint32_t freeHeap) {
  char topic[96];
  snprintf(topic, sizeof(topic), "clucknet/devices/%s/health", GATEWAY_ID);

  StaticJsonDocument<384> doc;
  doc["deviceId"] = GATEWAY_ID;
  doc["zoneId"] = 0;
  doc["timestamp"] = uptime;
  doc["rssi"] = rssi;
  doc["uptimeSec"] = uptime;
  doc["freeHeapBytes"] = freeHeap;
  doc["status"] = "ONLINE";

  char payload[384];
  serializeJson(doc, payload, sizeof(payload));

  Serial.println();
  Serial.println("===== GATEWAY HEALTH =====");
  Serial.printf(
      "RSSI      : %d\n",
      rssi
  );
  Serial.printf(
      "Free Heap : %lu\n",
      (unsigned long)freeHeap
  );
  Serial.printf(
      "Uptime    : %lu sec\n",
      (unsigned long)uptime
  );
  Serial.println("==========================");

  return mqttClient.publish(topic, payload, true);
}

bool publishGatewayStatus(const char *statusText, uint32_t timestamp) {
  char topic[96];
  snprintf(topic, sizeof(topic), "clucknet/gateway/%s/status", GATEWAY_ID);

  StaticJsonDocument<256> doc;
  doc["gatewayId"] = GATEWAY_ID;
  doc["status"] = statusText;
  doc["timestamp"] = timestamp;

  char payload[256];
  serializeJson(doc, payload, sizeof(payload));
  return mqttClient.publish(topic, payload, true);
}

// === MQTT INBOUND HANDLER ===
void onMqttMessageReceived(char *topic, byte *payload, unsigned int length) {
  StaticJsonDocument<512> doc;
  DeserializationError error = deserializeJson(doc, payload, length);
  if (error) {
    Serial.printf("[GW] Threshold JSON parse failed: %s\n", error.c_str());
    return;
  }

  uint32_t zoneId = topicZoneId(topic);
  if (zoneId == 0 || !doc.containsKey("thresholds")) {
    Serial.println("[GW] Invalid threshold command");
    return;
  }

  JsonObject th = doc["thresholds"];
  ThresholdPacket packet = {};
  packet.packetType = PACKET_THRESHOLD_SYNC;
  packet.zoneId = zoneId;
  packet.timestamp = (uint32_t)time(nullptr);
  packet.tempUpper = th["tempUpper"] | 35.0f;
  packet.tempLower = th["tempLower"] | 15.0f;
  packet.humUpper = th["humUpper"] | 80.0f;
  packet.humLower = th["humLower"] | 40.0f;
  packet.nh3Max = th["nh3Max"] | 25.0f;
  packet.lpgMax = th["lpgMax"] | 100.0f;

  Serial.println();
  Serial.println("==== THRESHOLD UPDATE ====");
  Serial.printf(
      "Zone      : %lu\n",
      (unsigned long)zoneId
  );
  Serial.printf(
      "Temp Max  : %.2f\n",
      packet.tempUpper
  );
  Serial.printf(
      "Temp Min  : %.2f\n",
      packet.tempLower
  );
  Serial.printf(
      "Hum Max   : %.2f\n",
      packet.humUpper
  );
  Serial.printf(
      "Hum Min   : %.2f\n",
      packet.humLower
  );
  Serial.printf(
      "NH3 Max   : %.2f\n",
      packet.nh3Max
  );
  Serial.printf(
      "LPG Max   : %.2f\n",
      packet.lpgMax
  );
  Serial.println("==========================");

  sendThresholdToEdge(zoneId, packet);
}

// === WIFI AND MQTT RECONNECT LOGIC ===
void handleWiFiReconnect() {
  if (WiFi.status() == WL_CONNECTED) {
    return;
  }
  uint32_t now = millis();
  if (now - lastWifiRetryTime >= WIFI_RETRY_INTERVAL_MS) {
    lastWifiRetryTime = now;
    Serial.println("[GW] WiFi reconnect attempt");
    WiFi.begin(WIFI_SSID, WIFI_PASS);
  }
}

bool waitForLocalTimeWithOffset() {
  if (time(nullptr) >= 100000) {
    return true;
  }
  configTime(19800, 0, NTP_SERVER, "time.nist.gov");
  for (int i = 0; i < 10; i++) {
    if (time(nullptr) >= 100000) {
      return true;
    }
    delay(500);
  }
  return time(nullptr) >= 100000;
}

void flushAllBuffersWithGaps() {
  AlertPacket alert;
  while (alertPop(alert)) {
    if (!publishAlert(alert)) {
      break;
    }
    delay(50);
  }

  TelemetryPacket telemetry;
  while (telemetryPop(telemetry)) {
    if (!publishTelemetry(telemetry)) {
      break;
    }
    delay(50);
  }

  AckPacket ack;
  while (ackPop(ack)) {
    if (!publishAck(ack)) {
      break;
    }
    delay(50);
  }
}

void handleMqttReconnect() {
  if (WiFi.status() != WL_CONNECTED || mqttClient.connected()) {
    return;
  }

  uint32_t now = millis();

  if (now - lastMqttRetryTime < NET_RETRY_INTERVAL_MS) {
    return;
  }

  lastMqttRetryTime = now;

  if (!waitForLocalTimeWithOffset()) {
    Serial.println("[GW] Time not synced; MQTT connect aborted");
    return;
  }

  time_t currentTime = time(nullptr);

  Serial.println();
  // Serial.println("========== MQTT DEBUG ==========");
  // Serial.printf("Free Heap: %u bytes\n", ESP.getFreeHeap());
  // Serial.printf("Current Epoch: %ld\n", currentTime);
  // Serial.printf("Current Time : %s", ctime(&currentTime));
  // Serial.printf("Endpoint     : %s\n", AWS_ENDPOINT);
  // Serial.printf("Port         : %u\n", AWS_PORT);
  // Serial.println("===============================");

  secureClient.setCACert(AWS_ROOT_CA);
  secureClient.setCertificate(AWS_CLIENT_CERT);
  secureClient.setPrivateKey(AWS_PRIVATE_KEY);

  mqttClient.setServer(AWS_ENDPOINT, AWS_PORT);

  mqttClient.setKeepAlive(60);
  mqttClient.setSocketTimeout(30);

  Serial.println("[GW] MQTT reconnect attempt...");

  bool connected = mqttClient.connect(GATEWAY_ID);

  if (connected) {

    Serial.println("[GW] MQTT CONNECTED");

    publishGatewayStatus(
        "ONLINE",
        (uint32_t)time(nullptr)
    );

    mqttClient.subscribe(
        "clucknet/zones/+/thresholds",
        1
    );

    flushAllBuffersWithGaps();

  } else {

      Serial.printf(
          "[GW] MQTT FAILED state=%d\n",
          mqttClient.state()
      );
  }
}

// === NTP TIME SYNC ===
bool syncSystemTime() {
  configTime(0, 0, "pool.ntp.org", "time.nist.gov");
  uint32_t start = millis();
  while (millis() - start < 15000) {
    if (sntp_get_sync_status() == SNTP_SYNC_STATUS_COMPLETED) {
      return true;
    }
    delay(500);
  }
  return false;
}

// === ESP-NOW CALLBACKS ===
#if ESP_IDF_VERSION >= ESP_IDF_VERSION_VAL(5, 5, 0)
void onEspNowDataSent(const esp_now_send_info_t *txInfo, esp_now_send_status_t status) {
  (void)txInfo;
#else
void onEspNowDataSent(const uint8_t *macAddr, esp_now_send_status_t status) {
  (void)macAddr;
#endif
  Serial.printf("[GW] ESP-NOW send: %s\n", status == ESP_NOW_SEND_SUCCESS ? "OK" : "FAILED");
}

#if defined(ESP_ARDUINO_VERSION_MAJOR) && ESP_ARDUINO_VERSION_MAJOR >= 3
void onEspNowDataReceived(const esp_now_recv_info_t *info, const uint8_t *incomingData, int len) {
  const uint8_t *mac = info->src_addr;
#else
void onEspNowDataReceived(const uint8_t *mac, const uint8_t *incomingData, int len) {
#endif
  if (len < 5) {
    return;
  }

  uint8_t packetType = incomingData[0];
  uint32_t zoneId = 0;
  memcpy(&zoneId, incomingData + 1, sizeof(zoneId));
  registerOrUpdateEdge(zoneId, mac);

  Serial.println();
  Serial.println("========== ESP-NOW RX ==========");
  Serial.printf("Packet Type : %d\n", packetType);
  Serial.printf("Zone ID     : %lu\n", (unsigned long)zoneId);
  Serial.printf(
      "From MAC    : %02X:%02X:%02X:%02X:%02X:%02X\n",
      mac[0], mac[1], mac[2],
      mac[3], mac[4], mac[5]
  );
  Serial.println("================================");

  if (packetType == PACKET_TELEMETRY && len == (int)sizeof(TelemetryPacket)) {
    TelemetryPacket packet;
    memcpy(&packet, incomingData, sizeof(packet));

    Serial.println();
    Serial.println("======= TELEMETRY RX =======");
    Serial.printf("Zone      : %lu\n", (unsigned long)packet.zoneId);
    Serial.printf("Device    : %s\n", packet.deviceId);
    Serial.printf("Temp      : %.2f C\n", packet.temp);
    Serial.printf("Humidity  : %.2f %%\n", packet.hum);
    Serial.printf("NH3       : %.2f ppm\n", packet.nh3);
    Serial.printf("LPG       : %.2f ppm\n", packet.lpg);
    Serial.printf("Status    : %s\n", packet.status);
    Serial.println("============================");

    telemetryPush(packet);
  } else if (packetType == PACKET_ALERT && len == (int)sizeof(AlertPacket)) {
    AlertPacket packet;
    memcpy(&packet, incomingData, sizeof(packet));

    Serial.println();
    Serial.println("!!!! ALERT RECEIVED !!!!");
    Serial.printf("Zone       : %lu\n", (unsigned long)packet.zoneId);
    Serial.printf("Device     : %s\n", packet.deviceId);
    Serial.printf("Alert Type : %s\n", packet.alertType);
    Serial.printf("Value      : %.2f\n", packet.value);
    Serial.printf("Threshold  : %.2f\n", packet.threshold);
    Serial.printf(
        "Buzzer     : %s\n",
        packet.buzzerActive ? "ON" : "OFF"
    );
    Serial.printf(
        "Servo      : %d\n",
        packet.servoAngle
    );
    Serial.println("=========================");

    alertPush(packet);
  } else if (packetType == PACKET_ACK && len == (int)sizeof(AckPacket)) {
    AckPacket packet;
    memcpy(&packet, incomingData, sizeof(packet));

    Serial.println();
    Serial.println("======= ACK RX =======");
    Serial.printf(
        "Zone      : %lu\n",
        (unsigned long)packet.zoneId
    );
    Serial.printf(
        "Device    : %s\n",
        packet.deviceId
    );
    Serial.printf(
        "Event     : %s\n",
        packet.ackEvent
    );
    Serial.printf(
        "Result    : %s\n",
        packet.success ? "SUCCESS" : "FAILED"
    );
    Serial.println("======================");

    ackPush(packet);
  }
}

// === SETUP ===
void setup() {
  Serial.begin(SERIAL_BAUD);
  uint32_t serialStart = millis();
  while (!Serial && millis() - serialStart < 3000) {
    delay(10);
  }

  WiFi.mode(WIFI_AP_STA);
  bool apOk = WiFi.softAP(GW_AP_SSID);
  Serial.printf("[GW] SoftAP: %s\n", apOk ? "OK" : "FAILED");
  WiFi.begin(WIFI_SSID, WIFI_PASS);

  Serial.printf("[GW] STA MAC: %s\n", WiFi.macAddress().c_str());
  Serial.printf("[GW] AP MAC: %s\n", WiFi.softAPmacAddress().c_str());
  Serial.printf("[GW] Channel: %d\n", WiFi.channel());

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.printf("[GW] WiFi connected, IP=%s\n", WiFi.localIP().toString().c_str());

  while (!syncSystemTime()) {
    Serial.println("[GW] NTP sync retry");
    delay(1000);
  }
  Serial.println("[GW] NTP synced");

  time_t now = time(nullptr);
  Serial.printf(
      "[GW] Current Time: %s",
      ctime(&now));

  mqttClient.setServer(AWS_ENDPOINT, AWS_PORT);

  mqttClient.setCallback(onMqttMessageReceived);
  mqttClient.setBufferSize(MQTT_BUFFER_SIZE);

  if (esp_now_init() != ESP_OK) {
    Serial.println("[GW] ESP-NOW init failed, restarting");
    ESP.restart();
  }
  esp_now_register_recv_cb(onEspNowDataReceived);
  esp_now_register_send_cb(onEspNowDataSent);

  lastHealthTime = millis();
}

// === LOOP ===
void loop() {

  if (millis() - lastHeartbeat >= 5000) {

    lastHeartbeat = millis();

    Serial.println();
    Serial.println("======= GATEWAY STATUS =======");

    Serial.printf(
        "WiFi      : %s\n",
        WiFi.status() == WL_CONNECTED
            ? "CONNECTED"
            : "DISCONNECTED"
    );

    Serial.printf(
        "MQTT      : %s\n",
        mqttClient.connected()
            ? "CONNECTED"
            : "DISCONNECTED"
    );

    Serial.printf(
        "RSSI      : %d\n",
        WiFi.RSSI()
    );

    Serial.printf(
        "Heap      : %u\n",
        ESP.getFreeHeap()
    );

    Serial.printf(
        "Edges     : %d\n",
        edgeNodeCount
    );

    Serial.printf(
        "Telemetry : %d\n",
        telemetryPending()
    );

    Serial.printf(
        "Alerts    : %d\n",
        alertPending()
    );

    Serial.printf(
        "ACKs      : %d\n",
        ackPending()
    );

    Serial.println("==============================");
  }

  uint32_t now = millis();

  // 1. WiFi + MQTT reconnect handlers
  handleWiFiReconnect();
  handleMqttReconnect();

  // 2. MQTT client loop (keeps connection alive, receives subscriptions)
  if (mqttClient.connected()) {
    mqttClient.loop();

    // 3. Flush buffers - priority order: alerts > telemetry > acks
    //    Process ONE packet per type per loop iteration
    if (alertPending() > 0) {
      AlertPacket a;
      if (alertPop(a)) {
        publishAlert(a);
      }
    }
    if (telemetryPending() > 0) {
      TelemetryPacket t;
      if (telemetryPop(t)) {
        publishTelemetry(t);
      }
    }
    if (ackPending() > 0) {
      AckPacket ak;
      if (ackPop(ak)) {
        publishAck(ak);
      }
    }
  }

  // 4. Health heartbeat (every 10s)
  if (now - lastHealthTime >= HEALTH_PUBLISH_INTERVAL_MS && mqttClient.connected()) {
    publishHealth(now / 1000, WiFi.RSSI(), ESP.getFreeHeap());
    lastHealthTime = now;
  }

  // 5. Channel debug log (every 10s)
  // Serial.printf("[DEBUG] Gateway Channel = %d\n", WiFi.channel());

  delay(1); // prevent CPU starvation
}
