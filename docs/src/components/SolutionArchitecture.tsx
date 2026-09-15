import React, { useState } from 'react';
import { Cpu, Wifi, Cloud, Database, Smartphone, ShieldCheck, Radio, Zap, Bell } from 'lucide-react';
import { getAssetUrl, handleImageError } from '../utils/assets';

export const SolutionArchitecture: React.FC = () => {
  const [selectedNode, setSelectedNode] = useState<number | null>(1);
  const [activeTab, setActiveTab] = useState<'monitor' | 'detect' | 'respond' | 'notify'>('monitor');

  const flowNodes = [
    {
      id: 1,
      step: '01',
      title: 'Sensors Layer',
      subtitle: 'SHT30, MQ135 & MQ6',
      icon: Radio,
      badge: 'I2C & Analog',
      desc: 'SHT30 measures temperature & humidity via I2C. MQ135 measures ammonia (NH₃), and MQ6 detects LPG gas levels.',
      activeClass: 'bg-emerald-50/90 border-emerald-500 shadow-md ring-2 ring-emerald-500/20 scale-[1.02]',
      hoverClass: 'hover:border-emerald-500 hover:bg-emerald-50/50 hover:-translate-y-1.5 hover:shadow-lg',
      iconActive: 'bg-emerald-600 text-white',
      iconDefault: 'bg-emerald-100 text-emerald-700',
      detailBoxClass: 'bg-emerald-50/40 border-emerald-400 shadow-emerald-500/10',
      detailTitleClass: 'text-emerald-900',
      badgeClass: 'bg-emerald-100 text-emerald-800 border-emerald-200'
    },
    {
      id: 2,
      step: '02',
      title: 'Edge Device',
      subtitle: 'ESP32 Microcontroller',
      icon: Cpu,
      badge: 'Local Control',
      desc: 'Processes signals locally. Immediately activates local buzzer alarm and 180° servo motor to close gas valve on danger.',
      activeClass: 'bg-blue-50/90 border-blue-500 shadow-md ring-2 ring-blue-500/20 scale-[1.02]',
      hoverClass: 'hover:border-blue-500 hover:bg-blue-50/50 hover:-translate-y-1.5 hover:shadow-lg',
      iconActive: 'bg-blue-600 text-white',
      iconDefault: 'bg-blue-100 text-blue-700',
      detailBoxClass: 'bg-blue-50/40 border-blue-400 shadow-blue-500/10',
      detailTitleClass: 'text-blue-900',
      badgeClass: 'bg-blue-100 text-blue-800 border-blue-200'
    },
    {
      id: 3,
      step: '03',
      title: 'ESP-NOW Wireless',
      subtitle: 'Low Latency Link',
      icon: Wifi,
      badge: 'Encrypted Link',
      desc: 'Transmits telemetry packets over encrypted peer-to-peer ESP-NOW protocol directly to gateway without internet.',
      activeClass: 'bg-teal-50/90 border-teal-500 shadow-md ring-2 ring-teal-500/20 scale-[1.02]',
      hoverClass: 'hover:border-teal-500 hover:bg-teal-50/50 hover:-translate-y-1.5 hover:shadow-lg',
      iconActive: 'bg-teal-600 text-white',
      iconDefault: 'bg-teal-100 text-teal-700',
      detailBoxClass: 'bg-teal-50/40 border-teal-400 shadow-teal-500/10',
      detailTitleClass: 'text-teal-900',
      badgeClass: 'bg-teal-100 text-teal-800 border-teal-200'
    },
    {
      id: 4,
      step: '04',
      title: 'Gateway ESP32',
      subtitle: 'WiFi Internet Bridge',
      icon: Wifi,
      badge: 'MQTT Bridge',
      desc: 'Forwards ESP-NOW local data packages over WiFi to cloud MQTT broker over TLS encrypted connection.',
      activeClass: 'bg-amber-50/90 border-amber-500 shadow-md ring-2 ring-amber-500/20 scale-[1.02]',
      hoverClass: 'hover:border-amber-500 hover:bg-amber-50/50 hover:-translate-y-1.5 hover:shadow-lg',
      iconActive: 'bg-amber-600 text-white',
      iconDefault: 'bg-amber-100 text-amber-700',
      detailBoxClass: 'bg-amber-50/40 border-amber-400 shadow-amber-500/10',
      detailTitleClass: 'text-amber-900',
      badgeClass: 'bg-amber-100 text-amber-800 border-amber-200'
    },
    {
      id: 5,
      step: '05',
      title: 'Cloud MQTT Broker',
      subtitle: 'AWS IoT Core',
      icon: Cloud,
      badge: 'Topic-Based Pub/Sub Model',
      desc: 'High-throughput cloud MQTT broker handling publish-subscribe message queues over port 8883.',
      activeClass: 'bg-indigo-50/90 border-indigo-500 shadow-md ring-2 ring-indigo-500/20 scale-[1.02]',
      hoverClass: 'hover:border-indigo-500 hover:bg-indigo-50/50 hover:-translate-y-1.5 hover:shadow-lg',
      iconActive: 'bg-indigo-600 text-white',
      iconDefault: 'bg-indigo-100 text-indigo-700',
      detailBoxClass: 'bg-indigo-50/40 border-indigo-400 shadow-indigo-500/10',
      detailTitleClass: 'text-indigo-900',
      badgeClass: 'bg-indigo-100 text-indigo-800 border-indigo-200'
    },
    {
      id: 6,
      step: '06',
      title: 'Backend Processing',
      subtitle: 'Spring Boot Java',
      icon: ShieldCheck,
      badge: 'REST & MQTT',
      desc: 'Hosted on AWS EC2. Subscribes to MQTT topics, executes business rules engine, and sends Firebase push notifications.',
      activeClass: 'bg-purple-50/90 border-purple-500 shadow-md ring-2 ring-purple-500/20 scale-[1.02]',
      hoverClass: 'hover:border-purple-500 hover:bg-purple-50/50 hover:-translate-y-1.5 hover:shadow-lg',
      iconActive: 'bg-purple-600 text-white',
      iconDefault: 'bg-purple-100 text-purple-700',
      detailBoxClass: 'bg-purple-50/40 border-purple-400 shadow-purple-500/10',
      detailTitleClass: 'text-purple-900',
      badgeClass: 'bg-purple-100 text-purple-800 border-purple-200'
    },
    {
      id: 7,
      step: '07',
      title: 'Dual Database',
      subtitle: 'MySQL & InfluxDB',
      icon: Database,
      badge: 'Relational + Time-Series',
      desc: 'MySQL stores users & devices. InfluxDB stores high-speed continuous sensor telemetry logs for trends.',
      activeClass: 'bg-rose-50/90 border-rose-500 shadow-md ring-2 ring-rose-500/20 scale-[1.02]',
      hoverClass: 'hover:border-rose-500 hover:bg-rose-50/50 hover:-translate-y-1.5 hover:shadow-lg',
      iconActive: 'bg-rose-600 text-white',
      iconDefault: 'bg-rose-100 text-rose-700',
      detailBoxClass: 'bg-rose-50/40 border-rose-400 shadow-rose-500/10',
      detailTitleClass: 'text-rose-900',
      badgeClass: 'bg-rose-100 text-rose-800 border-rose-200'
    },
    {
      id: 8,
      step: '08',
      title: 'Mobile Dashboard',
      subtitle: 'Flutter Mobile App',
      icon: Smartphone,
      badge: 'Cross-Platform',
      desc: 'Farmers monitor real-time zone cards, view telemetry charts, receive emergency push notifications, and issue remote controls.',
      activeClass: 'bg-orange-50/90 border-orange-500 shadow-md ring-2 ring-orange-500/20 scale-[1.02]',
      hoverClass: 'hover:border-orange-500 hover:bg-orange-50/50 hover:-translate-y-1.5 hover:shadow-lg',
      iconActive: 'bg-orange-600 text-white',
      iconDefault: 'bg-orange-100 text-orange-700',
      detailBoxClass: 'bg-orange-50/40 border-orange-400 shadow-orange-500/10',
      detailTitleClass: 'text-orange-900',
      badgeClass: 'bg-orange-100 text-orange-800 border-orange-200'
    }
  ];

  return (
    <section id="solution-architecture" className="py-24 relative bg-slate-100/80 border-t border-slate-300">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">

        {/* Left-Aligned Section Header */}
        <div className="text-left max-w-3xl mb-12">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 tracking-tight leading-tight mb-4">
            Solution Architecture
          </h2>
          <p className="text-base sm:text-lg text-slate-600">
            From physical environmental sensing on the edge to cloud processing, dual databases, and mobile app notifications.
          </p>
        </div>

        {/* Architecture Diagram Image Box */}
        <div className="bg-white p-4 sm:p-6 rounded-3xl border border-slate-200 mb-12 shadow-sm overflow-hidden">
          <div className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-4">
            <span>Verified System Architecture Diagram</span>
          </div>

          <div className="rounded-2xl overflow-hidden bg-slate-50 border border-slate-200 p-2 sm:p-4">
            <img
              src={getAssetUrl('assets/system architecture.png')}
              onError={(e) => handleImageError(e, 'assets/system architecture.png')}
              alt="CluckNet System Architecture Diagram"
              className="w-full h-auto object-contain max-h-[520px] mx-auto hover:scale-[1.01] transition-transform duration-500 rounded-xl"
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
                className={`p-5 rounded-2xl cursor-pointer transition-all duration-300 transform border ${
                  isSelected
                    ? node.activeClass
                    : `bg-white border-slate-200 shadow-sm ${node.hoverClass}`
                }`}
              >
                <div className="flex items-center justify-end mb-3">
                  <span className="text-[10px] font-bold px-2 py-0.5 rounded bg-slate-100 text-slate-700 border border-slate-200">
                    {node.badge}
                  </span>
                </div>

                <div className="flex items-center gap-3 mb-1">
                  <div className={`p-2 rounded-xl transition-colors duration-300 ${isSelected ? node.iconActive : node.iconDefault}`}>
                    <Icon className="w-4 h-4" />
                  </div>
                  <div>
                    <h3 className="text-sm font-bold text-slate-900 leading-snug">{node.title}</h3>
                    <div className="text-[11px] text-slate-500 font-medium">{node.subtitle}</div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Detail Inspection Box */}
        {selectedNode && (() => {
          const node = flowNodes[selectedNode - 1];
          return (
            <div className={`p-6 rounded-3xl border-2 shadow-md mb-16 transition-all duration-300 ${node.detailBoxClass}`}>
              <div className="flex flex-wrap items-center justify-between gap-3 mb-3">
                <h3 className={`text-lg font-extrabold ${node.detailTitleClass}`}>{node.title}</h3>
                <span className={`text-xs font-bold px-3 py-1 rounded-full border ${node.badgeClass}`}>
                  {node.badge}
                </span>
              </div>
              <p className="text-sm text-slate-700 leading-relaxed max-w-4xl pt-2 border-t border-slate-300/50 mt-2">
                {node.desc}
              </p>
            </div>
          );
        })()}

        {/* Core Solution Triad & Physical Box Showcase */}
        <div className="bg-white p-6 sm:p-8 rounded-3xl border border-slate-200 shadow-sm mb-12">

          {/* Section Subsection Title */}
          <div className="mb-8">
            <h3 className="text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">
              Our Smart Solution
            </h3>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-stretch">

            {/* Left Side: Hardware Prototype Image (Top and Bottom Aligned) */}
            <div className="lg:col-span-7 order-2 lg:order-1 flex flex-col">
              <div className="rounded-2xl overflow-hidden bg-slate-50 border border-slate-200 shadow-sm h-full w-full flex items-center justify-center group min-h-[360px] p-2">
                <img
                  src={getAssetUrl('assets/our solution/Screenshot 2026-09-07 105418.png')}
                  onError={(e) => handleImageError(e, 'assets/our solution/Screenshot 2026-09-07 105418.png')}
                  alt="CluckNet Hardware Module Prototype"
                  className="w-full h-full object-contain group-hover:scale-[1.02] transition-transform duration-500 rounded-xl"
                />
              </div>
            </div>

            {/* Right Side: Core Solution Capabilities Interactive Cards (Top and Bottom Aligned) */}
            <div className="lg:col-span-5 order-1 lg:order-2 flex flex-col justify-between gap-3 sm:gap-3.5">

              {/* Card 1: Emerald Theme */}
              <div
                onClick={() => setActiveTab('monitor')}
                onMouseEnter={() => setActiveTab('monitor')}
                className={`p-4 sm:p-5 rounded-2xl cursor-pointer transition-all duration-300 transform border flex-1 flex flex-col justify-center ${activeTab === 'monitor'
                    ? 'bg-emerald-50 border-emerald-500 shadow-md scale-[1.01] ring-2 ring-emerald-500/20'
                    : 'bg-slate-50 border-slate-200 hover:bg-emerald-50/60 hover:border-emerald-400 hover:-translate-y-1 hover:shadow-md'
                  }`}
              >
                <div className="flex items-center gap-3 mb-1.5">
                  <div className={`p-2 rounded-xl transition-colors shrink-0 ${
                    activeTab === 'monitor' ? 'bg-emerald-600 text-white shadow-sm' : 'bg-emerald-100 text-emerald-700'
                  }`}>
                    <Radio className="w-5 h-5" />
                  </div>
                  <div className="font-extrabold text-slate-900 text-base sm:text-lg">
                    Real-Time Environmental Sensing
                  </div>
                </div>
                <div className="text-sm text-slate-700 font-medium leading-relaxed pl-1">
                  Continuous sampling of temp, humidity, NH₃ ammonia, and LPG fuel gas.
                </div>
              </div>

              {/* Card 2: Blue Theme */}
              <div
                onClick={() => setActiveTab('detect')}
                onMouseEnter={() => setActiveTab('detect')}
                className={`p-4 sm:p-5 rounded-2xl cursor-pointer transition-all duration-300 transform border flex-1 flex flex-col justify-center ${activeTab === 'detect'
                    ? 'bg-blue-50 border-blue-500 shadow-md scale-[1.01] ring-2 ring-blue-500/20'
                    : 'bg-slate-50 border-slate-200 hover:bg-blue-50/60 hover:border-blue-400 hover:-translate-y-1 hover:shadow-md'
                  }`}
              >
                <div className="flex items-center gap-3 mb-1.5">
                  <div className={`p-2 rounded-xl transition-colors shrink-0 ${
                    activeTab === 'detect' ? 'bg-blue-600 text-white shadow-sm' : 'bg-blue-100 text-blue-700'
                  }`}>
                    <Cpu className="w-5 h-5" />
                  </div>
                  <div className="font-extrabold text-slate-900 text-base sm:text-lg">
                    Intelligent Edge Detection
                  </div>
                </div>
                <div className="text-sm text-slate-700 font-medium leading-relaxed pl-1">
                  ESP32 microcontrollers process drift limits locally at sub-second speeds.
                </div>
              </div>

              {/* Card 3: Amber Theme */}
              <div
                onClick={() => setActiveTab('respond')}
                onMouseEnter={() => setActiveTab('respond')}
                className={`p-4 sm:p-5 rounded-2xl cursor-pointer transition-all duration-300 transform border flex-1 flex flex-col justify-center ${activeTab === 'respond'
                    ? 'bg-amber-50 border-amber-500 shadow-md scale-[1.01] ring-2 ring-amber-500/20'
                    : 'bg-slate-50 border-slate-200 hover:bg-amber-50/60 hover:border-amber-400 hover:-translate-y-1 hover:shadow-md'
                  }`}
              >
                <div className="flex items-center gap-3 mb-1.5">
                  <div className={`p-2 rounded-xl transition-colors shrink-0 ${
                    activeTab === 'respond' ? 'bg-amber-600 text-white shadow-sm' : 'bg-amber-100 text-amber-700'
                  }`}>
                    <Zap className="w-5 h-5" />
                  </div>
                  <div className="font-extrabold text-slate-900 text-base sm:text-lg">
                    Smart Automated Physical Response
                  </div>
                </div>
                <div className="text-sm text-slate-700 font-medium leading-relaxed pl-1">
                  Local acoustic alarm & 180° servo motor turning physical gas regulator valve off.
                </div>
              </div>

              {/* Card 4: Purple Theme - Flutter Mobile Notifications */}
              <div
                onClick={() => setActiveTab('notify')}
                onMouseEnter={() => setActiveTab('notify')}
                className={`p-4 sm:p-5 rounded-2xl cursor-pointer transition-all duration-300 transform border flex-1 flex flex-col justify-center ${activeTab === 'notify'
                    ? 'bg-purple-50 border-purple-500 shadow-md scale-[1.01] ring-2 ring-purple-500/20'
                    : 'bg-slate-50 border-slate-200 hover:bg-purple-50/60 hover:border-purple-400 hover:-translate-y-1 hover:shadow-md'
                  }`}
              >
                <div className="flex items-center gap-3 mb-1.5">
                  <div className={`p-2 rounded-xl transition-colors shrink-0 ${
                    activeTab === 'notify' ? 'bg-purple-600 text-white shadow-sm' : 'bg-purple-100 text-purple-700'
                  }`}>
                    <Bell className="w-5 h-5" />
                  </div>
                  <div className="font-extrabold text-slate-900 text-base sm:text-lg">
                    Flutter Mobile Critical Notifications
                  </div>
                </div>
                <div className="text-sm text-slate-700 font-medium leading-relaxed pl-1">
                  Instant push notifications sent to the Flutter mobile app when a critical situation occurs.
                </div>
              </div>

            </div>

          </div>
        </div>

        {/* Demonstration Sub-Topic */}
        <div className="bg-white p-6 sm:p-8 rounded-3xl border border-slate-200 shadow-sm">
          
          <div className="mb-6">
            <h3 className="text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">
              Demonstration
            </h3>
          </div>

          {/* Video Container Box */}
          <div className="relative rounded-2xl overflow-hidden bg-slate-900 border border-slate-800 shadow-xl group aspect-video max-w-4xl mx-auto flex items-center justify-center">
            
            {/* HTML5 Video Element */}
            <video
              className="w-full h-full object-cover"
              controls
              preload="metadata"
              poster={getAssetUrl('assets/our solution/Screenshot 2026-09-07 105418.png')}
            >
              <source src={getAssetUrl('assets/demo-test01.mp4')} type="video/mp4" />
              Your browser does not support playing HTML5 video.
            </video>

          </div>

        </div>

      </div>
    </section>
  );
};

