import React from "react";
import { HashRouter as Router, Route, Routes } from "react-router-dom";
import Home from "../components/Home";
import About from "../components/About";
import TextToSpeech from "../components/TextToSpeech";
import Navbar from "../components/Navbar";

function AppRouter() {
  return (
    <Router>
      <Navbar />
      <Routes>
        <Route path="/" element={<TextToSpeech />} />
        <Route path="/home" element={<Home />} />
        <Route path="/about" element={<About msg="React" />} />
      </Routes>
    </Router>
  );
}

export default AppRouter;
