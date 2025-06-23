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
