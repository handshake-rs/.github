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
| [`hns-wallet-rs`](https://github.com/handshake-rs/hns-wallet-rs) | Independent encrypted wallet, provider, market-state, Shakedex, Bitcoin, Ethereum, host, FFI, and mobile-controller source boundary. The current mobile candidate wires the native HNS lifecycle and a strict non-value read projection; provider, value, name-action, settlement, and marketplace product gates remain false. |
| [`MeshMine`](https://github.com/handshake-rs/MeshMine) | Private `0.1.0` mining-overlay workspace consuming exact external node and protocol revisions. Its draft HNSA/HNSR `pool-stats` path is specialized, unqualified, and not a wallet, exchange, order book, or P2P marketplace. |
| [`hns-dane-engine`](https://github.com/handshake-rs/hns-dane-engine) | Canonical DNS wire, DNSSEC, TLSA/DANE, authenticated dual-root resolution, transport policy, browser authority lifecycle, observability, and source-level HNSA/HNSR admission. Platform service roles and provider availability remain downstream gates. |
| [`hns-dane-browser-mobile`](https://github.com/handshake-rs/hns-dane-browser-mobile) | Android/iOS shells owning platform lifecycle, staged headers, proxy integration, UI, stores, and packaging. Candidate `0.5.9` includes native wallet lifecycle controls and visible fail-closed read-only rows. It installs no scoped wallet-read credential or indexed backend, so balance, receive target, history, tracked names, and module data remain unavailable; send/value, name actions, website-provider access, HNSA/HNSR services, and markets remain absent. |
| [`hns-dane-browser-extension`](https://github.com/handshake-rs/hns-dane-browser-extension) | Chromium extension, PAC/proxy integration, native host, staged headers, and Setup packaging. Candidate `0.5.6` keeps wallet/provider/value/market and every HNSA/HNSR product role disabled; its optional MeshMine feed is display-only and unverified. |
| [`hns-dane-crawler`](https://github.com/handshake-rs/hns-dane-crawler) | Observational HSD-derived topology, stored DNS evidence, DANE-readiness queues, static reports, and optional live directory. It is not browser trust authority, a wallet, or an HNSA/HNSR/market service. |
| [`hns-dane-bootstrap-generator`](https://github.com/handshake-rs/hns-dane-bootstrap-generator) | Operator-facing web and appliance tooling that generates HNS/ICANN delegation, DNSSEC/DS, authoritative DoH, and TLSA material. Generated guidance is not live browser validation or transaction authority. |
| [`ecosystem`](https://github.com/handshake-rs/ecosystem) | Source audit, architecture, cross-project reconciliation, qualification matrices, migration records, and historical release evidence. No product code is combined here. |

## How the pieces fit

```text
hns-rs ─┬──> hns-node-rs ──────> MeshMine
        │      node authority      mining overlay
        ├──> hns-wallet-rs ─────> hns-dane-browser-mobile
        │      wallet authority    lifecycle + fail-closed read projection
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
canonical remote `main`; each selected candidate tag was confirmed absent.
“Candidate” means that a repository has selected source and version metadata.
It does not mean that a crate, binary, store build, tag, GitHub Release, npm
package, PyPI project, appliance, or StackScript has been published. The
machine-readable source identities and product gates live in
[`ecosystem-release-inventory.json`](./ecosystem-release-inventory.json).
In schema 3, a null `qualificationCommit` means that exact current-main
qualification is still open. Browser `artifactCommit` records the exact
code-bearing source of the retained artifact, while a null
`installedEvidenceCommit` means that artifact has no retained
installed-device/browser result.

| Repository | Exact remote `main` | Selected source state | Latest released/tagged state |
| --- | --- | --- | --- |
| `hns-rs` | [`c76cd6f`](https://github.com/handshake-rs/hns-rs/commit/c76cd6f57e0601b86aad6b5f051ae8bbe2fab2e7) | 17-crate `0.2.0` candidate | `v0.1.0` is public; `0.2.0` is not tagged or published |
| `hns-wallet-rs` | [`6cd3e8e`](https://github.com/handshake-rs/hns-wallet-rs/commit/6cd3e8ea1659dc64a89bedfb10d1296c83eb07a8) | 14-crate initial `0.1.0` candidate; mobile non-value read-controller source is present | no tag, GitHub Release, or crate publication |
| `hns-node-rs` | [`f2c9482`](https://github.com/handshake-rs/hns-node-rs/commit/f2c94823e16fa5b877d1270cc366052b6fd7dbd9) | untagged `0.3.5` candidate; guarded accumulator repair, script-free `chain_snapshot`, and an exact arm64 recovery-candidate contract are present | `v0.3.4` remains the latest GitHub prerelease |
| `MeshMine` | [`60eecd1`](https://github.com/handshake-rs/MeshMine/commit/60eecd1c1ab60fc8df1802b7de3f8e89e67974ca) | 27 private, non-publishable workspace packages at `0.1.0`; a non-production evaluation artifact contract is selected | no tag, GitHub Release, or package publication |
| `hns-dane-engine` | [`16d1de5`](https://github.com/handshake-rs/hns-dane-engine/commit/16d1de5f0667276400587970a36a307b8772a061) | 19-crate `0.2.0` candidate | `v0.1.0` is public and component tag `hns-browser-observability-v0.1.1` exists; `0.2.0` is not tagged or published |
| `hns-dane-browser-mobile` | [`8eb6937`](https://github.com/handshake-rs/hns-dane-browser-mobile/commit/8eb6937b1e9d3153a2bffdc87a5e881dc96ed8aa) | `0.5.9`, Android code 50, iOS build 59; native lifecycle and fail-closed read projection only | untagged and unshipped; `v0.5.7` remains the latest GitHub Release |
| `hns-dane-browser-extension` | [`82df115`](https://github.com/handshake-rs/hns-dane-browser-extension/commit/82df11585d5e43c595adda41f083698884c344b4) | untagged `0.5.6` candidate; HNSA feed and all wallet/value/market roles remain disabled | `v0.5.5` remains the latest GitHub Release |
| `hns-dane-crawler` | [`1a290ef`](https://github.com/handshake-rs/hns-dane-crawler/commit/1a290efa394a2b28e958fb94d556719199bb00dd) | first `denuo-hns-topology` `0.1.0` wheel/sdist candidate | no tag, GitHub Release, or PyPI publication |
| `hns-dane-bootstrap-generator` | [`65cc8aa`](https://github.com/handshake-rs/hns-dane-bootstrap-generator/commit/65cc8aa1335d7a0e0299c31a96e824a702914869) | private application `0.2.2` with a canonical, source-bound appliance candidate contract | `v0.2.1` remains the latest source tag; there is no GitHub Release |

### Local-only private boundary

The workspace also contains `freeDomains`, a non-Git, private Node package at
`0.1.0` for coordinating giveaway-name auctions through HSD. It has no
canonical remote, selected release candidate, tag, publication boundary, or
artifact contract, so it is deliberately outside the repository table and
release order. Its live `config.json`, SQLite database, and SQLite WAL/SHM
sidecars are operator state—not source or release artifacts—and no path,
credential location, wallet identifier, database content, or hash from them is
recorded here.

Before `freeDomains` can enter source control or release preparation, its setup
documentation must replace the storage-device, specific-wallet/port, and
creation-time sync narrative with portable example-based instructions. The
current ignore rules exclude the database files but not the live `config.json`;
the directory therefore must not be archived or published as-is. Only
sanitized source, package metadata, documentation, tests, word-bank data, and
`config.example.json` can be considered for a future source candidate. Its
current restart behavior is also restart-aware rather than fully restart-safe
because a process interruption between broadcast and durable `sent` recording
can require operator reconciliation. The configured network is not yet enforced
against the contacted node as a live-action admission check, which is another
release blocker.

These versions remain valid candidates while unpublished corrective source and
documentation work is absorbed. Any changed source must receive new
exact-commit qualification and artifact identity; evidence never transfers
automatically from an ancestor.

### Exact qualification evidence

Package-cohort evidence is:

- `hns-rs c76cd6f`: CI
  [`31426984919`](https://github.com/handshake-rs/hns-rs/actions/runs/31426984919),
  CodeQL
  [`31426984517`](https://github.com/handshake-rs/hns-rs/actions/runs/31426984517),
  and 17-package preflight
  [`31427951687`](https://github.com/handshake-rs/hns-rs/actions/runs/31427951687)
  passed.
- `hns-dane-engine 16d1de5`: the documentation-only successor clarifies why
  the full facade/OpenSSL closure is not mobile-safe and identifies the missing
  HNSA/HNSR mobile authority bridge. Exact-main CI
  [`31434406521`](https://github.com/handshake-rs/hns-dane-engine/actions/runs/31434406521)
  and CodeQL
  [`31434404983`](https://github.com/handshake-rs/hns-dane-engine/actions/runs/31434404983)
  and successor 19-package preflight
  [`31435014568`](https://github.com/handshake-rs/hns-dane-engine/actions/runs/31435014568)
  passed.
- `hns-wallet-rs 6cd3e8e`: final exact-main CI
  [`31434731924`](https://github.com/handshake-rs/hns-wallet-rs/actions/runs/31434731924)
  and CodeQL
  [`31434731180`](https://github.com/handshake-rs/hns-wallet-rs/actions/runs/31434731180)
  and exact 14-package preflight
  [`31435094733`](https://github.com/handshake-rs/hns-wallet-rs/actions/runs/31435094733)
  passed.

Application and utility evidence is:

- `hns-node-rs f2c9482`: exact-main CI
  [`31436795564`](https://github.com/handshake-rs/hns-node-rs/actions/runs/31436795564)
  (including RustSec and the complete locked Node/fuzz gate), CodeQL
  [`31436795119`](https://github.com/handshake-rs/hns-node-rs/actions/runs/31436795119),
  routine container verification
  [`31436795658`](https://github.com/handshake-rs/hns-node-rs/actions/runs/31436795658)
  and the manually dispatched arm64 recovery-candidate run
  [`31436813778`](https://github.com/handshake-rs/hns-node-rs/actions/runs/31436813778)
  passed. That run retained artifact `9081472784`, named
  `hsrd-recovery-arm64-f2c94823e16fa5b877d1270cc366052b6fd7dbd9`; its
  47,839,662-byte GitHub ZIP has API digest
  `sha256:7764618bf217519840b5a552fc478fef9adf5a4e338e25bdd6b2300f65a64092`
  and expires on 2026-08-17. Read-only streaming verification confirmed its
  three-file bundle binds source `f2c94823` and tree
  `a3fc65d7ea4e461f0cb2e73b2b594002c0ba86c0`. The 47,837,184-byte OCI,
  provenance, and `SHA256SUMS` SHA-256 values are respectively
  `987239331ff16c65b854c269aaf9e0a11db04cdc2c6ab8318b6f12d9e29d34d6`,
  `fba2362f800450850611bf135cf14e987744ccf09eb86caad9d3e5d897f44f77`,
  and
  `22bb21989e09d89a0750e58cb18a35411c808546fa5239be561ed862d7f0e07b`.
  OCI manifest and config/image IDs are
  `sha256:3cee1f9d0a645aa0023e1ab5bb4907be089a8e3c4cee5ed95f96ec782e5ac65f`
  and
  `sha256:8258ae50ea48e32061d31c4296151a01789be86ef02742d6c0c57cc96c417564`.
  All eight blob hashes/sizes, labels, and runtime metadata verified as
  `linux/arm64`, `hsrd 0.3.5`, uid/gid 10001, workdir `/var/lib/hsrd`, and
  `SIGTERM`; no Docker state was touched. The unchanged code-bearing source
  [`2b267ff`](https://github.com/handshake-rs/hns-node-rs/commit/2b267ffe7fc6f9929063a18986a83b566d02ae6d)
  passed CI
  [`31419193412`](https://github.com/handshake-rs/hns-node-rs/actions/runs/31419193412),
  CodeQL
  [`31419192881`](https://github.com/handshake-rs/hns-node-rs/actions/runs/31419192881),
  and its container matrix
  [`31419193517`](https://github.com/handshake-rs/hns-node-rs/actions/runs/31419193517).
  The recovery candidate is not a release or production volume. Neither it nor
  those ancestor runs grant mainnet mining, wallet-index, authenticated
  mobile-backend, or live-volume recovery authority.
- `MeshMine 60eecd1`: CI
  [`31429529696`](https://github.com/handshake-rs/MeshMine/actions/runs/31429529696),
  CodeQL
  [`31429527328`](https://github.com/handshake-rs/MeshMine/actions/runs/31429527328),
  and private-candidate run
  [`31430320865`](https://github.com/handshake-rs/MeshMine/actions/runs/31430320865)
  passed. Its provenance binds node source `2712d1d` and protocol source
  `b24b66c`, and declares `production_eligible: false`. The retained evaluation
  archive and checksum sidecar have SHA-256 values
  `8147d32b91c4839420a2d01b0c2cd075f9f0b1048be383ea1a3cf6918c8fd3b3`
  and
  `eaaba8d9716d63b8691ac832a264801ba600ad68275fff79ca8fc110eb2627a1`.
- `hns-dane-browser-extension 82df115`: CI
  [`31424571462`](https://github.com/handshake-rs/hns-dane-browser-extension/actions/runs/31424571462)
  and CodeQL
  [`31424570936`](https://github.com/handshake-rs/hns-dane-browser-extension/actions/runs/31424570936)
  passed. The exact candidate was exercised in an isolated Chromium
  `149.0.7827.196` arm64 profile: current mainnet headers, restart/reconnect,
  and ICANN WebPKI passed, while disabled product roles remained disabled.
  Canonical extension ID
  `idejjnoplngbhpnpjekblpalblbianio` was preserved. The provenance, native
  host, native archive, extension ZIP, and manifest SHA-256 values are
  respectively
  `30d6e2f5977313a3cc7fdcc21706fb6d617f8e836c5e2eba8fad36077bc41fd7`,
  `bb44e020080bb31d55962374ada1cde38e7fce9fcd4fc45d71fd34f7c234ba38`,
  `26ffa8594f639a142f7369f96633b0724f8e5013250cbf086647bd547f73237d`,
  `75ad176f9052a22f603717df5c63e92c505305ccb5eb42262e4e4175be7e2e5a`,
  and
  `4329a0cfde5d24b10c1f0723589a342b70e4fc1eeeea74c6c43e0a8606c5b171`.
  This installed-browser result does not qualify a positive HNS/DANE origin,
  local CA origin termination, HNSA feed, wallet/provider, value, HNSR, ODoH,
  or market.
- `hns-dane-crawler 1a290ef`: CI
  [`31428776970`](https://github.com/handshake-rs/hns-dane-crawler/actions/runs/31428776970),
  CodeQL
  [`31428776667`](https://github.com/handshake-rs/hns-dane-crawler/actions/runs/31428776667),
  and exact-main package preflight
  [`31428915071`](https://github.com/handshake-rs/hns-dane-crawler/actions/runs/31428915071)
  passed. Provenance and `SHA256SUMS` have SHA-256 values
  `fe8d0b3267f553defced6c848d2b6f38cd51053d87908faced3043b795609d26`
  and
  `66166d216a14dc3f8527236edcdfd4ca5d68da4d18a4d7cc42ff6ad1735c2e18`;
  the wheel and sdist SHA-256 values are
  `0cccf8e92c06f7cf4747c488e9abc204a715a077f9390c9ad10535ab22ad1bf4`
  and
  `6b8c12ffe1af93aecfaceef607181eeecc96168a9ccfb42c5e7b65425e5e1a24`.
- `hns-dane-bootstrap-generator 65cc8aa`: CI
  [`31432491449`](https://github.com/handshake-rs/hns-dane-bootstrap-generator/actions/runs/31432491449),
  CodeQL
  [`31432489652`](https://github.com/handshake-rs/hns-dane-bootstrap-generator/actions/runs/31432489652),
  and appliance preflight
  [`31432688388`](https://github.com/handshake-rs/hns-dane-bootstrap-generator/actions/runs/31432688388)
  passed. Artifact `9079736472` binds source tree
  `1e23b91536a83c2ae567c6edb6ce3fde395e922a`; the canonical archive,
  `SHA256SUMS`, and provenance SHA-256 values are respectively
  `b1ee7626fa1e912bcbb875c88af37b00efc9cf6cadb8edc0493b5549ed004121`,
  `a3c29212b1ff6e38c88385a1c4c904a37dfbf4d575af1ac2bfb69970811043dc`,
  and
  `86733189dfd43450b39642f1324445a58f90dd6e876f0fa05c655bfa397e9c26`.
- `hns-dane-browser-mobile 8eb6937`: this documentation/store-metadata-only
  successor reconciles the exact final code/artifact and Pixel 9 install
  evidence with the remaining product gates. Its docs-scoped CI
  [`31439218482`](https://github.com/handshake-rs/hns-dane-browser-mobile/actions/runs/31439218482),
  Code Quality
  [`31439218446`](https://github.com/handshake-rs/hns-dane-browser-mobile/actions/runs/31439218446),
  and CodeQL
  [`31439218065`](https://github.com/handshake-rs/hns-dane-browser-mobile/actions/runs/31439218065)
  passed. Code-bearing and artifact source `893ba82` keeps
  five canonical resolution contracts and the private mobile adapters in one
  source graph at engine source
  [`2b23bd5`](https://github.com/handshake-rs/hns-dane-engine/commit/2b23bd55d14d36fe60073606869d75b4796c54f7)
  while excluding the host facade and its OpenSSL closure. The native wallet
  remains pinned to code source
  [`2229be8`](https://github.com/handshake-rs/hns-wallet-rs/commit/2229be849557d58a8eb723bcc03349f0f2df9796)
  with protocol closure
  [`b24b66c`](https://github.com/handshake-rs/hns-rs/commit/b24b66c382de53330ec21dd3137e056a2bea3e2d);
  subsequent wallet and protocol commits are release/documentation successors,
  not substituted dependencies. The candidate also revokes iOS wallet UI/read
  authority immediately, then retains the exact lease while serial background
  teardown locks and destroys the controller.
  HNSA/HNSR facade APIs remain outside the mobile graph and no related product
  gate changed. Full impacted CI
  [`31433931682`](https://github.com/handshake-rs/hns-dane-browser-mobile/actions/runs/31433931682)
  passed, including the
  [Apple ABI/XCFramework/iOS-shell job](https://github.com/handshake-rs/hns-dane-browser-mobile/actions/runs/31433931682/job/93603724289)
  and aggregate
  [Required CI job](https://github.com/handshake-rs/hns-dane-browser-mobile/actions/runs/31433931682/job/93610751128).
  Code Quality
  [`31433931278`](https://github.com/handshake-rs/hns-dane-browser-mobile/actions/runs/31433931278)
  and CodeQL
  [`31433931259`](https://github.com/handshake-rs/hns-dane-browser-mobile/actions/runs/31433931259)
  passed. Completed Android jobs retained artifact `9080493058`: its debug APK
  is 65,680,703 bytes with SHA-256
  `7ea4c5b7cb4e2713287bf90794a6bb706311d0bb8fbb7348f94875ce615cc8fb`,
  package `com.denuoweb.hnsdane.debug`, version name `0.5.9-debug`, version code
  50, minimum SDK 30, target SDK 37, and arm64/x86_64 native inventory. Its v2
  debug signature verifies. This exact APK was subsequently installed on a
  Google Pixel 9 (`tokay`) running Android 17 / API 37. The installed
  `base.apk` hash matched the artifact; a cold launch reached `MainActivity`,
  and Browser menu → Settings → HNS wallet exposed the fresh-install,
  fail-closed wallet shell/read projection without creating or restoring a
  wallet or exercising credentials, sync, signing, value, HNSA/HNSR, provider,
  or marketplace authority. Both machine-readable `artifactCommit` and
  `installedEvidenceCommit` therefore remain the code-bearing
  `893ba8271787f1ab7247fa78ed8787462b5542fc`, while current-main documentation
  qualification is recorded separately at `8eb6937`.

The hosted mobile disclosure at
[denuoweb.com/work/hns-dane-browser/privacy](https://denuoweb.com/work/hns-dane-browser/privacy)
was deployed and read back from exact website source
[`c5e1901`](https://github.com/Denuo-Web/DenuoWebSite/commit/c5e1901194065f6f13f3239bbad2746a99c3e319).
It describes the `0.5.9` visible fail-closed wallet-read boundary without
claiming a backend, network request, value control, or marketplace.

## Browser product gates

| Surface | Current status |
| --- | --- |
| Mobile native wallet lifecycle | **Implemented in candidate source.** Create, restore, open/status, unlock, lock, and one local HNS account identity are wired through the native Android and iOS boundaries. This is not a public or signed-store release. |
| Mobile visible wallet-read projection | **Implemented, fail closed.** The native `0.5.9` screens contain strict read-only rows for balance, receive target, transaction history, tracked names, and module status. Without a scoped credential/backend they visibly report unavailable; this UI projection is not evidence that any read data is available. |
| Mobile wallet-read backend and data | **Unavailable.** The app provisions neither a scoped loopback credential nor an indexed/archive-capable wallet backend. A pruned `hsrd` without wallet indexing and scoped authentication is not such a backend. Balance, receive target, history, tracked-name, and module data therefore remain unavailable. |
| Mobile value and name controls | **Unavailable.** Send, funding/value/fee authority, settlement, exchange, name import, and name actions are not exposed. |
| Browser website provider | **Unavailable.** Neither browser assembles the qualified wallet service, private process transport, engine authority adapter, and approval projection required to expose a provider. |
| Mobile requester-only P2P DNS relay | **Implemented as a separate opt-in source feature.** It is a bounded one-hop HIP-76 DNS requester, not an HNSR endpoint/output node, wallet transport, discovery network, or marketplace. |
| Browser P2P marketplace | **Unavailable.** Protocol and persisted workflow source is not a live discovery, order-book, transport, approval, funding, or settlement product. Neither browser exposes a marketplace. |
| HNSA/HNSR browser services | **Unavailable.** Mobile exposes no HNSA/HNSR control. Chromium keeps every service role disabled and its optional MeshMine feed unverified. Protocol, engine, node, and MeshMine source do not by themselves qualify an endpoint, rendezvous, provider, or marketplace. |

The extension's HNSA verifier core does not make its optional feed a verified
product. The current named-route selector admits the HNS Web and Chat profiles,
not MeshMine's private `0xff00` pool-statistics profile. The browser has no
independently selected canonical HNS name, current proof-backed `hsa1` record,
exact profile authorization, or durable authorization serial, endpoint/snapshot
sequence, trusted-time, and conflict state. Mobile additionally lacks the
verified-resource bridge, authenticated rollback-resistant store, and live
HNSR transport adapter needed to compose a requester. Those are product
integration gates. Mobile's engine graph imports five canonical resolution
contracts; the HNSA/HNSR facade APIs remain upstream and outside that graph.

In particular, `visibleFailClosedWalletReadProjection: true` and
`nativeWalletLifecycle: true` in the machine-readable inventory do not make
`walletReadDataAvailable`, any value-authority gate, `p2pMarketplace`,
`hnsaServiceRole`, or `hnsrServiceRole` true.

The independently maintained `denuoweb/namehold-wallet` mirror is at exact
remote main
[`60f10f9`](https://github.com/denuoweb/namehold-wallet/commit/60f10f91e6f856e4620bfd1b430dd1eb3a08a1a5)
and remains version `0.4.0`. Exact CI
[`31412326500`](https://github.com/denuoweb/namehold-wallet/actions/runs/31412326500)
and Workflow Validation
[`31412329124`](https://github.com/denuoweb/namehold-wallet/actions/runs/31412329124)
passed at that source. It is a separate hsd-backed, value- and name-capable
desktop wallet, not the `hns-wallet-rs` mobile integration, and it does not
make the mobile or Chromium gates above true. Existing updater authority and
public
[`v0.4.0`](https://github.com/DimazzzZ/namehold-wallet/releases/tag/v0.4.0)
remain at `DimazzzZ/namehold-wallet`. The mirror cannot select or release a
next version until release-repository ownership, updater endpoint, signing-key
custody, and continuity for existing installations are resolved together.

## Release order

Publication remains an explicit release-owner action. Once authorized, the
dependency order is:

1. Publish the 17 `hns-rs 0.2.0` crates from exact selected source
   `c76cd6f`, then verify each immutable registry archive and VCS identity.
2. Reconfirm that upstream archive set, then independently publish the 19
   `hns-dane-engine 0.2.0` crates from its final qualified head and the 14
   `hns-wallet-rs 0.1.0` crates from their final qualified head.
3. Requalify and package mobile `0.5.9` and Chromium `0.5.6` from their
   selected exact heads. Store signing, screenshots, catalog review, and upload
   are separate product actions.
4. Release node `0.3.5`, Bootstrap `0.2.2`, the first Crawler distribution,
   or the private MeshMine evaluation artifact only under each repository's own
   artifact contract and authority.

No candidate above has been tagged or published by this preparation work.
Tagging, package upload, store upload, signing, public StackScript mutation, and
GitHub Release creation remain separate authorized actions.

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
