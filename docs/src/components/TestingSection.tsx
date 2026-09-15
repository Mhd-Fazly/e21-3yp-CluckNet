import React, { useState } from 'react';
import { CheckCircle2, ChevronLeft, ChevronRight, Maximize2, X } from 'lucide-react';
import { getAssetUrl, handleImageError } from '../utils/assets';

interface SoftwareSlide {
  id: string;
  title: string;
  badge: string;
  badgeColor: string;
  description: string;
  imageSrc: string;
  rawSrc: string;
  alt: string;
}

const softwareSlides: SoftwareSlide[] = [
  {
    id: 'unit',
    title: 'Spring Boot JUnit & Mockito Test Coverage',
    badge: '11 / 11 Passed',
    badgeColor: 'bg-emerald-50 text-emerald-700 border-emerald-200',
    description: '100% pass rate for DeviceAssignmentService, MqttSyncPublisher, and TelemetryProcessingService.',
    imageSrc: getAssetUrl('assets/testing/unit testing.jpg'),
    rawSrc: 'assets/testing/unit testing.jpg',
    alt: 'Software Unit Testing Execution Screenshots'
  },
  {
    id: 'mock',
    title: 'Mock Hardware & Telemetry Simulation Testing',
    badge: 'Simulation Active',
    badgeColor: 'bg-blue-50 text-blue-700 border-blue-200',
    description: 'Automated mock test suite validating edge-to-cloud payload publishing, MQTT sync, and failure recovery.',
    imageSrc: getAssetUrl('assets/testing/Mock testing.png'),
    rawSrc: 'assets/testing/Mock testing.png',
    alt: 'Mock Testing Execution Screenshots'
  },
  {
    id: 'api',
    title: 'REST API Endpoint & Integration Validation',
    badge: 'Endpoints Verified',
    badgeColor: 'bg-purple-50 text-purple-700 border-purple-200',
    description: 'Integration tests confirming HTTP 200 responses, request serialization, and authentication header validation.',
    imageSrc: getAssetUrl('assets/testing/API testing.png'),
    rawSrc: 'assets/testing/API testing.png',
    alt: 'API Testing Execution Screenshots'
  }
];

