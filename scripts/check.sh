#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

sha256sum --check profile/assets/SHA256SUMS

python3 - <<'PY'
from pathlib import Path
import struct

expected_assets = {
    "handshake-rs-hero-v1.png": (1774, 887),
    "handshake-rs-icon-github-v1.png": (768, 768),
    "handshake-rs-icon-v1.png": (1254, 1254),
    "handshake-rs-logo-v1.png": (1983, 793),
}
assets = Path("profile/assets")
for name, dimensions in expected_assets.items():
    with (assets / name).open("rb") as image:
        header = image.read(24)
    if len(header) != 24 or header[:8] != b"\x89PNG\r\n\x1a\n":
        raise SystemExit(f"{name}: invalid PNG header")
    if struct.unpack(">II", header[16:24]) != dimensions:
        raise SystemExit(f"{name}: dimensions differ from the canonical asset")

profile = Path("profile/README.md").read_text(encoding="utf-8")
for repository in (
    "hns-rs", "hns-node-rs", "hns-wallet-rs", "hns-dane-engine",
    "hns-dane-browser-mobile", "hns-dane-browser-extension", "MeshMine",
    "hns-dane-crawler", "hns-dane-bootstrap-generator", "ecosystem",
):
    if f"https://github.com/handshake-rs/{repository})" not in profile:
        raise SystemExit(f"profile omits project link: {repository}")

asset_readme = (assets / "README.md").read_text(encoding="utf-8")
for name in expected_assets:
    if f"`{name}`" not in asset_readme:
        raise SystemExit(f"asset README omits {name}")

print("profile project links and canonical assets verified")
PY
