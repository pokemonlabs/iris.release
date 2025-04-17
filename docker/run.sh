#!/bin/bash

# Determine Docker compose command format
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker-compose"
elif command -v docker &> /dev/null && docker compose version &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    echo -e "\033[1;31mError: Neither docker-compose nor docker compose command found\033[0m"
    exit 1
fi

# Download docker-compose.yaml from GitHub
curl -fsSL https://raw.githubusercontent.com/pokemonlabs/iris.release/refs/heads/main/docker/docker-compose.yaml -o docker-compose.yaml

# Verify download was successful
if [ ! -f "docker-compose.yaml" ]; then
    echo -e "\033[1;31mError: Failed to download docker-compose.yaml\033[0m"
    exit 1
fi

# Run docker compose
echo -e "\033[1;36mStarting IRIS Operator environment...\033[0m"
$DOCKER_COMPOSE_CMD up -d

echo -e "\033[1;32mIRIS Operator environment started successfully!\033[0m"

echo -e "\n\033[1;33mAccess the AI agent via VNC at port 6901\033[0m"
echo -e "\033[1;33mSend commands to the AI agent via port 8080\033[0m"
echo -e "\033[1;33mGet your API keys from: https://agent.tryiris.dev/login\033[0m\n"

# Open VNC port in default browser with OS-specific command
case "$(uname -s)" in
    Darwin*)
        echo -e "🍏 \033[1;33mOpening VNC viewer for macOS...\033[0m"
        open "http://localhost:6901"
        ;;
    Linux*)
        echo -e "🐧 \033[1;33mOpening VNC viewer for Linux...\033[0m"
        xdg-open "http://localhost:6901"
        ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
        echo -e "🪟 \033[1;33mOpening VNC viewer for Windows...\033[0m"
        start "http://localhost:6901"
        ;;
    *)
        echo -e "\033[1;33mPlease manually open http://localhost:6901 in your browser\033[0m"
        ;;
esac