#!/bin/bash

# ---- Project Setup ----
PROJECT_NAME="animoogz-timbre-ui"
mkdir $PROJECT_NAME && cd $PROJECT_NAME || exit

# ---- Create Temporary Directories ----
# These files are okay to delete after setup
maketree <<EOF
.
└─── tmp
    └── taku
        └── package.json
EOF

mkdir -p ./tmp/.taku
touch ./tmp/.taku/package.json

# ---- Init Project ----
npm init -y

# ---- Install Dev Dependencies ----
npm install --save react react-dom tone wavefile audiobuffer-to-wav sqlite3
npm install --save-dev webpack webpack-cli webpack-dev-server \
  babel-loader @babel/core @babel/preset-env @babel/preset-react \
  tailwindcss postcss autoprefixer postcss-loader \
  css-loader style-loader html-webpack-plugin

# ---- Tailwind Setup ----
npx tailwindcss init -p

# ---- Create File Structure ----
mkdir src public back
touch tailwind.config.js postcss.config.js webpack.config.js

# ---- Create Rust Backend ----
cd back || exit
cargo init --name backend
cd .. || exit

# ---- Add Rust Dependencies ----
cat <<EOF >back/Cargo.toml
[package]
name = "backend"
version = "0.1.0"
edition = "2021"

[dependencies]
rusqlite = { version = "0.31", features = ["bundled"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
tokio = { version = "1.0", features = ["full"] }
tao = "0.26"
wry = "0.37"
EOF

# ---- Rust Database Service ----
cat <<EOF >back/src/database.rs
use rusqlite::{params, Connection, Result};
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct FileRecord {
    pub id: i32,
    pub name: String,
    pub path: String,
    pub size: Option<i32>,
    pub created_at: Option<String>,
    pub modified_at: Option<String>,
    pub is_directory: bool,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Tag {
    pub id: i32,
    pub descriptor: String,
}

pub struct DatabaseService {
    conn: Connection,
}

impl DatabaseService {
    pub fn new(db_path: &str) -> Result<Self> {
        let conn = Connection::open(db_path)?;
        Ok(DatabaseService { conn })
    }

    pub fn get_all_files(&self) -> Result<Vec<FileRecord>> {
        let mut stmt = self.conn.prepare("SELECT id, name, path, size, created_at, modified_at, is_directory FROM files")?;
        let file_iter = stmt.query_map([], |row| {
            Ok(FileRecord {
                id: row.get(0)?,
                name: row.get(1)?,
                path: row.get(2)?,
                size: row.get(3)?,
                created_at: row.get(4)?,
                modified_at: row.get(5)?,
                is_directory: row.get(6)?,
            })
        })?;

        let mut files = Vec::new();
        for file in file_iter {
            files.push(file?);
        }
        Ok(files)
    }

    pub fn get_files_by_tag(&self, tag_name: &str) -> Result<Vec<FileRecord>> {
        let mut stmt = self.conn.prepare("
            SELECT f.id, f.name, f.path, f.size, f.created_at, f.modified_at, f.is_directory
            FROM files f
            JOIN file_tags ft ON f.id = ft.file_id
            JOIN tags t ON ft.tag_id = t.id
            WHERE t.descriptor = ?
        ")?;
        
        let file_iter = stmt.query_map(params![tag_name], |row| {
            Ok(FileRecord {
                id: row.get(0)?,
                name: row.get(1)?,
                path: row.get(2)?,
                size: row.get(3)?,
                created_at: row.get(4)?,
                modified_at: row.get(5)?,
                is_directory: row.get(6)?,
            })
        })?;

        let mut files = Vec::new();
        for file in file_iter {
            files.push(file?);
        }
        Ok(files)
    }

    pub fn get_all_tags(&self) -> Result<Vec<Tag>> {
        let mut stmt = self.conn.prepare("SELECT id, descriptor FROM tags")?;
        let tag_iter = stmt.query_map([], |row| {
            Ok(Tag {
                id: row.get(0)?,
                descriptor: row.get(1)?,
            })
        })?;

        let mut tags = Vec::new();
        for tag in tag_iter {
            tags.push(tag?);
        }
        Ok(tags)
    }
}
EOF

# ---- Rust Main File ----
cat <<EOF >back/src/main.rs
mod database;

use database::DatabaseService;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let db = DatabaseService::new("../os_files.db")?;
    
    // Example usage
    let files = db.get_all_files()?;
    println!("Found {} files in database", files.len());
    
    let tags = db.get_all_tags()?;
    println!("Found {} tags in database", tags.len());
    
    Ok(())
}
EOF

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

# ---- Add "dev" script to package.json ----
jq '.scripts.dev = "webpack serve --mode development --open"' package.json >tmp/.taku/package.json
mv tmp/taku/package.json package.json

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
