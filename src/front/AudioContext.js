// Setup Web Audio API
const audioContext = new (window.AudioContext || window.webkitAudioContext)();
const gainNode = audioContext.createGain();
const delayNode = audioContext.createDelay(5.0);
const stereoPanner = audioContext.createStereoPanner();
const oscillator = audioContext.createOscillator(); // We'll use an oscillator for simplicity

// Configure delay and panner
delayNode.delayTime.setValueAtTime(0.3, audioContext.currentTime); // Delay in seconds
stereoPanner.pan.setValueAtTime(1, audioContext.currentTime); // Start panned to the right

// Setup oscillator (tone generator)
oscillator.type = "sine"; // Sine wave (smooth)
oscillator.frequency.setValueAtTime(440, audioContext.currentTime); // Set frequency to A4
oscillator.connect(delayNode);
delayNode.connect(stereoPanner);
stereoPanner.connect(gainNode);
gainNode.connect(audioContext.destination);

// Start oscillator (sound source)
oscillator.start();

// Effect timing — freeze, silence, and explosion
function applyEffects() {
  // Start with a clean tone
  gainNode.gain.setValueAtTime(0.5, audioContext.currentTime); // Set volume to 50%

  // Introduce delay (emulating the "freeze" moment with panning)
  stereoPanner.pan.setValueAtTime(-1, audioContext.currentTime); // Pan left
  delayNode.delayTime.setValueAtTime(1.5, audioContext.currentTime); // Increase delay time

  // After a moment, cut the sound (freeze the time)
  gainNode.gain.setValueAtTime(0, audioContext.currentTime + 2); // Silence for 2 seconds

  // Boom! Rush of bass after silence (bass explosion)
  gainNode.gain.setValueAtTime(1, audioContext.currentTime + 3); // Gradually bring the sound back with full volume
  oscillator.frequency.setValueAtTime(120, audioContext.currentTime + 3); // Drop to bass frequency
}

// Start the effect sequence
applyEffects();

