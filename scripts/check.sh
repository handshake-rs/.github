#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_root"

sha256sum --check profile/assets/SHA256SUMS

python3 - <<'PY'
from datetime import date
from pathlib import Path
import json
import re
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
inventory = json.loads(
    Path("profile/ecosystem-release-inventory.json").read_text(encoding="utf-8")
)
if inventory.get("schemaVersion") != 4:
    raise SystemExit("unsupported ecosystem release inventory schema")
snapshot = inventory.get("snapshotDate", "")
try:
    date.fromisoformat(snapshot)
except ValueError as error:
    raise SystemExit("invalid inventory snapshot date") from error
if f"Snapshot: **{snapshot}**" not in profile:
    raise SystemExit("profile and inventory snapshot dates differ")

repositories = inventory.get("repositories")
if not isinstance(repositories, list) or len(repositories) != 9:
    raise SystemExit("expected nine ecosystem repositories")
if len({item.get("repository") for item in repositories}) != len(repositories):
    raise SystemExit("duplicate repository inventory entry")
for item in repositories:
    required = {
        "repository", "codeCommit", "docsAuditCommit", "sourceVersion",
        "latestSourceTag", "releaseState",
    }
    if set(item) - (required | {"androidVersionCode", "iosBuild"}):
        raise SystemExit(f"{item.get('repository')}: unexpected inventory field")
    if required - set(item):
        raise SystemExit(f"{item.get('repository')}: missing inventory field")
    for key in ("codeCommit", "docsAuditCommit"):
        if not re.fullmatch(r"[0-9a-f]{40}", item[key]):
            raise SystemExit(f"{item['repository']}: {key} is not a full Git SHA")
    if not re.fullmatch(r"\d+\.\d+\.\d+", item["sourceVersion"]):
        raise SystemExit(f"{item['repository']}: invalid source version")
    name = item["repository"].rsplit("/", 1)[1]
    rows = [line for line in profile.splitlines() if line.startswith(f"| `{name}` |")]
    if len(rows) != 1:
        raise SystemExit(f"{name}: expected one profile inventory row")
    for value in (item["codeCommit"], item["docsAuditCommit"], item["sourceVersion"]):
        if value not in rows[0]:
            raise SystemExit(f"{name}: profile row omits {value}")

related = inventory.get("relatedProducts")
if not isinstance(related, list) or len(related) != 1:
    raise SystemExit("expected one related product")
for value in related[0].values():
    if str(value) not in profile:
        raise SystemExit(f"profile omits related-product value: {value}")

for gate_group in ("mobileProductGates", "chromiumProductGates"):
    gates = inventory.get(gate_group)
    if not isinstance(gates, dict) or not gates:
        raise SystemExit(f"{gate_group}: missing product gates")
    if not all(isinstance(value, bool) for value in gates.values()):
        raise SystemExit(f"{gate_group}: product gates must be boolean")

asset_readme = (assets / "README.md").read_text(encoding="utf-8")
for name in expected_assets:
    if f"`{name}`" not in asset_readme:
        raise SystemExit(f"asset README omits {name}")

print("profile, schema-4 inventory, product gates, and canonical assets verified")
PY
