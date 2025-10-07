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
- Node LTS y Azure Functions Core Tools (preinstaladas en la imagen)
- Extensiones VS Code para los stacks anteriores
  - Incluye GitHub Copilot y Copilot Chat (requiere iniciar sesión en GitHub dentro de VS Code)
- Montaje del socket de Docker del host (`/var/run/docker.sock`)

Este perfil se construye y publica como imagen en GHCR:

- `ghcr.io/ronaldesp/devcontainer-polyglot:latest`

Workflow: `.github/workflows/build-polyglot-devcontainer.yml`.

### Variantes de Azure Functions Core Tools (tags y ejemplos)

Publicamos dos variantes según la versión de Core Tools:

- Predeterminada (estable): 4.3.0
  - Tags: `ghcr.io/ronaldesp/devcontainer-polyglot:latest` y `ghcr.io/ronaldesp/devcontainer-polyglot:coretools-4.3.0`
- Variante anterior (estable): 4.0.5455
  - Tag: `ghcr.io/ronaldesp/devcontainer-polyglot:coretools-4.0.5455`

Usa el tag que necesites en tu `devcontainer.json`.

Ejemplo usando la variante predeterminada (4.3.0):

```json
{
  "name": "Polyglot Cloud POCs",
  "image": "ghcr.io/ronaldesp/devcontainer-polyglot:latest",
  "remoteUser": "vscode"
}
```

Ejemplo fijando la variante 4.3.0 explícita:

```json
{
  "name": "Polyglot Cloud POCs",
  "image": "ghcr.io/ronaldesp/devcontainer-polyglot:coretools-4.3.0",
  "remoteUser": "vscode"
}
```

Ejemplo usando la variante anterior 4.0.5455:

```json
{
  "name": "Polyglot Cloud POCs (Core Tools 4.0.5455)",
  "image": "ghcr.io/ronaldesp/devcontainer-polyglot:coretools-4.0.5455",
  "remoteUser": "vscode"
}
```

Comprobación rápida de la versión dentro del contenedor:

```bash
func --version
```

Desde PowerShell en Windows (nota de comillas ya detallada más abajo):

```powershell
docker run --rm ghcr.io/ronaldesp/devcontainer-polyglot:coretools-4.0.5455 bash -lc 'func --version'
```

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

Nota PowerShell (Windows): para comandos con `$` dentro del contenedor (por ejemplo, PowerShell en contenedor), usa comillas simples para evitar la expansión en el host. Ejemplo:

```powershell
docker run --rm ghcr.io/ronaldesp/devcontainer-polyglot:latest pwsh -NoLogo -Command '$PSVersionTable.PSVersion'
```

### Azure Tools dentro del devcontainer

Este perfil instala el pack "Azure Tools" y extensiones relacionadas (Azure CLI, Azure Functions, Storage, etc.). Para empezar:

1) Abre la vista de Azure
  - En VS Code, lado izquierdo → icono de Azure (Azure: Resources/Explorer).
  - Si no aparece, F1 → "Azure: Open Azure View".

2) Inicia sesión y selecciona suscripción
  - Haz clic en "Sign in to Azure" desde la vista; sigue el navegador.
  - Verifica que tu suscripción esté seleccionada en la parte superior de la vista.

3) Azurite (emulador de Storage)
  - El contenedor arranca Azurite automáticamente en los puertos 10000/10001/10002.
  - Connection string de desarrollo (ya presente en `AZURE_STORAGE_CONNECTION_STRING`): `UseDevelopmentStorage=true`.
  - En la vista Azure → Storage, usa "Attach Storage Account" y elige "Use development storage (Azurite)" o pega la connection string.
  - Endpoints:
    - Blob: http://127.0.0.1:10000/devstoreaccount1
    - Queue: http://127.0.0.1:10001/devstoreaccount1
    - Table: http://127.0.0.1:10002/devstoreaccount1
    - Account: `devstoreaccount1` · Key: `Eby8vdM02xNOcqFeqCnf2U==`

4) Azure Functions (Core Tools 4.x estable)
  - **Para .NET C# isolated**: ejecuta `setup-dotnet-functions [nombre-proyecto]` para crear un proyecto preconfigurado con depuración lista.
  - **Para otros lenguajes**: F1 → "Azure Functions: Create New Project..." (elige Python/Node según tu POC).
  - Para ejecutar local: F5 o `func start` en terminal.
  - Recomendado en Python: usar 3.12 por compatibilidad de runtime; puedes cambiar a 3.13 con `use-py313` si tu POC lo permite.

5) CLI rápidas
  - `az login`, `aws configure sso` / `aws configure`, `gcloud auth login` dentro del contenedor.

#### Ejemplos mínimos de conexión a Azurite

Python (Blob Storage):

```python
from azure.storage.blob import BlobServiceClient

conn_str = "UseDevelopmentStorage=true"
service = BlobServiceClient.from_connection_string(conn_str)

container_name = "demo"
blob_name = "hello.txt"

service.create_container(container_name)
blob = service.get_blob_client(container=container_name, blob=blob_name)
blob.upload_blob(b"hola azurite", overwrite=True)
print(blob.download_blob().readall())
```

.NET (C# – Blob Storage):

```csharp
using Azure.Storage.Blobs;
using System;

var connStr = "UseDevelopmentStorage=true";
var service = new BlobServiceClient(connStr);

string containerName = "demo";
string blobName = "hello.txt";

var container = service.GetBlobContainerClient(containerName);
await container.CreateIfNotExistsAsync();

var blob = container.GetBlobClient(blobName);
await blob.UploadAsync(BinaryData.FromString("hola azurite"), overwrite: true);
var content = await blob.DownloadContentAsync();
Console.WriteLine(content.Value.Content.ToString());
```

### Bootstrap por script

En repositorios existentes, puedes inyectar el devcontainer mínimo con el script `scripts/add-polyglot-devcontainer.sh`.
