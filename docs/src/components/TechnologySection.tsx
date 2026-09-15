import React, { useState } from 'react';
import { Server, Zap, Lock, Check } from 'lucide-react';
import { getAssetUrl, handleImageError } from '../utils/assets';

export const TechnologySection: React.FC = () => {
  const [activeCategory, setActiveCategory] = useState<'all' | 'hardware' | 'backend' | 'power' | 'security'>('all');

  const techStack = [
    {
      category: 'hardware',
      name: 'ESP32 Microcontroller',
      role: 'Edge Computing & Gateway',
      detail: 'Dual-core 240MHz microcontroller handling local sensor IO, ESP-NOW wireless mesh, and MQTT publishing.',
      specs: '5V VIN · 150–200 mA · 0.75–1.0 W'
    },
    {
      category: 'hardware',
      name: 'SHT30 Sensor Module',
      role: 'Temperature & Humidity',
      detail: 'High-precision digital environmental sensor interfaced via I2C bus.',
      specs: '3.3V · 2 mA · 0.006 W'
    },
    {
      category: 'hardware',
      name: 'MQ135 Gas Sensor',
      role: 'Ammonia (NH₃) Detection',
      detail: 'Analog gas sensor calibrated for detecting dangerous ammonia concentrations.',
      specs: '5V · 150–200 mA · 0.75–1.0 W'
    },
    {
      category: 'hardware',
      name: 'MQ6 Gas Sensor',
      role: 'LPG Gas Leak Detection',
      detail: 'Combustible gas sensor monitoring heater fuel lines for explosive leaks.',
      specs: '5V · 150–200 mA · 0.75–1.0 W'
    },
    {
      category: 'hardware',
      name: 'Servo Motor (MG995)',
      role: 'Gas Valve Regulator Actuator',
      detail: 'High-torque 180° physical actuator that mechanically shuts down gas supply during alerts.',
      specs: '5V · 10–500 mA · 0.05–2.5 W'
    },
    {
      category: 'hardware',
      name: '5V Buzzer Module',
      role: 'Audible Hazard Alert',
      detail: 'High-decibel acoustic alert system for immediate local farm notifications.',
      specs: '5V · 10–20 mA · 0.1–0.25 W'
    },
    {
      category: 'backend',
      name: 'Spring Boot (Java)',
      role: 'Core Backend Framework',
      detail: 'Enterprise Java backend managing MQTT subscriber threads, REST APIs, and business rules engine.',
      specs: 'Hosted on AWS EC2'
    },
    {
      category: 'backend',
      name: 'AWS IoT Core',
      role: 'Cloud MQTT Broker',
      detail: 'High-speed MQTT message broker supporting encrypted TLS connections under a topic-based publisher-subscriber model.',
      specs: 'MQTT over TLS'
    },
    {
      category: 'backend',
      name: 'MySQL Database',
      role: 'Relational Data Storage',
      detail: 'Stores user accounts, farm zone assignments, and device configuration metadata.',
      specs: 'AWS RDS Managed'
    },
    {
      category: 'backend',
      name: 'InfluxDB',
      role: 'Time-Series Database',
      detail: 'Optimized high-speed storage for continuous telemetry time-series logs and historical trends.',
      specs: 'Long-term Telemetry'
    },
    {
      category: 'backend',
      name: 'Flutter & Firebase',
      role: 'Mobile Frontend & Push',
      detail: 'Cross-platform mobile app for iOS and Android with real-time push alerts via Firebase Cloud Messaging.',
      specs: 'JWT Auth · REST API'
    },
    {
      category: 'security',
      name: 'ESP-NOW Encryption',
      role: 'Edge-to-Gateway Link',
      detail: 'Local peer-to-peer wireless protocol encrypted natively between edge nodes.',
      specs: 'Sub-100ms Latency'
    },
    {
      category: 'security',
      name: 'MQTT over TLS / SSL',
      role: 'Gateway-to-Cloud Link',
      detail: 'End-to-end transport layer encryption protecting telemetry in transit across public networks.',
      specs: 'X.509 Certificates'
    },
    {
      category: 'power',
      name: '3S LiFePO4 Battery Pack',
      role: 'Uninterruptible Backup Power',
      detail: '3x 3.7V 18650 cells (11.1V nominal / 12.6V full) with 3S BMS protection and LM2596 buck converter.',
      specs: 'Dual Failover Power'
    }
  ];

  const filteredTech = activeCategory === 'all'
    ? techStack
    : techStack.filter(item => item.category === activeCategory);

  return (
    <section id="technology" className="py-24 relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">

        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-12">
          <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs font-semibold uppercase tracking-wider mb-4">
            <Server className="w-3.5 h-3.5" />
            Engineering Credibility
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-white tracking-tight leading-tight mb-4">
            Built from the edge to the cloud
          </h2>
          <p className="text-base sm:text-lg text-slate-300">
            A production-grade tech stack combining edge computing, encrypted protocols, cloud infrastructure, and fail-safe power architecture.
          </p>
        </div>

        {/* Category Filter Tabs */}
        <div className="flex flex-wrap items-center justify-center gap-2 mb-12">
          {[
            { id: 'all', label: 'All Technologies' },
            { id: 'hardware', label: 'Hardware & Edge' },
            { id: 'backend', label: 'Backend & Cloud' },
            { id: 'power', label: 'Power System' },
            { id: 'security', label: 'Security & Auth' },
          ].map(tab => (
            <button
              key={tab.id}
              onClick={() => setActiveCategory(tab.id as any)}
              className={`px-5 py-2.5 rounded-full text-xs font-bold transition-all duration-200 ${activeCategory === tab.id
                  ? 'bg-emerald-500 text-cluck-navy shadow-lg shadow-emerald-500/20'
                  : 'bg-white/5 hover:bg-white/10 text-slate-300 border border-white/10'
                }`}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {/* Tech Stack Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-16">
          {filteredTech.map((item, idx) => (
            <div
              key={idx}
              className="glass-panel p-6 rounded-3xl border border-white/10 hover:border-emerald-500/30 transition-all duration-300 flex flex-col justify-between group"
            >
              <div>
                <div className="flex items-center justify-between mb-3">
                  <span className="text-xs font-bold text-emerald-400 uppercase tracking-wider">{item.role}</span>
                  <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-white/5 text-slate-400 border border-white/5">
                    {item.specs}
                  </span>
                </div>
                <h3 className="text-lg font-bold text-white group-hover:text-emerald-400 transition-colors mb-2">
                  {item.name}
                </h3>
                <p className="text-xs text-slate-300 leading-relaxed mb-4">
                  {item.detail}
                </p>
              </div>

              <div className="pt-3 border-t border-white/5 flex items-center justify-between text-[11px] text-slate-400 font-medium">
                <span>Status: Production Ready</span>
                <Check className="w-3.5 h-3.5 text-emerald-400" />
              </div>
            </div>
          ))}
        </div>

        {/* Highlight Box: Security & Power Schematics Diagrams */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">

          {/* Security Deep Dive with Visual Architecture Diagram */}
          <div className="glass-panel p-6 sm:p-8 rounded-3xl border border-white/10 bg-slate-900/80 flex flex-col justify-between">
            <div>
              <div className="flex items-center gap-3 mb-6">
                <div className="w-10 h-10 rounded-xl bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 flex items-center justify-center">
                  <Lock className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="text-xl font-bold text-white">Multi-Layer System Security</h3>
                  <div className="text-xs text-slate-400">Zero-Trust Telemetry Architecture</div>
                </div>
              </div>

              <div className="rounded-2xl overflow-hidden bg-slate-950 border border-white/10 mb-6 p-2">
                <img
                  src={getAssetUrl('assets/security.png')}
                  onError={(e) => handleImageError(e, 'assets/security.png')}
                  alt="CluckNet System Security Diagram"
                  className="w-full h-auto object-contain max-h-[380px] mx-auto hover:scale-[1.01] transition-transform duration-500 rounded-xl"
                />
              </div>

              <div className="space-y-2.5">
                <div className="bg-slate-950 p-3.5 rounded-2xl border border-white/5">
                  <div className="text-xs font-bold text-white mb-0.5">ESP-NOW Encrypted Mesh</div>
                  <div className="text-xs text-slate-300">Local radio communications between edge sensor nodes and gateway are encrypted at the MAC layer.</div>
                </div>
                <div className="bg-slate-950 p-3.5 rounded-2xl border border-white/5">
                  <div className="text-xs font-bold text-white mb-0.5">MQTT over TLS Encrypted Sockets</div>
                  <div className="text-xs text-slate-300">Gateway publishes data to AWS IoT Core over port 8883 with mutual TLS authentication.</div>
                </div>
              </div>
            </div>
          </div>

          {/* Power System Failover with Schematic Diagram */}
          <div className="glass-panel p-6 sm:p-8 rounded-3xl border border-white/10 bg-slate-900/80 flex flex-col justify-between">
            <div>
              <div className="flex items-center gap-3 mb-6">
                <div className="w-10 h-10 rounded-xl bg-amber-500/10 text-amber-400 border border-amber-500/20 flex items-center justify-center">
                  <Zap className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="text-xl font-bold text-white">Dual Power Failover Architecture</h3>
                  <div className="text-xs text-slate-400">Continuous 24/7 Monitoring Guarantee</div>
                </div>
              </div>

              <div className="rounded-2xl overflow-hidden bg-slate-950 border border-white/10 mb-6">
                <img
                  src={getAssetUrl('assets/device power system/Screenshot 2026-09-07 110108.png')}
                  onError={(e) => handleImageError(e, 'assets/device power system/Screenshot 2026-09-07 110108.png')}
                  alt="CluckNet Power System Wiring Schematic"
                  className="w-full h-auto object-contain max-h-[280px] mx-auto hover:scale-105 transition-transform duration-500"
                />
              </div>

              <div className="space-y-2.5">
                <div className="bg-slate-950 p-3.5 rounded-2xl border border-white/5">
                  <div className="flex items-center justify-between text-xs font-bold text-emerald-400 mb-0.5">
                    <span>Normal Operation</span>
                    <span>Grid AC Power</span>
                  </div>
                  <div className="text-xs text-slate-300">12V DC Adapter (2A) → LM2596 Buck Converter (5V DC) → ESP32 Edge & Sensors while charging the LiFePO4 battery pack.</div>
                </div>

                <div className="bg-slate-950 p-3.5 rounded-2xl border border-white/5">
                  <div className="flex items-center justify-between text-xs font-bold text-amber-400 mb-0.5">
                    <span>Backup Power Mode</span>
                    <span>Instant Battery Switchover</span>
                  </div>
                  <div className="text-xs text-slate-300">3S 18650 BMS Battery Pack (11.1V Nominal) seamlessly feeds the buck converter with zero power interruption during blackout.</div>
                </div>
              </div>
            </div>
          </div>

        </div>

      </div>
    </section>
  );
};
