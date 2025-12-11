#!/bin/bash
# Build Flutter clients for Android, macOS, and Windows, and copy them to server/data/clients
# Usage: ./build_clients.sh

set -e

ROOT_DIR="$(pwd)"

CLIENT_DIR="client"
OUTPUT_DIR="server/data/clients"
PUBSPEC="$CLIENT_DIR/pubspec.yaml"

# Get version from pubspec.yaml
VERSION=$(grep "^version:" "$PUBSPEC" | sed 's/version: //' | cut -d'+' -f1)

mkdir -p "$OUTPUT_DIR"

cd "$CLIENT_DIR"

# Build macOS app (DMG)
echo "Building macOS app..."
MACOS_APP_PATH="build/macos/Build/Products/Release/client.app"
rm -rf "$MACOS_APP_PATH"
mkdir -p "build/macos/Build/Products/Release/Client"
rm -rf "build/macos/Build/Products/Release/Client/*"
[ -e "build/macos/Build/Products/Release/Client/Applications" ] && rm -rf "build/macos/Build/Products/Release/Client/Applications"
flutter build macos --release
cp -Rf "$MACOS_APP_PATH" "build/macos/Build/Products/Release/Client/Smartopia Learning.app"
cd "build/macos/Build/Products/Release/Client"

ln -s /Applications Applications
cd "$ROOT_DIR"
cd "$CLIENT_DIR"
DMG_OUT="../$OUTPUT_DIR/smartopia_learning_macos_${VERSION}.dmg"
hdiutil create -volname "Smartopia Learning" -srcfolder "build/macos/Build/Products/Release/Client" -ov -format UDZO "$DMG_OUT"
cp "$DMG_OUT" "../$OUTPUT_DIR/smartopia_learning_macos_latest.dmg"

# Build Android APK
#echo "Building Android APK..."
#flutter build apk --release
#APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
#APK_OUT="../$OUTPUT_DIR/smartopia_learning_android_${VERSION}.apk"
#cp "$APK_PATH" "$APK_OUT"
#cp "$APK_PATH" "../$OUTPUT_DIR/smartopia_learning_android_latest.apk"


cd ..
echo "Builds copied to $OUTPUT_DIR"
echo "Done!"