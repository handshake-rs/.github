<p align="center">
  <img src="./assets/handshake-rs-hero-v1.png" alt="handshake-rs — a luminous decentralized network rooted in the Handshake Rust emblem" width="100%">
</p>

<h1 align="center">Handshake Rust Ecosystem</h1>

<p align="center">
  <strong>Sovereign naming. Systems-grade Rust. Infrastructure without gatekeepers.</strong>
</p>

`handshake-rs` is an independent, community-led, Rust-centered collection of
libraries, services, and applications for the Handshake ecosystem. Each
product has its own repository, version history, qualification gates, and
release boundary.
The [`ecosystem`](https://github.com/handshake-rs/ecosystem) repository
coordinates them; it is not a monorepo or an umbrella package.

## Projects

| Repository | Responsibility |
| --- | --- |
| [`hns-rs`](https://github.com/handshake-rs/hns-rs) | Canonical, runtime-independent Handshake primitives: encoding, headers, transactions, covenants, scripts, wire messages, proofs, swaps, the Denuo experimental registry, and typed relay/output/requester consent policy. |
| [`hns-node-rs`](https://github.com/handshake-rs/hns-node-rs) | Standalone Rust node runtime: chain state, authenticated storage, P2P, synchronization, mempool, mining templates, and RPC. It pins the canonical Denuo/HIP-76 types and carries a bounded live HIP-76 session; production DNS output, wallet, and market layers remain separate work. |
| [`MeshMine`](https://github.com/handshake-rs/MeshMine) | Experimental decentralized mining overlay and operator application. It consumes the standalone node through an external authority boundary rather than defining consensus or embedding the node as its protocol authority. |
| [`hns-dane-engine`](https://github.com/handshake-rs/hns-dane-engine) | Canonical DNS wire, DNSSEC, TLSA/DANE, authenticated-resolver, full-host HNS/ICANN dual-root, and typed direct-first transport/role-policy crates. |
| [`hns-dane-browser-mobile`](https://github.com/handshake-rs/hns-dane-browser-mobile) | Android/iOS shells consuming the shared DANE via ICANN DoH, namespace-decision, and transport-policy contracts; broader resolver/gateway consolidation remains tracked work. |
| [`hns-dane-browser-extension`](https://github.com/handshake-rs/hns-dane-browser-extension) | Chromium extension, PAC/proxy integration, native host, and desktop packaging consuming the same three shared policy contracts. |
| [`hns-dane-crawler`](https://github.com/handshake-rs/hns-dane-crawler) | HSD-derived namespace topology, stored DNS evidence, DANE-readiness queues, static reports, and an optional live directory. Its output is observational, not browser trust authority. |
| [`hns-dane-bootstrap-generator`](https://github.com/handshake-rs/hns-dane-bootstrap-generator) | Operator-facing web and appliance tooling that generates HNS/ICANN delegation, DNSSEC/DS, authoritative DoH, and TLSA deployment material. |
| [`ecosystem`](https://github.com/handshake-rs/ecosystem) | Source audit, architecture, cross-project reconciliation, qualification matrix, migration records, and release evidence. No product code is combined here. |

## How the pieces fit

```text
hns-rs ── exact immutable pin ──> hns-node-rs ───────> MeshMine
  canonical types/registry        runtime authority      mining application

hns-dane-engine ──────> hns-dane-browser-mobile
        └─────────────> hns-dane-browser-extension
  DNSSEC/DANE, dual-root,      platform lifecycle, UI,
  and transport policy         proxy, and packaging

hns-dane-crawler ── observed gap/handoff ──> hns-dane-bootstrap-generator
  topology and evidence                       operator-authored DNS records

ecosystem ── audits compatibility, integration, and release evidence for all
```

The authority direction is intentional. The browser-to-engine and
MeshMine-to-node boundaries are implemented at the current audited
checkpoints, and `hns-node-rs` now consumes an exact immutable `hns-rs`
revision:

- protocol numbers, canonical encodings, and the experimental registry have
  one owner in `hns-rs`;
- opaque P2P relaying is default-on with persistent opt-out; HIP-76 requester
  eligibility defaults to `Auto` with its own opt-out; and any
  plaintext DNS/network output role remains a separate explicit opt-in;
- node runtime and chain authority belong in `hns-node-rs`;
- the node's current HIP-76 boundary transports strict correlated DNS messages
  but labels returned bytes untrusted—Brontide peer authentication does not
  replace local DNSSEC, TLSA, or DANE validation;
- MeshMine consumes a coherent external-node snapshot and never becomes
  consensus authority;
- TLSA-owner derivation, DANE via ICANN DoH, dual-root namespace selection, and
  typed transport admission stay below browser UI code in
  `hns-dane-engine`; broader shared-engine consolidation remains tracked work;
- both browser products map their existing relay switch only to requester
  `Disabled`/`Auto`, use direct authoritative UDP/TCP before authenticated
  authoritative DoH and any admitted relay, and explicitly disable every
  provider/output role in their adapters;
- browser shells do not classify a hostname from an IANA suffix list. They
  resolve the complete hostname through HNS and ICANN, retain one complete
  connection/trust plan, and fail closed on bogus or indeterminate evidence;
- that shared decision reaches mobile and Chromium navigation, redirects,
  subresources, Service Workers, downloads, and WebSockets through each
  product's whole-request Rust boundary; and
- crawler reports can guide an operator into the bootstrap generator, but
  neither cached crawler data nor generated instructions can replace live
  browser DNSSEC/DANE validation.

## Source governance and releases

Canonical source and review policy live in `handshake-rs`. Release publishing
and binary signing are separate responsibilities: Denuo Web LLC may continue
to publish/sign the browser products, MeshMine, and auxiliary DANE services or
appliances without owning every source repository or receiving
organization-wide owner access. Signed artifacts must identify the exact
canonical source commit or tag.

## Maturity

This ecosystem is under active construction and is **not yet release-ready as
a whole**. Passing primitive or portable build tests does not imply full-node,
wallet, marketplace, installed-browser, signed-device, mainnet, or production
qualification. Current evidence and remaining blockers are tracked in the
[`ecosystem` qualification matrix](https://github.com/handshake-rs/ecosystem/blob/main/QUALIFICATION_MATRIX.md)
and
[`remaining gaps`](https://github.com/handshake-rs/ecosystem/blob/main/REMAINING_GAPS.md).

Some repositories do not yet have a finalized top-level license; public source
availability alone does not grant additional rights. Start with the
[`ecosystem` integration state](https://github.com/handshake-rs/ecosystem/blob/main/INTEGRATION_STATE.md)
and each repository's own README and license terms.

> This is an independent project and does not claim to be the official
> Handshake organization.

The canonical [brand assets](./assets/README.md) are maintained with this
profile.
