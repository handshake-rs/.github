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

inventory_path = Path("profile/ecosystem-release-inventory.json")
inventory = json.loads(inventory_path.read_text(encoding="utf-8"))
expected_inventory_keys = {
    "schemaVersion",
    "snapshotDate",
    "repositories",
    "localComponents",
    "relatedProducts",
    "mobileProductGates",
    "chromiumProductGates",
}
if set(inventory) != expected_inventory_keys:
    raise SystemExit("ecosystem release inventory top-level schema differs")
if inventory.get("schemaVersion") != 3:
    raise SystemExit("unsupported ecosystem release inventory schema")
snapshot_date = inventory.get("snapshotDate", "")
if not re.fullmatch(r"\d{4}-\d{2}-\d{2}", snapshot_date):
    raise SystemExit("ecosystem release inventory has an invalid snapshot date")
try:
    date.fromisoformat(snapshot_date)
except ValueError as error:
    raise SystemExit("ecosystem release inventory date does not exist") from error
if f"Snapshot: **{snapshot_date}**" not in profile:
    raise SystemExit("profile README and release inventory snapshot dates differ")

expected_repositories = {
    "handshake-rs/hns-rs",
    "handshake-rs/hns-wallet-rs",
    "handshake-rs/hns-node-rs",
    "handshake-rs/MeshMine",
    "handshake-rs/hns-dane-engine",
    "handshake-rs/hns-dane-browser-mobile",
    "handshake-rs/hns-dane-browser-extension",
    "handshake-rs/hns-dane-crawler",
    "handshake-rs/hns-dane-bootstrap-generator",
}
repositories = inventory.get("repositories")
if not isinstance(repositories, list):
    raise SystemExit("ecosystem release inventory repositories must be a list")
actual_repositories = {item.get("repository") for item in repositories}
if (
    actual_repositories != expected_repositories
    or len(repositories) != len(expected_repositories)
):
    raise SystemExit(
        "ecosystem release inventory repository set differs from the profile"
    )

