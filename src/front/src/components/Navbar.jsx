import React from "react";
import { NavLink } from "react-router-dom";

const NavBar = () => {
  return (
    <div className="bg-slate-500 p-4 h-max flex items-center shadow-md sticky top-0">
      <nav className="container mx-auto flex flex-row justify-start items-start gap-4">
        <NavLink
          to="/"
          className={({ isActive }) =>
            `rounded-xl border border-3 border-white px-4 py-2 transition-colors ${
              isActive ? "bg-cyan-700 text-white" : "bg-blue-500 text-white"
            }`
          }
        >
          Home
        </NavLink>
        <NavLink
          to="/about"
          className={({ isActive }) =>
            `rounded-xl border border-3 border-white px-4 py-2 transition-colors ${
              isActive ? "bg-cyan-700 text-white" : "bg-blue-500 text-white"
            }`
          }
        >
          About
        </NavLink>
      </nav>
    </div>
  );
};

export default NavBar;
