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
> "Adversarial novelty pass"); every change is listed in §8.

## 1. Thesis
Test whether Paper 3's two central results transfer from outdoor streets to
anatomical place recognition (endoscopy): (a) frozen VPR representations are
strong, and (b) retrieval error splits into a part that *some* model in a
diverse zoo recovers and a part that *none* does — a **zoo-relative oracle
ceiling** (after [waheed2021improving]), not a model-independent limit.

The street-vs-anatomy question ("is the ceiling a property of recognition, or of
cities?") is a **test**, not a claim: two domains (one partly phantom) can give
evidence for or against recurrence, never proof of domain generality. A
cross-environment, argued method-independent ambiguity measure already exists
([wang2025topobench]); the P4 question is only whether the *oracle-ceiling
structure* recurs. Streets-vs-colon comparisons confound domain with set-up
(ground-truth kind, frame rate, exclusion window) [schubert2021makes].

## 2. Honest novelty position (per contribution)

| # | Contribution | Verdict | What may be claimed |
|---|---|---|---|
| C0 | Endoscopic localization as place recognition / retrieval | **Pre-empted — not claimed** | Nothing. Prior: [ye2017image], [ma2021colon10k], [morlana2021selfsupervised], [azagra2023endomapper], [morlana2024colonmapper], [morlana2024topological]; surgical: [gaubatz2022location], [wei2023stereo]; bronchoscopy: [keuth2024airway], [tomasini2025online], [tomasini2026bronchotop]. |
| C1 | Zero-shot benchmark of the frozen outdoor VPR zoo | **Incremental; "first" is dead** | "A *systematic* zero-shot benchmark of the *2022–2025* frozen VPR zoo (NetVLAD as historical anchor), plus AnyLoc and raw DINOv2, under endoscopist GT (Colon10k) and overlap GT (C3VD/C3VDv2), with a street-protocol transfer gap." [morlana2021selfsupervised] already ran an off-the-shelf landmark/city-trained retrieval CNN on real-colonoscopy GT; [ma2021colon10k] evaluated "different existing place recognition techniques" (which ones: unread). Off-the-shelf models appear as unmeasured components ([li2026automated], [li2026raul], [wei2023stereo], LoFTR/LightGlue in [morlana2024colonmapper]/[morlana2024topological]) and in training-free FM re-identification ([soberanismukul2026global]). |
| C2 | Ceiling in the body | **Novel as a measurement; the core** | "A zoo-relative oracle ceiling (after [waheed2021improving]; Paper 3's estimator, reused unchanged), measured for the first time on endoscopic place-recognition GT, as far as we found." Split precedent: [vasconcelos2004minimum]. "Irreducible" always qualified: *for this zoo, this GT and this exclusion window*. This is the only sentence in P4 allowed to contain "first". |
| C3 | Representation diagnosis | **Incremental; premise contested** | "A feature-reliance diagnosis of place retrieval: shape/texture/colour cue suppression (after [burgert2025imagenettrained]) on C3VDv2's geometry × texture design", hypotheses two-sided. [geirhos2018imagenettrained]'s texture-bias premise is contested by [burgert2025imagenettrained]; never cite Geirhos alone for a CNN-vs-ViT texture story. Causal wording only for phantom contrasts, and only "in phantoms". |
| C4 | Domain-generality of the ceiling | **Novel only as a question; most overreach-prone** | "Does the zoo-relative ceiling structure recur in anatomy, and does it agree with a TOPO-Bench-style ambiguity score on the same data?" Evidence for/against, not proof. Never a headline if C2 is null. |

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
- **In progress, not merged, no results:** a separate agent is implementing the
  endoscopy data layer on branch `paper/p4-endoscopy-loaders` (worktree
  `vpr-testtime-wt/p4-endoscopy`): Colon10k interval-GT loader, C3VD pose+angle
  GT, EndoMapper/REAL-Colon label interfaces, FOV/specular preprocessing,
  random-ranking and handcrafted baselines, and the pre-registration decision
  machinery (numeric thresholds left to the owner). Nothing from it may be
  claimed until it is merged, run on data, and exported via `make snapshot`.
- **Paper scaffold (this repo):** `Makefile` (from the vprbench template),
  `paper/main.tex` + `paper/sections/*.tex` (llncs, anonymized),
  `paper/splncs04p4.bst` (presentation-only splncs04 variant, see §7),
  `generated/vprresults.sty` (via `make sty`; no `numbers.yaml`, no
  `snapshot/`). Every result and every pre-registered threshold is `\pending`.

## 4. Binding design decisions (from positioning.md; the method must follow them)
- **Zoo.** Outdoor: NetVLAD, CosPlace, EigenPlaces, MixVPR, BoQ, SALAD, MegaLoc.
  Generic: raw DINOv2 (CLS and GeM) and AnyLoc-GeM (strictly zero-shot).
  AnyLoc-VLAD builds its vocabulary from target database images, so it is a
  separate "target-adapted" condition, outside every zero-shot claim.
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
- **Ceiling reporting:** per GT definition, per window, per feature family
  (outdoor, generic, medical, union — the irreducible fraction is
  embedding-dependent [renggli2021evaluating]); zoo-size curve and
  leave-one-model-out; a random-ranking **chance ceiling** (union of |Z| random
  rankers), because Colon10k positive intervals can be wide.
- **kNN-BER bracket:** demoted to a labelled heuristic or dropped; never
  corroboration ([wheat2025bayes]); never "Bayes limit".
- **C3VD/C3VDv2 GT:** view overlap from depth + pose is primary; pose radius
  alone is never used (SEALOC failure mode, [larsen2026longterm]); pose + angle
  is the secondary definition. Prefer C3VDv2 (clean/debris twins on identical
  trajectories). Report both definitions.
- **Informativeness:** stratify irreducible queries by frame quality (blur,
  specular area, exposure / wall contact), so they are not counted as aliasing.
- **E3:** primary REAL-Colon section labels [biffi2025temporal] (60 procedures,
  4 centres), patient- and centre-held-out; CAS-Colon [song2025cascolon]
  secondary (CC BY-NC-ND: no redistribution of derived data); EndoMapper
  (region labels on 5 sequences only) tertiary, leave-one-sequence-out.
  Supervised references (EndoMapper Table 7; ColonTCN) are reported beside the
  frozen probe, not as competitors. HyperKvasir landmarks are dropped
  (saturated by frozen DINOv2 [dermyer2025endodino]).
- **C3 protocol:** cue suppression after [burgert2025imagenettrained];
  DAR-style distractor analysis on C3VDv2 debris twins [kim2026visual];
  grayscale ablation [ismagilov2026channel]; two-sided.
- **C4 protocol:** set-up-matched comparison or an explicit statement that
  domain and set-up are confounded [schubert2021makes]; TOPO-Bench-style score
  on the same data [wang2025topobench].
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

## 6. Open items that block submission (not resolvable from the notes)
- Read the Colon10k ISBI results table: *which* existing techniques, and
  whether any were off-the-shelf (paywalled; abstract only read).
- Check Morlana's 2025 PhD thesis for descriptor comparisons (no metadata record).
- Identify the foundation model in [soberanismukul2026global] (closed access).
- Verify availability of ColonMapper's EndoMapper protocol labels, and of
  GastroNet-5M / EndoDINO / Radenović-GeM weights.
- Confirm the harness implements depth+pose **overlap** GT for C3VD (the
  in-progress branch is described as pose+angle GT only).
- Decide how to reference the companion Paper 3 in an anonymized submission
  (it is not in the bib).
- The positioning questions of the original §6 are answered in
  `notes/literature.md` and `notes/positioning.md`.

## 7. Target venue
MICCAI (LNCS `llncs.cls`, 8 pages + refs) as default; IEEE TMI / MedIA as the
journal alternative. The draft body fits 8 pages. The **reference list does
not fit MICCAI's ~2-page allowance**: the must-cite core (52 keys cited) takes
~5 pages in splncs04 (full author lists, DOIs). The paper uses
`paper/splncs04p4.bst`, a presentation-only splncs04 variant that omits the
duplicate URL when a DOI exists and the audit `note` field; the bib itself is
untouched. Cutting references, truncating author lists, or reverting to stock
splncs04 is an owner decision.

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
