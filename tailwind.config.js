module.exports = {
  mode: 'jit',
  purge: [
    // Your CSS will rebuild any time *any* file in `src` changes
    './src/**/*.{html,js}',
    './maintmpl.html'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}




