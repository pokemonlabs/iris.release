#!/bin/bash

# Determine Docker compose command format
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker-compose"
elif command -v docker &> /dev/null && docker compose version &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    echo "Error: Neither docker-compose nor docker compose command found"
    exit 1
fi

# Download docker-compose.yaml from GitHub
curl -fsSL https://raw.githubusercontent.com/pokemonlabs/iris.release/refs/heads/main/docker/docker-compose.yaml -o docker-compose.yaml

# Verify download was successful
if [ ! -f "docker-compose.yaml" ]; then
    echo "Error: Failed to download docker-compose.yaml"
    exit 1
fi

# Run docker compose
echo "Starting IRIS Operator environment..."
$DOCKER_COMPOSE_CMD up -d

echo "IRIS Operator environment started successfully!"