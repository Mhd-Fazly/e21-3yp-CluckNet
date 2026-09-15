import React, { useState } from 'react';
import { Cpu, Wifi, Cloud, Database, Smartphone, ShieldCheck, Zap, Radio } from 'lucide-react';
import { getAssetUrl, handleImageError } from '../utils/assets';

export const HowItWorks: React.FC = () => {
  const [selectedNode, setSelectedNode] = useState<number | null>(1);

  const flowNodes = [
    {
      id: 1,
      step: '01',
      title: 'Sensors Layer',
      subtitle: 'SHT30, MQ135 & MQ6',
      icon: Radio,
      color: 'emerald',
      badge: 'I2C & Analog',
      desc: 'SHT30 measures ambient temperature & humidity via I2C. MQ135 measures ammonia gas (NH₃), and MQ6 detects flammable LPG gas levels.'
    },
    {
      id: 2,
      step: '02',
      title: 'Edge Device',
      subtitle: 'ESP32 Microcontroller',
      icon: Cpu,
      color: 'blue',
      badge: 'Local Control',
      desc: 'Processes analog & digital signals in real-time. Immediately triggers local buzzer and turns the 180° servo motor to close the gas regulator valve if threshold breaches occur.'
    },
    {
      id: 3,
      step: '03',
      title: 'ESP-NOW Wireless',
      subtitle: 'Low Latency Link',
      icon: Wifi,
      color: 'cyan',
      badge: 'Encrypted Link',
      desc: 'Transmits telemetry packets over low-latency peer-to-peer ESP-NOW protocol directly to the gateway, ensuring independence from local internet outages.'
    },
    {
      id: 4,
      step: '04',
      title: 'Gateway ESP32',
      subtitle: 'WiFi Internet Bridge',
      icon: Wifi,
      color: 'amber',
      badge: 'MQTT Bridge',
      desc: 'Receives local ESP-NOW data packages and forwards them over WiFi connection to the cloud MQTT broker via TLS-encrypted socket.'
    },
    {
      id: 5,
      step: '05',
      title: 'Cloud MQTT Broker',
      subtitle: 'AWS IoT Core',
      icon: Cloud,
      color: 'purple',
      badge: 'Topic-Based Pub/Sub Model',
      desc: 'High-throughput enterprise MQTT broker managing publish-subscribe queues and secure TLS handshake.'
    },
    {
      id: 6,
      step: '06',
      title: 'Backend Processing',
      subtitle: 'Spring Boot Java',
      icon: ShieldCheck,
      color: 'emerald',
      badge: 'REST & MQTT',
      desc: 'Hosted on AWS EC2. Subscribes to MQTT telemetry topics, executes business logic, triggers Firebase push notifications, and handles user REST API requests.'
    },
    {
      id: 7,
      step: '07',
      title: 'Dual Database',
      subtitle: 'MySQL & InfluxDB',
      icon: Database,
      color: 'blue',
      badge: 'Relational + Time-Series',
      desc: 'MySQL stores user credentials, farm zones & device metadata. InfluxDB stores high-resolution time-series telemetry data for historical analytics.'
    },
    {
      id: 8,
      step: '08',
      title: 'Mobile Dashboard',
      subtitle: 'Mobile Dashboard',
      icon: Smartphone,
      color: 'teal',
      badge: 'Cross-Platform',
      desc: 'Farmers monitor real-time zone cards, view telemetry charts, receive instant emergency push notifications, and issue remote override controls.'
    }
  ];

  return (
    <section id="how-it-works" className="py-24 relative bg-slate-950/80 border-t border-white/5">
      {/* Background Glow */}
      <div className="absolute top-1/3 left-1/2 -translate-x-1/2 w-[800px] h-[300px] bg-emerald-500/5 blur-[160px] pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">

        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-xs font-semibold uppercase tracking-wider mb-4">
            <Zap className="w-3.5 h-3.5" />
            System Architecture
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-white tracking-tight leading-tight mb-4">
            From sensing to automated action
          </h2>
          <p className="text-base sm:text-lg text-slate-300">
            Click or hover over any component in the data pipeline to inspect its exact role in CluckNet's end-to-end architecture.
          </p>
        </div>

        {/* Architecture Diagram Image from Provided Materials */}
        <div className="glass-panel p-4 sm:p-6 rounded-3xl border border-white/10 mb-12 bg-slate-900/90 shadow-2xl overflow-hidden">
          <div className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-4 flex items-center justify-between">
            <span>Verified System Architecture Schema</span>
            <span className="text-emerald-400 font-mono">AWS IoT Core + Spring Boot</span>
          </div>

          <div className="rounded-2xl overflow-hidden bg-slate-950 border border-white/10">
            <img
              src={getAssetUrl('assets/system architecture.png')}
              onError={(e) => handleImageError(e, 'assets/system architecture.png')}
              alt="CluckNet Official System Architecture Diagram"
              className="w-full h-auto object-contain max-h-[480px] mx-auto hover:scale-[1.01] transition-transform duration-500"
            />
          </div>
        </div>

        {/* Interactive Data Flow Pipeline Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
          {flowNodes.map((node) => {
            const Icon = node.icon;
            const isSelected = selectedNode === node.id;

            return (
              <div
                key={node.id}
                onClick={() => setSelectedNode(node.id)}
                onMouseEnter={() => setSelectedNode(node.id)}
                className={`p-5 rounded-2xl cursor-pointer transition-all duration-300 border ${isSelected
                    ? 'bg-slate-900 border-emerald-500 shadow-lg shadow-emerald-500/15 scale-[1.03]'
                    : 'glass-panel border-white/10 hover:border-white/20'
                  }`}
              >
                <div className="flex items-center justify-between mb-3">
                  <span className="text-xs font-mono font-bold text-slate-500">{node.step}</span>
                  <span className="text-[10px] font-semibold px-2 py-0.5 rounded bg-white/5 text-slate-300 border border-white/10">
                    {node.badge}
                  </span>
                </div>

                <div className="flex items-center gap-3 mb-2">
                  <div className={`p-2.5 rounded-xl ${isSelected ? 'bg-emerald-500 text-cluck-navy' : 'bg-white/5 text-emerald-400'}`}>
                    <Icon className="w-5 h-5" />
                  </div>
                  <div>
                    <h3 className="text-sm font-bold text-white leading-snug">{node.title}</h3>
                    <div className="text-xs text-slate-400 font-medium">{node.subtitle}</div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Detail Inspection Box */}
        {selectedNode && (
          <div className="glass-panel p-6 sm:p-8 rounded-3xl border border-emerald-500/30 bg-slate-900/90 transition-all duration-300">
            <div className="flex items-center gap-3 mb-3">
              <span className="text-xs font-mono font-bold px-2.5 py-1 rounded bg-emerald-500/20 text-emerald-400 border border-emerald-500/30">
                Component Detail — Step {flowNodes[selectedNode - 1].step}
              </span>
              <h3 className="text-xl font-bold text-white">{flowNodes[selectedNode - 1].title}</h3>
            </div>
            <p className="text-sm sm:text-base text-slate-200 leading-relaxed max-w-4xl">
              {flowNodes[selectedNode - 1].desc}
            </p>
          </div>
        )}

      </div>
    </section>
  );
};
