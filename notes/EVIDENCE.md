# Paper 4 — Evidence Brief ("Generalization": anatomical VPR)

> Status: **STAGED — zero results.** No data downloaded; no dataset access
> agreements signed. The plan is `vpr-testtime/docs/papers/PAPER4_OUTLINE.md`,
> **as corrected by this file** (see §8): where the outline and this file
> disagree, this file wins.
>
> **Hard rule:** this paper has *no* results section content until the Colon10k
> go/no-go probe runs, and that needs the user's explicit go-ahead (plus data
> access agreements). The scaffold may contain the method, protocol, and
> related work. Until a `numbers.yaml` exists, every result slot is a
> `\pending{...}` marker (it renders `[PENDING: ...]` in draft and **fails the
> build** under `\usepackage[final]{generated/vprresults}`); once results exist,
> each slot becomes a `\res{key}` generated from a hash-verified snapshot. No
> number is ever typed by hand.
>
> This file is the single source of truth for what P4 may claim. It was
> corrected on 2026-09-25 against `notes/positioning.md` (including its
> "Adversarial novelty pass"); every change is listed in §8. It was revised
> again on 2026-09-25 after a Reviewer-2 pass on the draft; those changes are
> listed in §9 and answered finding by finding in `notes/review_response.md`.
>
> **Canonical protocol.** For the Colon10k gate, the ground-truth definitions
> and the baselines, the canonical document is
> `vpr-testtime/docs/papers/P4_PREREGISTRATION.md` with its implementation
> `vprbench/analysis/preregistration.py` (branch `paper/p4-endoscopy-loaders`,
> `eac266d` as cited by the review; the paper was matched to the branch head
> `eeba592`, unmerged, unsigned). The paper's §4 restates it; the paper's E2/E4
> rules are additions that must be merged into it before it is signed
> (list in `notes/review_response.md`, M1). Nothing is registered: the paper
> says "pre-specified", never "pre-registered", until a public, timestamped
> registry record of the signed document exists.

## 1. Thesis
Test whether Paper 3's two central results transfer from outdoor streets to
anatomical place recognition (endoscopy): (a) frozen VPR representations are
strong, and (b) retrieval error splits into a part that *some* model in a
diverse zoo recovers and a part that *none* does — a **zoo-relative oracle
ceiling** (after [waheed2021improving]), not a model-independent limit.

