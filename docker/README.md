# IRIS Operator Environment

Quick setup for the IRIS Operator environment using Docker.

## One-Line Installation & Launch

Run this command to download and execute the setup script:

```bash
curl -fsSL https://raw.githubusercontent.com/pokemonlabs/iris.release/refs/heads/main/docker/run.sh | bash
```

Or with wget:

```bash
wget -qO- https://raw.githubusercontent.com/pokemonlabs/iris.release/refs/heads/main/docker/run.sh | bash
```

Or directly run:

```bash
curl -fsSL https://raw.githubusercontent.com/pokemonlabs/iris.release/refs/heads/main/docker/docker-compose.yaml -o docker-compose.yaml && docker-compose up -d
```

## Manual Setup

If you prefer to download the script first:

1. Clone the repository:
   ```bash
   git clone https://github.com/shanurcsenitap/iris-operator.git
   ```

2. Navigate to the docker directory:
   ```bash
   cd iris-operator/docker
   ```

3. Run the script:
   ```bash
   chmod +x run.sh
   ./run.sh
   ```

## Services

After running the script, you'll have access to:

- **VNC Server (Agent Visualization)**: http://localhost:6901/?password=password
- **Command Center (Control API)**: http://localhost:8080

Default VNC password: `password`

## Requirements

- Docker
- Docker Compose

## Troubleshooting

If you encounter issues:

```bash
# View logs
docker-compose logs

# Restart the environment
docker-compose restart

# Stop the environment
docker-compose down
```