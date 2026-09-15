import React, { useEffect } from 'react';
import { Navbar } from './components/Navbar';
import { Hero } from './components/Hero';
import { IntroductionSection } from './components/IntroductionSection';
import { SolutionArchitecture } from './components/SolutionArchitecture';
import { HardwareSoftware } from './components/HardwareSoftware';
import { TestingSection } from './components/TestingSection';
import { BudgetSection } from './components/BudgetSection';
import { TeamSection } from './components/TeamSection';
import { Footer } from './components/Footer';
import { getAssetUrl } from './utils/assets';

export const App: React.FC = () => {
  useEffect(() => {
    const logoUrl = getAssetUrl('assets/webpage-logo.png');
    let link: HTMLLinkElement | null = document.querySelector("link[rel*='icon']");
    if (!link) {
      link = document.createElement('link');
      document.head.appendChild(link);
    }
    link.type = 'image/png';
    link.rel = 'shortcut icon';
    link.href = logoUrl;
  }, []);

  return (
    <div className="min-h-screen bg-slate-50 text-slate-900 selection:bg-emerald-500 selection:text-white">
      <Navbar />
      <main>
        <Hero />
        <IntroductionSection />
        <SolutionArchitecture />
        <HardwareSoftware />
        <TestingSection />
        <BudgetSection />
        <TeamSection />
      </main>
      <Footer />
    </div>
  );
};

export default App;
