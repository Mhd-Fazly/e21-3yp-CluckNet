import React from 'react';
import { ThermometerSnowflake, EyeOff, TrendingDown, Target, ShieldCheck, Activity } from 'lucide-react';

export const IntroductionSection: React.FC = () => {
  const broodingTimeline = [
    { week: 'Week 1', temp: '32–35°C', note: 'Critical Warmth' },
    { week: 'Week 2', temp: '29–32°C', note: 'Gradual Shift' },
    { week: 'Week 3', temp: '27–29°C', note: 'Feathering Stage' },
    { week: 'Week 4', temp: '24–26°C', note: 'Growth Acceleration' },
    { week: 'Week 5', temp: '21–24°C', note: 'Maturation' },
    { week: 'Week 6', temp: '21–24°C', note: 'Adult Climate' },
  ];

  return (
    <section id="introduction" className="py-24 relative bg-slate-50/50 border-y border-slate-200">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Left-Aligned Section Header */}
        <div className="text-left max-w-3xl mb-12">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 tracking-tight leading-tight mb-4">
            Introduction to <span className="text-emerald-600">CluckNet</span>
          </h2>
          <p className="text-base sm:text-lg text-slate-600">
            Poultry environments change faster than manual labor can inspect. CluckNet replaces guesswork with continuous, automated environmental sensing and real-time response.
          </p>
        </div>

        {/* Project Objectives Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-16">
          {/* Card 1: Accurate Data Acquisition */}
          <div className="bg-white p-7 rounded-3xl border border-slate-200/80 shadow-sm transition-all duration-300 ease-out transform hover:-translate-y-2 hover:shadow-xl hover:shadow-emerald-500/10 hover:border-emerald-500/50 cursor-pointer group">
            <div className="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold mb-5 group-hover:bg-emerald-600 group-hover:text-white transition-all duration-300 shadow-sm group-hover:shadow-md group-hover:shadow-emerald-500/30 group-hover:scale-105">
              <Target className="w-6 h-6 group-hover:rotate-6 transition-transform duration-300" />
            </div>
            <h3 className="text-lg font-bold text-slate-900 mb-2.5 group-hover:text-emerald-600 transition-colors duration-200">Accurate Data Acquisition</h3>
            <p className="text-xs sm:text-sm text-slate-600 leading-relaxed">
              Continuous sampling of temperature, humidity, ammonia (NH₃), and LPG gases using calibrated sensors to ensure high precision data streams.
            </p>
          </div>

          {/* Card 2: Reliable Transmission */}
          <div className="bg-white p-7 rounded-3xl border border-slate-200/80 shadow-sm transition-all duration-300 ease-out transform hover:-translate-y-2 hover:shadow-xl hover:shadow-blue-500/10 hover:border-blue-500/50 cursor-pointer group">
            <div className="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center font-bold mb-5 group-hover:bg-blue-600 group-hover:text-white transition-all duration-300 shadow-sm group-hover:shadow-md group-hover:shadow-blue-500/30 group-hover:scale-105">
              <ShieldCheck className="w-6 h-6 group-hover:rotate-6 transition-transform duration-300" />
            </div>
            <h3 className="text-lg font-bold text-slate-900 mb-2.5 group-hover:text-blue-600 transition-colors duration-200">Reliable Transmission</h3>
            <p className="text-xs sm:text-sm text-slate-600 leading-relaxed">
              Utilizing ESP-NOW peer-to-peer radio mesh and cloud MQTT TLS sockets with automatic battery backup to prevent single points of failure (SPOF).
            </p>
          </div>

          {/* Card 3: Rapid Hazard Response */}
          <div className="bg-white p-7 rounded-3xl border border-slate-200/80 shadow-sm transition-all duration-300 ease-out transform hover:-translate-y-2 hover:shadow-xl hover:shadow-amber-500/10 hover:border-amber-500/50 cursor-pointer group">
            <div className="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center font-bold mb-5 group-hover:bg-amber-600 group-hover:text-white transition-all duration-300 shadow-sm group-hover:shadow-md group-hover:shadow-amber-500/30 group-hover:scale-105">
              <Activity className="w-6 h-6 group-hover:rotate-6 transition-transform duration-300" />
            </div>
            <h3 className="text-lg font-bold text-slate-900 mb-2.5 group-hover:text-amber-600 transition-colors duration-200">Rapid Hazard Response</h3>
            <p className="text-xs sm:text-sm text-slate-600 leading-relaxed">
              Automated physical response (180° servo motor shutting gas valve + acoustic buzzer alarm) combined with instant mobile push notifications.
            </p>
          </div>
        </div>

        {/* Subsection Header */}
        <div className="text-left mb-8 pt-4">
          <h3 className="text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">
            What We Are <span className="text-red-600">Concerned About</span>
          </h3>
        </div>

        {/* 3 Environmental Problem Pillars */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          
          {/* Pillar 1: Temperature */}
          <div className="bg-white p-7 rounded-3xl border border-slate-200/80 shadow-sm flex flex-col justify-center transition-all duration-300 ease-out transform hover:-translate-y-2 hover:shadow-xl hover:shadow-amber-500/10 hover:border-amber-500/50 cursor-pointer group">
            <div>
              <div className="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center font-bold mb-5 group-hover:bg-amber-600 group-hover:text-white transition-all duration-300 shadow-sm group-hover:shadow-md group-hover:shadow-amber-500/30 group-hover:scale-105">
                <ThermometerSnowflake className="w-6 h-6 group-hover:rotate-6 transition-transform duration-300" />
              </div>
              <h3 className="text-lg font-bold text-slate-900 mb-2.5 group-hover:text-amber-600 transition-colors duration-200">Brooding Temperature Drift</h3>
              <p className="text-xs sm:text-sm text-slate-600 leading-relaxed mb-5">
                Chicks require strict temperature curves from 35°C down to 21°C. Uncontrolled temperature shifts lead to high mortality, stunted growth, and poor feed conversion.
              </p>
            </div>

            <div className="bg-slate-50 group-hover:bg-amber-50/40 rounded-2xl p-4 border border-slate-100 group-hover:border-amber-200/60 space-y-1.5 transition-colors duration-300">
              <div className="text-[11px] font-bold text-slate-500 uppercase tracking-wider mb-2">Brooding Temp Targets</div>
              {broodingTimeline.slice(0, 4).map((item, idx) => (
                <div key={idx} className="flex items-center justify-between text-xs py-0.5 border-b border-slate-200/60 last:border-0">
                  <span className="text-slate-700 font-semibold">{item.week}</span>
                  <span className="font-mono text-amber-700 font-bold">{item.temp}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Pillar 2: Humidity */}
          <div className="bg-white p-7 rounded-3xl border border-slate-200/80 shadow-sm flex flex-col justify-center transition-all duration-300 ease-out transform hover:-translate-y-2 hover:shadow-xl hover:shadow-blue-500/10 hover:border-blue-500/50 cursor-pointer group">
            <div>
              <div className="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center font-bold mb-5 group-hover:bg-blue-600 group-hover:text-white transition-all duration-300 shadow-sm group-hover:shadow-md group-hover:shadow-blue-500/30 group-hover:scale-105">
                <TrendingDown className="w-6 h-6 group-hover:rotate-6 transition-transform duration-300" />
              </div>
              <h3 className="text-lg font-bold text-slate-900 mb-2.5 group-hover:text-blue-600 transition-colors duration-200">Humidity Extremes</h3>
              <p className="text-xs sm:text-sm text-slate-600 leading-relaxed mb-5">
                Relative humidity out of bounds impairs flock health and respiratory systems.
              </p>
            </div>

            <div className="space-y-2.5">
              <div className="bg-slate-50 group-hover:bg-blue-50/40 p-3.5 rounded-2xl border border-slate-100 group-hover:border-blue-200/60 transition-colors duration-300">
                <div className="flex items-center justify-between text-xs font-bold text-amber-700 mb-0.5">
                  <span>Too Low (&lt; 50%)</span>
                  <span>Dry Dust Air</span>
                </div>
                <p className="text-[11px] text-slate-600">Increases airborne dust particles and dehydrates young chicks.</p>
              </div>

              <div className="bg-slate-50 group-hover:bg-blue-50/40 p-3.5 rounded-2xl border border-slate-100 group-hover:border-blue-200/60 transition-colors duration-300">
                <div className="flex items-center justify-between text-xs font-bold text-red-700 mb-0.5">
                  <span>Too High (&gt; 70%)</span>
                  <span>Bacterial Growth</span>
                </div>
                <p className="text-[11px] text-slate-600">Promotes pathogen growth, increases ammonia gas, and reduces body weight.</p>
              </div>
            </div>
          </div>

          {/* Pillar 3: Ammonia & Gas Toxicity */}
          <div className="bg-white p-7 rounded-3xl border border-slate-200/80 shadow-sm flex flex-col justify-center transition-all duration-300 ease-out transform hover:-translate-y-2 hover:shadow-xl hover:shadow-red-500/10 hover:border-red-500/50 cursor-pointer group">
            <div>
              <div className="w-12 h-12 rounded-2xl bg-red-50 text-red-600 flex items-center justify-center font-bold mb-5 group-hover:bg-red-600 group-hover:text-white transition-all duration-300 shadow-sm group-hover:shadow-md group-hover:shadow-red-500/30 group-hover:scale-105">
                <EyeOff className="w-6 h-6 group-hover:rotate-6 transition-transform duration-300" />
              </div>
              <h3 className="text-lg font-bold text-slate-900 mb-2.5 group-hover:text-red-600 transition-colors duration-200">Ammonia & Gas Hazards</h3>
              <p className="text-xs sm:text-sm text-slate-600 leading-relaxed mb-5">
                Colorless Ammonia (NH₃) damages respiratory mucosa, while LPG gas leaks pose severe fire hazards.
              </p>
            </div>

            <div className="bg-slate-50 group-hover:bg-red-50/40 p-4 rounded-2xl border border-slate-100 group-hover:border-red-200/60 space-y-2 transition-colors duration-300">
              <div className="flex items-center gap-2 text-xs text-slate-700">
                <span className="w-2 h-2 rounded-full bg-amber-500 shrink-0" />
                <span className="font-bold text-slate-900">5–10 ppm:</span>
                <span className="text-slate-600">Lung irritation begins</span>
              </div>
              <div className="flex items-center gap-2 text-xs text-slate-700">
                <span className="w-2 h-2 rounded-full bg-orange-500 shrink-0" />
                <span className="font-bold text-slate-900">20–25 ppm:</span>
                <span className="text-slate-600">Safety Limit (Immunity drops)</span>
              </div>
              <div className="flex items-center gap-2 text-xs text-slate-700">
                <span className="w-2 h-2 rounded-full bg-red-600 shrink-0" />
                <span className="font-bold text-slate-900">150–200 ppm:</span>
                <span className="text-slate-600">Growth halts completely</span>
              </div>
            </div>
          </div>
        </div>

      </div>
    </section>
  );
};


