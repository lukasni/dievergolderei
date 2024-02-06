module.exports = {
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js",
  ],
  theme: {
    extend: {
      typography: (theme) => ({
        DEFAULT: {
          css: {
            color: theme('colors.gray.900'),
            h1: {
              fontWeight: 400
            },
            h2: {
              fontWeight: 400
            },
            h3: {
              fontWeight: 400
            },
            h4: {
              fontWeight: 400
            },
          }
        }
      }),
      fontFamily: {
        'sans': ['Raleway', 'sans-serif'],
      },
      colors: {
        dvgold: {
          100: '#fffa50',
          200: '#ffe63c',
          300: '#ebd228',
          400: '#d7be14',
          500: '#C3AA00',
          600: '#af9600',
          700: '#9b8200',
          800: '#876e00',
          900: '#735a00'
        },
        dvblue: {
          100: '#6f9fcc',
          200: '#5b8bb8',
          300: '#4777a4',
          400: '#336390',
          500: '#1F4F7C',
          600: '#0b3b68',
          700: '#002754',
          800: '#001340',
          900: '#00002c'
        }
      },
      height: theme => ({
        "screen/2": "50vh",
        "screen/3": "calc(100vh / 3)",
        "screen/4": "calc(100vh / 4)",
        "screen/5": "calc(100vh / 5)",
      }),
    },
  },
  variants: {},
  plugins: [
    require('@tailwindcss/typography'),
    require("@tailwindcss/forms")
  ]
}
