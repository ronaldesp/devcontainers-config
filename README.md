# Dev Containers Config (Polyglot)

Este repositorio contiene el perfil canónico de Dev Container "Polyglot Cloud POCs" y el pipeline para publicarlo como imagen preconstruida en GHCR.

## Objetivo

Proveer un entorno reproducible y listo para pruebas de concepto multi‑cloud con:
- Python 3.12, .NET 8, PowerShell, Terraform 1.9
- Azure CLI, AWS CLI, Google Cloud SDK
- Node LTS y Azure Functions Core Tools v4

## Usar la imagen preconstruida (recomendado)

En tu nuevo repositorio, crea `.devcontainer/devcontainer.json` con:

```json
{
  "name": "Polyglot Cloud POCs",
  "image": "ghcr.io/ronaldesp/devcontainer-polyglot:latest",
  "customizations": {
    "vscode": {
      "settings": {
        "files.eol": "\n",
        "editor.wordWrap": "on"
      }
    }
  },
  "remoteUser": "vscode"
}
```

Abre el repo en VS Code → "Dev Containers: Reopen in Container".

Autentícate según necesidad:
- `gh auth login`
- `az login`
- `aws configure sso` o `aws configure`
- `gcloud auth login` y `gcloud auth application-default login` cuando aplique

Notas:
- La imagen se publica en `ghcr.io/ronaldesp/devcontainer-polyglot:latest` tras un push/merge a `main` que toque `.devcontainer/polyglot/`.
- Evita incluir secretos en imágenes o configuraciones; usa logins interactivos.

## Opción: copiar el perfil completo (bootstrap)

Para repos existentes donde prefieras copiar la carpeta completa:

```bash
curl -fsSL https://raw.githubusercontent.com/ronaldesp/devcontainers-config/main/scripts/add-polyglot-devcontainer.sh | bash
```

El script creará/actualizará `.devcontainer/` con el perfil canónico desde este repo. Revisa cambios, haz commit y abre en contenedor.

## Desarrollo del perfil

- El origen de la verdad está en `./.devcontainer/polyglot/`.
- Al modificar ese directorio, el workflow `Build and Publish Polyglot DevContainer` construye y publica la imagen a GHCR.
- Mantén versiones fijas en `features` para reproducibilidad.

## Resolución de problemas

- Asegúrate de tener Docker Desktop activo (si ejecutas en Windows con WSL2) o un Docker daemon disponible.
- Si la instalación de Azure Functions Core Tools tarda en la primera apertura, es normal (se instala vía npm durante `postCreateCommand`).
- Si necesitas que venga preinstalado en la imagen, abre un PR agregando un `Dockerfile` en el perfil y moviendo la instalación de `func` a `RUN npm i -g azure-functions-core-tools@4`.
