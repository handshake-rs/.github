<p align="center">
  <img src="./assets/handshake-rs-hero-v1.png" alt="handshake-rs — a luminous decentralized network rooted in the Handshake Rust emblem" width="100%">
</p>

<h1 align="center">Handshake Rust Ecosystem</h1>

<p align="center">
  <strong>Sovereign naming. Systems-grade Rust. Infrastructure without gatekeepers.</strong>
</p>

`handshake-rs` is an independent, community-led collection of Rust libraries,
services, and applications for Handshake. Each product has its own repository,
qualification gates, license, and release boundary. The
[`ecosystem`](https://github.com/handshake-rs/ecosystem) repository coordinates
cross-project architecture and integration; it is not a monorepo or umbrella
package.

## Projects

| Repository | Responsibility |
| --- | --- |
| [`hns-rs`](https://github.com/handshake-rs/hns-rs) | Runtime-independent consensus, transaction, covenant, proof, swap, Shakescape V1, HNSA, and HNSR protocol primitives. It defines wire and state-machine boundaries; it does not operate a node, wallet, relay, or market. |
| [`hns-node-rs`](https://github.com/handshake-rs/hns-node-rs) | Standalone `hsrd` node with chain state, P2P sync, mempool, mining templates, RPC, resolver support, wallet indexes, and an opaque HNSR swap-circuit relay. Relaying bytes does not grant wallet, marketplace, or settlement authority. |
| [`hns-wallet-rs`](https://github.com/handshake-rs/hns-wallet-rs) | Encrypted HNS wallet, direct peer controller, Bitcoin support, closed Shakedex workflows, provider types, host/FFI boundaries, and mobile controllers. The published package is independently versioned from its consumers. |
| [`hns-dane-engine`](https://github.com/handshake-rs/hns-dane-engine) | Canonical DNS wire, DNSSEC, TLSA/DANE, dual-root resolution, browser authority lifecycle, transport policy, observability, and HNSA/HNSR admission contracts. Product roles remain downstream integration decisions. |
| [`hns-dane-browser-mobile`](https://github.com/handshake-rs/hns-dane-browser-mobile) | Shakescape for Android and iOS: authenticated HNS/ICANN browsing plus native direct-wallet reads, send review/broadcast, name transfers, and closed Shakedex offer exchange. Website-provider access and active HNSA/HNSR roles remain disabled. |
| [`hns-dane-browser-extension`](https://github.com/handshake-rs/hns-dane-browser-extension) | Shakescape Extension, its Chromium MV3 UI, authenticated loopback proxy/native host, and cross-platform Setup application. It can request the optional DNS-relay transport but does not serve opaque relay traffic or expose wallet/provider/market authority. |
| [`MeshMine`](https://github.com/handshake-rs/MeshMine) | Private mining-overlay workspace consuming the node and protocol layers. Its `pool-stats` work is specialized and does not make it a wallet, exchange, order book, or general marketplace. |
| [`hns-dane-crawler`](https://github.com/handshake-rs/hns-dane-crawler) | Observational HSD-derived topology, stored DNS evidence, DANE-readiness queues, reports, and optional directory output. Observations are not browser trust authority. |
| [`hns-dane-bootstrap-generator`](https://github.com/handshake-rs/hns-dane-bootstrap-generator) | Operator tooling for HNS/ICANN delegation, DNSSEC/DS, authoritative DoH, TLSA, and appliance configuration. Generated guidance is not live validation or transaction authority. |
| [`ecosystem`](https://github.com/handshake-rs/ecosystem) | Current architecture, integration requirements, and qualification guidance across the separate repositories. |

## How the pieces fit

```text
hns-rs ─┬──> hns-node-rs ──────> MeshMine
        ├──> hns-wallet-rs ─────> Shakescape mobile
        └──> hns-dane-engine ─┬─> Shakescape mobile
                             └─> Shakescape Extension

hns-node-rs ── typed chain/RPC adapter ──> hns-wallet-rs

hns-dane-crawler ── observed gap ──> hns-dane-bootstrap-generator

ecosystem ── coordinates architecture, integration, and qualification
```

Authority follows those arrows deliberately. Protocol types do not activate a
service; node or relay state does not become wallet signing authority; and a
crawler observation or generated record does not become browser trust
evidence. Both browser products resolve through HNS and ICANN and validate the
selected DNSSEC, TLSA, and DANE evidence locally.

## Browser product boundaries

Shakescape mobile integrates the protocol, wallet, and browser-engine packages
pinned by its own manifests. Its native direct-wallet path supports local
wallet lifecycle, synchronized balance and history, distinct receive targets,
send review and broadcast, tracked names, transfer/finalization, and closed
Shakedex offer exchange. Explicit IP-literal Shakescape V1 pairing and the
wallet-owned listener are revoked when the wallet locks or the app crosses a
protected lifecycle boundary.

Those native capabilities do not create a website provider. Web content cannot
request wallet actions, and active HNSA/HNSR browser roles and mainnet
cross-chain settlement remain disabled. Physical-iPhone coverage and installed
cross-chain swap qualification also remain open.

Shakescape Extension `1.0.0` integrates the published browser-engine component
graph and keeps its optional requester-only P2P DNS relay behind explicit
consent. It opts out of opaque relay serving. Wallet authority, a website
provider, value settlement, marketplace operation, HNSA/HNSR service roles,
and a verified MeshMine feed remain unavailable in the Chromium product.

The node's `0x0004` swap circuit is an opaque relay boundary. Enabled relayers
may advertise Node, Web, Chat, and Shakescape swap profiles, while requesters
use their selected profile. The node neither decodes marketplace payloads nor
gains discovery, order-book, wallet, approval, funding, or settlement
authority from relaying them.

## Related product boundary

[`denuoweb/namehold-wallet`](https://github.com/denuoweb/namehold-wallet) is an
hsd-backed desktop wallet with its own packaging and updater configuration.
It is independent of the `hns-wallet-rs` mobile stack. Consult its release
procedure for the configured signing and distribution authority.

## Source governance and maturity

Canonical source and review policy live in the individual `handshake-rs`
repositories. Release publishing, application-store submission, and binary
signing are distinct responsibilities. Denuo Web LLC may publish or sign
browser products and auxiliary services without receiving organization-wide
source ownership. Artifacts must identify their exact source commit or tag.

The ecosystem is under active construction and is **not release-ready as a
whole**. A passing primitive, crate, or portable build does not imply
installed-browser, wallet-value, marketplace, signed-device, mainnet, or
production qualification. Consult each product repository's current manifests
and release procedure for package versions, supported capabilities, and
qualification requirements.

License terms differ by repository. Public source availability alone does not
grant additional rights; consult each repository's license and third-party
notices before redistribution.

> This is an independent project and does not claim to be the official
> Handshake organization.

The canonical [brand assets](./assets/README.md) are maintained with this
profile.
