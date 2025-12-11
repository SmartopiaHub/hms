#!/usr/bin/env bash
set -euo pipefail

echo "🛠️  Building Flutter Web..."
cd client
flutter pub get
flutter build web --release --no-tree-shake-icons

echo "📁 Copying build to server/public..."
TARGET="../server/public"
mkdir -p "$TARGET"
rm -rf "$TARGET"/*
cp -R build/web/* "$TARGET/"

cd ..

echo "✅ Deployment complete!"