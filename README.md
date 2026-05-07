# Into the Backrooms - Servidor Minecraft

Modpack: [Into the Backrooms: Found Footage Horror](https://modrinth.com/modpack/into-the-backrooms-found-footage)
- Minecraft: 1.20.1
- Loader: Fabric

## Como iniciar no GitHub Codespaces

1. Abra o repositório no GitHub e clique em **Code > Codespaces > Create codespace**
2. Espere o ambiente carregar
3. No terminal, rode:
   ```bash
   chmod +x start.sh && ./start.sh
   ```
4. Quando o servidor terminar de iniciar, vá em **Ports**
5. Na porta `25565`, mude a visibilidade para **Public**
6. Copie o endereço e conecte no Minecraft

## Salvar o progresso

```bash
cd server
git add world
git commit -m "save: checkpoint"
git push
```
