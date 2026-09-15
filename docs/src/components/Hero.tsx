import React from 'react';
import { ArrowRight, ChevronRight } from 'lucide-react';
import { getAssetUrl, handleImageError } from '../utils/assets';

export const Hero: React.FC = () => {
  return (
    <section id="home" className="relative pt-32 pb-20 md:pt-40 md:pb-28 overflow-hidden bg-slate-100/80 border-b border-slate-300">
      {/* Subtle Background Gradients */}
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-emerald-400/10 rounded-full blur-[140px] pointer-events-none" />
      <div className="absolute top-1/3 right-10 w-[450px] h-[450px] bg-blue-400/10 rounded-full blur-[130px] pointer-events-none" />

      {/* Transparent Clucks Background Image on Right Side (Visibility Increases Moving Right) */}
      <div className="absolute inset-y-0 right-0 w-full lg:w-2/3 pointer-events-none overflow-hidden z-0">
        <img
          src={getAssetUrl('assets/clucks.jpg')}
          onError={(e) => handleImageError(e, 'assets/clucks.jpg')}
          alt="CluckNet Poultry Environment"
          className="w-full h-full object-cover object-right opacity-45 mix-blend-multiply"
          style={{
            maskImage: 'linear-gradient(to left, rgba(0,0,0,0.95) 0%, rgba(0,0,0,0.45) 45%, rgba(0,0,0,0) 85%)',
            WebkitMaskImage: 'linear-gradient(to left, rgba(0,0,0,0.95) 0%, rgba(0,0,0,0.45) 45%, rgba(0,0,0,0) 85%)'
          }}
        />
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Left-Aligned Hero Container */}
        <div className="max-w-4xl text-left flex flex-col items-start">
          
          {/* Hero Main Headline */}
          <h1 className="text-4xl sm:text-6xl lg:text-7xl font-extrabold tracking-tight text-slate-900 leading-[1.12] mb-6">
            Cluck<span className="text-emerald-600">Net</span>
          </h1>

          <h2 className="text-2xl sm:text-4xl font-bold text-slate-800 tracking-tight mb-6">
            Smarter Monitoring. <span className="text-emerald-600">Healthier Flocks.</span>
          </h2>

          {/* Hero Subtitle */}
          <p className="text-base sm:text-lg text-slate-600 max-w-2xl font-normal leading-relaxed mb-10">
            An intelligent IoT-based poultry monitoring and control system that transforms continuous environmental data into real-time insights and automated safety response.
          </p>

          {/* Action CTAs */}
          <div className="flex flex-col sm:flex-row items-center justify-start gap-4 mb-16 w-full sm:w-auto">
            <a
              href="#solution-architecture"
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-7 py-3.5 rounded-full text-sm font-bold bg-emerald-600 hover:bg-emerald-700 text-white transition-all duration-200 shadow-md shadow-emerald-600/20 active:scale-95"
            >
              <span>Explore Architecture</span>
              <ArrowRight className="w-4 h-4" />
            </a>

            <a
              href="#introduction"
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-7 py-3.5 rounded-full text-sm font-semibold bg-white hover:bg-slate-100 text-slate-700 border border-slate-300 transition-all duration-200 shadow-sm"
            >
              <span>Project Introduction</span>
              <ChevronRight className="w-4 h-4 text-slate-400" />
            </a>
          </div>

          {/* Quick Spec Highlights Bar */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3 sm:gap-5 pt-10 border-t border-slate-200/80 w-full max-w-5xl">
            <div className="bg-white p-3.5 sm:p-5 rounded-2xl border border-slate-200 shadow-sm text-left transition-all duration-300 transform hover:-translate-y-2 hover:shadow-xl hover:border-slate-400 group cursor-pointer overflow-hidden">
              <div className="text-lg sm:text-xl lg:text-2xl font-extrabold text-slate-900 font-sans mb-1 group-hover:scale-105 transition-transform duration-300 whitespace-nowrap">99.9%</div>
              <div className="text-[11px] sm:text-xs text-slate-500 font-semibold uppercase tracking-wider whitespace-nowrap">Uptime Guarantee</div>
            </div>

            <div className="bg-white p-3.5 sm:p-5 rounded-2xl border border-slate-200 shadow-sm text-left transition-all duration-300 transform hover:-translate-y-2 hover:shadow-xl hover:border-emerald-500 hover:shadow-emerald-500/10 group cursor-pointer overflow-hidden">
              <div className="text-lg sm:text-xl lg:text-2xl font-extrabold text-emerald-600 font-sans mb-1 group-hover:scale-105 transition-transform duration-300 whitespace-nowrap">&lt; 100ms</div>
              <div className="text-[11px] sm:text-xs text-slate-500 font-semibold uppercase tracking-wider whitespace-nowrap">ESP-NOW Latency</div>
            </div>

            <div className="bg-white p-3.5 sm:p-5 rounded-2xl border border-slate-200 shadow-sm text-left transition-all duration-300 transform hover:-translate-y-2 hover:shadow-xl hover:border-blue-500 hover:shadow-blue-500/10 group cursor-pointer overflow-hidden">
              <div className="text-lg sm:text-xl lg:text-2xl font-extrabold text-blue-600 font-sans mb-1 group-hover:scale-105 transition-transform duration-300 whitespace-nowrap">Dual-Layer</div>
              <div className="text-[11px] sm:text-xs text-slate-500 font-semibold uppercase tracking-wider whitespace-nowrap">Battery Failover</div>
            </div>

            <div className="bg-white p-3.5 sm:p-5 rounded-2xl border border-slate-200 shadow-sm text-left transition-all duration-300 transform hover:-translate-y-2 hover:shadow-xl hover:border-red-500 hover:shadow-red-500/10 group cursor-pointer overflow-hidden">
              <div className="text-lg sm:text-xl lg:text-2xl font-extrabold text-red-600 font-sans mb-1 group-hover:scale-105 transition-transform duration-300 whitespace-nowrap">Auto-Blocking</div>
              <div className="text-[11px] sm:text-xs text-slate-500 font-semibold uppercase tracking-wider whitespace-nowrap">180° Servo Valve</div>
            </div>
          </div>

        </div>

      </div>
    </section>
  );
};
