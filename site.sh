#!/usr/bin/env bash
set -euo pipefail
site_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd -- "$site_root"
export XDG_CACHE_HOME="$site_root/.local/cache"
export XDG_CONFIG_HOME="$site_root/.local/config"
export XDG_DATA_HOME="$site_root/.local/share"
export XDG_STATE_HOME="$site_root/.local/state"
export TMPDIR="$site_root/.local/tmp"
export TMP="$TMPDIR"
export TEMP="$TMPDIR"
export PYTHONPYCACHEPREFIX="$site_root/.local/cache/pycache"
export PYTHONNOUSERSITE=1
export PIP_CONFIG_FILE=/dev/null
export PIP_NO_CACHE_DIR=1
export PIP_DISABLE_PIP_VERSION_CHECK=1
mkdir -p -- "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$TMPDIR"
if [[ "${1:-}" == "setup" ]]; then
    shift
    python3 -B - <<'BOOTSTRAP'
from pathlib import Path
import os
import subprocess
import urllib.request
import venv

root = Path.cwd()
venv_dir = root / ".venv"
if not venv_dir.exists():
    venv.EnvBuilder(with_pip=False, symlinks=False).create(venv_dir)
python = str(venv_dir / "bin" / "python")
probe = subprocess.run([python, "-m", "pip", "--version"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
if probe.returncode:
    bootstrap = root / ".local" / "tmp" / "get-pip.py"
    try:
        with urllib.request.urlopen("https://bootstrap.pypa.io/get-pip.py", timeout=60) as response:
            bootstrap.write_bytes(response.read())
        subprocess.run([python, str(bootstrap), "--no-cache-dir", "--only-binary=:all:", "pip"], check=True)
    finally:
        bootstrap.unlink(missing_ok=True)
BOOTSTRAP
    exec "$site_root/.venv/bin/python" -m pip install --only-binary=:all: -r "$site_root/requirements.txt" "$@"
fi
if [[ "${1:-}" == "install" ]]; then
    shift
    exec "$site_root/.venv/bin/python" -m pip install --only-binary=:all: -r "$site_root/requirements.txt" "$@"
fi
exec "$site_root/.venv/bin/zensical" "$@"
