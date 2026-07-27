#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

sha256sum --check profile/assets/SHA256SUMS

python3 - <<'PY'
from pathlib import Path
import struct

expected = {
    "handshake-rs-hero-v1.png": (1774, 887),
    "handshake-rs-icon-github-v1.png": (768, 768),
    "handshake-rs-icon-v1.png": (1254, 1254),
    "handshake-rs-logo-v1.png": (1983, 793),
}
assets = Path("profile/assets")

for name, dimensions in expected.items():
    path = assets / name
    with path.open("rb") as image:
        header = image.read(24)
    if len(header) != 24 or header[:8] != b"\x89PNG\r\n\x1a\n":
        raise SystemExit(f"{path}: not a valid PNG header")
    actual = struct.unpack(">II", header[16:24])
    if actual != dimensions:
        raise SystemExit(f"{path}: expected {dimensions}, found {actual}")

profile = Path("profile/README.md").read_text(encoding="utf-8")
if "./assets/handshake-rs-hero-v1.png" not in profile:
    raise SystemExit("profile/README.md does not reference the canonical hero")

asset_readme = (assets / "README.md").read_text(encoding="utf-8")
for name in expected:
    if f"`{name}`" not in asset_readme:
        raise SystemExit(f"profile/assets/README.md does not inventory {name}")

print("profile and canonical brand assets verified")
PY
