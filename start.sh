#!/bin/bash
set -e

SERVER_DIR="server"
mkdir -p "$SERVER_DIR" && cd "$SERVER_DIR"

MC_VERSION="1.20.1"
FABRIC_INSTALLER_VERSION="1.0.1"

# Baixa o mrpack-install se ainda nao tiver
if [ ! -f mrpack-install ]; then
  echo "Baixando mrpack-install..."
  wget -q -O mrpack-install https://github.com/nothub/mrpack-install/releases/latest/download/mrpack-install-linux-amd64
  chmod +x mrpack-install
fi

# Instala o Fabric Server se ainda nao tiver
if [ ! -f fabric-server-launch.jar ]; then
  echo "Instalando Fabric Server ${MC_VERSION}..."
  wget -q -O fabric-installer.jar "https://maven.fabricmc.net/net/fabricmc/fabric-installer/${FABRIC_INSTALLER_VERSION}/fabric-installer-${FABRIC_INSTALLER_VERSION}.jar"
  java -jar fabric-installer.jar server -mcversion ${MC_VERSION} -downloadMinecraft
  rm fabric-installer.jar
fi

# Instala os mods do modpack se ainda nao tiver
if [ ! -d mods ] || [ -z "$(ls -A mods 2>/dev/null)" ]; then
  echo "Instalando mods do modpack..."
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