for item in repositories:
    required_keys = {
        "repository",
        "mainCommit",
        "qualificationCommit",
        "sourceVersion",
        "candidateTag",
        "candidateTagPresent",
        "currentVersionPublished",
        "latestGithubRelease",
    }
    missing_keys = required_keys - set(item)
    if missing_keys:
        raise SystemExit(f"repository inventory entry lacks keys: {sorted(missing_keys)}")
    repository = item["repository"]
    commit = item.get("mainCommit", "")
    version = item.get("sourceVersion", "")
    if not re.fullmatch(r"[0-9a-f]{40}", commit):
        raise SystemExit(f"{repository}: mainCommit is not a full Git SHA")
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        raise SystemExit(f"{repository}: sourceVersion is not semantic versioning")
    candidate_tag = item.get("candidateTag")
    candidate_tag_present = item.get("candidateTagPresent")
    expected_candidate_tag = (
        None if repository == "handshake-rs/MeshMine" else f"v{version}"
    )
    expected_tag_presence = None if expected_candidate_tag is None else False
    if candidate_tag != expected_candidate_tag:
        raise SystemExit(f"{repository}: candidate tag differs from its release boundary")
    if candidate_tag_present is not expected_tag_presence:
        raise SystemExit(f"{repository}: candidate tag presence is inconsistent")
    if item.get("currentVersionPublished") is not False:
        raise SystemExit(f"{repository}: this snapshot must remain pre-publication")
    recovery_eligible = item.get("recoveryCandidateProductionEligible")
    if repository == "handshake-rs/hns-node-rs":
        if recovery_eligible is not False:
            raise SystemExit("node recovery candidate must remain non-production")
    elif recovery_eligible is not None:
        raise SystemExit(
            f"{repository}: unexpected recoveryCandidateProductionEligible"
        )
    component_tag = item.get("latestComponentTag")
    if repository == "handshake-rs/hns-dane-engine":
        if component_tag != "hns-browser-observability-v0.1.1":
            raise SystemExit("engine component tag differs from the reviewed state")
        if component_tag not in profile:
            raise SystemExit("engine component tag is absent from README")
    elif component_tag is not None:
        raise SystemExit(f"{repository}: unexpected latestComponentTag")
    repository_name = repository.rsplit("/", 1)[1]
    rows = [
        line
        for line in profile.splitlines()
        if line.startswith(f"| `{repository_name}` |")
    ]
    if len(rows) != 1:
        raise SystemExit(f"{repository}: expected exactly one README inventory row")
    if commit not in rows[0]:
        raise SystemExit(f"{repository}: exact inventory commit is absent from its row")
    if f"`{version}`" not in rows[0]:
        raise SystemExit(f"{repository}: source version is absent from its row")

    qualification_commit = item["qualificationCommit"]
    if qualification_commit is not None:
        if not re.fullmatch(r"[0-9a-f]{40}", qualification_commit):
            raise SystemExit(
                f"{repository}: qualificationCommit is neither null nor a full Git SHA"
            )
        if qualification_commit != commit:
            raise SystemExit(
                f"{repository}: qualificationCommit must identify exact current main"
            )
        if qualification_commit not in profile:
            raise SystemExit(
                f"{repository}: qualificationCommit is absent from README evidence"
            )

    artifact_key = "artifactCommit"
    installed_evidence_key = "installedEvidenceCommit"
    if repository in {
        "handshake-rs/hns-dane-browser-mobile",
        "handshake-rs/hns-dane-browser-extension",
    }:
        missing_browser_keys = {artifact_key, installed_evidence_key} - set(item)
        if missing_browser_keys:
            raise SystemExit(
                f"{repository}: browser evidence keys are missing: "
                f"{sorted(missing_browser_keys)}"
            )
        artifact_commit = item[artifact_key]
        if not re.fullmatch(r"[0-9a-f]{40}", artifact_commit):
            raise SystemExit(f"{repository}: artifactCommit is not a full Git SHA")
        if artifact_commit not in profile:
            raise SystemExit(f"{repository}: artifactCommit is absent from README")
        evidence_commit = item[installed_evidence_key]
        if evidence_commit is None:
            raise SystemExit(
                f"{repository}: this snapshot requires exact installed evidence"
            )
        if not re.fullmatch(r"[0-9a-f]{40}", evidence_commit):
            raise SystemExit(
                f"{repository}: installedEvidenceCommit is not a full Git SHA"
            )
        if evidence_commit != artifact_commit:
            raise SystemExit(
                f"{repository}: installed evidence must identify exact artifact source"
            )
        if evidence_commit not in profile:
            raise SystemExit(
                f"{repository}: installedEvidenceCommit is absent from README evidence"
            )
    elif {artifact_key, installed_evidence_key} & set(item):
        raise SystemExit(f"{repository}: unexpected browser evidence fields")

local_components = inventory.get("localComponents")
expected_local_components = [
    {
        "name": "freeDomains",
        "sourceVersion": "0.1.0",
        "sourceControl": "none",
        "private": True,
        "releaseCandidate": False,
        "publishable": False,
        "liveConfigurationReleaseArtifact": False,
        "liveDatabaseReleaseArtifact": False,
    }
]
if local_components != expected_local_components:
    raise SystemExit("local private component boundary differs")
for value in ("freeDomains", "0.1.0", "non-Git"):
    if value not in profile:
        raise SystemExit(f"local private component value is absent from README: {value}")

related_products = inventory.get("relatedProducts")
if not isinstance(related_products, list) or len(related_products) != 1:
    raise SystemExit("release inventory must contain one related product boundary")
namehold = related_products[0]
expected_namehold_keys = {
    "repository",
    "mainCommit",
    "qualificationCommit",
    "sourceVersion",
    "releaseAuthorityRepository",
    "latestPublicRelease",
    "nextVersionSelected",
    "mirrorReleaseAuthorized",
}
if set(namehold) != expected_namehold_keys:
    raise SystemExit("Namehold release inventory schema differs")