The street-vs-anatomy question ("is the ceiling a property of recognition, or of
cities?") is a **test**, not a claim: two domains (one partly phantom) can give
evidence for or against recurrence, never proof of domain generality.
**(review, 2026-09-25)** In the MICCAI paper it is only a *descriptive*
side-by-side (C4): Paper 3 has not established a street ceiling structure to
test recurrence against (§2 C4). A
cross-environment, argued method-independent ambiguity measure already exists
([wang2025topobench]); the P4 question is only whether the *oracle-ceiling
structure* recurs. Streets-vs-colon comparisons confound domain with set-up
(ground-truth kind, frame rate, exclusion window) [schubert2021makes].

## 2. Honest novelty position (per contribution)

| # | Contribution | Verdict | What may be claimed |
|---|---|---|---|
| C0 | Endoscopic localization as place recognition / retrieval | **Pre-empted — not claimed** | Nothing. Prior: [ye2017image], [ma2021colon10k], [morlana2021selfsupervised], [azagra2023endomapper], [morlana2024colonmapper], [morlana2024topological]; surgical: [gaubatz2022location], [wei2023stereo]; bronchoscopy: [keuth2024airway], [tomasini2025online], [tomasini2026bronchotop]. |
| C1 | Zero-shot benchmark of the frozen outdoor VPR zoo | **Incremental; "first" is dead** | "A *systematic* zero-shot benchmark of the *2022–2025* frozen VPR zoo (NetVLAD as historical anchor), plus AnyLoc and raw DINOv2, under endoscopist GT (Colon10k) and overlap GT (C3VD/C3VDv2), with a street-protocol transfer gap." [morlana2021selfsupervised] already ran an off-the-shelf landmark/city-trained retrieval CNN on real-colonoscopy GT; [ma2021colon10k] evaluated "different existing place recognition techniques" (which ones: unread). Off-the-shelf models appear as unmeasured components ([li2026automated], [li2026raul], LoFTR/LightGlue in [morlana2024colonmapper]/[morlana2024topological]) and in training-free FM re-identification ([soberanismukul2026global]). [wei2023stereo] is an outdoor-VPR-*derived* component (a student distilled from NetVLAD on Google Landmarks, SCARED and in-vivo clips), **not** zero-shot (review M9). |
| C2 | Ceiling in the body | **Novel as a measurement; the core** | "A zoo ceiling, the any-correct oracle over a model zoo (after [waheed2021improving]), measured for the first time on endoscopic place-recognition GT, as far as we found." Terminology is Paper 3's: *zoo ceiling*, *zoo-unsolved* (never a bare "irreducible"), *selection-recoverable* (never a bare "recoverable"), *headroom*. "Zoo-unsolved" always qualified: *for this zoo, this GT and this exclusion window*. The paper states the four bound directions (§3.3): upper bound only on per-query selectors returning one member's list; lower bound on recognizability only up to chance hits and GT artefacts; no bound on models outside the zoo; no bound on fusion, ranked-list voting, re-ranking or adaptation. The estimator is defined self-contained in the paper (implementation: `oracle_decomposition`, vpr-testtime main `08b3212`; its code is identical on the P3 branch, only docstrings differ); the companion Paper 3 is not referenced in the anonymized paper. [vasconcelos2004minimum] is not cited (space); if cited, only as "conceptually analogous", since its irreducible term is the Bayes error. This is the only sentence in P4 allowed to contain "first". |
| C3 | Representation diagnosis | **Incremental; premise contested** | "A feature-reliance diagnosis of place retrieval: shape/texture/colour cue suppression (after [burgert2025imagenettrained]) on C3VDv2's geometry × texture design", hypotheses two-sided. [geirhos2018imagenettrained]'s texture-bias premise is contested by [burgert2025imagenettrained]; never cite Geirhos alone for a CNN-vs-ViT texture story. Causal wording only for phantom contrasts, and only "in phantoms". |
| C4 | Street side by side | **Descriptive only** | "The same ceiling statistics, with the same estimator and zoo, on the street data of the transfer gap, reported beside the colon values." No recurrence verdict and no "as on streets": Paper 3 has not established a street "ceiling structure" (its EVIDENCE §3–§5: zoo-size curves, chance null and DINOv2-era members still pending), so nothing may be defined relative to it until P3 quantities are `\res`-backed and citable. The TOPO-Bench-style score is dropped from the protocol (its definition was read once from the arXiv HTML and could not be pre-specified); [wang2025topobench] is cited only to say we propose no ambiguity measure. Never a headline if C2 is null. |

## 3. What exists
- Reusable code in vpr-testtime (main @ `08b3212`):
  `vprbench/analysis/recognizability.py` (`oracle_decomposition` is
  GT-agnostic: it takes per-query correctness and is reused unchanged), the
  model zoo, provenance store, guard, and the paper tooling
  (`vprbench/paper`, `docs/PAPER_TOOLING.md`).
  - **Do not quote the estimator's docstring.** Its "model-independent" and
    "has NEVER been applied to VPR" statements are wrong
    ([waheed2021improving]; Paper 3 positioning).
  - The zoo in `vprbench/models/` (as of `08b3212`) has NetVLAD, CosPlace,
    EigenPlaces, MixVPR, BoQ (ResNet-50 and DINOv2), SALAD, MegaLoc, AnyLoc,
    CricaVPR, SelaVPR. It has **no raw-DINOv2 wrapper and no medical-arm
    wrappers** (EndoViT, Endo-FM, Hirsch et al.); both are required by §4.
  - **AnyLoc in the harness is AnyLoc-VLAD only** (`vprbench/models/anyloc.py`:
    DINOv2 ViT-G/14, layer 31, value facet, 32 clusters) with the *released*
    vocabularies of other domains (`aerial`, `indoor`, `urban`, `hawkins`,
    `laurel_caverns`). That condition is strictly zero-shot. There is **no
    AnyLoc-GeM** and **no target-vocabulary AnyLoc-VLAD** (building a
    vocabulary from the target database is not implemented).
  - Backbone facts verified in the wrappers: SALAD is DINOv2-B (comment);
    BoQ-DINOv2 is trained and run at 224×224 (`_INPUT_SIZE`); the MegaLoc
    wrapper only *probes* its output dimension at 322×322, which is not
    necessarily its evaluation resolution. The MegaLoc and BoQ-DINOv2 backbone
    *sizes* are not stated in the wrappers, so the backbone-matched raw-DINOv2
    pairs of H1b are a Table 1 item.
- **In progress, not merged, no results:** a separate agent is implementing the
  endoscopy data layer on branch `paper/p4-endoscopy-loaders` (worktree
  `vpr-testtime-wt/p4-endoscopy`, head `eeba592`): Colon10k interval-GT loader, C3VD pose+angle
  GT, EndoMapper/REAL-Colon label interfaces, FOV/specular preprocessing,
  random-ranking and handcrafted baselines, and the pre-registration decision
  machinery (numeric thresholds left to the owner). Nothing from it may be
  claimed until it is merged, run on data, and exported via `make snapshot`.
  What that branch does **not** do (read 2026-09-25):
  - the C3VD loader does **not** verify that recordings or textures share a
    world frame ("Callers state world frames explicitly"), and **view-overlap
    GT is not implemented** (pose-radius + viewing-angle only);
  - `EndoscopyPreprocess` is **not wired into `run()`** (the descriptor cache
    key lacks the transform); its thresholds are untuned defaults. Algorithm
    (at `eeba592`, after fix F9): FOV = convex hull of the lit components
    (max-channel threshold, opening) whose area is at least a fraction of the
    largest one's, plus a circle fit; specular = HSV V ≥ threshold and
    S ≤ threshold, dilated; masked pixels set to a constant fill colour, then
    mask-aware crop/resize (no inpainting, no token dropping);
  - the gate (`decide_gate`) is GO / NO_GO / OWNER_REVIEW with
    `min_models_passing` and a "meaningful split"; it has **no chance-ceiling
    term** and **no multiplicity correction** across models (one `ci_level`
    for every bound); the bootstrap is a cluster percentile bootstrap.
  - Changes between `eac266d` (cited by the review) and `eeba592` that the
    paper now follows: the window is fixed in §8 **in frames of the image
    list** (the id-unit value goes to §8c); `db_scope` is a §8 field, checked
    against the scope derived from the GT (`GateEvidence.from_gt`);
    `min_irreducible_frac` / `min_recoverable_frac` = `-inf` disables that half
    of the split (otherwise a zero zoo-unsolved fraction can never reach GO);
    ties are counted pessimistically and tie-sensitive queries reported;
    sign-off is in **two dated stages** (A: §8/§8b before acquisition;
    B: §8c file facts after acquisition, before any descriptor). The branch is
    still moving: re-check it before signing.
- **Paper scaffold (this repo):** `Makefile` (from the vprbench template),
  `paper/main.tex` + `paper/sections/*.tex` (llncs, anonymized),
  `paper/splncs04p4.bst` (presentation-only splncs04 variant, see §7),
  `generated/vprresults.sty` (via `make sty`; no `numbers.yaml`, no
  `snapshot/`). Every result and every pre-registered threshold is `\pending`.

## 4. Binding design decisions (from positioning.md; the method must follow them)
- **Gate, GT definitions, baselines: the canonical document rules** (header).
  GO = at least `min_models_passing` non-trivial models AND a meaningful split
  (LB of the zoo-unsolved fraction > `min_irreducible_frac` and LB of the best
  model's selection-recoverable fraction > `min_recoverable_frac`); NO_GO = no
  model beats random (→ section probe or shelve); anything else =
  OWNER_REVIEW, for which no action is defined (anything done is post hoc).
  ONE handcrafted baseline (`raw_thumbnail` or `color_histogram`). H-E1a
  (transfer gap per model) is a two-sided test, not "descriptive". The chance
  ceiling is reported beside the split, not gated on. Colon10k has **no
  validation split**: every case enters every statistic.
- **Zoo.** Outdoor: NetVLAD, CosPlace, EigenPlaces, MixVPR, BoQ, SALAD, MegaLoc.
  Generic: raw DINOv2 (CLS and GeM), backbone-matched to each contrasted model,
  and **AnyLoc-VLAD with a released off-domain vocabulary** (strictly
  zero-shot; the only AnyLoc the harness has). AnyLoc-VLAD with a vocabulary
  built from target database images is a separate "target-adapted" condition,
  outside every zero-shot claim (not implemented). AnyLoc-GeM joins only if a
  wrapper is written. *Backbone family* (CNN / DINOv2 incl. the generic arm /
  medical) is distinct from *arm* (outdoor / generic / medical): E2's "two or
  more families" rule is over families, which share no backbone.
  Medical arm (frozen): EndoViT, Endo-FM, Hirsch et al.; GastroNet-5M and
  EndoDINO only after weight availability is verified. Optional: DINOv3,
  CliqueMining; the Radenović landmark-trained GeM model of
  [morlana2021selfsupervised] as historical anchor if its weights are obtainable.
  Excluded by design (and said so): reference-set fine-tuning
  [zaffar2025overlooked], adapters, re-ranking.
- **E1 is two-sided.** The outline's "Hypothesis: large drop (finding)" is
  withdrawn ([morlana2021selfsupervised]'s zero-shot gap was 3.9–8.0 R@1
  points; frozen DINOv2 is known to transfer [dermyer2025endodino],
  [parolari2026contrastive]). Contrasts: DINOv2- vs CNN-based VPR models;
  DINOv2-based VPR models vs raw DINOv2; outdoor zoo vs medical arm.
- **"Non-trivial recall" is numeric and fixed before data:** a margin over a
  random-ranking baseline and over a raw-pixel/handcrafted baseline, at the
  lower bound of a sequence-level (cluster) bootstrap CI. Thresholds are an
  **owner decision** (still unset; `\pending` in the paper).
- **Temporal-exclusion window** on Colon10k with a reported sweep
  ([morlana2021selfsupervised]: off-the-shelf R@1 fell ~15 points from D = 5 to
  D = 15).
- **Ceiling reporting:** per GT definition, per window, per arm, per backbone
  family and for the union (the fraction is zoo-relative by construction);
  zoo-size curve and leave-one-model-out; headroom; a random-ranking **chance
  ceiling** (union of |Z| random rankers), because Colon10k positive intervals
  can be wide.
- **Chance-adjusted E2 rules** (review M7, S10). Adding members never raises
  the zoo-unsolved fraction I, so "representation failure" needs
  LB(ΔI − ΔI_rand) > δ_Δ, with ΔI_rand the expected drop from adding |Z'|
  random rankers. "Stable" = UB of the max−min spread across windows (and
  across the two geometric GTs on phantoms) ≤ ε; zoo size is not a stability
  axis. "Saturated" = UB(last zoo-size increment − expected gain of one random
  ranker) < η.
- **Ground-truth audit** (review M8). Before any Colon10k query is read as view
  ambiguity, a random sample of zoo-unsolved queries is labelled blind (GT
  miss / ambiguous view / low quality / representation failure); no ambiguity
  reading if UB(GT-miss share) > γ.
- **kNN-BER bracket:** dropped from the paper; never corroboration
  ([wheat2025bayes]); never "Bayes limit".
- **C3VD/C3VDv2 GT:** view overlap from depth + pose is primary; pose radius
  alone is never used (SEALOC failure mode, [larsen2026longterm]); pose + angle
  is the secondary definition. Prefer C3VDv2 (clean/debris twins on identical
  trajectories). Report both definitions.
- **Informativeness:** stratify zoo-unsolved queries by frame quality (blur,
  specular area, exposure / wall contact), so they are not counted as aliasing.
- **C3VD/C3VDv2 design** (review S7, M4). E2 pairs recordings of one phantom
  and texture on different trajectories; clean/debris twins (same trajectory)
  enter only E4. Resampling clusters are phantom segments, not recordings.
  Video pairs, clusters and world frames are fixed from the release structure
  before any model runs (the release's per-segment video layout was not
  verified here). A shared world frame across recordings/textures is an
  unverified precondition. Overlap GT: directional (query→database), valid
  pixels = in FOV with depth in the released valid range, released fisheye
  calibration, depth-consistency tolerance ε_d.
- **E3 (not in the MICCAI paper; review M13/S11):** the section probe is
  reported separately (it is also the canonical NO_GO fallback). Its plan is
  unchanged: primary REAL-Colon section labels [biffi2025temporal] (60
  procedures, 4 centres), patient- and centre-held-out; CAS-Colon
  [song2025cascolon] secondary (CC BY-NC-ND: no redistribution of derived
  data); EndoMapper (region labels on 5 sequences only) tertiary,
  leave-one-sequence-out. Supervised references (EndoMapper Table 7; ColonTCN)
  beside the frozen probe, not as competitors. HyperKvasir landmarks dropped
  (saturated by frozen DINOv2 [dermyer2025endodino]). Before it runs, fix the
  S11 items: label set (sections only, or all nine REAL-Colon categories incl.
  outside/insertion), the "chance" macro-F1 (uniform vs class prior), kNN k,
  probe regularisation and the data they are chosen on; kNN is not "linear";
  a per-frame probe is not comparable to temporal ColonTCN.
- **E5 (sequence priors): dropped** (review S16). Paper 3 withdrew its St Lucia
  TPR run (position-sorted defect), its Urban-MM TPR is validated on synthetic
  data only, and TPR is a pre-empted primitive ([schubert2021beyond],
  [vysotska2016lazy] in P3's bib).
- **C3 protocol:** cue suppression with the operators of
  [burgert2025imagenettrained] (fixed in Table 1 from that work); DAR-style
  distractor analysis as defined by [kim2026visual]: debris-laden queries
  against their clean twins (same places) **plus debris-laden frames of other
  segments as distractors (same condition, different places)** — twins are
  the same place, never distractors; grayscale ablation (the
  [ismagilov2026channel] precedent is not cited in the paper, for space);
  two-sided. E4(a) axial share: the wrong top-1 of the dataset's best member,
  centreline from the released phantom mesh (if none is released, E4(a) is
  not run), against a **distance-matched** non-positive null. The "confident
  wrong matches" figure (old E4(c)) is dropped.
- **C4 protocol:** descriptive side-by-side on the street data of the
  transfer gap, with an explicit statement that domain and set-up are
  confounded [schubert2021makes]. No TOPO-Bench-style score (see §2 C4).
- **Head-to-head:** ColonMapper's EndoMapper Seq_027/Seq_035 protocol (84/78
  queries, covisibility labels, mAP) if its labels are available (unverified).

## 5. Must not
- Download any dataset or model weights.
- Write any number as a result; type any number into LaTeX outside `\res{}`.
- Claim clinical utility.
- Claim "first place recognition in the body"; "we introduce anatomical place
  recognition"; "we formulate endoscopic localization as retrieval".
- Claim "first zero-shot / training-free localization in endoscopy", "first use
  of outdoor VPR models in the body", "first benchmark of existing VPR methods on
  colonoscopy", or "first zero-shot benchmark".
- Write "all prior work fine-tunes a medical descriptor or uses an endoscopy
  foundation model" (false: [soberanismukul2026global], [li2026automated],
  outdoor LoFTR in [morlana2024colonmapper]).
- Present "a large domain gap" as a discovery ([keetha2024anyloc],
  [chen2023coloscrl]); write "outdoor VPR fails in the body" as a blanket
  statement; use "universal" in any title-level claim.
- Call the ceiling "model-independent", "the Bayes limit/error", or "the"
  aliasing measure; write "we prove/establish the Bayes limit"; use "irreducible"
  without "for this zoo, this GT and this exclusion window".
- Write "the colon is intrinsically aliasing-bound" unless E2 shows it under
  both GT definitions (endoscopist and geometric) and more than one feature
  space; write "first to observe axial aliasing in the colon"
  ([jiang2025c3vdreg] got there first for registration).
- Write "VPR features rely on texture rather than geometry" as a causal claim
  from real-data breakdowns.
- Write "the ceiling is a universal property of recognition", "we prove the
  ceiling is domain-general", "first cross-domain measure of VPR difficulty",
  or use C4 as a headline when C2 is null.
- Write "real-patient pose GT does not exist". The precise wording is: "no
  public dataset pairs real-patient endoscopic images with frame-level pose"
  [cold2025mapping] (real-data GT in SimCol3D is COLMAP pseudo-GT
  [rau2024simcol3d]).
- Hard-code a Colon10k image count: 10,126 (paper abstract, EndoMapper Table 1)
  vs 10,216 (sum of the official page's per-case counts) is unreconciled; count
  the files at acquisition.
- (review, 2026-09-25) Write "pre-registered", "fixed before any data" or
  "pre-registration" as a property of this study until the signed canonical
  document has a public, timestamped registry record; use "pre-specified" /
  "to be fixed". Say "in silico" for the phantoms (they are physical silicone
  phantoms filmed by a colonoscope; write "phantom-only"). Write "any
  (available) representation" (the zoo is finite). Write a bare "recoverable"
  or "irreducible"; use "selection-recoverable" and "zoo-unsolved". Say the
  oracle bounds fusion, voting over ranked lists, re-ranking or adaptation.
  Read "zoo-unsolved" as view ambiguity before the GT audit. Define anything
  "as on streets" before Paper 3 has `\res`-backed street results. Attribute
  to the code a check it does not do (e.g. "the loader checks" a shared world
  frame). Call [wei2023stereo] zero-shot (it is distilled on surgical video),
  cite [wei2025breaking] for "distance-threshold GT overestimates recall" (only
  [larsen2026longterm] says that), write "compared only for object-level
  retrieval" ([kim2025improving] is class-level), or "none measures per-model
  retrieval quality" ([morlana2021selfsupervised]; ColonSLAM's LightGlue
  baseline). Use twins as DAR distractors.

## 6. Open items that block submission (not resolvable from the notes)
- Read the Colon10k ISBI results table: *which* existing techniques, and
  whether any were off-the-shelf (paywalled; abstract only read).
- Check Morlana's 2025 PhD thesis for descriptor comparisons (no metadata record).
- Identify the foundation model in [soberanismukul2026global] (closed access).
- Verify availability of ColonMapper's EndoMapper protocol labels, and of
  GastroNet-5M / EndoDINO / Radenović-GeM weights.
- Implement depth+pose **overlap** GT for C3VD/C3VDv2 (confirmed absent on the
  branch: pose+angle only), and verify whether recordings and textures share
  a world frame (the loader does not check this).
- (review) The owner fills and signs the canonical document, **after merging
  the paper's additions into it** (E2 verdict rules, audit, phantom design,
  E4, C4, Bonferroni `ci_level` rule, Holm families; list in
  `notes/review_response.md`, M1), then files a public, timestamped
  registration (e.g. OSF or AsPredicted) citing the commit of the signed file,
  and the paper cites it anonymously. Until then the paper must say
  "pre-specified".
