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
| [`hns-node-rs`](https://github.com/handshake-rs/hns-node-rs) | Standalone Rust node runtime: chain state, authenticated storage, P2P, synchronization, mempool, mining templates, and RPC. Functional consensus readiness is complete; the base snapshot starts at `pre-authority`, live native RPC reports a mode-specific release stage, and mainnet authority remains conditional on the synchronized durable canary. It pins the canonical Denuo/HIP-76 types and carries a bounded live HIP-76 session; production DNS output, wallet, and market layers remain separate work. |
| [`MeshMine`](https://github.com/handshake-rs/MeshMine) | Experimental decentralized mining overlay and operator application. It consumes exact node revision `504d3fed035feb8a637ca09c4e0816b6e1144622` through an external authority boundary rather than defining consensus or embedding the node as its protocol authority; that pin predates the standalone Denuo/HIP-76 session. |
| [`hns-dane-engine`](https://github.com/handshake-rs/hns-dane-engine) | Canonical DNS wire, DNSSEC, TLSA/DANE, authenticated resolution, full-host HNS/ICANN dual-root policy, direct-first transport/role policy, separately consented terminal recursive-HNS-DoH recovery, browser authority lifecycle, and security observability crates. |
| [`hns-dane-browser-mobile`](https://github.com/handshake-rs/hns-dane-browser-mobile) | Android/iOS shells consuming the engine's ICANN DANE, namespace, transport-policy, authority-runtime, and observability contracts while retaining platform lifecycle, staged header maintenance, UI, proxy, store, and packaging ownership. |
| [`hns-dane-browser-extension`](https://github.com/handshake-rs/hns-dane-browser-extension) | Chromium extension, PAC/proxy integration, native host, staged header maintenance, and cross-platform Setup packaging consuming the same five canonical engine contracts. |
| [`hns-dane-crawler`](https://github.com/handshake-rs/hns-dane-crawler) | HSD-derived namespace topology, stored DNS evidence, DANE-readiness queues, nameserver-handoff cohorts and preflights, static reports, and an optional live directory. Its output is observational, not browser trust authority. |
| [`hns-dane-bootstrap-generator`](https://github.com/handshake-rs/hns-dane-bootstrap-generator) | Operator-facing web and appliance tooling that generates HNS/ICANN delegation, DNSSEC/DS, authoritative DoH, and TLSA deployment material. |
| [`ecosystem`](https://github.com/handshake-rs/ecosystem) | Source audit, architecture, cross-project reconciliation, qualification matrix, migration records, and release evidence. No product code is combined here. |

## How the pieces fit

```text
hns-rs ─┬─ exact immutable pin ──> hns-node-rs ───────> MeshMine
        │                           runtime authority      mining application
        └─ exact immutable pin ──> hns-dane-engine
  canonical types/registry        DNSSEC/DANE, dual-root,
                                  transport policy, authority
                                  lifecycle, and observability
                                           ├──────────> hns-dane-browser-mobile
                                           └──────────> hns-dane-browser-extension
                                             platform lifecycle, UI,
                                             proxy, and packaging

hns-dane-crawler ── observed gap/handoff ──> hns-dane-bootstrap-generator
  topology and evidence                       operator-authored DNS records

ecosystem ── audits compatibility, integration, and release evidence for all
```

The authority direction is intentional. The browser-to-engine and
MeshMine-to-node boundaries are implemented at the current audited
checkpoints, and both `hns-node-rs` and `hns-dane-engine` consume exact
immutable `hns-rs` revisions:

- protocol numbers, canonical encodings, and the experimental registry have
  one owner in `hns-rs`;
- in the generic node/runtime policy, opaque P2P relaying is default-on with
  an opt-out, HIP-76 requester eligibility defaults to `Auto` with its own
  opt-out, and every plaintext DNS/network output role remains a separate
  explicit opt-in. Durable persistence of those choices is still a
  platform/release gate;
- node runtime and chain authority belong in `hns-node-rs`;
- the node's functional readiness fields are all true. Its base snapshot uses
  `pre-authority`, while live native RPC reports `native-sync-live-p2p`,
  `mining-engine-observe`, or `mainnet-canary-gated` according to
  configuration; none of those diagnostic stages grants a private mining
  capability unless the explicit canary, synchronized active state, and
  coherent durable authoritative tip all pass;
- the node's current HIP-76 boundary transports strict correlated DNS messages
  but labels returned bytes untrusted—Brontide peer authentication does not
  replace local DNSSEC, TLSA, or DANE validation;
- MeshMine consumes a coherent external-node snapshot and never becomes
  consensus authority. Its current immutable node pin includes complete
  functional readiness but not the later Denuo/HIP-76 session;
- TLSA-owner derivation, DANE via ICANN DoH, dual-root namespace selection,
  typed transport admission, the authority state graph, runtime session and
  generation/event admission, and schema-v2 security status stay below browser
  UI code in `hns-dane-engine`; its complete Cargo graph builds from a
  standalone checkout without an adjacent `hns-rs` tree;
- both browser products intentionally start their persisted P2P requester
  switch false/off and require explicit user opt-in; false maps to `Disabled`,
  true maps to direct-first `Auto`, their P2P `VERSION` service mask remains
  zero, and every provider/output role remains disabled;
- recursive HNS DoH recovery is a separate setting and consent boundary in
  each browser. Its endpoint is blank/off by default and is terminal only
  after eligible failures exhaust direct authoritative DNS, proof-anchored
  owner authoritative DoH, and any opted-in requester-only P2P relay. Returned
  DNS bytes remain untrusted until local HNS proof, DNSSEC, TLSA, and DANE
  validation succeeds;
- each portable browser adapter binds one checked nonzero runtime session to
  the active proxy generation. Shared admission/publication tests reject stale
  requests, responses, and trusted status after policy change, degradation,
  revocation, or restart; the installed per-class matrix remains open;
- browser header maintenance stages network work and candidate state away from
  the live request path, revalidates its starting generation and tip, then
  publishes headers, peers, readiness, and maintenance epoch atomically. This
  keeps the active proxy available during staging while making older
  navigation receipts and late publications explicitly stale;
- browser shells do not classify a hostname from an IANA suffix list. They
  resolve the complete hostname through HNS and ICANN, retain one complete
  connection/trust plan, and fail closed on bogus or indeterminate evidence;
- each product's portable whole-request Rust boundary requires and tests that
  shared decision for navigation, redirects, subresources, Service Workers,
  downloads, and WebSockets; and
- crawler reports can guide an operator into the bootstrap generator, but
  neither cached crawler data nor generated instructions can replace live
  browser DNSSEC/DANE validation.

Platform proxy/resolver implementation consolidation and installed-browser or
signed-device qualification remain open; portable contract adoption is not a
claim that those release gates have passed.

## Non-mobile source and package checkpoints

All 14 allowlisted `hns-rs` crates are published and non-yanked at `0.1.0`.
Every package embeds source commit
`0ea5994c336642ea7d01c51c0e22df2008985426` in its Cargo VCS metadata.
Documentation head
`f6f46e1ecf9b31ca6592a6350c254a6effb9c9d0` records the complete
publication, but no local or remote `v0.1.0` Git tag exists.

The canonical `hns-dane-engine` remote remains at
`7f7bb8fa100c2393f2cd5a64c64bf5e20a0f3ab5`. Local release preparation
ending at `1d0fc9c6ba72f008e60d8c5a98741a32aeea4a75` is unpublished and
intentionally unpushed. MeshMine documentation head
`9f781a00ee8fc3b7c6773538434235a65f167ca3` passed all three jobs in CI run
`30440116148` without changing its immutable external-node boundary.

The bootstrap-generator workflow is hosted, but its current evidence is a
failure rather than a pass: run `30401402868` stopped at `npm ci` because
`@emnapi/runtime@1.11.3` is missing from `package-lock.json`.

## Distribution checkpoints

The mobile repository identifies Android as its validated shipping baseline
and links the current
[Google Play listing](https://play.google.com/store/apps/details?id=com.denuoweb.hnsdane)
and
[Apple App Store listing](https://apps.apple.com/us/app/hns-dane-browser/id6791914326).
Both listings reported version `0.5.0` on 2026-07-28; repository main is the
`0.5.3` update candidate. Its native iOS shell, signing/upload automation, and
store metadata remain product-specific evidence rather than ecosystem-wide
release qualification.

The Chromium repository's latest tag is `v0.5.5` at source
`86b18497285753944ec1b9196ec05ee359c6db11`. Its public release contains 29
assets across the Manifest V3, native-host, Setup, checksum, and provenance
surface. macOS native-host and Setup artifacts are Developer ID signed and
Apple notarized; Setup tickets are stapled and standalone native hosts use
Apple's online ticket. Windows artifacts remain unsigned. Documentation head
`3495bd1c5e7c26f9486ea81fb21dc1618c9bc2c8` passed exact-head CI run
`30439859541`. Catalog signing, review, published catalog IDs, and
installed-browser testing remain separate distribution gates.

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
