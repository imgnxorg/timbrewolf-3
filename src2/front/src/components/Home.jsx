import React, { useState } from "react";
import webpackLogo from "@/assets/webpack.png";
import takuLogo from "@/assets/leaf.png";

const App = () => {
  const [count, setCount] = useState(0);
  const increment = () => setCount((count) => count + 1);
  const decrement = () => setCount((count) => count - 1);

  return (
    <main className="bg-slate-200">
      <div id="atf" className="container mx-auto flex flex-col items-center justify-center text-center">
        <div className="grid grid-cols-2 gap-4 mb-8">
          <div className="flex flex-col items-center justify-center">
            
            <img src={webpackLogo} className="w-full h-auto max-w-[225px] mx-auto" alt="Webpack logo" />
            <h1 className="heading">
              This is the <span>Home</span> page!
            </h1>
            <p>Click the buttons below to increment and decrement the count.</p>

            <p className="my-10 flex gap-4 items-center justify-center">
              <span className="text-lg">Count: </span>
              <code className="text-6xl bg-lime-200 px-1.5 py-1 font-mono text-black rounded-lg border-3 border-slate-800 outline-2 outline-slate-400 ring-1 ring-slate-100">
                {count}
              </code>
            </p>
            <div className="flex gap-4 justify-center">
              <button
                className="bg-indigo-600 hover:bg-indigo-700 active:bg-indigo-500 rounded-xl text-white shadow-xl border-white border-3 h-20 w-20 text-[3rem]"
                onClick={decrement}
              >
                <span className="relative inset-0">-</span>
              </button>
              <button
                className="bg-slate-200 hover:bg-slate-300 active:bg-slate-100 rounded-xl text-indigo-800 shadow-xl border-indigo-800 border-3 h-20 w-20 text-[3rem]"
                onClick={increment}
              >
                <span className="relative inset-0">+</span>
              </button>
            </div>
          </div>
          <div className="flex flex-col items-center justify-center">
            <h1 id="taku" class="text-[9rem] !my-0 relative inline leading-none">
              Tak
              <span class="inline relative">
                <img
                  src={takuLogo}
                  class="inline absolute bottom-[100%] transform -mb-24 max-w-max text-green-500 "
                />
                u
              </span>
            </h1>
            <h2 id="chalkbox" class="text-6xl mt-10 mb-2">
              ChalkBox
            </h2>
            <h3 class="text-4xl text-gray-500 my-4 inline-block">Native WebView</h3>
            <p>Hello from Taku Native WebView!</p>
          </div>
        </div>
      </div>
    </main>
  );
};

export default App;
