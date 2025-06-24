/** @type {import('tailwindcss').Config} */
const { mauve, mauveDark, violet, violetDark } = require("@radix-ui/colors");

module.exports = {
  content: ["./src/**/*.{js,jsx,ts,tsx,html}", "./public/index.html"],
  theme: {
    extend: {
      colors: {
        mauve: { ...mauve },
        mauveDark: { ...mauveDark },
        violet: { ...violet },
        violetDark: { ...violetDark },
      },
    },
  },
  plugins: [],
};