export const TestingSection: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'hardware' | 'software'>('hardware');
  const [currentSoftwareSlide, setCurrentSoftwareSlide] = useState(0);
  const [selectedImageModal, setSelectedImageModal] = useState<{ src: string; rawSrc: string; title: string } | null>(null);

  const nextSoftwareSlide = () => {
    setCurrentSoftwareSlide((prev) => (prev + 1) % softwareSlides.length);
  };

  const prevSoftwareSlide = () => {
    setCurrentSoftwareSlide((prev) => (prev - 1 + softwareSlides.length) % softwareSlides.length);
  };

  const activeSlide = softwareSlides[currentSoftwareSlide];

  const hardwareCards = [
    {
      title: 'Raw Battery Bus (10.78V DC)',
      subtitle: 'Multimeter measurement across raw battery bus',
      imageSrc: getAssetUrl('assets/testing/Hardware testing1.png'),
      rawSrc: 'assets/testing/Hardware testing1.png',
      alt: 'Raw Battery Bus Multimeter Reading 10.78V DC'
    },
    {
      title: 'PCB Board & Circuit Setup',
      subtitle: 'ESP32 microcontroller, relays & buck converter assembly',
      imageSrc: getAssetUrl('assets/testing/Hardware testing.png'),
      rawSrc: 'assets/testing/Hardware testing.png',
      alt: 'ESP32 Hardware PCB Board Assembly Setup'
    },
    {
      title: 'Logic Supply Bus (4.99V DC)',
      subtitle: 'Multimeter measurement across 5V buck logic bus',
      imageSrc: getAssetUrl('assets/testing/Hardware testing2.png'),
      rawSrc: 'assets/testing/Hardware testing2.png',
      alt: 'Logic Supply Bus Multimeter Reading 4.99V DC'
    }
  ];

  return (
    <section id="testing" className="py-24 relative bg-slate-100/80 border-t border-slate-300">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Section Header */}
        <div className="text-left max-w-3xl mb-12">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 tracking-tight leading-tight mb-4">
            System Testing & Results
          </h2>
          <p className="text-base sm:text-lg text-slate-600">
            Empirical validation covering hardware PCB multimeter voltage rails, Java backend unit/mock/API tests, and system integration.
          </p>
        </div>

        {/* Category Tabs */}
        <div className="flex flex-wrap items-center justify-start gap-2 mb-8">
          <button
            onClick={() => setActiveTab('hardware')}
            className={`px-5 py-2.5 rounded-full text-xs font-bold transition-all ${
              activeTab === 'hardware'
                ? 'bg-emerald-600 text-white shadow-md'
                : 'bg-white text-slate-700 border border-slate-200 hover:bg-slate-50'
            }`}
          >
            Hardware Testing
          </button>
          <button
            onClick={() => setActiveTab('software')}
            className={`px-5 py-2.5 rounded-full text-xs font-bold transition-all ${
              activeTab === 'software'
                ? 'bg-blue-600 text-white shadow-md'
                : 'bg-white text-slate-700 border border-slate-200 hover:bg-slate-50'
            }`}
          >
            Software Testing
          </button>
        </div>

        {/* Tab 1: Hardware Testing (Single Window, 3 Columns Grid, No Black Spaces) */}
        {activeTab === 'hardware' && (
          <div className="bg-white p-6 sm:p-8 rounded-3xl border border-slate-200 shadow-sm relative">
            <div className="flex flex-col md:flex-row items-start md:items-center justify-between pb-6 mb-6 border-b border-slate-200 gap-4">
              <div>
                <h3 className="text-xl font-bold text-slate-900">Empirical Hardware Multimeter & Board Measurements</h3>
              </div>
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-emerald-50 text-emerald-700 border border-emerald-200 shrink-0">
                <CheckCircle2 className="w-4 h-4" /> Hardware Verification Passed
              </span>
            </div>

            {/* 3 Columns Grid */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {hardwareCards.map((card, idx) => (
                <div 
                  key={idx}
                  className="flex flex-col bg-slate-50 rounded-2xl border border-slate-200 overflow-hidden cursor-pointer group hover:border-emerald-500/50 hover:shadow-md transition-all duration-300"
                  onClick={() => setSelectedImageModal({ src: card.imageSrc, rawSrc: card.rawSrc, title: card.title })}
                >
                  <div className="relative overflow-hidden aspect-[3/4] bg-slate-100 flex items-center justify-center">
                    <img
                      src={card.imageSrc}
                      onError={(e) => handleImageError(e, card.rawSrc)}
                      alt={card.alt}
                      className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                    />
                    <div className="absolute inset-0 bg-slate-900/0 group-hover:bg-slate-900/20 transition-all flex items-center justify-center">
                      <span className="opacity-0 group-hover:opacity-100 transition-opacity duration-200 bg-slate-900/90 text-white text-xs px-3.5 py-1.5 rounded-full backdrop-blur-md flex items-center gap-1.5 shadow-lg border border-white/10">
                        <Maximize2 className="w-3.5 h-3.5 text-emerald-400" /> Expand
                      </span>
                    </div>
                  </div>
                  <div className="p-4 bg-white border-t border-slate-100 flex-1 flex flex-col justify-center">
                    <h4 className="text-sm font-bold text-slate-900 mb-0.5 group-hover:text-emerald-700 transition-colors">{card.title}</h4>
                    <p className="text-[11px] font-['Arial',sans-serif] font-medium text-slate-600 leading-tight">{card.subtitle}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Tab 2: Software Unit / Mock / API Testing Slider (Without Redundant Sub-Tabs) */}
        {activeTab === 'software' && (
          <div className="bg-white p-6 sm:p-8 rounded-3xl border border-slate-200 shadow-sm relative">
            
            {/* Slide Header Info */}
            <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mb-6">
              <div>
                <h3 className="text-xl font-bold text-slate-900 mb-1 flex items-center gap-2">
                  <span>{activeSlide.title}</span>
                </h3>
                <p className="text-xs text-slate-600 max-w-2xl">{activeSlide.description}</p>
              </div>
              <span className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold border shrink-0 ${activeSlide.badgeColor}`}>
                <CheckCircle2 className="w-4 h-4" /> {activeSlide.badge}
              </span>
            </div>

            {/* Image Slide Area */}
            <div className="relative rounded-2xl overflow-hidden bg-slate-950 border border-slate-200 group">
              <div 
                className="cursor-pointer relative overflow-hidden flex items-center justify-center min-h-[300px] max-h-[520px]"
                onClick={() => setSelectedImageModal({ src: activeSlide.imageSrc, rawSrc: activeSlide.rawSrc, title: activeSlide.title })}
              >
                <img
                  key={activeSlide.id}
                  src={activeSlide.imageSrc}
                  onError={(e) => handleImageError(e, activeSlide.rawSrc)}
                  alt={activeSlide.alt}
                  className="w-full h-auto object-contain max-h-[520px] mx-auto transition-all duration-500 ease-in-out group-hover:scale-[1.01]"
                />

                {/* Hover overlay hint */}
                <div className="absolute inset-0 bg-slate-900/0 group-hover:bg-slate-900/30 transition-all flex items-center justify-center pointer-events-none">
                  <span className="opacity-0 group-hover:opacity-100 transition-opacity duration-200 bg-slate-900/90 text-white text-xs px-4 py-2 rounded-full backdrop-blur-md flex items-center gap-2 shadow-xl border border-white/10">
                    <Maximize2 className="w-3.5 h-3.5 text-emerald-400" /> Click to Expand Full View
                  </span>
                </div>
              </div>

              {/* Prev / Next overlay arrows on image sides */}
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  prevSoftwareSlide();
                }}
                className="absolute left-3 top-1/2 -translate-y-1/2 p-2.5 rounded-full bg-slate-900/60 hover:bg-slate-900/90 text-white border border-white/20 backdrop-blur-md opacity-70 hover:opacity-100 transition-all shadow-lg active:scale-95"
                aria-label="Previous image"
              >
                <ChevronLeft className="w-5 h-5" />
              </button>
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  nextSoftwareSlide();
                }}
                className="absolute right-3 top-1/2 -translate-y-1/2 p-2.5 rounded-full bg-slate-900/60 hover:bg-slate-900/90 text-white border border-white/20 backdrop-blur-md opacity-70 hover:opacity-100 transition-all shadow-lg active:scale-95"
                aria-label="Next image"
              >
                <ChevronRight className="w-5 h-5" />
              </button>

              {/* Slide Indicator Dots at bottom of image */}
              <div className="absolute bottom-3 left-1/2 -translate-x-1/2 flex items-center gap-2 px-3 py-1.5 rounded-full bg-slate-900/75 backdrop-blur-md border border-white/10 shadow-md">
                {softwareSlides.map((_, idx) => (
                  <button
                    key={idx}
                    onClick={(e) => {
                      e.stopPropagation();
                      setCurrentSoftwareSlide(idx);
                    }}
                    className={`h-2 rounded-full transition-all ${
                      currentSoftwareSlide === idx ? 'w-6 bg-blue-400' : 'w-2 bg-white/40 hover:bg-white/70'
                    }`}
                    aria-label={`Go to slide ${idx + 1}`}
                  />
                ))}
              </div>
            </div>
          </div>
        )}

      </div>

      {/* Lightbox Image Modal */}
      {selectedImageModal && (
        <div 
          className="fixed inset-0 z-50 bg-slate-950/90 backdrop-blur-md flex items-center justify-center p-4 sm:p-8 animate-fadeIn"
          onClick={() => setSelectedImageModal(null)}
        >
          <div 
            className="relative max-w-6xl w-full bg-slate-900 rounded-3xl border border-slate-800 p-4 shadow-2xl flex flex-col max-h-[90vh]"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between pb-3 px-2 border-b border-slate-800">
              <h4 className="text-sm font-bold text-white flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-emerald-400" />
                {selectedImageModal.title}
              </h4>
              <button
                onClick={() => setSelectedImageModal(null)}
                className="p-1.5 rounded-full bg-slate-800 text-slate-300 hover:bg-slate-700 hover:text-white transition-all"
                aria-label="Close modal"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            <div className="overflow-auto flex-1 flex items-center justify-center p-2">
              <img
                src={selectedImageModal.src}
                onError={(e) => handleImageError(e, selectedImageModal.rawSrc)}
                alt={selectedImageModal.title}
                className="max-w-full max-h-[75vh] object-contain rounded-xl"
              />
            </div>
          </div>
        </div>
      )}
    </section>
  );
};
