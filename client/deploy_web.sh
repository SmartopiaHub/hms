#!/usr/bin/env bash
# filepath: client/deploy_web.sh

set -euo pipefail

echo "🛠️  Building Flutter Web..."
flutter pub get
flutter build web --no-tree-shake-icons --release

echo "📁 Copying build to server/public..."
# adjust the path if your server folder is elsewhere
TARGET="../server/public"
mkdir -p "$TARGET"
rm -rf "$TARGET"/*
cp -R build/web/* "$TARGET/"

echo "✅ Deployment complete!"