- (review) Decide the OWNER_REVIEW actions in the canonical document before
  signing (the document currently defines none), and whether to add a
  chance-ceiling gate term or a simultaneous (max-statistic) bound; any such
  change goes into the document and `preregistration.py` first, then the paper.
- (review) Identify the E2 audit annotators (an endoscopist is likely needed to
  judge "same place") and the audit sample size.
- (review) Confirm that C3VD/C3VDv2 release phantom meshes (E4(a) needs a
  centreline; otherwise E4(a) is not run) and read the release's per-segment
  video layout (which recordings pair as query/database).
- (review) Write the raw-DINOv2, medical-arm and AnyLoc-GeM wrappers, a
  target-vocabulary AnyLoc-VLAD, and wire `EndoscopyPreprocess` into `run()`
  (cache key first).
- The companion Paper 3 is **not referenced** in the anonymized paper (C4 no
  longer depends on it; the estimator is defined self-contained). If a later
  version cites it, supply an anonymized copy as supplementary material.
- The positioning questions of the original §6 are answered in
  `notes/literature.md` and `notes/positioning.md`.

## 7. Target venue
MICCAI (LNCS `llncs.cls`, 8 pages + refs) as default; IEEE TMI / MedIA as the
journal alternative. **After the review revision the PDF is 10 pages: the body
ends on page 8 and the references run from page 8 to page 10** (32 keys).
This was reached by (a) dropping E3 and E5 and merging §6 into the protocol,
(b) cutting cited keys from 52 to 32, and (c) two more presentation-only
changes in `paper/splncs04p4.bst` (first author + "et al." for lists of more
than three; no URL for arXiv entries whose `howpublished` already prints the
id). The bib itself is untouched. Whether the venue accepts truncated author
lists was not verified; restoring full lists (`max.names`) costs 17
reference lines, about a third of a page (measured).
Keys removed from the citation list (21; all still in the bib and the lock):
biffi2024realcolon, biffi2025temporal, cold2025mapping, cover1967nearest,
dermyer2025endodino, elvira2024cudasiftslam, gorry2025imagebased,
huix2024natural, ismagilov2026channel, jong2026gastronet5m,
lamarca2021defslam, ma2021rnnslam, raghu2019transfusion,
renggli2021evaluating, torii2015visual, vasconcelos2004minimum,
wei2023stereo, wei2025breaking, wheat2025bayes, ye2017image,
zaffar2025overlooked. Added (1): kim2025improving (review M11). **Results will not fit as-is**: when they exist, Table 1
moves to the public registration (cited), or the paper moves to TMI/MedIA.
That is an owner decision.

