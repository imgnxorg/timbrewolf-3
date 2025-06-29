// midi.js
// A minimal JavaScript utility to build MIDI files in the browser or Node.js

/**
 * Convert a number into an array of big-endian bytes.
 * @param {number} value
 * @param {number} byteCount
 * @returns {number[]}
 */
function toBytes(value, byteCount) {
  const bytes = [];
  for (let i = byteCount - 1; i >= 0; i--) {
    bytes.push((value >> (8 * i)) & 0xff);
  }
  return bytes;
}

/**
 * Write a variable-length quantity.
 * @param {number} value
 * @returns {number[]}
 */
function writeVarLen(value) {
  let buffer = value & 0x7f;
  const bytes = [];
  while ((value >>= 7)) {
    buffer <<= 8;
    buffer |= (value & 0x7f) | 0x80;
  }
  while (true) {
    bytes.push(buffer & 0xff);
    if (buffer & 0x80) buffer >>= 8;
    else break;
  }
  return bytes;
}

/**
 * Build the MIDI header chunk.
 * @param {number} numTracks
 * @param {number} ticksPerQuarter
 * @returns {number[]}
 */
function writeHeader(numTracks, ticksPerQuarter) {
  const header = []
    .concat([0x4d, 0x54, 0x68, 0x64]) // 'MThd'
    .concat(toBytes(6, 4)) // header length = 6
    .concat([0x00, 0x01]) // format = 1
    .concat(toBytes(numTracks, 2)) // number of tracks
    .concat(toBytes(ticksPerQuarter, 2)); // division
  return header;
}

/**
 * Build a single track chunk.
 * @param {number[]} eventsBytes
 * @returns {number[]}
 */
function writeTrack(eventsBytes) {
  const length = eventsBytes.length;
  return []
    .concat([0x4d, 0x54, 0x72, 0x6b]) // 'MTrk'
    .concat(toBytes(length, 4)) // track length
    .concat(eventsBytes);
}

/**
 * Note On event.
 * @param {number} channel 0-15
 * @param {number} note 0-127
 * @param {number} velocity 0-127
 * @param {number} deltaTime in ticks
 * @returns {number[]}
 */
function noteOn(channel, note, velocity, deltaTime = 0) {
  return [].concat(writeVarLen(deltaTime)).concat([0x90 | (channel & 0x0f), note & 0x7f, velocity & 0x7f]);
}

/**
 * Note Off event.
 * @param {number} channel 0-15
 * @param {number} note 0-127
 * @param {number} velocity 0-127
 * @param {number} deltaTime in ticks
 * @returns {number[]}
 */
function noteOff(channel, note, velocity, deltaTime = 0) {
  return [].concat(writeVarLen(deltaTime)).concat([0x80 | (channel & 0x0f), note & 0x7f, velocity & 0x7f]);
}

/**
 * Set tempo meta-event.
 * @param {number} microsecondsPerQuarter
 * @param {number} deltaTime
 * @returns {number[]}
 */
function setTempo(microsecondsPerQuarter = 500000, deltaTime = 0) {
  return []
    .concat(writeVarLen(deltaTime))
    .concat([0xff, 0x51, 0x03])
    .concat(toBytes(microsecondsPerQuarter, 3));
}

/**
 * End‐of‐track meta-event.
 * @returns {number[]}
 */
function endOfTrack() {
  return [0x00, 0xff, 0x2f, 0x00];
}

/**
 * Assemble a full MIDI file from one or more tracks.
 * @param {number[][]} tracks Array of event‐byte arrays
 * @param {number} ticksPerQuarter
 * @returns {Uint8Array}
 */
function createMidiFile(tracks, ticksPerQuarter = 480) {
  const bytes = [].concat(writeHeader(tracks.length, ticksPerQuarter));

  for (const ev of tracks) {
    // ensure each track ends with End‐of‐Track
    const trackBytes = ev.concat(endOfTrack());
    bytes.push(...writeTrack(trackBytes));
  }

  return new Uint8Array(bytes);
}

// Export for Node.js or ES Modules
if (typeof module !== "undefined" && module.exports) {
  module.exports = {
    writeVarLen,
    noteOn,
    noteOff,
    setTempo,
    createMidiFile,
  };
} else {
  export { writeVarLen, noteOn, noteOff, setTempo, createMidiFile };
}
