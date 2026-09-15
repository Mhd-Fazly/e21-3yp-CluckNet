import React, { useState } from 'react';
import { Camera, CheckCircle2, Smartphone } from 'lucide-react';
import { getAssetUrl, handleImageError } from '../utils/assets';

export const Showcase: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'hardware' | 'mobile' | 'testing' | 'budget'>('hardware');

  const budgetItems = [
    { name: 'ESP-32 Microcontroller', qty: 2, unitPrice: '1,400.00', total: '2,800.00' },
    { name: 'SHT-30 Temp & Humidity Sensor', qty: 1, unitPrice: '960.00', total: '960.00' },
    { name: 'MQ-135 Ammonia Sensor', qty: 1, unitPrice: '590.00', total: '590.00' },
    { name: 'MQ-6 LPG Gas Sensor', qty: 1, unitPrice: '490.00', total: '400.00' },
    { name: 'Lithium Battery Cells', qty: 3, unitPrice: '490.00', total: '1,470.00' },
    { name: 'Battery Holder', qty: 1, unitPrice: '150.00', total: '150.00' },
    { name: '5V Buzzer Module', qty: 1, unitPrice: '180.00', total: '180.00' },
    { name: 'Custom 3D Design & Printing', qty: 1, unitPrice: '5,300.00', total: '5,300.00' },
    { name: '3S 12V BMS Board', qty: 1, unitPrice: '720.00', total: '720.00' },
    { name: 'LM2596 Buck Converter', qty: 1, unitPrice: '250.00', total: '250.00' },
    { name: 'Custom Printed Circuit Board (PCB)', qty: 1, unitPrice: '3,200.00', total: '3,200.00' },
    { name: 'MG995 Servo Motor', qty: 1, unitPrice: '1,500.00', total: '1,500.00' },
  ];

  return (
    <section id="showcase" className="py-24 relative bg-slate-950/90 border-t border-white/5">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">

        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-12">
          <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-xs font-semibold uppercase tracking-wider mb-4">
            <Camera className="w-3.5 h-3.5" />
            Project Evidence & Showcase
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-white tracking-tight leading-tight mb-4">
            Verified Prototypes & Testing
          </h2>
          <p className="text-base sm:text-lg text-slate-300">
            Inspect physical PCB assembly, multi-meter voltage verification, software unit test execution, and zone hardware budget.
          </p>
        </div>

        {/* Showcase Category Tabs */}
        <div className="flex flex-wrap items-center justify-center gap-2 mb-12">
          <button
            onClick={() => setActiveTab('hardware')}
            className={`px-5 py-2.5 rounded-full text-xs font-bold transition-all ${activeTab === 'hardware'
                ? 'bg-emerald-500 text-cluck-navy shadow-lg shadow-emerald-500/20'
                : 'bg-white/5 text-slate-300 border border-white/10 hover:bg-white/10'
              }`}
          >
            Hardware Testing & PCB
          </button>
          <button
            onClick={() => setActiveTab('mobile')}
            className={`px-5 py-2.5 rounded-full text-xs font-bold transition-all ${activeTab === 'mobile'
                ? 'bg-emerald-500 text-cluck-navy shadow-lg shadow-emerald-500/20'
                : 'bg-white/5 text-slate-300 border border-white/10 hover:bg-white/10'
              }`}
          >
            Flutter Mobile UI
          </button>
          <button
            onClick={() => setActiveTab('testing')}
            className={`px-5 py-2.5 rounded-full text-xs font-bold transition-all ${activeTab === 'testing'
                ? 'bg-emerald-500 text-cluck-navy shadow-lg shadow-emerald-500/20'
                : 'bg-white/5 text-slate-300 border border-white/10 hover:bg-white/10'
              }`}
          >
            Software Unit Tests
          </button>
          <button
            onClick={() => setActiveTab('budget')}
            className={`px-5 py-2.5 rounded-full text-xs font-bold transition-all ${activeTab === 'budget'
                ? 'bg-emerald-500 text-cluck-navy shadow-lg shadow-emerald-500/20'
                : 'bg-white/5 text-slate-300 border border-white/10 hover:bg-white/10'
              }`}
          >
            Zone Hardware Budget
          </button>
        </div>

        {/* Tab 1: Hardware Testing & PCB */}
        {activeTab === 'hardware' && (
          <div className="glass-panel p-6 sm:p-8 rounded-3xl border border-white/10 bg-slate-900/90">
            <div className="flex flex-col md:flex-row items-start md:items-center justify-between pb-6 mb-6 border-b border-white/10 gap-4">
              <div>
                <h3 className="text-xl font-bold text-white mb-1">Hardware Testing</h3>
                <p className="text-xs text-slate-300">Measuring the actual supply voltages.</p>
              </div>
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-emerald-500/20 text-emerald-400 border border-emerald-500/30">
                <CheckCircle2 className="w-4 h-4" /> Voltage Verification Passed
              </span>
            </div>

            <div className="rounded-2xl overflow-hidden bg-slate-950 border border-white/10 mb-6">
              <img
                src={getAssetUrl('assets/testing/Hardware testing.png')}
                onError={(e) => handleImageError(e, 'assets/testing/Hardware testing.png')}
                alt="Hardware PCB Testing and Multimeter Measurements"
                className="w-full h-auto object-contain max-h-[500px] mx-auto"
              />
            </div>
          </div>
        )}

        {/* Tab 2: Flutter Mobile App UI */}
        {activeTab === 'mobile' && (
          <div className="glass-panel p-6 sm:p-8 rounded-3xl border border-white/10 bg-slate-900/90">
            <div className="flex flex-col md:flex-row items-start md:items-center justify-between pb-6 mb-6 border-b border-white/10 gap-4">
              <div>
                <h3 className="text-xl font-bold text-white mb-1">Flutter Cross-Platform Mobile Dashboard</h3>
                <p className="text-xs text-slate-300">Sleek dark-themed UI featuring real-time zone statuses, active gas warnings, and live telemetry graphs.</p>
              </div>
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-blue-500/20 text-blue-400 border border-blue-500/30">
                <Smartphone className="w-4 h-4" /> Android & iOS Supported
              </span>
            </div>

            <div className="rounded-2xl overflow-hidden bg-slate-950 border border-white/10">
              <img
                src={getAssetUrl('assets/backend-frontend tech/Screenshot 2026-09-07 110002.png')}
                onError={(e) => handleImageError(e, 'assets/backend-frontend tech/Screenshot 2026-09-07 110002.png')}
                alt="Flutter Mobile Application Dashboard Screenshots"
                className="w-full h-auto object-contain max-h-[500px] mx-auto"
              />
            </div>
          </div>
        )}

        {/* Tab 3: Software Unit Testing */}
        {activeTab === 'testing' && (
          <div className="glass-panel p-6 sm:p-8 rounded-3xl border border-white/10 bg-slate-900/90">
            <div className="flex flex-col md:flex-row items-start md:items-center justify-between pb-6 mb-6 border-b border-white/10 gap-4">
              <div>
                <h3 className="text-xl font-bold text-white mb-1">Backend JUnit & Mockito Unit Test Execution</h3>
                <p className="text-xs text-slate-300">100% test coverage for DeviceAssignmentService, MqttSyncPublisher, and ThresholdEvaluationService.</p>
              </div>
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-emerald-500/20 text-emerald-400 border border-emerald-500/30">
                <CheckCircle2 className="w-4 h-4" /> 11/11 Tests Passed
              </span>
            </div>

            <div className="rounded-2xl overflow-hidden bg-slate-950 border border-white/10">
              <img
                src={getAssetUrl('assets/testing/software testing.png')}
                onError={(e) => handleImageError(e, 'assets/testing/software testing.png')}
                alt="Software Unit Testing Execution Screenshots"
                className="w-full h-auto object-contain max-h-[500px] mx-auto"
              />
            </div>
          </div>
        )}

        {/* Tab 4: Zone Hardware Budget */}
        {activeTab === 'budget' && (
          <div className="glass-panel p-6 sm:p-8 rounded-3xl border border-white/10 bg-slate-900/90">
            <div className="flex flex-col md:flex-row items-start md:items-center justify-between pb-6 mb-6 border-b border-white/10 gap-4">
              <div>
                <h3 className="text-xl font-bold text-white mb-1">Zone Hardware Component Cost Breakdown</h3>
                <p className="text-xs text-slate-300">Itemized bill of materials for deploying one complete CluckNet monitoring zone node.</p>
              </div>
              <div className="text-right">
                <div className="text-xs text-slate-400 font-medium">Total Cost Per Zone</div>
                <div className="text-2xl font-bold text-emerald-400 font-mono">17,520.00 LKR</div>
              </div>
            </div>

            {/* Budget Table */}
            <div className="overflow-x-auto rounded-2xl border border-white/10">
              <table className="w-full text-left text-xs">
                <thead className="bg-slate-950 text-slate-300 uppercase font-mono font-semibold border-b border-white/10">
                  <tr>
                    <th className="px-4 py-3">Components</th>
                    <th className="px-4 py-3 text-center">Quantity</th>
                    <th className="px-4 py-3 text-right">Unit Price (LKR)</th>
                    <th className="px-4 py-3 text-right">Total Amount (LKR)</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-white/5 text-slate-200">
                  {budgetItems.map((item, idx) => (
                    <tr key={idx} className="hover:bg-white/5 transition-colors">
                      <td className="px-4 py-2.5 font-medium text-white">{item.name}</td>
                      <td className="px-4 py-2.5 text-center font-mono text-slate-300">{item.qty}</td>
                      <td className="px-4 py-2.5 text-right font-mono text-slate-400">{item.unitPrice}</td>
                      <td className="px-4 py-2.5 text-right font-mono text-emerald-400 font-semibold">{item.total}</td>
                    </tr>
                  ))}
                </tbody>
                <tfoot className="bg-slate-950 font-bold border-t border-white/10">
                  <tr>
                    <td colSpan={3} className="px-4 py-3 text-white uppercase tracking-wider text-right">Grand Total</td>
                    <td className="px-4 py-3 text-right font-mono text-emerald-400 text-sm">17,520.00 LKR</td>
                  </tr>
                </tfoot>
              </table>
            </div>
          </div>
        )}

      </div>
    </section>
  );
};
