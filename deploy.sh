#!/bin/bash
set -e

# 1. Deploy web
cd "$(dirname "$0")"
echo "[1/4] Deploying web..."
./deploy_web.sh

# 2. Build Flutter clients
./build_clients.sh

# 3. Build new Docker image
if [ -f server/Dockerfile ]; then
  echo "[3/4] Building Docker image..."
  docker build -f server/Dockerfile -t smartopiahub/hms-server:latest .
else
  echo "No Dockerfile found in server/. Skipping Docker build."
fi


# 4. Docker Compose Up (recreate containers with latest image)
if [ -f server/docker-compose.yaml ]; then
  echo "[4/4] Recreating Docker containers with latest image..."
  cd server
  docker-compose down
  docker-compose up -d --build
  cd ..
else
  echo "No docker-compose.yaml found. Skipping docker-compose up."
fi

echo "Deployment complete."
