/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'base': '#F8F9F4',
        'surface': '#F0F4EF',
        'primary-text': '#2D3748',
        'primary-accent': '#34C759',
        'support-accent': '#FF9500',
        'neutral-light': '#A0AEC0',
        'neutral-medium': '#718096',
        'neutral-dark': '#4A5568'
      }
    },
  },
  plugins: [],
}
