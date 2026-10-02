const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      colors: {
        buna: {
          dark: '#140B07',       // Deepest obsidian roast
          espresso: '#24130D',   // Rich extraction brown
          roast: '#3A2016',      // Roasted bean mahogany
          terracotta: '#9E472A', // Authentic Jebena clay
          clay: '#B55A3C',       // Earthen pottery tone
          amber: '#D48B38',      // Golden coffee crema
          gold: '#E5A652',       // Ornate Saba motif gold
          sand: '#EFE7DA',       // Handwoven Ketema mat tone
          parchment: '#FAF6EE',  // Warm clean background
          card: '#FDFBF7',       // Soft porcelain card surface
          forest: '#183822',     // Kaffa highland forest
          leaf: '#2A5A38'        // Tenadam (Rue) herb green
        },
        safaricom: {
          green: '#00A859',      // Official Safaricom M-Pesa green
          hover: '#008F4C',
          dark: '#006C38'
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', ...defaultTheme.fontFamily.sans],
        serif: ['Playfair Display', 'Georgia', ...defaultTheme.fontFamily.serif],
        amharic: ['Nyala', 'Abyssinica SIL', 'Noto Sans Ethiopic', 'sans-serif']
      },
      boxShadow: {
        'buna-soft': '0 4px 20px -2px rgba(36, 19, 13, 0.08)',
        'buna-card': '0 8px 30px -4px rgba(36, 19, 13, 0.12)',
        'buna-glow': '0 0 25px rgba(212, 139, 56, 0.25)'
      }
    },
  },
  plugins: [
    // standard tailwind plugins if needed
  ]
}