if namehold["repository"] != "denuoweb/namehold-wallet":
    raise SystemExit("Namehold mirror repository differs")
if not re.fullmatch(r"[0-9a-f]{40}", namehold["mainCommit"]):
    raise SystemExit("Namehold mainCommit is not a full Git SHA")
qualification_commit = namehold["qualificationCommit"]
if qualification_commit is not None and not re.fullmatch(
    r"[0-9a-f]{40}", qualification_commit
):
    raise SystemExit("Namehold qualificationCommit is neither null nor a full Git SHA")
if not re.fullmatch(r"\d+\.\d+\.\d+", namehold["sourceVersion"]):
    raise SystemExit("Namehold sourceVersion is not semantic versioning")
if namehold["releaseAuthorityRepository"] != "DimazzzZ/namehold-wallet":
    raise SystemExit("Namehold updater release authority differs")
if namehold["latestPublicRelease"] != f"v{namehold['sourceVersion']}":
    raise SystemExit("Namehold public release and source version differ")
if namehold["nextVersionSelected"] is not False:
    raise SystemExit("Namehold next version must remain unselected")
if namehold["mirrorReleaseAuthorized"] is not False:
    raise SystemExit("Namehold mirror release must remain unauthorized")
for value in (
    namehold["mainCommit"],
    namehold["sourceVersion"],
    namehold["releaseAuthorityRepository"],
    namehold["latestPublicRelease"],
):
    if value not in profile:
        raise SystemExit(f"Namehold inventory value is absent from README: {value}")
if qualification_commit is not None and qualification_commit not in profile:
    raise SystemExit("Namehold qualification commit is absent from README")

mobile_gates = inventory.get("mobileProductGates", {})
expected_mobile_gates = {
    "nativeWalletLifecycle": True,
    "visibleFailClosedWalletReadProjection": True,
    "scopedWalletReadCredential": False,
    "indexedWalletReadBackend": False,
    "walletReadDataAvailable": False,
    "balanceAvailable": False,
    "receiveTargetAvailable": False,
    "transactionHistoryAvailable": False,
    "trackedNamesAvailable": False,
    "walletModuleStatusAvailable": False,
    "sendValueControl": False,
    "nameManagement": False,
    "websiteProvider": False,
    "valueSettlement": False,
    "hip76P2pDnsRelayRequester": True,
    "p2pMarketplace": False,
    "hnsaServiceRole": False,
    "hnsrServiceRole": False,
}
if mobile_gates != expected_mobile_gates:
    raise SystemExit("mobile product gates differ from the reviewed schema-3 boundary")

chromium_gates = inventory.get("chromiumProductGates", {})
expected_chromium_gates = {
    "websiteProvider": False,
    "walletAuthority": False,
    "valueSettlement": False,
    "p2pMarketplace": False,
    "hnsaServiceRole": False,
    "hnsrServiceRole": False,
    "meshmineFeedVerified": False,
}
if chromium_gates != expected_chromium_gates:
    raise SystemExit("Chromium product gates differ from the reviewed schema-3 boundary")

legacy_markers = (
    "504d3fed035feb8a637ca09c4e0816b6e1144622",
    "7f7bb8fa100c2393f2cd5a64c64bf5e20a0f3ab5",
    "@emnapi/runtime@1.11.3",
    "WAITING_FOR_REVIEW",
)
for marker in legacy_markers:
    if marker in profile:
        raise SystemExit(f"profile README retains legacy marker: {marker}")

asset_readme = (assets / "README.md").read_text(encoding="utf-8")
for name in expected:
    if f"`{name}`" not in asset_readme:
        raise SystemExit(f"profile/assets/README.md does not inventory {name}")

print("profile, release inventory, product gates, and canonical assets verified")
PY
