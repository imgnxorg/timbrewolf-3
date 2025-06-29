import React, { useEffect } from "react";
import MIDI from "@/modules/midi.js"; // Adjust the import path as necessary
const page = () => {
  useEffect(() => {
    function playZeldaMelody() {
      MIDI.loadPlugin({
        soundfontUrl: "./soundfont/",
        instruments: ["glockenspiel"],
        onsuccess: function () {
          MIDI.programChange(0, MIDI.GM.byName["glockenspiel"].number);

          const notes = [79, 78, 63, 69, 68, 76, 80, 84]; // G5, Gb5, Eb4, A4, Ab4, E5, Ab5, C6
          let time = 0;

          notes.forEach(function (note, i) {
            MIDI.noteOn(0, note, 127, time);
            MIDI.noteOff(0, note, time + 0.2);
            time += 0.25;
          });
        },
      });
    }
    return () => {
      console.log("page unmounted");
    };
  }, []);
  return (
    <div>
      <h1>Example MIDI Page</h1>
      <p>This page demonstrates playing a melody using the MIDI.js library.</p>
      <button onClick={playZeldaMelody}>Play Zelda Melody</button>
      <p>Check the console for MIDI events.</p>
    </div>
  );
};

export default page;
