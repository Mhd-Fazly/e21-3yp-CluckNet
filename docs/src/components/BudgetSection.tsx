import React from 'react';

export const BudgetSection: React.FC = () => {
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
    { name: 'Servo Motor (MG995)', qty: 1, unitPrice: '1,500.00', total: '1,500.00' },
  ];

  return (
    <section id="budget" className="py-24 relative bg-white border-t border-slate-300">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Left-Aligned Section Header */}
        <div className="text-left max-w-3xl mb-12">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-slate-900 tracking-tight leading-tight mb-4">
            Zone Budget
          </h2>
          <p className="text-base sm:text-lg text-slate-600">
            Itemized component bill of materials for deploying one complete CluckNet environmental monitoring and control node.
          </p>
        </div>

        {/* Itemized Table */}
        <div className="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs sm:text-sm">
              <thead className="bg-slate-100 text-slate-800 uppercase font-sans font-bold border-b border-slate-200">
                <tr>
                  <th className="px-6 py-4">Components</th>
                  <th className="px-6 py-4 text-center">Quantity</th>
                  <th className="px-6 py-4 text-right">Unit Price (LKR)</th>
                  <th className="px-6 py-4 text-right">Total Amount (LKR)</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-200/60 text-slate-800">
                {budgetItems.map((item, idx) => (
                  <tr
                    key={idx}
                    className={`transition-colors duration-150 hover:bg-[#dbece4] ${
                      idx % 2 === 0 ? 'bg-white' : 'bg-slate-50/50'
                    }`}
                  >
                    <td className="px-6 py-3.5 font-semibold text-slate-900">{item.name}</td>
                    <td className="px-6 py-3.5 text-center font-['Arial',sans-serif] font-semibold text-slate-800">{item.qty}</td>
                    <td className="px-6 py-3.5 text-right font-['Arial',sans-serif] font-semibold text-slate-700">{item.unitPrice}</td>
                    <td className="px-6 py-3.5 text-right font-['Arial',sans-serif] font-bold text-emerald-700">{item.total}</td>
                  </tr>
                ))}
              </tbody>
              <tfoot className="bg-slate-100 font-bold border-t border-slate-200">
                <tr>
                  <td colSpan={3} className="px-6 py-4 text-slate-900 uppercase tracking-wider text-right text-xs">Total Amount Per Zone</td>
                  <td className="px-6 py-4 text-right font-['Arial',sans-serif] font-bold text-emerald-700 text-base sm:text-lg">17,520.00 LKR</td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>

      </div>
    </section>
  );
};
