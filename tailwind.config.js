module.exports = {
  theme: {
    extend: {
      colors: {
        rumena: 'rgb(240, 240, 0)',
        zelena: 'rgb(45, 136, 45)',
        rdeca:  'rgb(230, 57, 57)',
        modra:  'rgb(30, 50, 255)',
        rjava:  'rgb(125, 80, 10)',
        primary:  {
           50: '#f3faf7',
          100: '#f0fff4',
          200: '#c6f6d5',
          300: '#9ae6b4',
          400: '#68d391',
      default: '#48bb78',
          500: '#48bb78',
          600: '#38a169',
          700: '#2f855a',
          800: '#276749',
          900: '#22543d',
        },
        secondary: {
           50: '#fdf2f2',
          100: '#fff5f5',
          200: '#fed7d7',
          300: '#feb2b2',
          400: '#fc8181',
          default: '#f56565',
          500: '#f56565',
          600: '#e53e3e',
          700: '#c53030',
          800: '#9b2c2c',
          900: '#742a2a',
        }
      }
    },
  },
  variants: {
    borderColor: ['responsive', 'hover', 'focus', 'disabled'],
  },
  plugins: [ require('@tailwindcss/ui'), ],
}