## 8. Change log (2026-09-25, corrections from notes/positioning.md)
1. Status: result slots are `\pending{}` until a spec exists (was "`\res{}`
   placeholder"), matching `docs/PAPER_TOOLING.md`'s staged-paper case.
2. §1: "model-independent recognizability ceiling" → zoo-relative oracle
   ceiling after [waheed2021improving]; the "recognition vs cities" question
   reframed as a test, qualified by [wang2025topobench] and [schubert2021makes].
3. §2 C0: added [ye2017image], [morlana2021selfsupervised],
   [gaubatz2022location], [wei2023stereo] to the pre-empting prior.
4. §2 C1: "Open: a zero-shot benchmark of the frozen outdoor zoo" narrowed to a
   *systematic* benchmark of the *2022–2025* zoo; "first" dropped permanently
   ([morlana2021selfsupervised] off-the-shelf baseline; [ma2021colon10k]
   evaluated existing techniques).
5. §2 C2: attributed the oracle to [waheed2021improving] and the split to
   [vasconcelos2004minimum]; "model-independent" removed; kNN-BER demoted
   ([wheat2025bayes]); the mandated "first ... as far as we found" wording fixed.
6. §2 C3: texture-bias premise marked contested ([burgert2025imagenettrained]);
   reframed as a cue-suppression feature-reliance diagnosis.
7. §2 C4: reframed as a test; qualified by [wang2025topobench].
8. §3: recorded the estimator-docstring errors, the missing raw-DINOv2 and
   medical-arm wrappers, the in-progress loader branch, and the scaffold.
9. §4 (new): the binding design decisions (zoo additions, two-sided E1, numeric
   non-trivial recall, exclusion window, chance ceiling, overlap GT, quality
   strata, E3 dataset move, C3/C4 protocols, head-to-head).
10. §5: extended the "Must not" list with every "Never write" item in
    positioning.md, the precise pose-GT wording, and the Colon10k count rule.
11. §6: replaced the answered positioning questions with the blocking
    pre-submission checks.
12. §7: recorded the reference-length problem and the presentation-only bst.

## 9. Change log (2026-09-25, Reviewer-2 revision; details in notes/review_response.md)
1. Header: the harness document `P4_PREREGISTRATION.md` (+ `preregistration.py`,
   `eac266d`; matched at `eeba592`) is canonical for the gate, GT and baselines; the paper matches it
   (M1). "Pre-specified", not "pre-registered", until a registry record exists
   (M2).
2. §1, §2 C2/C4: Paper 3 terminology (zoo ceiling, zoo-unsolved,
   selection-recoverable, headroom) and the four bound directions (M6, S17);
   C4 reduced to a descriptive side-by-side, no street "ceiling structure"
   assumed, TOPO-Bench-style score dropped (M3, S15); companion paper not
   referenced (S17, D6).
3. §3: verified harness facts (AnyLoc-VLAD only, with released off-domain
   vocabularies; no AnyLoc-GeM; no overlap GT; no shared-frame check;
   preprocessing unwired; gate has no chance-ceiling term and no multiplicity
   correction; wrapper backbone facts) (M4, S8, S13, S14).
4. §4: canonical gate; AnyLoc conditions; backbone family vs arm;
   chance-adjusted E2 rules; GT audit; C3VD/C3VDv2 design; E3 moved out of the
   paper with the S11 checklist; E5 dropped; DAR distractors corrected; E4(a)
   distance-matched null and mesh centreline; old E4(c) dropped; kNN-BER dropped
   (M7, M8, S7, S10, S11, S12, S16).
5. §5: new "must not" wording rules from the review (M2, M5, M6, M8, M9–M12,
   S6, S12).
6. §6: new blocking items (merge + sign + register the canonical document;
   OWNER_REVIEW actions; audit annotators; meshes and video layout; wrappers
   and preprocessing wiring; overlap GT and shared frame).
7. §7: the PDF is 8 + 2 pages; 21 keys removed from the citation list, 1 added;
   two more presentation-only bst changes; results will not fit without moving
   Table 1 to the registration or changing venue (M13).
8. Paper synced to the canonical branch head `eeba592` (the review cited
   `eac266d`): window fixed in frames of the image list, `db_scope` as a
   document field, −∞ disables a split bound, pessimistic ties, two-stage
   signing (thresholds before acquisition; file facts after acquisition,
   before any descriptor), FOV = convex hull of the large lit components.
