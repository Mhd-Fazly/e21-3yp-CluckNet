# 🐔 CluckNet - Smart Chick Monitoring System

An IoT-based smart poultry monitoring and safety system designed to monitor environmental conditions inside poultry farms in real time and provide automated safety actions.

---

# 🔧 System Components

## 📡 Edge ESP32
- Collects environmental sensor data
- Reads:
  - Temperature & Humidity (SHT30)
  - NH3 Gas (MQ135)
  - LPG Gas (MQ6)
- Controls:
  - Buzzer alerts
  - Servo motor for gas regulator control

---

## 🌐 Gateway ESP32
- Receives data from edge nodes using ESP-NOW
- Sends data securely to AWS IoT Core using WiFi
- Acts as the bridge between local devices and cloud services

---

## ☁️ AWS IoT Core
- MQTT broker for secure cloud communication
- Handles:
  - Device authentication
  - MQTT topic management
  - Secure TLS communication
  - Real-time message delivery

---

## ⚙️ Backend Server
Built using Spring Boot.

Responsibilities:
- Subscribe to MQTT topics from AWS IoT Core
- Process incoming sensor data
- Generate alerts
- Store system data
- Provide REST APIs for mobile application

---

## 🗄️ Databases

### MySQL
Used for:
- User management
- Zones
- Devices
- Alerts
- Threshold settings
- Notifications

### InfluxDB
Used for:
- Time-series sensor data
- Historical analytics
- Real-time monitoring data
- Sensor trend visualization

---

## 📱 Mobile Application
Built using Flutter.

Features:
- Real-time monitoring
- Alert notifications
- Historical charts
- Zone management
- Threshold configuration
- Dark & light theme support

---

# 🔄 System Flow

Sensors  
→ Edge ESP32  
→ Gateway ESP32  
→ AWS IoT Core (MQTT)  
→ Spring Boot Backend  
→ MySQL + InfluxDB  
→ Flutter Mobile App

---

# 🚨 Main Features

- Real-time poultry monitoring
- NH3 and LPG gas detection
- Automatic emergency response
- Smart alert notifications
- Zone-based monitoring
- Historical analytics
- Role-based mobile application
- Threshold customization
- Cloud-based architecture

---

# 🔐 Security Features

- Secure MQTT communication using TLS/SSL
- AWS IoT device authentication using certificates
- Role-based user access
- Protected REST APIs
- Cloud-based secure infrastructure

---

# 🛠️ Technologies Used

## Hardware
- ESP32
- MQ135 Sensor
- MQ6 Sensor
- SHT30 Sensor
- Servo Motor
- Buzzer

## Software & Cloud
- Flutter
- Spring Boot
- MySQL
- InfluxDB
- AWS IoT Core
- Firebase Cloud Messaging (FCM)

---

# 📁 Project Structure

text
clucknet/
│
├── edge-esp32/          # Edge ESP32 source code
├── gateway-esp32/       # Gateway ESP32 source code
├── backend/             # Spring Boot backend
├── mobile-app/          # Flutter mobile application
├── diagrams/            # System diagrams & UML
├── docs/                # Documentation
└── README.md

## 👨‍💻 Team

Group 18 – University of Peradeniya


---

## Team
- e21130, Fazly Foumy, [e21130@eng.pdn.ac.lk](mailto:member1@email.com)
- e21335, Rayid Husain, [e21335@eng.pdn.ac.lk](mailto:member2@email.com)
- e21336, Rinos Ramlan, [e21336@eng.pdn.ac.lk](mailto:member3@email.com)
- e21342, Saabith Munab, [e21342@eng.pdn.ac.lk](mailto:member4@email.com)

<!-- Image (photo/drawing of the final hardware) should be here -->
<!-- ![System Overview](./images/system_overview.png) -->

## Links

- [Project Repository](https://github.com/cepdnaclk/{{ page.repository-name }}){:target="_blank"}
- [Project Page](https://cepdnaclk.github.io/{{ page.repository-name}}){:target="_blank"}
- [Department of Computer Engineering](http://www.ce.pdn.ac.lk/)
- [University of Peradeniya](https://eng.pdn.ac.lk/)
