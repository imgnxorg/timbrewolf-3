#!/bin/bash

# ---- Project Setup ----
PROJECT_NAME="animoogz-timbre-ui"
mkdir $PROJECT_NAME && cd $PROJECT_NAME || exit

# ---- Init Project ----
npm init -y

# ---- Install Dev Dependencies ----
npm install --save react react-dom tone wavefile audiobuffer-to-wav
npm install --save-dev webpack webpack-cli webpack-dev-server \
    babel-loader @babel/core @babel/preset-env @babel/preset-react \
    tailwindcss postcss autoprefixer postcss-loader \
    css-loader style-loader html-webpack-plugin

# ---- Tailwind Setup ----
npx tailwindcss init -p

# ---- Create File Structure ----
mkdir src public
touch tailwind.config.js postcss.config.js webpack.config.js

# ---- Tailwind Config ----
cat <<EOF >tailwind.config.js
module.exports = {
  content: ['./src/**/*.{js,jsx}'],
  theme: {
    extend: {},
  },
  plugins: [],
};
EOF

# ---- PostCSS Config ----
cat <<EOF >postcss.config.js
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
EOF

# ---- Webpack Config ----
cat <<EOF >webpack.config.js
const HtmlWebpackPlugin = require('html-webpack-plugin');
const path = require('path');

module.exports = {
  entry: './src/index.jsx',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
    clean: true,
  },
  mode: 'development',
  devServer: {
    static: './dist',
    hot: true,
    open: true,
  },
  module: {
    rules: [
      {
        test: /\\.jsx?$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
        },
      },
      {
        test: /\\.css$/,
        use: ['style-loader', 'css-loader', 'postcss-loader'],
      },
    ],
  },
  resolve: {
    extensions: ['.js', '.jsx'],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './public/index.html',
    }),
  ],
};
EOF

# ---- Babel Config ----
cat <<EOF >.babelrc
{
  "presets": ["@babel/preset-env", "@babel/preset-react"]
}
EOF

# ---- HTML Template ----
cat <<EOF >public/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Animoog Z Timbre Tool</title>
</head>
<body>
  <div id="root"></div>
</body>
</html>
EOF

# ---- Tailwind Entry ----
cat <<EOF >src/index.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# ---- React Entry ----
cat <<EOF >src/index.jsx
import React from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import App from './App';

const root = createRoot(document.getElementById('root'));
root.render(<App />);
EOF

# ---- Main App Scaffold ----
cat <<EOF >src/App.jsx
import React from 'react';

const timbres = [
  "Glassy FM Bell",
  "Swampy Sub Wobble",
  "Aggro Rezo Slicer",
  "Cold Digital Pad",
  "Robotic Formant Chatter",
  "Granular Storm Noise",
  "Hollow Wooden Pluck",
  "Serpentine Acid Whirl"
];

export default function App() {
  return (
    <div className="p-8 space-y-4">
      <h1 className="text-2xl font-bold">Animoog Z Timbre Generator</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {timbres.map((name, i) => (
          <div key={i} className="bg-gray-900 p-4 rounded-2xl shadow-md space-y-2">
            <h2 className="text-xl font-semibold text-white">{name}</h2>
            <button className="px-4 py-2 bg-green-600 rounded-xl text-white hover:bg-green-500">
              Play
            </button>
            <button className="px-4 py-2 bg-blue-600 rounded-xl text-white hover:bg-blue-500">
              Export WAV
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
EOF

# ---- Launch Dev Server ----
echo "Project setup complete! Serving..."
npx webpack serve

# Open the app in the default browser
if command -v xdg-open >/dev/null; then
    xdg-open http://localhost:8080
elif command -v open >/dev/null; then
    open http://localhost:8080
else
    echo "Please open http://localhost:8080 in your browser."
fi
echo "Enjoy your new Animoog Z Timbre Tool!"
