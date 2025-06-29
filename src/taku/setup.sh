#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

APP_NAME="Taku"

echo "🔧 Installing frontend dependencies..."
yarn install

echo "🛠️ Building frontend..."
yarn build

echo "📦 Building Rust backend..."
cargo build --release

# Determine real build location
TARGET_DIR=$(cargo metadata --format-version 1 --no-deps | jq -r '.target_directory')
EXECUTABLE="${TARGET_DIR}/release/taku"
FRONTEND_DIST="./frontend/dist"
APP_DIR="${TARGET_DIR}/${APP_NAME}.app"

echo "📦 Bundling into macOS .app at ${APP_DIR}..."

# Check prerequisites
if [ ! -f "$EXECUTABLE" ]; then
  echo "❌ ERROR: Compiled binary not found at $EXECUTABLE"
  exit 1
fi

if [ ! -f "$FRONTEND_DIST/index.html" ]; then
  echo "❌ ERROR: Frontend build not found at $FRONTEND_DIST"
  exit 1
fi

# Clean old bundle
rm -rf "$APP_DIR"

# Create .app structure
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Copy executable and frontend
cp "$EXECUTABLE" "$APP_DIR/Contents/MacOS/${APP_NAME}"
cp -R "$FRONTEND_DIST" "$APP_DIR/Contents/Resources/dist"

# Create Info.plist
cat >"$APP_DIR/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>${APP_NAME}</string>
  <key>CFBundleIdentifier</key>
  <string>com.example.${APP_NAME}</string>
  <key>CFBundleName</key>
  <string>${APP_NAME}</string>
  <key>CFBundleVersion</key>
  <string>0.1.0</string>
</dict>
</plist>
EOF

echo "✅ Bundle complete."
echo "💡 Opening..."
open "$APP_DIR"
echo "たく (Taku) is ready to use!"
echo "🚀 Enjoy your app!"

