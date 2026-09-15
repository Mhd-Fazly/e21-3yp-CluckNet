import React from 'react';
import { AlertTriangle, ThermometerSnowflake, EyeOff, TrendingDown, Skull } from 'lucide-react';
import { getAssetUrl, handleImageError } from '../utils/assets';

export const ProblemSection: React.FC = () => {
  const broodingTimeline = [
    { week: 'Week 1', temp: '32–35°C', status: 'Critical Warmth' },
    { week: 'Week 2', temp: '29–32°C', status: 'Gradual Transition' },
    { week: 'Week 3', temp: '27–29°C', status: 'Feathering Stage' },
    { week: 'Week 4', temp: '24–26°C', status: 'Growth Acceleration' },
    { week: 'Week 5', temp: '21–24°C', status: 'Maturation' },
    { week: 'Week 6', temp: '21–24°C', status: 'Optimal Adult Climate' },
  ];

  return (
    <section id="problem" className="py-24 relative bg-slate-950/60 border-y border-white/5">
      {/* Background accents */}
      <div className="absolute top-1/2 left-0 w-72 h-72 bg-red-500/5 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">

        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-16">
          <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-red-500/10 border border-red-500/20 text-red-400 text-xs font-semibold uppercase tracking-wider mb-4">
            <AlertTriangle className="w-3.5 h-3.5" />
            The Agriculture Challenge
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-white tracking-tight leading-tight mb-4">
            Poultry environments change faster than humans can respond.
          </h2>
          <p className="text-base sm:text-lg text-slate-300">
            A few degrees of drift or a silent gas leak can wipe out an entire flock in hours. Traditional manual inspections fail to catch micro-climatic shifts in real-time.
          </p>
        </div>

        {/* 3 Core Problem Pillars */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">

          {/* Pillar 1: Temperature & Brooding Curve */}
          <div className="glass-panel p-6 sm:p-8 rounded-3xl border border-white/10 relative overflow-hidden flex flex-col justify-between">
            <div>
              <div className="w-12 h-12 rounded-2xl bg-amber-500/10 border border-amber-500/20 flex items-center justify-center text-amber-400 mb-6">
                <ThermometerSnowflake className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-white mb-3">Strict Brooding Requirements</h3>
              <p className="text-sm text-slate-300 leading-relaxed mb-6">
                Chicks require weekly temperature reductions from 35°C down to 21°C. Deviations lead to high mortality, stunted growth, and poor feed conversion.
              </p>
            </div>

            {/* Visual Brooding Timeline */}
            <div className="bg-slate-900/80 rounded-2xl p-4 border border-white/5 space-y-2">
              <div className="text-[11px] font-bold text-slate-400 uppercase tracking-wider mb-2">Brooding Schedule & Temp Curve</div>
              {broodingTimeline.slice(0, 4).map((item, idx) => (
                <div key={idx} className="flex items-center justify-between text-xs py-1 border-b border-white/5 last:border-0">
                  <span className="text-slate-300 font-medium">{item.week}</span>
                  <span className="font-mono text-amber-400 font-bold">{item.temp}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Pillar 2: Humidity Imbalance */}
          <div className="glass-panel p-6 sm:p-8 rounded-3xl border border-white/10 relative overflow-hidden flex flex-col justify-between">
            <div>
              <div className="w-12 h-12 rounded-2xl bg-blue-500/10 border border-blue-500/20 flex items-center justify-center text-blue-400 mb-6">
                <TrendingDown className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-white mb-3">Humidity Imbalance</h3>
              <p className="text-sm text-slate-300 leading-relaxed mb-6">
                Uncontrolled relative humidity drastically alters disease resistance and flock welfare:
              </p>
            </div>

            <div className="space-y-3">
              <div className="bg-slate-900/80 p-3.5 rounded-2xl border border-white/5">
                <div className="flex items-center justify-between text-xs font-bold text-amber-400 mb-1">
                  <span>Too Low (&lt; 50%)</span>
                  <span>Dry Dust Air</span>
                </div>
                <p className="text-xs text-slate-400">Increases airborne dust particles and severely dehydrates young chicks during heating.</p>
              </div>

              <div className="bg-slate-900/80 p-3.5 rounded-2xl border border-white/5">
                <div className="flex items-center justify-between text-xs font-bold text-red-400 mb-1">
                  <span>Too High (&gt; 70%)</span>
                  <span>Bacterial Explosion</span>
                </div>
                <p className="text-xs text-slate-400">Promotes pathogen growth, amplifies ammonia emission, and depresses bird body weight gain.</p>
              </div>
            </div>
          </div>

          {/* Pillar 3: Invisible Ammonia & LPG Hazards */}
          <div className="glass-panel p-6 sm:p-8 rounded-3xl border border-white/10 relative overflow-hidden flex flex-col justify-between">
            <div>
              <div className="w-12 h-12 rounded-2xl bg-red-500/10 border border-red-500/20 flex items-center justify-center text-red-400 mb-6">
                <EyeOff className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-white mb-3">Invisible Ammonia Toxicity</h3>
              <p className="text-sm text-slate-300 leading-relaxed mb-6">
                Ammonia (NH₃) is colorless and highly corrosive to poultry respiratory systems. Furthermore, LPG leaks from heating equipment present severe fire hazards.
              </p>
            </div>

            <div className="bg-slate-900/80 p-4 rounded-2xl border border-white/5 space-y-2.5">
              <div className="flex items-center gap-2 text-xs text-slate-300">
                <span className="w-2 h-2 rounded-full bg-amber-400" />
                <span className="font-bold text-white">5–10 ppm:</span> Lung irritation begins
              </div>
              <div className="flex items-center gap-2 text-xs text-slate-300">
                <span className="w-2 h-2 rounded-full bg-orange-400" />
                <span className="font-bold text-white">20–25 ppm:</span> Max safety limit (Immunity drops)
              </div>
              <div className="flex items-center gap-2 text-xs text-slate-300">
                <span className="w-2 h-2 rounded-full bg-red-500" />
                <span className="font-bold text-white">150–200 ppm:</span> Flock growth halts completely
              </div>
            </div>
          </div>

        </div>

        {/* Visual Reference Diagram Cards Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-12">

          {/* Brooding Temperature Curve Graphic */}
          <div className="glass-panel p-6 rounded-3xl border border-white/10 bg-slate-900/80">
            <div className="text-xs font-bold text-amber-400 uppercase tracking-wider mb-2">Brooding Environmental Degradation</div>
            <h4 className="text-lg font-bold text-white mb-4">Temperature Requirements & Brooding Risks</h4>
            <div className="rounded-2xl overflow-hidden bg-slate-950 border border-white/10">
              <img
                src={getAssetUrl('assets/intro/Screenshot 2026-09-07 105229.png')}
                onError={(e) => handleImageError(e, 'assets/intro/Screenshot 2026-09-07 105229.png')}
                alt="Brooding Temperature Curve and Risks"
                className="w-full h-auto object-contain max-h-[300px] mx-auto hover:scale-105 transition-transform duration-500"
              />
            </div>
          </div>

          {/* Chick Guesswork vs Data Graphic */}
          <div className="glass-panel p-6 rounded-3xl border border-white/10 bg-slate-900/80">
            <div className="text-xs font-bold text-red-400 uppercase tracking-wider mb-2">Traditional Reliance on Guesswork</div>
            <h4 className="text-lg font-bold text-white mb-4">Behavioral Indicators vs Real Telemetry Data</h4>
            <div className="rounded-2xl overflow-hidden bg-slate-950 border border-white/10">
              <img
                src={getAssetUrl('assets/intro/Screenshot 2026-09-07 105243.png')}
                onError={(e) => handleImageError(e, 'assets/intro/Screenshot 2026-09-07 105243.png')}
                alt="Traditional Guesswork vs Data Driven Chicks Behavior"
                className="w-full h-auto object-contain max-h-[300px] mx-auto hover:scale-105 transition-transform duration-500"
              />
            </div>
          </div>

        </div>

        {/* Visual Behavior Reference Box */}
        <div className="glass-panel p-6 sm:p-8 rounded-3xl border border-white/10 bg-gradient-to-r from-slate-900/90 to-cluck-navy/90">
          <div className="grid grid-cols-1 md:grid-cols-12 gap-6 items-center">

            <div className="md:col-span-4">
              <div className="flex items-center gap-2 text-xs font-bold text-amber-400 uppercase tracking-wider mb-2">
                <Skull className="w-4 h-4" />
                Physical Signs Are Too Late
              </div>
              <h4 className="text-xl font-bold text-white mb-2">Why Continuous Sensing Wins</h4>
              <p className="text-xs text-slate-300 leading-relaxed">
                By the time farmers notice chicks crowding together (too cold) or fleeing to outer perimeters (too hot), biological damage and growth loss have already occurred.
              </p>
            </div>

            <div className="md:col-span-8 grid grid-cols-3 gap-3">
              <div className="bg-slate-950/80 p-4 rounded-2xl border border-white/10 text-center">
                <div className="w-8 h-8 rounded-full bg-blue-500/20 text-blue-400 flex items-center justify-center mx-auto mb-2 font-bold text-xs">
                  Cold
                </div>
                <div className="text-xs font-bold text-white mb-1">Crowded Together</div>
                <div className="text-[10px] text-red-400 font-medium">Too Cold Climate</div>
              </div>

              <div className="bg-slate-950/80 p-4 rounded-2xl border border-white/10 text-center">
                <div className="w-8 h-8 rounded-full bg-amber-500/20 text-amber-400 flex items-center justify-center mx-auto mb-2 font-bold text-xs">
                  Hot
                </div>
                <div className="text-xs font-bold text-white mb-1">Away from Heat</div>
                <div className="text-[10px] text-amber-400 font-medium">Too Hot Climate</div>
              </div>

              <div className="bg-slate-950/80 p-4 rounded-2xl border border-emerald-500/30 text-center bg-emerald-500/5">
                <div className="w-8 h-8 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center mx-auto mb-2 font-bold text-xs">
                  Opt
                </div>
                <div className="text-xs font-bold text-white mb-1">Evenly Spread</div>
                <div className="text-[10px] text-emerald-400 font-medium">Optimal Environment</div>
              </div>
            </div>

          </div>
        </div>

      </div>
    </section>
  );
};
