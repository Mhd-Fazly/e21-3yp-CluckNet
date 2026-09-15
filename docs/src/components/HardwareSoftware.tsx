import React, { useState } from 'react';
import { Cpu, Code2, ChevronLeft, ChevronRight } from 'lucide-react';
import { getAssetUrl, handleImageError } from '../utils/assets';

export const HardwareSoftware: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'hardware' | 'software'>('hardware');
  const [powerSlideIndex, setPowerSlideIndex] = useState<number>(0);

  const powerSlides = [
    {
      title: 'Hardware Power System Circuit Implementation 1',
      rawPath: 'assets/device power system/Screenshot 2026-09-07 110119.png',
      src: getAssetUrl('assets/device power system/Screenshot 2026-09-07 110119.png')
    },
    {
      title: 'Hardware Power System Circuit Implementation 2',
      rawPath: 'assets/device power system/Screenshot 2026-09-07 110108.png',
      src: getAssetUrl('assets/device power system/Screenshot 2026-09-07 110108.png')
    }
  ];

  const hardwareItems = [
    {
      name: 'ESP32 Microcontroller',
      role: 'Edge Core & Gateway',
      specs: 'Dual-core 240MHz · 5V VIN · 150–200mA',
      symbol: getAssetUrl('assets/Hardware components/esp32.png'),
      rawSymbol: 'assets/Hardware components/esp32.png'
    },
    {
      name: 'SHT30 Sensor Module',
      role: 'Temperature & Humidity',
      specs: 'I2C Interface · 3.3V · 2mA',
      symbol: getAssetUrl('assets/Hardware components/sht30.png'),
      rawSymbol: 'assets/Hardware components/sht30.png'
    },
    {
      name: 'MQ135 Gas Sensor',
      role: 'Ammonia (NH₃) Gas Detection',
      specs: 'Analog Output · 5V · 150–200mA',
      symbol: getAssetUrl('assets/Hardware components/mq135.png'),
      rawSymbol: 'assets/Hardware components/mq135.png'
    },
    {
      name: 'MQ6 Gas Sensor',
      role: 'LPG Fuel Leak Detection',
      specs: 'Analog Output · 5V · 150–200mA',
      symbol: getAssetUrl('assets/Hardware components/mq6.png'),
      rawSymbol: 'assets/Hardware components/mq6.png'
    },
    {
      name: 'Servo Motor (MG995)',
      role: '180° Gas Regulator Shutoff',
      specs: '5V · High Torque 10–500mA',
      symbol: getAssetUrl('assets/Hardware components/servo-motor.png'),
      rawSymbol: 'assets/Hardware components/servo-motor.png'
    },
    {
      name: '5V Buzzer Module',
      role: 'Acoustic Hazard Alert',
      specs: '5V · 10–20mA High Decibel',
      symbol: getAssetUrl('assets/Hardware components/buzzer.png'),
      rawSymbol: 'assets/Hardware components/buzzer.png'
    },
    {
      name: 'LM2596 Buck Converter',
      role: 'Voltage Step Down (12V to 5V)',
      specs: '12V DC Input · 5V DC Output',
      symbol: getAssetUrl('assets/Hardware components/bug-convertor.png'),
      rawSymbol: 'assets/Hardware components/bug-convertor.png'
    },
    {
      name: '3S LiFePO4 Battery Pack',
      role: 'Uninterruptible Backup Power',
      specs: '3x 18650 Cells · 11.1V Nominal · 3S BMS',
      symbol: getAssetUrl('assets/Hardware components/battery.png'),
      rawSymbol: 'assets/Hardware components/battery.png'
    },
  ];

  const softwareItems = [
    {
      name: 'Spring Boot (Java)',
      role: 'Core Backend Framework',
      specs: 'AWS EC2 Hosted · REST APIs & MQTT Threads',
      symbol: getAssetUrl('assets/symbols/spring-boot.png'),
      rawSymbol: 'assets/symbols/spring-boot.png'
    },
    {
      name: 'AWS IoT Core',
      role: 'Cloud MQTT Broker',
      specs: 'MQTT over TLS · Topic-Based Pub/Sub Model',
      symbol: getAssetUrl('assets/symbols/iot_title.png'),
      rawSymbol: 'assets/symbols/iot_title.png'
    },
    {
      name: 'MySQL Database',
      role: 'Relational User & Device Data',
      specs: 'AWS RDS Managed · Structured Storage',
      symbol: getAssetUrl('assets/symbols/mysql.png'),
      rawSymbol: 'assets/symbols/mysql.png'
    },
    {
      name: 'InfluxDB',
      role: 'Time-Series Telemetry DB',
      specs: 'High-speed Telemetry & Historical Analytics',
      symbol: getAssetUrl('assets/symbols/influx.png'),
      rawSymbol: 'assets/symbols/influx.png'
    },
    {
      name: 'Flutter Framework',
      role: 'Cross-Platform Mobile App',
      specs: 'iOS & Android · Real-Time Dashboard UI',
      symbol: getAssetUrl('assets/symbols/flutter.jpg'),
      rawSymbol: 'assets/symbols/flutter.jpg'
    },
    {
      name: 'Firebase Cloud Messaging',
      role: 'Instant Push Alerts',
      specs: 'Mobile Hazard Alert Notifications',
      symbol: getAssetUrl('assets/symbols/firebase-cloud-messaging.jpg'),
      rawSymbol: 'assets/symbols/firebase-cloud-messaging.jpg'
    },
    {
      name: 'ESP-NOW Protocol',
      role: 'Peer-to-Peer Radio Mesh',
      specs: 'Encrypted MAC Layer · Sub-100ms Latency',
      symbol: getAssetUrl('assets/symbols/esp-now.jpg'),
      rawSymbol: 'assets/symbols/esp-now.jpg'
    },
    {
      name: 'JWT & BCrypt Security',
      role: 'REST Authentication & Encryption',
      specs: 'HTTPS · Session Tokens & Password Hashing',
      symbol: getAssetUrl('assets/symbols/jwt.webp'),
      rawSymbol: 'assets/symbols/jwt.webp'
    },
  ];

  return (
    <section id="hardware-software" className="py-24 relative bg-white border-t border-slate-300">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Left-Aligned Section Header */}
        <div className="text-left max-w-3xl mb-12">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 tracking-tight leading-tight mb-4">
            Hardware & Software
          </h2>
          <p className="text-base sm:text-lg text-slate-600">
            A production-grade engineering stack dividing edge physical hardware components and robust cloud software infrastructure.
          </p>
        </div>

        {/* Toggle Selector Tabs */}
        <div className="flex items-center justify-start gap-3 mb-12">
          <button
            onClick={() => setActiveTab('hardware')}
            className={`flex items-center gap-2 px-6 py-3 rounded-full text-xs font-bold transition-all shadow-sm ${
              activeTab === 'hardware'
                ? 'bg-emerald-600 text-white shadow-emerald-600/20'
                : 'bg-slate-100 text-slate-700 hover:bg-slate-200 border border-slate-200'
            }`}
          >
            <Cpu className="w-4 h-4" />
            <span>Hardware Components</span>
          </button>
          <button
            onClick={() => setActiveTab('software')}
            className={`flex items-center gap-2 px-6 py-3 rounded-full text-xs font-bold transition-all shadow-sm ${
              activeTab === 'software'
                ? 'bg-blue-600 text-white shadow-blue-600/20'
                : 'bg-slate-100 text-slate-700 hover:bg-slate-200 border border-slate-200'
            }`}
          >
            <Code2 className="w-4 h-4" />
            <span>Software Stack</span>
          </button>
        </div>

        {/* HARDWARE AREA */}
        {activeTab === 'hardware' && (
          <div>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
              {hardwareItems.map((item, idx) => (
                <div
                  key={idx}
                  className="bg-slate-50 hover:bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex flex-col justify-between transition-all duration-300 transform hover:-translate-y-2 hover:shadow-xl hover:border-emerald-500/50 cursor-pointer group"
                >
                  <div>
                    <div className="flex items-start justify-between gap-3 mb-2">
                      <div>
                        <span className="text-[10px] font-bold text-emerald-700 uppercase tracking-wider block mb-1">{item.role}</span>
                        <h3 className="text-base font-bold text-slate-900 group-hover:text-emerald-700 transition-colors">{item.name}</h3>
                      </div>
                      {item.symbol && (
                        <div className="w-10 h-10 rounded-xl bg-white border border-slate-200 shadow-sm p-1.5 flex items-center justify-center shrink-0 group-hover:border-emerald-400 transition-colors">
                          <img
                            src={item.symbol}
                            onError={(e) => handleImageError(e, item.rawSymbol)}
                            alt={item.name}
                            className="w-full h-full object-contain rounded"
                          />
                        </div>
                      )}
                    </div>
                  </div>
                  <div className="pt-3 border-t border-slate-200 text-[11px] font-['Arial',sans-serif] text-slate-600">
                    {item.specs}
                  </div>
                </div>
              ))}
            </div>

            {/* Power Wiring Schematic & Circuit Implementation Interactive Slider Card */}
            <div className="bg-slate-50 p-6 sm:p-8 rounded-3xl border border-slate-200 shadow-sm">
              <div className="mb-4">
                <h4 className="text-lg font-extrabold text-slate-900">Hardware Power System & Circuit Implementation</h4>
              </div>

              {/* Sliding Image Container */}
              <div className="rounded-2xl overflow-hidden bg-white border border-slate-200 p-2 sm:p-4 relative group">
                <img
                  src={powerSlides[powerSlideIndex].src}
                  onError={(e) => handleImageError(e, powerSlides[powerSlideIndex].rawPath)}
                  alt={powerSlides[powerSlideIndex].title}
                  className="w-full h-auto object-contain max-h-[520px] mx-auto hover:scale-[1.01] transition-transform duration-500 rounded-xl"
                />

                {/* Left Arrow Button */}
                <button
                  onClick={() => setPowerSlideIndex((prev) => (prev === 0 ? powerSlides.length - 1 : prev - 1))}
                  className="absolute left-4 top-1/2 -translate-y-1/2 p-2.5 rounded-full bg-slate-900/60 text-white hover:bg-emerald-600 transition-all shadow-md active:scale-95 backdrop-blur-sm"
                  title="Previous Diagram"
                >
                  <ChevronLeft className="w-5 h-5" />
                </button>

                {/* Right Arrow Button */}
                <button
                  onClick={() => setPowerSlideIndex((prev) => (prev === powerSlides.length - 1 ? 0 : prev + 1))}
                  className="absolute right-4 top-1/2 -translate-y-1/2 p-2.5 rounded-full bg-slate-900/60 text-white hover:bg-emerald-600 transition-all shadow-md active:scale-95 backdrop-blur-sm"
                  title="Next Diagram"
                >
                  <ChevronRight className="w-5 h-5" />
                </button>

                {/* Sliding Dot Navigation Indicators */}
                <div className="flex justify-center items-center gap-2 mt-4 pt-3 border-t border-slate-100">
                  {powerSlides.map((_, idx) => (
                    <button
                      key={idx}
                      onClick={() => setPowerSlideIndex(idx)}
                      className={`h-2.5 rounded-full transition-all duration-300 ${
                        powerSlideIndex === idx
                          ? 'w-8 bg-emerald-600'
                          : 'w-2.5 bg-slate-300 hover:bg-slate-400'
                      }`}
                      title={`Switch to Diagram ${idx + 1}`}
                    />
                  ))}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* SOFTWARE AREA */}
        {activeTab === 'software' && (
          <div>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
              {softwareItems.map((item, idx) => (
                <div
                  key={idx}
                  className="bg-slate-50 hover:bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex flex-col justify-between transition-all duration-300 transform hover:-translate-y-2 hover:shadow-xl hover:border-blue-500/50 cursor-pointer group"
                >
                  <div>
                    <div className="flex items-start justify-between gap-3 mb-2">
                      <div>
                        <span className="text-[10px] font-bold text-blue-700 uppercase tracking-wider block mb-1">{item.role}</span>
                        <h3 className="text-base font-bold text-slate-900 group-hover:text-blue-700 transition-colors">{item.name}</h3>
                      </div>
                      {item.symbol && (
                        <div className="w-10 h-10 rounded-xl bg-white border border-slate-200 shadow-sm p-1.5 flex items-center justify-center shrink-0 group-hover:border-blue-400 transition-colors">
                          <img
                            src={item.symbol}
                            onError={(e) => handleImageError(e, item.rawSymbol)}
                            alt={item.name}
                            className="w-full h-full object-contain rounded"
                          />
                        </div>
                      )}
                    </div>
                  </div>
                  <div className="pt-3 border-t border-slate-200 text-[11px] font-['Arial',sans-serif] text-slate-600">
                    {item.specs}
                  </div>
                </div>
              ))}
            </div>

            {/* Security Architecture Diagram */}
            <div className="bg-slate-50 p-6 rounded-3xl border border-slate-200 shadow-sm">
              <h4 className="text-lg font-bold text-slate-900 mb-4">Software Security & Auth Architecture</h4>
              <div className="rounded-2xl overflow-hidden bg-white border border-slate-200 p-2 sm:p-4">
                <img
                  src={getAssetUrl('assets/security.png')}
                  onError={(e) => handleImageError(e, 'assets/security.png')}
                  alt="CluckNet Security Architecture Diagram"
                  className="w-full h-auto object-contain max-h-[480px] mx-auto hover:scale-[1.01] transition-transform duration-500 rounded-xl"
                />
              </div>
            </div>
          </div>
        )}

      </div>
    </section>
  );
};
