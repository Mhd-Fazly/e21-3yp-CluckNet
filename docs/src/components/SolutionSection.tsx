import React, { useState } from 'react';
import { Cpu, ShieldCheck, Zap, Radio, Bell } from 'lucide-react';
import { getAssetUrl, handleImageError } from '../utils/assets';

export const SolutionSection: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'monitor' | 'detect' | 'respond' | 'notify'>('monitor');

  return (
    <section id="solution" className="py-24 relative overflow-hidden">
      {/* Background Glow */}
      <div className="absolute top-1/2 right-0 w-96 h-96 bg-emerald-500/10 rounded-full blur-[140px] pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">

        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs font-semibold uppercase tracking-wider mb-4">
            <Cpu className="w-3.5 h-3.5" />
            The Next Generation Solution
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-white tracking-tight leading-tight mb-4">
            Meet <span className="gradient-text-emerald">CluckNet</span>
          </h2>
          <p className="text-base sm:text-lg text-slate-300">
            CluckNet brings real-time environmental sensing, edge intelligence, immediate physical response, and Flutter mobile critical alert notifications together into one reliable, continuous system.
          </p>
        </div>

        {/* Interactive Feature Showcase */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center mb-16">

          {/* Left Feature Selector */}
          <div className="lg:col-span-5 space-y-4">

            {/* Feature 1: Real-Time Monitoring */}
            <div
              onClick={() => setActiveTab('monitor')}
              className={`p-6 rounded-3xl cursor-pointer transition-all duration-300 border ${activeTab === 'monitor'
                  ? 'bg-slate-900 border-emerald-500/50 shadow-lg shadow-emerald-500/10 scale-[1.02]'
                  : 'glass-panel border-white/10 hover:border-white/20 opacity-80'
                }`}
            >
              <div className="flex items-start gap-4">
                <div className={`p-3 rounded-2xl ${activeTab === 'monitor' ? 'bg-emerald-500 text-cluck-navy' : 'bg-white/5 text-emerald-400'}`}>
                  <Radio className="w-6 h-6" />
                </div>
                <div>
                  <div className="flex items-center gap-2 mb-1">
                    <h3 className="text-lg font-bold text-white">1. Real-Time Monitoring</h3>
                    <span className="text-[10px] font-bold px-2 py-0.5 rounded bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">Continuous</span>
                  </div>
                  <p className="text-xs text-slate-300 leading-relaxed">
                    Continuously samples temperature, relative humidity, ammonia (NH₃), and LPG levels across brooder zones using precision digital and analog sensors.
                  </p>
                </div>
              </div>
            </div>

            {/* Feature 2: Intelligent Detection */}
            <div
              onClick={() => setActiveTab('detect')}
              className={`p-6 rounded-3xl cursor-pointer transition-all duration-300 border ${activeTab === 'detect'
                  ? 'bg-slate-900 border-blue-500/50 shadow-lg shadow-blue-500/10 scale-[1.02]'
                  : 'glass-panel border-white/10 hover:border-white/20 opacity-80'
                }`}
            >
              <div className="flex items-start gap-4">
                <div className={`p-3 rounded-2xl ${activeTab === 'detect' ? 'bg-blue-500 text-cluck-navy' : 'bg-white/5 text-blue-400'}`}>
                  <ShieldCheck className="w-6 h-6" />
                </div>
                <div>
                  <div className="flex items-center gap-2 mb-1">
                    <h3 className="text-lg font-bold text-white">2. Intelligent Edge Detection</h3>
                    <span className="text-[10px] font-bold px-2 py-0.5 rounded bg-blue-500/10 text-blue-400 border border-blue-500/20">ESP32 Core</span>
                  </div>
                  <p className="text-xs text-slate-300 leading-relaxed">
                    Processes sensor readings locally at sub-second speeds to identify environmental drift and dangerous gas concentrations before harm occurs.
                  </p>
                </div>
              </div>
            </div>

            {/* Feature 3: Smart Response */}
            <div
              onClick={() => setActiveTab('respond')}
              className={`p-6 rounded-3xl cursor-pointer transition-all duration-300 border ${activeTab === 'respond'
                  ? 'bg-slate-900 border-amber-500/50 shadow-lg shadow-amber-500/10 scale-[1.02]'
                  : 'glass-panel border-white/10 hover:border-white/20 opacity-80'
                }`}
            >
              <div className="flex items-start gap-4">
                <div className={`p-3 rounded-2xl ${activeTab === 'respond' ? 'bg-amber-500 text-cluck-navy' : 'bg-white/5 text-amber-400'}`}>
                  <Zap className="w-6 h-6" />
                </div>
                <div>
                  <div className="flex items-center gap-2 mb-1">
                    <h3 className="text-lg font-bold text-white">3. Smart Automated Response</h3>
                    <span className="text-[10px] font-bold px-2 py-0.5 rounded bg-amber-500/10 text-amber-400 border border-amber-500/20">Zero Latency</span>
                  </div>
                  <p className="text-xs text-slate-300 leading-relaxed">
                    Triggers instant local buzzer alarms and mechanically turns a 180° servo motor to cut off the main gas regulator valve automatically.
                  </p>
                </div>
              </div>
            </div>

            {/* Feature 4: Flutter Mobile Critical Notifications */}
            <div
              onClick={() => setActiveTab('notify')}
              className={`p-6 rounded-3xl cursor-pointer transition-all duration-300 border ${activeTab === 'notify'
                  ? 'bg-slate-900 border-purple-500/50 shadow-lg shadow-purple-500/10 scale-[1.02]'
                  : 'glass-panel border-white/10 hover:border-white/20 opacity-80'
                }`}
            >
              <div className="flex items-start gap-4">
                <div className={`p-3 rounded-2xl ${activeTab === 'notify' ? 'bg-purple-500 text-cluck-navy' : 'bg-white/5 text-purple-400'}`}>
                  <Bell className="w-6 h-6" />
                </div>
                <div>
                  <div className="flex items-center gap-2 mb-1">
                    <h3 className="text-lg font-bold text-white">4. Flutter Mobile Critical Alerts</h3>
                    <span className="text-[10px] font-bold px-2 py-0.5 rounded bg-purple-500/10 text-purple-400 border border-purple-500/20">Flutter & FCM</span>
                  </div>
                  <p className="text-xs text-slate-300 leading-relaxed">
                    Dispatches instant push notifications to the Flutter mobile app when critical threshold breaches or emergency situations occur.
                  </p>
                </div>
              </div>
            </div>

          </div>

          {/* Right Product Image Showcase */}
          <div className="lg:col-span-7 relative">
            <div className="glass-panel p-4 sm:p-6 rounded-3xl border border-white/15 bg-slate-900/90 shadow-2xl relative">

              {/* Product Photo */}
              <div className="relative rounded-2xl overflow-hidden aspect-[16/10] bg-slate-950 border border-white/10 mb-6">
                <img
                  src={getAssetUrl('assets/our solution/Screenshot 2026-09-07 105418.png')}
                  onError={(e) => handleImageError(e, 'assets/our solution/Screenshot 2026-09-07 105418.png')}
                  alt="CluckNet Physical Device Box and Servo Motor"
                  className="w-full h-full object-cover"
                />
              </div>

              {/* Dynamic Feature Details Box */}
              <div className="grid grid-cols-3 gap-4">
                <div className="bg-slate-950 p-3.5 rounded-2xl border border-white/5 text-center">
                  <div className="text-xs text-slate-400 font-medium mb-1">Enclosure</div>
                  <div className="text-xs font-bold text-white">Custom 3D Printed</div>
                </div>
                <div className="bg-slate-950 p-3.5 rounded-2xl border border-white/5 text-center">
                  <div className="text-xs text-slate-400 font-medium mb-1">Actuator</div>
                  <div className="text-xs font-bold text-emerald-400">180° Servo Valve</div>
                </div>
                <div className="bg-slate-950 p-3.5 rounded-2xl border border-white/5 text-center">
                  <div className="text-xs text-slate-400 font-medium mb-1">Power Failover</div>
                  <div className="text-xs font-bold text-blue-400">18650 Battery Pack</div>
                </div>
              </div>

            </div>
          </div>

        </div>

      </div>
    </section>
  );
};
