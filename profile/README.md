<p align="center">
  <img src="./assets/handshake-rs-hero-v1.png" alt="handshake-rs — a luminous decentralized network rooted in the Handshake Rust emblem" width="100%">
</p>

<h1 align="center">Handshake Rust Ecosystem</h1>

<p align="center">
  <strong>Sovereign naming. Systems-grade Rust. Infrastructure without gatekeepers.</strong>
</p>

`handshake-rs` is an independent, community-led collection of Rust libraries,
services, and applications for the Handshake ecosystem. Each product has its
own repository, version history, qualification gates, and release boundary.
The [`ecosystem`](https://github.com/handshake-rs/ecosystem) repository
coordinates them; it is not a monorepo or an umbrella package.

## Projects

| Repository | Responsibility |
| --- | --- |
| [`hns-rs`](https://github.com/handshake-rs/hns-rs) | Canonical, runtime-independent Handshake primitives: encoding, headers, transactions, covenants, scripts, wire messages, proofs, swaps, the Denuo experimental registry, and typed relay/output/requester consent policy. |
| [`hns-node-rs`](https://github.com/handshake-rs/hns-node-rs) | Standalone Rust node runtime: chain state, authenticated storage, P2P, synchronization, mempool, mining templates, and RPC. Wallet and market layers remain planned work. |
| [`MeshMine`](https://github.com/handshake-rs/MeshMine) | Experimental decentralized mining overlay and operator application. It consumes the standalone node through an external authority boundary rather than defining consensus or embedding the node as its protocol authority. |
| [`hns-dane-engine`](https://github.com/handshake-rs/hns-dane-engine) | Canonical DNS wire, DNSSEC, TLSA/DANE, authenticated-resolver, browser-policy, and full-host HNS/ICANN dual-root crates. |
| [`hns-dane-browser-mobile`](https://github.com/handshake-rs/hns-dane-browser-mobile) | Android/iOS shells consuming the shared DANE via ICANN DoH and namespace-decision crates; broader resolver/gateway consolidation remains tracked work. |
| [`hns-dane-browser-extension`](https://github.com/handshake-rs/hns-dane-browser-extension) | Chromium extension, PAC/proxy integration, and native host consuming the same shared policy crates. |
| [`ecosystem`](https://github.com/handshake-rs/ecosystem) | Source audit, architecture, cross-project reconciliation, qualification matrix, migration records, and release evidence. No product code is combined here. |

## How the pieces fit

```text
hns-rs ── next integration ──> hns-node-rs ─────────> MeshMine
  canonical types/registry      runtime authority       mining application

hns-dane-engine ──────> hns-dane-browser-mobile
        └─────────────> hns-dane-browser-extension
  DNSSEC/DANE and          platform lifecycle, UI,
  dual-root policy         proxy, and packaging

ecosystem ── audits compatibility, integration, and release evidence for all
```

The authority direction is intentional. The browser-to-engine and
MeshMine-to-node boundaries are implemented at the current audited
checkpoints; adoption of `hns-rs` by `hns-node-rs` is the next identified
integration milestone:

- protocol numbers, canonical encodings, and the experimental registry have
  one owner in `hns-rs`;
- opaque P2P relaying is default-on with persistent opt-out, while requester
  and output-node authority are separate explicit opt-ins;
- node runtime and chain authority belong in `hns-node-rs`;
- MeshMine consumes a coherent external-node snapshot and never becomes
  consensus authority;
- TLSA-owner derivation, DANE via ICANN DoH, and dual-root namespace selection
  stay below browser UI code in `hns-dane-engine`; broader shared-engine
  consolidation remains tracked work; and
- browser shells do not classify a hostname from an IANA suffix list. They
  resolve the complete hostname through HNS and ICANN, retain one complete
  connection/trust plan, and fail closed on bogus or indeterminate evidence.

## Source governance and releases

Canonical source and review policy live in `handshake-rs`. Release publishing
and binary signing are separate responsibilities: Denuo Web LLC may continue
to publish/sign the browser products and MeshMine without owning every source
repository or receiving organization-wide owner access. Signed artifacts must
identify the exact canonical source commit or tag.

## Maturity

This ecosystem is under active construction and is **not yet release-ready as
a whole**. Passing primitive or portable build tests does not imply full-node,
wallet, marketplace, installed-browser, signed-device, mainnet, or production
qualification. Current evidence and remaining blockers are tracked in the
[`ecosystem` qualification matrix](https://github.com/handshake-rs/ecosystem/blob/main/integration/QUALIFICATION_MATRIX.md)
and
[`remaining gaps`](https://github.com/handshake-rs/ecosystem/blob/main/integration/REMAINING_GAPS.md).

Some repositories do not yet have a finalized top-level license; public source
availability alone does not grant additional rights. Start with the
[`ecosystem` integration state](https://github.com/handshake-rs/ecosystem/blob/main/integration/INTEGRATION_STATE.md)
and each repository's own README and license terms.

> This is an independent project and does not claim to be the official
> Handshake organization.

The canonical [brand assets](./assets/README.md) are maintained with this
profile.
