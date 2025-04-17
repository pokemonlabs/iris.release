#!/bin/bash
# IRIS Operator Environment Launcher
# https://github.com/pokemonlabs/iris.release
#
# This script automates the setup and launch of the IRIS Operator environment
# Usage: curl -fsSL https://raw.githubusercontent.com/pokemonlabs/iris.release/refs/heads/main/docker/run.sh | bash

# Function for colored output
log() {
  local color=$1
  local message=$2
  case $color in
    "green") echo -e "\033[0;32m$message\033[0m" ;;
    "yellow") echo -e "\033[0;33m$message\033[0m" ;;
    "blue") echo -e "\033[0;34m$message\033[0m" ;;
    "red") echo -e "\033[0;31m$message\033[0m" ;;
    *) echo "$message" ;;
  esac
}

# Print header
log "blue" "══════════════════════════════════════════════════════════"
log "blue" "          IRIS OPERATOR ENVIRONMENT LAUNCHER              "
log "blue" "══════════════════════════════════════════════════════════"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  log "red" "❌ ERROR: Docker is not installed. Please install Docker first."
  exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
  log "red" "❌ ERROR: Docker Compose is not installed. Please install Docker Compose first."
  exit 1
fi

# Print welcome message
log "blue" "🚀 Starting IRIS Operator environment..."
log "yellow" "⏳ Pulling container images and starting services. This may take a few minutes on first run."

# Verify repository URL and set base URL
REPO_URL="https://github.com/pokemonlabs/iris.release.git"
BASE_URL="https://raw.githubusercontent.com/pokemonlabs/iris.release/refs/heads/main"

# Check if docker-compose.yaml exists in current directory
if [ ! -f "docker-compose.yaml" ]; then
  log "yellow" "⏳ docker-compose.yaml not found in current directory, attempting to download..."
  
  # Verify repository exists and is accessible
  if ! curl -fsSL "$REPO_URL/info/refs?service=git-upload-pack" &> /dev/null; then
    log "red" "❌ ERROR: Unable to access repository. Please check your internet connection and repository URL."
    exit 1
  fi
  
  curl -fsSL "$BASE_URL/docker/docker-compose.yaml" -o docker-compose.yaml
  
  if [ ! -f "docker-compose.yaml" ]; then
    log "red" "❌ Failed to download docker-compose.yaml. Please download it manually from:"
    log "yellow" "   https://github.com/pokemonlabs/iris.release"
    exit 1
  else
    log "green" "✅ docker-compose.yaml downloaded successfully!"
  fi
fi

# Start the docker compose services
docker-compose up -d

if [ $? -ne 0 ]; then
  log "red" "❌ Failed to start Docker services. Please check the error messages above."
  exit 1
fi

log "green" "✅ Docker services started successfully!"
log "yellow" "⏳ Waiting for services to initialize..."

# Wait for the services to be ready
sleep 5

# Detect the user's operating system and open browser
log "blue" "🔗 Preparing to open VNC client in your default browser..."

# Open browser with VNC client URL and password parameter
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  log "yellow" "🍎 Detected macOS. Opening in default browser..."
  open "http://localhost:6901/?password=password"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux
  log "yellow" "🐧 Detected Linux. Opening in default browser..."
  if command -v xdg-open &> /dev/null; then
    xdg-open "http://localhost:6901/?password=password"
  else
    log "yellow" "⚠️  Could not open browser automatically. Please open the URL manually."
  fi
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]]; then
  # Windows
  log "yellow" "🪟 Detected Windows. Opening in default browser..."
  start "http://localhost:6901/?password=password"
else
  log "yellow" "⚠️  Could not detect your operating system."
fi

# Print final instructions
log "green" "✅ IRIS Operator environment is now running!"
log "blue" "══════════════════════════════════════════════════════════"
log "blue" "                   AVAILABLE SERVICES                     "
log "blue" "══════════════════════════════════════════════════════════"
log "blue" "📌 VNC SERVER (Agent Visualization):"
log "green" "   URL: http://localhost:6901/?password=password"
log "yellow" "   Default password: password"
log "yellow" "   Purpose: View and interact with the agent's graphical interface"
log "blue" ""
log "blue" "📌 COMMAND CENTER (Control API):"
log "green" "   URL: http://localhost:8080"
log "yellow" "   Purpose: Send commands to the agent and monitor its activities"
log "yellow" "   API endpoint to control agent behavior"
log "blue" "══════════════════════════════════════════════════════════"
log "blue" "                   USEFUL COMMANDS                        "
log "blue" "══════════════════════════════════════════════════════════"
log "yellow" "ℹ️  To stop the environment: docker-compose down"
log "yellow" "ℹ️  To view container logs: docker-compose logs"
log "yellow" "ℹ️  To restart services: docker-compose restart"

# Check if the container is actually running
if docker ps | grep -q "pokemonlabs/iris"; then
  log "green" "🟢 Container status: Running"
else
  log "red" "🔴 Container status: Not running. There might be an issue with the container startup."
  log "yellow" "⚠️  Check container logs with: docker-compose logs"
fi