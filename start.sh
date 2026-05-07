#!/bin/bash
set -e

SERVER_DIR="server"
mkdir -p "$SERVER_DIR" && cd "$SERVER_DIR"

# Baixa o mrpack-install se ainda nao tiver
if [ ! -f mrpack-install ]; then
  echo "Baixando mrpack-install..."
  wget -q -O mrpack-install https://github.com/nothub/mrpack-install/releases/latest/download/mrpack-install-linux-amd64
  chmod +x mrpack-install
fi

# Instala o modpack do Modrinth (Into the Backrooms: Found Footage)
if [ ! -f fabric-server-launch.jar ]; then
  echo "Instalando modpack..."
  ./mrpack-install modrinth into-the-backrooms-found-footage --server-dir .
fi

echo "eula=true" > eula.txt

echo ""
echo "========================================"
echo " Into the Backrooms Server - Iniciando  "
echo "========================================"
echo " Porta: 25565                           "
echo " Va em Ports > mude para Public         "
echo "========================================"
echo ""

java -Xmx4G -Xms2G -jar fabric-server-launch.jar nogui
