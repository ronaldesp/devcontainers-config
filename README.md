# devcontainers-config

[![Build and Publish Polyglot Devcontainer](https://github.com/ronaldesp/devcontainers-config/actions/workflows/build-polyglot-devcontainer.yml/badge.svg?branch=main)](https://github.com/ronaldesp/devcontainers-config/actions/workflows/build-polyglot-devcontainer.yml)

Imagen en GHCR: `ghcr.io/ronaldesp/devcontainer-polyglot:latest` · Paquete: https://github.com/ronaldesp/devcontainers-config/pkgs/container/devcontainer-polyglot

Perfiles de Dev Containers reutilizables.

## Perfil: Polyglot Cloud POCs

Carpeta canónica:
- `./.devcontainer/polyglot/.devcontainer/devcontainer.json`

Incluye:
- Python 3.12 (default) y Python 3.13.7 (en paralelo), .NET 8, PowerShell, Terraform 1.13.3
- Azure CLI, AWS CLI, Google Cloud SDK
- Node LTS y Azure Functions Core Tools (se instala al crear el contenedor)
- Extensiones VS Code para los stacks anteriores
- Montaje del socket de Docker del host (`/var/run/docker.sock`)

Este perfil se construye y publica como imagen en GHCR:

- `ghcr.io/ronaldesp/devcontainer-polyglot:latest`

Workflow: `.github/workflows/build-polyglot-devcontainer.yml`.

### Cómo usarlo en un repo nuevo (opción recomendada)

Crea un `.devcontainer/devcontainer.json` mínimo que referencie la imagen:

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

Luego abre el repo en VS Code → “Dev Containers: Reopen in Container”.

Autenticación dentro del contenedor:
- `gh auth login`
- `az login`
- `aws configure sso` (o `aws configure`)
- `gcloud auth login`

Python 3.13 rápido:
- `use-py313` abre un shell con Python 3.13 delante en el PATH.
- `use-py313 pip3.13 install -U <paquete>` ejecuta un comando puntual con 3.13.

### Bootstrap por script

En repositorios existentes, puedes inyectar el devcontainer mínimo con el script `scripts/add-polyglot-devcontainer.sh`.
