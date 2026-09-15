/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        cluck: {
          navy: '#0B132B',
          darkBlue: '#1C2541',
          cardBg: '#16203A',
          border: '#2A3656',
          green: '#10B981',
          greenHover: '#059669',
          greenLight: 'rgba(16, 185, 129, 0.12)',
          blue: '#3B82F6',
          blueLight: 'rgba(59, 130, 246, 0.12)',
          cyan: '#0EA5E9',
          danger: '#EF4444',
          warning: '#F59E0B',
          textMuted: '#94A3B8',
          textLight: '#F8FAFC',
          surface: '#F8FAFC',
          surfaceDark: '#0F172A',
        }
      },
      fontFamily: {
        sans: ['Plus Jakarta Sans', 'Inter', 'sans-serif'],
      },
      boxShadow: {
        'glow-green': '0 0 25px -5px rgba(16, 185, 129, 0.3)',
        'glow-blue': '0 0 25px -5px rgba(59, 130, 246, 0.3)',
        'glow-amber': '0 0 25px -5px rgba(245, 158, 11, 0.3)',
      },
      animation: {
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'float': 'float 4s ease-in-out infinite',
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-8px)' },
        }
      }
    },
  },
  plugins: [],
}
