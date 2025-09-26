#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/ronaldesp/devcontainers-config.git"
SRC_PATH=".devcontainer/polyglot"
DEST_PATH=".devcontainer"

# Requisitos
command -v git >/dev/null 2>&1 || { echo "[ERROR] git no está instalado"; exit 1; }

# Carpeta temporal
TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

echo "Clonando perfil canónico desde $REPO_URL..."
git clone --depth 1 "$REPO_URL" "$TMPDIR/src" >/dev/null

mkdir -p "$DEST_PATH"
rsync -a --delete "$TMPDIR/src/$SRC_PATH/" "$DEST_PATH/"

echo "Perfil copiado a $DEST_PATH." 

# Asegura ignores útiles
GITIGNORE=".gitignore"
ensure_ignore() {
  local pattern="$1"
  if [ -f "$GITIGNORE" ]; then
    if ! grep -qE "^${pattern//\*/\\*}$" "$GITIGNORE"; then
      echo "$pattern" >> "$GITIGNORE"
    fi
  else
    echo "$pattern" > "$GITIGNORE"
  fi
}

ensure_ignore ".devcontainer/*.local*.json"
ensure_ignore ".devcontainer/*.env"

echo "Listo. Recomendado: abre VS Code y usa 'Dev Containers: Reopen in Container'."
echo "Recuerda autenticarte: az login / aws configure sso / gcloud auth login / gh auth login"