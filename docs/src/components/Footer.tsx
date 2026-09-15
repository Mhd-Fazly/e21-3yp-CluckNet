import React from 'react';
import { ArrowUp } from 'lucide-react';
import { getAssetUrl, handleImageError } from '../utils/assets';

export const Footer: React.FC = () => {
  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <footer className="bg-slate-950 border-t border-white/10 pt-16 pb-12 relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">

        <div className="grid grid-cols-1 md:grid-cols-12 gap-8 pb-12 border-b border-white/10">

          {/* Brand Col */}
          <div className="md:col-span-5 flex flex-col">
            <div className="flex items-center gap-3 mb-4">
              <img
                src={getAssetUrl('assets/webpage-logo.png')}
                onError={(e) => handleImageError(e, 'assets/webpage-logo.png')}
                alt="CluckNet Logo"
                className="h-10 w-auto object-contain drop-shadow-sm rounded-2xl"
              />
              <span className="text-2xl font-bold tracking-tight text-white font-sans">
                Cluck<span className="text-emerald-400">Net</span>
              </span>
            </div>
            <p className="text-sm text-slate-400 max-w-sm mb-4">
              Smarter Monitoring. Healthier Flocks. An intelligent IoT-based poultry monitoring and control system.
            </p>
            <div className="text-xs text-slate-500">
              Department of Computer Engineering · University of Peradeniya
            </div>
          </div>

          {/* Nav Links Col */}
          <div className="md:col-span-4 grid grid-cols-2 gap-4">
            <div>
              <div className="text-xs font-bold text-slate-300 uppercase tracking-wider mb-3">Navigation</div>
              <ul className="space-y-2 text-xs text-slate-400 font-medium">
                <li><a href="#home" className="hover:text-emerald-400 transition-colors">Home</a></li>
                <li><a href="#solution" className="hover:text-emerald-400 transition-colors">Solution</a></li>
                <li><a href="#how-it-works" className="hover:text-emerald-400 transition-colors">How It Works</a></li>
              </ul>
            </div>
            <div>
              <div className="text-xs font-bold text-slate-300 uppercase tracking-wider mb-3">Resources</div>
              <ul className="space-y-2 text-xs text-slate-400 font-medium">
                <li><a href="#technology" className="hover:text-emerald-400 transition-colors">Technology Stack</a></li>
                <li><a href="#showcase" className="hover:text-emerald-400 transition-colors">Project Showcase</a></li>
                <li><a href="#team" className="hover:text-emerald-400 transition-colors">Team Members</a></li>
              </ul>
            </div>
          </div>

          {/* Academic Info & Scroll Top */}
          <div className="md:col-span-3 flex flex-col justify-between items-start md:items-end">
            <button
              onClick={scrollToTop}
              className="p-3 rounded-full bg-white/5 hover:bg-emerald-500 hover:text-cluck-navy text-slate-300 border border-white/10 transition-all shadow-lg"
              aria-label="Back to Top"
            >
              <ArrowUp className="w-5 h-5" />
            </button>
            <div className="text-xs text-slate-400 text-left md:text-right mt-6 md:mt-0">
              Third Year Project <br />
              <span className="text-emerald-400 font-semibold">Group 18</span>
            </div>
          </div>

        </div>

        {/* Copyright */}
        <div className="pt-8 flex flex-col sm:flex-row items-center justify-between text-xs text-slate-500 gap-4">
          <div>
            © {new Date().getFullYear()} CluckNet Project. All rights reserved.
          </div>
          <div className="flex items-center gap-1">
            {/* Designed & Built with <Heart className="w-3.5 h-3.5 text-emerald-400 fill-emerald-400 mx-1" /> for Poultry Engineering. */}
            Designed & Built for Smarter Poultry Farming
          </div>
        </div>

      </div>
    </footer>
  );
};
