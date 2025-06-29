import React, { useState, useRef } from "react";

const TextToSpeech = () => {
  const [text, setText] = useState("");
  const [isGenerating, setIsGenerating] = useState(false);
  const [voicePreset, setVoicePreset] = useState("en_speaker_0");
  const [textTemp, setTextTemp] = useState(0.7);
  const [waveformTemp, setWaveformTemp] = useState(0.7);
  const [audioSrc, setAudioSrc] = useState(null);
  const [error, setError] = useState(null);
  const audioRef = useRef(null);

  const voicePresets = [
    "en_speaker_0",
    "en_speaker_1",
    "en_speaker_2",
    "en_speaker_3",
    "en_speaker_4",
    "en_speaker_5",
    "en_speaker_6",
    "en_speaker_7",
    "en_speaker_8",
    "en_speaker_9",
  ];

  const handleGenerate = async () => {
    if (!text.trim()) {
      setError("Please enter some text to generate speech");
      return;
    }

    setIsGenerating(true);
    setError(null);
    setAudioSrc(null);

    try {
      const result = await window.generateAudio(text, {
        voicePreset,
        textTemp,
        waveformTemp,
      });

      if (result.success && result.audio_path) {
        setAudioSrc(`file://${result.audio_path}`);
      } else {
        setError(result.error || "Failed to generate audio");
      }
    } catch (err) {
      setError("Error communicating with backend: " + err.message);
    } finally {
      setIsGenerating(false);
    }
  };

  const handlePlayAudio = () => {
    if (audioRef.current) {
      audioRef.current.play();
    }
  };

  return (
    <div className="max-w-4xl mx-auto p-6 bg-white rounded-lg shadow-lg">
      <h1 className="text-3xl font-bold text-gray-800 mb-6 text-center">🎤 Bark Text-to-Speech</h1>

      <div className="space-y-6">
        {/* Text Input */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Text to Convert to Speech</label>
          <textarea
            value={text}
            onChange={(e) => setText(e.target.value)}
            className="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 resize-vertical"
            rows="4"
            placeholder="Enter the text you want to convert to speech..."
            disabled={isGenerating}
          />
        </div>

        {/* Voice Settings */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Voice Preset</label>
            <select
              value={voicePreset}
              onChange={(e) => setVoicePreset(e.target.value)}
              className="w-full p-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              disabled={isGenerating}
            >
              {voicePresets.map((preset) => (
                <option key={preset} value={preset}>
                  {preset.replace("_", " ").replace(/\b\w/g, (l) => l.toUpperCase())}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Text Temperature: {textTemp}
            </label>
            <input
              type="range"
              min="0"
              max="1"
              step="0.1"
              value={textTemp}
              onChange={(e) => setTextTemp(parseFloat(e.target.value))}
              className="w-full"
              disabled={isGenerating}
            />
            <div className="text-xs text-gray-500 mt-1">Lower = more conservative, Higher = more diverse</div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Waveform Temperature: {waveformTemp}
            </label>
            <input
              type="range"
              min="0"
              max="1"
              step="0.1"
              value={waveformTemp}
              onChange={(e) => setWaveformTemp(parseFloat(e.target.value))}
              className="w-full"
              disabled={isGenerating}
            />
            <div className="text-xs text-gray-500 mt-1">Controls audio variation</div>
          </div>
        </div>

        {/* Generate Button */}
        <button
          onClick={handleGenerate}
          disabled={isGenerating || !text.trim()}
          className={`w-full py-3 px-6 rounded-md font-medium text-white transition-colors ${
            isGenerating || !text.trim()
              ? "bg-gray-400 cursor-not-allowed"
              : "bg-blue-600 hover:bg-blue-700 focus:ring-2 focus:ring-blue-500"
          }`}
        >
          {isGenerating ? (
            <span className="flex items-center justify-center">
              <svg
                className="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
              >
                <circle
                  className="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  strokeWidth="4"
                ></circle>
                <path
                  className="opacity-75"
                  fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                ></path>
              </svg>
              Generating Speech...
            </span>
          ) : (
            "🎵 Generate Speech"
          )}
        </button>

        {/* Error Display */}
        {error && (
          <div className="p-4 bg-red-50 border border-red-200 rounded-md">
            <div className="text-red-700">
              <strong>Error:</strong> {error}
            </div>
          </div>
        )}

        {/* Audio Player */}
        {audioSrc && (
          <div className="p-4 bg-green-50 border border-green-200 rounded-md">
            <h3 className="text-lg font-medium text-green-800 mb-3">🎉 Audio Generated Successfully!</h3>
            <div className="space-y-3">
              <audio ref={audioRef} src={audioSrc} controls className="w-full" />
              <button
                onClick={handlePlayAudio}
                className="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors"
              >
                ▶️ Play Audio
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Info Section */}
      <div className="mt-8 p-4 bg-blue-50 border border-blue-200 rounded-md">
        <h3 className="text-lg font-medium text-blue-800 mb-2">ℹ️ About Bark</h3>
        <p className="text-blue-700 text-sm">
          Bark is a transformer-based text-to-audio model that can generate highly realistic, multilingual
          speech as well as other audio including music, background noise and simple sound effects. The model
          can also produce nonverbal communications like laughing, sighing and crying.
        </p>
      </div>
    </div>
  );
};

export default TextToSpeech;
