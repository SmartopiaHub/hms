#!/bin/bash

# Script to bump patch version in both client and server pubspec.yaml files

set -e

CLIENT_PUBSPEC="client/pubspec.yaml"
SERVER_PUBSPEC="server/pubspec.yaml"

# Function to bump version
bump_version() {
  local file=$1
  
  # Extract current version
  current_version=$(grep "^version:" "$file" | sed 's/version: //' | cut -d'+' -f1)
  build_number=$(grep "^version:" "$file" | sed 's/version: //' | cut -d'+' -f2)
  
  # Split version into major.minor.patch
  IFS='.' read -r major minor patch <<< "$current_version"
  
  # Increment patch version
  patch=$((patch + 1))
  
  # New version
  new_version="$major.$minor.$patch"
  
  # Update the file
  sed -i.bak "s/^version: .*/version: $new_version+$build_number/" "$file"
  rm "$file.bak"
  
  echo "Updated $file: $current_version -> $new_version"
  echo "$new_version"
}

# Bump client version
CLIENT_VERSION=$(bump_version "$CLIENT_PUBSPEC")

# Bump server version
SERVER_VERSION=$(bump_version "$SERVER_PUBSPEC")

echo "Version bump complete!"
echo "Client: $CLIENT_VERSION"
echo "Server: $SERVER_VERSION"
