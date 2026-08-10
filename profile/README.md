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
release boundary. The
[`ecosystem`](https://github.com/handshake-rs/ecosystem) repository coordinates
architecture and cross-project evidence; it is not a monorepo or umbrella
package.

## Projects

| Repository | Responsibility |
| --- | --- |
| [`hns-rs`](https://github.com/handshake-rs/hns-rs) | Runtime-independent Handshake protocol primitives, including consensus encodings, transactions, covenants, proofs, swaps, the experimental Denuo registry, HNSA objects, and HNSR state machines. It defines protocol boundaries; it does not operate a wallet, node, relay, or marketplace service. |
| [`hns-node-rs`](https://github.com/handshake-rs/hns-node-rs) | Standalone `hsrd` node, chain state, P2P synchronization, mempool, mining templates, RPC, resolver sidecar, and release-gated wallet indexes. Mainnet mining still requires the explicit synchronized canary; the node is not a wallet or market UI. |
| [`hns-wallet-rs`](https://github.com/handshake-rs/hns-wallet-rs) | Independent encrypted wallet, provider, market-state, Shakedex, Bitcoin, Ethereum, host, FFI, and mobile-controller source boundary. Only the native non-value HNS lifecycle is wired into the current mobile source candidate; provider, value, name-action, settlement, and marketplace product gates remain false. |
| [`MeshMine`](https://github.com/handshake-rs/MeshMine) | Private `0.1.0` mining-overlay workspace consuming exact external node and protocol revisions. Its draft HNSA/HNSR `pool-stats` path is specialized, unqualified, and not a wallet, exchange, order book, or P2P marketplace. |
| [`hns-dane-engine`](https://github.com/handshake-rs/hns-dane-engine) | Canonical DNS wire, DNSSEC, TLSA/DANE, authenticated dual-root resolution, transport policy, browser authority lifecycle, observability, and source-level HNSA/HNSR admission. Platform service roles and provider availability remain downstream gates. |
| [`hns-dane-browser-mobile`](https://github.com/handshake-rs/hns-dane-browser-mobile) | Android/iOS shells owning platform lifecycle, staged headers, proxy integration, UI, stores, and packaging. Candidate `0.5.8` adds native-only wallet creation, restoration, status, lock/unlock, and one HNS account identity; it does not expose balances, receive/send, name management, website wallet-provider access, HNSA/HNSR services, or markets. |
| [`hns-dane-browser-extension`](https://github.com/handshake-rs/hns-dane-browser-extension) | Chromium extension, PAC/proxy integration, native host, staged headers, and Setup packaging. Candidate `0.5.6` keeps wallet/provider/value/market and every HNSA/HNSR product role disabled; its optional MeshMine feed is display-only and unverified. |
| [`hns-dane-crawler`](https://github.com/handshake-rs/hns-dane-crawler) | Observational HSD-derived topology, stored DNS evidence, DANE-readiness queues, static reports, and optional live directory. It is not browser trust authority, a wallet, or an HNSA/HNSR/market service. |
| [`hns-dane-bootstrap-generator`](https://github.com/handshake-rs/hns-dane-bootstrap-generator) | Operator-facing web and appliance tooling that generates HNS/ICANN delegation, DNSSEC/DS, authoritative DoH, and TLSA material. Generated guidance is not live browser validation or transaction authority. |
| [`ecosystem`](https://github.com/handshake-rs/ecosystem) | Source audit, architecture, cross-project reconciliation, qualification matrices, migration records, and historical release evidence. No product code is combined here. |

## How the pieces fit

```text
hns-rs ─┬──> hns-node-rs ──────> MeshMine
        │      node authority      mining overlay
        ├──> hns-wallet-rs ─────> hns-dane-browser-mobile
        │      wallet authority    native lifecycle only
        └──> hns-dane-engine ─┬─> hns-dane-browser-mobile
             browser security └─> hns-dane-browser-extension

hns-node-rs ── typed chain/RPC adapter ──> hns-wallet-rs

hns-dane-crawler ── observed gap/handoff ──> hns-dane-bootstrap-generator
  topology and evidence                       operator-authored DNS records

ecosystem ── audits compatibility, integration, and release evidence for all
```

The authority direction is intentional. Protocol types in `hns-rs` do not
activate a service, node state never becomes wallet signing authority, and a
crawler observation or generated record never becomes browser trust evidence.
The browser products resolve the complete hostname through HNS and ICANN,
retain one authenticated connection plan, and validate DNSSEC, TLSA, and DANE
locally. Returned HIP-76, ODoH, HNSR, DoH, or ordinary DNS bytes remain
untrusted until that validation succeeds.

## Source and release inventory

Snapshot: **2026-08-10**. Every source identity below was read back from the
canonical remote `main`; each selected candidate-version tag was also confirmed
absent. “Candidate” means source and metadata are prepared. It does not mean a
crate, binary, store build, tag, GitHub Release, npm package, PyPI project,
appliance, or StackScript has been published. Its source identities and browser
product gates are available as
[`ecosystem-release-inventory.json`](./ecosystem-release-inventory.json) for
automation.

| Repository | Exact remote `main` | Source identity | Latest released/tagged state |
| --- | --- | --- | --- |
| `hns-rs` | [`b24b66c`](https://github.com/handshake-rs/hns-rs/commit/b24b66c382de53330ec21dd3137e056a2bea3e2d) | 17-crate `0.2.0` candidate | `v0.1.0` is public; `0.2.0` is not tagged or published |
| `hns-wallet-rs` | [`4e78bb2`](https://github.com/handshake-rs/hns-wallet-rs/commit/4e78bb2587bc448d3a65341c7628b2e62cae79cd) | 14-crate initial `0.1.0` candidate | no tag, GitHub Release, or crate publication |
| `hns-node-rs` | [`9ed129f`](https://github.com/handshake-rs/hns-node-rs/commit/9ed129f30c8cd8cd8a07c6872aa4ac40ece5d23b) | untagged `0.3.5` candidate | `v0.3.4` remains the latest GitHub prerelease |
| `MeshMine` | [`ad0958e`](https://github.com/handshake-rs/MeshMine/commit/ad0958e0234075470e5b03ba726e3c9dc9b7f865) | 27 private workspace packages at existing `0.1.0`; release version not selected | no tag, GitHub Release, publication, or selected artifact contract |
| `hns-dane-engine` | [`2b23bd5`](https://github.com/handshake-rs/hns-dane-engine/commit/2b23bd55d14d36fe60073606869d75b4796c54f7) | 19-crate `0.2.0` candidate | `v0.1.0` is public; `0.2.0` is not tagged or published |
| `hns-dane-browser-mobile` | [`f21bee1`](https://github.com/handshake-rs/hns-dane-browser-mobile/commit/f21bee1c3afccd06604dc99fccb51528e2441055) | `0.5.8`, Android code 49, iOS build 58 | untagged and unshipped; `v0.5.7` remains the latest GitHub Release |
| `hns-dane-browser-extension` | [`5a7683e`](https://github.com/handshake-rs/hns-dane-browser-extension/commit/5a7683e70162220c8bfbdae9e8a7d4c3c37acf02) | untagged `0.5.6` candidate | `v0.5.5` remains the latest GitHub Release |
| `hns-dane-crawler` | [`43b78fb`](https://github.com/handshake-rs/hns-dane-crawler/commit/43b78fb6a28f920415aed6145d232126f5fa57e5) | first `denuo-hns-topology` `0.1.0` wheel candidate | no tag, GitHub Release, or PyPI publication |
| `hns-dane-bootstrap-generator` | [`30aa079`](https://github.com/handshake-rs/hns-dane-bootstrap-generator/commit/30aa0791730ce54ff6a0b345f97afce7b232bdd5) | private-package/application `0.2.2` candidate | untagged; `v0.2.1` remains the latest source tag and public StackScript baseline |

The protocol, wallet, and engine candidates each passed exact-commit CI,
CodeQL, and credential-free package preflight:

- `hns-rs`: CI
  [`31398600728`](https://github.com/handshake-rs/hns-rs/actions/runs/31398600728),
  CodeQL
  [`31398598588`](https://github.com/handshake-rs/hns-rs/actions/runs/31398598588),
  and 17-package preflight
  [`31399004538`](https://github.com/handshake-rs/hns-rs/actions/runs/31399004538);
- `hns-wallet-rs`: CI
  [`31400338534`](https://github.com/handshake-rs/hns-wallet-rs/actions/runs/31400338534),
  CodeQL
  [`31400331144`](https://github.com/handshake-rs/hns-wallet-rs/actions/runs/31400331144),
  and 14-package preflight
  [`31400883156`](https://github.com/handshake-rs/hns-wallet-rs/actions/runs/31400883156); and
- `hns-dane-engine`: CI
  [`31400455158`](https://github.com/handshake-rs/hns-dane-engine/actions/runs/31400455158),
  CodeQL
  [`31400453827`](https://github.com/handshake-rs/hns-dane-engine/actions/runs/31400453827),
  and 19-package preflight
  [`31401229842`](https://github.com/handshake-rs/hns-dane-engine/actions/runs/31401229842).

The product and utility source candidates also have exact-commit evidence:

- node CI
  [`31403592812`](https://github.com/handshake-rs/hns-node-rs/actions/runs/31403592812),
  CodeQL
  [`31403592231`](https://github.com/handshake-rs/hns-node-rs/actions/runs/31403592231),
  and container build
  [`31403593273`](https://github.com/handshake-rs/hns-node-rs/actions/runs/31403593273)
  passed at `9ed129f` without granting mainnet mining or wallet-index release
  authority;
- MeshMine CI
  [`31406917807`](https://github.com/handshake-rs/MeshMine/actions/runs/31406917807)
  and CodeQL
  [`31406911750`](https://github.com/handshake-rs/MeshMine/actions/runs/31406911750)
  passed at `ad0958e`; source qualification does not close its hardware,
  public-WAN, independent-review, production-mode, or artifact-contract gates;
- mobile CI
  [`31402758394`](https://github.com/handshake-rs/hns-dane-browser-mobile/actions/runs/31402758394)
  passed at `f21bee1`; its exact CI-produced Android debug APK, SHA-256
  `e7dd8ee68f5167ea869fc985e1fef60a799e8cfc637a1a1b651a5f0f74b40508`,
  was installed fresh and inspected on a Pixel 9. Apple ABI, XCFramework, and
  iOS shell jobs passed in the same gate, but a signed/store build still
  requires fresh exact-candidate screenshots and the protected release
  workflow. The
  [hosted privacy disclosure](https://denuoweb.com/work/hns-dane-browser/privacy)
  was deployed and read back from exact website source
  [`909dbd1`](https://github.com/Denuo-Web/DenuoWebSite/commit/909dbd1a713f322f0a8d4cff88e765c612e184f3);
  its candidate/current-binaries wording must be reconciled after `0.5.8`
  becomes public;
- extension CI
  [`31404782077`](https://github.com/handshake-rs/hns-dane-browser-extension/actions/runs/31404782077)
  and CodeQL
  [`31404781059`](https://github.com/handshake-rs/hns-dane-browser-extension/actions/runs/31404781059)
  passed at `5a7683e`, producing the exact Linux arm64 qualification inputs.
  Bundle provenance SHA-256 is
  `bc73451efe1c9490d2da171683b0ea3c734da78a749defbd211edd3a15fd6bdd`;
  the native host SHA-256 is
  `096be59083d014e821433a18dc8a206ee5e5491bec85e9771f7937e5650b4e65`;
  the canonical extension ZIP SHA-256 is
  `5e81b3f5e2df4d8090784714b7c7f30335d453aadde5a26d5a62f26d3dae8567`;
  and manifest SHA-256 is
  `4329a0cfde5d24b10c1f0723589a342b70e4fc1eeeea74c6c43e0a8606c5b171`.
  Those exact inputs passed the available isolated-profile checks in Chromium
  `149.0.7827.196` arm64: current headers, ICANN WebPKI, restart/reconnect, and
  disabled capabilities under canonical ID
  `idejjnoplngbhpnpjekblpalblbianio`. Two positive HNS-origin proof attempts
  timed out and failed closed; therefore the required positive HNS/DANE portion
  remains open. Clean teardown left the normal profile untouched. This exact
  installed-browser evidence is neither complete candidate qualification nor
  store publication;
- crawler CI
  [`31404940342`](https://github.com/handshake-rs/hns-dane-crawler/actions/runs/31404940342)
  passed at `43b78fb`, producing wheel
  `denuo_hns_topology-0.1.0-py3-none-any.whl` with SHA-256
  `1bb3db2b22a3d803fe7e5ca20826b60967aa406d6ee08c27b5be4f0445299a17`;
  and
- bootstrap CI
  [`31403055128`](https://github.com/handshake-rs/hns-dane-bootstrap-generator/actions/runs/31403055128)
  and CodeQL
  [`31403052511`](https://github.com/handshake-rs/hns-dane-bootstrap-generator/actions/runs/31403052511)
  passed at `30aa079`.

## Browser product gates

| Surface | Current status |
| --- | --- |
| Mobile native wallet lifecycle | Ready in `0.5.8` source for create, restore, open/status, unlock, lock, and one HNS account identity. Exact Android debug-device and Apple CI evidence exists; no public `0.5.8` build exists. |
| Mobile balances, receive/send, and name management | **Unavailable.** The mobile controller intentionally exposes no value or name-action API. |
| Browser website provider | **Unavailable.** Wallet/provider and approval-window source exists, but neither browser product assembles the complete availability path: a qualified wallet-service artifact, private process transport, consumable browser-engine authority adapter, and reviewed native-to-public approval projection. |
| Browser value and settlement | **Unavailable.** All `hns-wallet-rs` HNS funding/value/fee, Shakedex, Bitcoin, and Ethereum value/settlement release gates remain false. |
| Browser P2P marketplace | **Unavailable.** Canonical protocol and persisted workflow source is not a live discovery, order-book, transport, approval, funding, or settlement product. Neither browser exposes it. |
| HNSA/HNSR browser services | **Unavailable.** Mobile exposes no controls; Chromium disables every role and labels its optional MeshMine feed unverified. Source-level protocol, node, engine, or MeshMine paths do not qualify a browser endpoint/rendezvous/provider service. |

The independently maintained
[`DenuoWeb/namehold-wallet`](https://github.com/denuoweb/namehold-wallet) desktop
wallet is not the `hns-wallet-rs` mobile integration. Its hsd-backed value and
name controls, release history, updater authority, and qualification boundary
remain product-local; they do not make the mobile or Chromium gates above true.

## Release order

When a release owner explicitly authorizes publication, the next package
sequence is deliberately dependency ordered:

1. Publish all 17 `hns-rs 0.2.0` crates from exact source `b24b66c`, then
   verify every immutable registry archive and VCS identity.
2. Reconfirm that exact upstream archive set, then publish the 19 engine and
   14 wallet crates from `2b23bd5` and `4e78bb2` respectively. These two
   cohorts have independent release gates.
3. Requalify and package mobile `0.5.8` and Chromium `0.5.6` from their exact
   source commits. Store signing, screenshots, catalog review, and uploads are
   separate product actions.
4. Release node `0.3.5`, Bootstrap `0.2.2`, and any first Crawler or MeshMine
   artifact only after each repository’s own candidate and artifact contract
   is accepted.

No candidate above has been tagged or published by this preparation work.
Tagging, crate/package upload, store upload, signing, public StackScript update,
and GitHub Release creation remain explicit release-owner actions.

## Source governance and releases

Canonical source and review policy live in `handshake-rs`. Release publishing
and binary signing are separate responsibilities: Denuo Web LLC may publish or
sign browser products, MeshMine, and auxiliary DANE services or appliances
without owning every source repository or receiving
organization-wide owner access. Signed artifacts must identify the exact
canonical source commit or tag.

## Maturity

This ecosystem is under active construction and is **not release-ready as a
whole**. Passing primitive, package, or portable build tests does not imply
wallet value, marketplace, installed-browser, signed-device, mainnet, or
production qualification. Repository-local release and qualification documents
define their product gates; this dated profile records later cross-project
evidence without weakening them. The
[`ecosystem` qualification matrix](https://github.com/handshake-rs/ecosystem/blob/main/QUALIFICATION_MATRIX.md),
[`remaining gaps`](https://github.com/handshake-rs/ecosystem/blob/main/REMAINING_GAPS.md),
and
[`integration state`](https://github.com/handshake-rs/ecosystem/blob/main/INTEGRATION_STATE.md)
provide deeper cross-project background; this dated profile inventory takes
precedence for the current source identities listed above.

License terms differ by repository. Public source availability alone does not
grant additional rights; consult each repository’s current license and
third-party notices before redistribution.

> This is an independent project and does not claim to be the official
> Handshake organization.

The canonical [brand assets](./assets/README.md) are maintained with this
profile.
