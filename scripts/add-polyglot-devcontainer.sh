#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR=${1:-".devcontainer"}
mkdir -p "$TARGET_DIR"

cat > "$TARGET_DIR/devcontainer.json" <<'JSON'
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
JSON

echo "Created $TARGET_DIR/devcontainer.json"
