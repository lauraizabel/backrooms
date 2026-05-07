#!/bin/bash

SERVER_DIR="server"
mkdir -p "$SERVER_DIR" && cd "$SERVER_DIR"

MC_VERSION="1.20.1"
FABRIC_INSTALLER_VERSION="1.0.1"
MODRINTH_SLUG="into-the-backrooms-found-footage"

# Instala o Fabric Server se ainda nao tiver
if [ ! -f fabric-server-launch.jar ]; then
  echo "Instalando Fabric Server ${MC_VERSION}..."
  wget -q -O fabric-installer.jar "https://maven.fabricmc.net/net/fabricmc/fabric-installer/${FABRIC_INSTALLER_VERSION}/fabric-installer-${FABRIC_INSTALLER_VERSION}.jar"
  java -jar fabric-installer.jar server -mcversion ${MC_VERSION} -downloadMinecraft
  rm fabric-installer.jar
  echo "Fabric instalado!"
fi

# Baixa e instala os mods do modpack via API do Modrinth
if [ ! -d mods ] || [ -z "$(ls -A mods 2>/dev/null)" ]; then
  mkdir -p mods

  echo "Buscando versao mais recente do modpack no Modrinth..."
  VERSIONS_JSON=$(curl -s "https://api.modrinth.com/v2/project/${MODRINTH_SLUG}/version?game_versions=[\"${MC_VERSION}\"]&loaders=[\"fabric\"]")
  MRPACK_URL=$(echo "$VERSIONS_JSON" | grep -o '"url":"[^"]*\.mrpack"' | head -1 | cut -d'"' -f4)

  if [ -z "$MRPACK_URL" ]; then
    echo "Erro: nao foi possivel encontrar o modpack. Verifique o slug ou versao."
    exit 1
  fi

  echo "Baixando modpack..."
  wget -q -O modpack.mrpack "$MRPACK_URL"

  echo "Extraindo mods..."
  unzip -q modpack.mrpack -d modpack_tmp

  # Baixa cada mod listado no manifest
  echo "Baixando mods individuais..."
  TOTAL=$(python3 -c "import json; d=json.load(open('modpack_tmp/modrinth.index.json')); print(len([f for f in d['files'] if 'env' not in f or f['env'].get('server','required')!='unsupported']))")
  COUNT=0
  python3 - <<'PYEOF'
import json, urllib.request, os, sys

with open('modpack_tmp/modrinth.index.json') as f:
    index = json.load(f)

files = index['files']
total = len(files)

for i, file in enumerate(files, 1):
    env = file.get('env', {})
    if env.get('server', 'required') == 'unsupported':
        continue

    url = file['downloads'][0]
    filename = os.path.basename(file['path'])
    dest = file['path']

    os.makedirs(os.path.dirname(dest) if os.path.dirname(dest) else '.', exist_ok=True)

    print(f"[{i}/{total}] {filename}")
    try:
        urllib.request.urlretrieve(url, dest)
    except Exception as e:
        print(f"  Aviso: falhou ao baixar {filename}: {e}")

print("Mods baixados com sucesso!")
PYEOF

  # Copia overrides (configs, etc)
  if [ -d modpack_tmp/overrides ]; then
    cp -r modpack_tmp/overrides/. .
  fi

  rm -rf modpack_tmp modpack.mrpack
  echo "Modpack instalado!"
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
