import React, { useState, useEffect } from 'react';
import { Menu, X } from 'lucide-react';
import logoImg from '../assets/webpage-logo.png';

export const Navbar: React.FC = () => {
  const [isScrolled, setIsScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [activeSection, setActiveSection] = useState('home');

  const navLinks = [
    { name: 'Home', href: '#home', id: 'home' },
    { name: 'Introduction', href: '#introduction', id: 'introduction' },
    { name: 'Solution Architecture', href: '#solution-architecture', id: 'solution-architecture' },
    { name: 'Hardware & Software', href: '#hardware-software', id: 'hardware-software' },
    { name: 'Testing', href: '#testing', id: 'testing' },
    { name: 'Budget', href: '#budget', id: 'budget' },
    { name: 'Team', href: '#team', id: 'team' },
  ];

  useEffect(() => {
    // Ensure dark class is removed when reverted
    document.documentElement.classList.remove('dark');
    localStorage.removeItem('theme');

    const handleScroll = () => {
      setIsScrolled(window.scrollY > 20);

      // Simple active scroll spy
      const sections = navLinks.map(link => document.getElementById(link.id));
      const scrollPosition = window.scrollY + 200;

      for (let i = sections.length - 1; i >= 0; i--) {
        const section = sections[i];
        if (section && section.offsetTop <= scrollPosition) {
          setActiveSection(navLinks[i].id);
          break;
        }
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <header
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        isScrolled
          ? 'bg-white/95 backdrop-blur-md border-b border-slate-200/80 py-3.5 shadow-sm'
          : 'bg-white/80 backdrop-blur-sm border-b border-slate-100 py-4'
      }`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between">
          
          {/* CluckNet Branding: Logo + Cluck (BLACK) + Net (GREEN) */}
          <a href="#home" className="flex items-center gap-3 group">
            <img
              src={logoImg}
              alt="CluckNet Logo"
              className="h-10 sm:h-11 md:h-12 w-auto object-contain transition-transform duration-200 group-hover:scale-105 drop-shadow-sm rounded-2xl"
            />
            <span className="text-2xl sm:text-3xl font-extrabold tracking-tight font-sans">
              <span className="text-slate-900">Cluck</span>
              <span className="text-emerald-600">Net</span>
            </span>
          </a>

          {/* Desktop Navigation Links — Black text, Green active state */}
          <nav className="hidden lg:flex items-center gap-1 xl:gap-2">
            {navLinks.map((link) => {
              const isActive = activeSection === link.id;
              return (
                <a
                  key={link.name}
                  href={link.href}
                  className={`px-3 py-1.5 text-xs xl:text-sm font-semibold transition-colors duration-150 relative ${
                    isActive
                      ? 'text-emerald-600 font-bold'
                      : 'text-slate-800 hover:text-emerald-600'
                  }`}
                >
                  {link.name}
                  {isActive && (
                    <span className="absolute bottom-0 left-3 right-3 h-0.5 bg-emerald-600 rounded-full" />
                  )}
                </a>
              );
            })}
          </nav>

          {/* Mobile Hamburger Menu Button */}
          <button
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            className="lg:hidden p-2 rounded-xl bg-slate-100 border border-slate-200 text-slate-800 hover:text-slate-900 focus:outline-none"
            aria-label="Toggle Navigation Menu"
          >
            {mobileMenuOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
          </button>
        </div>
      </div>

      {/* Mobile Drawer Menu */}
      {mobileMenuOpen && (
        <div className="lg:hidden bg-white border-b border-slate-200 backdrop-blur-xl px-4 pt-3 pb-5 transition-all shadow-lg">
          <div className="flex flex-col gap-1">
            {navLinks.map((link) => {
              const isActive = activeSection === link.id;
              return (
                <a
                  key={link.name}
                  href={link.href}
                  onClick={() => setMobileMenuOpen(false)}
                  className={`px-4 py-2.5 rounded-lg text-sm font-semibold transition-colors ${
                    isActive
                      ? 'bg-emerald-50 text-emerald-700 font-bold'
                      : 'text-slate-800 hover:bg-slate-50 hover:text-emerald-600'
                  }`}
                >
                  {link.name}
                </a>
              );
            })}
          </div>
        </div>
      )}
    </header>
  );
};
