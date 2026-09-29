# Paper 4 — Response to Reviewer 2, round 2 (2026-09-28)

Scope: the results paper at `bb4805f` (one-shot Colon10k test gate, GO).
Nothing was run. The P4 test split was not touched, and neither was its lock.
No dataset or weight was downloaded. No new number was typed: every added
number is a `\res` value from the unchanged, hash-verified snapshot
(`source_commit` `f17b5cc`). The vpr-testtime repository was read and not
edited.

After the revision:
- `make check` passes: 8 snapshot files verified clean against `f17b5cc`,
  generated files fresh, texlint 0 violations and 0 pragmas, bibcheck
  0 errors.
- `make pdf` gives 10 pages: body on pages 1–8, references on 9–10 (27 keys).
  There are no overfull boxes and no undefined citations.
- The PDF's Title and Author metadata are empty. Its text contains no name,
  URL, "Paper 3", "Claude" or "vpr-testtime".

Verdicts: **Fixed**, **Fixed differently** (with the reason), **Partly
fixed** (what remains and why), **Documented** (for document items). No
finding is rejected. A new rule is followed throughout: the added text had to
fit the 8-page body. The last section lists every cut, so the reviewer can
check that nothing substantive was removed.

## Must-fix

**M1 — Colon10k's own evaluation is not credited; the blocking check dropped
off §0.4. Fixed. (b) cannot be completed here and remains blocking.**
- (a) Related work now opens with Colon10k's evaluation and quotes its
  abstract verbatim. Its authors report "an extensive evaluation on different
  existing place recognition techniques" on its endoscopist-verified
  intervals, and they state that "traditional image retrieval techniques do
  not generalize well in colonic images". The paper calls this evaluation
  "on the same dataset … the closest to ours". The introduction also credits
  it: "existing techniques, among them an off-the-shelf network trained on
  landmarks, have been evaluated on real colonoscopy [ma2021colon10k,
  morlana2021selfsupervised]". I re-read the abstract from its OpenAlex record
  before quoting it. The second statement comes before the benchmark in the
  abstract, as motivation, so the paper writes "state", not "found".
- (b) I tried to read the results table and could not:
  - OpenAlex lists no open-access location for
    10.1109/isbi48211.2021.9433780;
  - PubMed and PMC have no record;
  - the dataset page gives only the fine-tuning parameters.

  The paper therefore says "we read only its abstract, so we cannot say which
  techniques it ran or whether any ran off the shelf, and we compare with none
  of its numbers". That restores the round-1 S19 wording. "Read the Colon10k
  results table" is back at the top of EVIDENCE §0.4 as item 0, marked
  **blocks submission**. It says what to do after reading: name its methods;
  if it ran a zoo member such as NetVLAD off the shelf, say so and compare
  **by method only**, since a numeric comparison would need a `\res`-backed
  source. A comment in `related.tex` marks the sentence to replace.
- (c) The novelty sentence now rests on the measurement, not the robot: "As
  far as we found (search to September 2026), no VPR model published since
  2022 has been evaluated frozen on colonoscopy same-place ground truth."
  - Colon10k (ISBI 2021) and Morlana et al. (MIDL 2021) cannot contain a
    post-2021 model.
  - ColonMapper and ColonSLAM fine-tune their descriptors.
  - This matches EVIDENCE §2 C1, "the 2022–2025 frozen VPR zoo".
  - The robot gap stays as motivation only, stated as the cited facts of
    paragraph 1.
  - positioning.md's old "safe novelty phrasing" is marked superseded.
  - NetVLAD (2016) is the one zoo member the sentence does not cover. It is
    also the member Colon10k may have run.

## Should-fix

**S1 — non-causal, within-procedure evaluation. Fixed.**
- Methods: "The database is the query's own case, frames recorded after the
  query included, so the test is offline".
- A new limitation, "Offline, within one procedure":
  - a query may be answered by a revisit an on-line relocalizer would not yet
    have seen, and we did not count such queries;
  - all revisits lie inside one short procedure, with databases of
    `\res{pc-ndb-c08}` to `\res{pc-ndb-c14}` frames per test case. These are
    new `\res` keys over `per_case.csv`'s `n_db`. The test extremes are cases
    08 and 14; the reviewer's 104–879 is the same range;
  - relocalization across procedures, as at follow-up, is not tested.
- The follow-up example is scoped, and a within-procedure need is added from
  Colon10k's abstract: robots need their position "to recheck a region during
  a procedure [ma2021colon10k] or to retarget a lesion at follow-up
  [bianchi2019localization]; we test only the former (Sec. 5)".
- The abstract says "offline".
- The reviewer's validation-GT count (17 of 50) is **not** in the paper. It is
  not in the snapshot. EVIDENCE §0.3 says it may enter only as a `\res` value
  exported by the consolidator, and that on the test split it would be a
  post-gate analysis.

**S2 — the FOV-masked secondary run and H-E1b are not accounted for. Fixed.**
- The limitations now say "The pre-registered secondary run with
  field-of-view masking was not run (masking was never wired into the
  evaluation code)". I checked this at `91ea512`:
  - `EndoscopyPreprocess` is not imported by the runner or `run.py`;
  - `p4_protocol.py` raises "EndoscopyPreprocess is not wired into this run".
- They also say: "Raw DINOv2 was to join the zoo only if its wrapper existed
  at Stage B, and it did not, so the pre-registered contrast of VPR training
  with raw DINOv2 (H-E1b) is untestable". This is §8b's conditional clause
  and §8d note 3; `b0a71b7` has no raw-DINOv2 wrapper, which I checked in its
  tree.
- The paragraph is now "Zoo, statistics, work not run".
- EVIDENCE §0.4 item 11 records the owner's choice. Keep "not run", or approve
  a separate, recorded procedure; the committed runner cannot do it.

**S3 — the conclusion overstates when the protocol was fixed. Fixed.**
- The conclusion now opens: "With thresholds, zoo, comparator and case split
  fixed before any model was run in an internal pre-registration". This is the
  abstract's scope.
- EVIDENCE §0.5 makes this scope a wording rule, because the §8d rules, row C
  and the AnyLoc-GeM parameters came later.

**S4 — the ρ denominator; headroom is not called an oracle bound. Fixed.**
- Methods: ρ_m "is the share of *all* queries that m misses and another
  member solves", and ρ_{m*} "is also the headroom of an oracle per-query
  selector over the best member".
- Results: "The best member misses, while another member solves, ρ_{m*} = …
  of all queries … the headroom of an oracle per-query selector over it (no
  realizable selector was tested)".
- Conclusion: "An oracle per-query selector would recover
  `\res{or-rec-share}` of the best member's errors". That share is
  ρ/(1 − R), which is conditional on the best member's errors, as worded.

**S5 — the AI-assistance disclosure omits Stage A. Fixed.** Protocol: "Stage A
fixed … before the data were acquired; an AI coding assistant proposed these
values and the protocol owner approved them". This is §11 row A. The Stage B
sentence now says "by the same assistant", and the §8d sentence is unchanged.
Keeping or removing the whole disclosure is still the owner's call; EVIDENCE
§0.4 item 6 now requires that, if kept, it stay complete.

**S6 — MegaLoc called street-trained. Fixed. The title change goes beyond the
request.**
- Methods: "The VPR models, trained on street imagery (MegaLoc on a union of
  VPR and landmark datasets), are …". That is literature.md's wording; I did
  not assert MegaLoc's datasets beyond it.
- Abstract: "frozen visual place recognition (VPR) models, most of them
  trained on street imagery".
- Title: "Frozen Street-Trained Place Recognition in the Colon: …" became
  "Frozen Place Recognition in the Colon: …". AnyLoc-GeM is training-free too,
  so "street-trained" was inaccurate for the zoo as a title-level claim. The
  running title changed with it.
- The owner may prefer "Mostly Street-Trained" (EVIDENCE §0.4 item 12).
- The conclusion's "most of them street-trained" is kept, as the reviewer
  allowed.

**S7 — the input transform is not stated. Fixed.** Methods: "Every model and
the thumbnail receive the harness's generic input: the frame upsampled with
its aspect ratio kept, padded with black to a 448-pixel square and
ImageNet-normalized (MixVPR resizes it to its fixed input size)." Checked at
`91ea512`:
- the runner docstring at lines 86–87;
- `VPRTransform`: letterbox, target 448, black canvas, ImageNet mean and std;
- MixVPR's wrapper interpolates to its fixed input size;
- the handcrafted baselines invert the normalisation.

The sentence sits right after "no endoscopy-specific preprocessing (masking)",
which qualifies that claim as the reviewer asked.

## Document items

**D1 — the `\pending` markers, including an unmet pre-registered commitment.
Documented, plus one text change.**
- The street paragraph now says: "The pre-registered two-sided test of Δ_m
  and the commitment to report each Δ_m with its interval are not yet met: the
  interval method was chosen after the gate ran".
- EVIDENCE §0.4 item 1 marks H-E1a as an unmet pre-registered reporting
  commitment.
- Item 10 lists all 7 markers, each of which stops the build under `[final]`:
  H-E1c, the GT audit, H-E1a, E2, E4, E3, E5.
- It notes that H-E1c can be computed from the saved per-query files without
  re-running anything, reported as computed after the gate.
- I did not compute H-E1c or approve MOVER. Both remain owner decisions (items
  1–2).

**D2 — the gate ran from the main checkout, not a worktree. Documented** in
the new EVIDENCE §0.7. I re-checked what I could:
- `91ea512` changes only `.gitignore` (the weight cache and the SelaVPR clone)
  and `.gitmodules` (three `ignore = untracked` lines). It comes after row C
  (`23dfcdc` is an ancestor).
- The gate record's `out_root` and lock path are in the main checkout, with
  `git_clean: true`.
- The descriptor cache holds 570 files. 150 predate the lock timestamp; the
  last is at 2026-09-27 23:51:41 −04:00. 420 follow it; the first is at
  2026-09-28 20:22:13 −04:00, against the lock at 20:22:12 −04:00.
- These are modification times, so they are not tamper-proof. The
  5 × 15 × 2 and 14 × 15 × 2 split is recorded as the reviewer's reading
  because the cache keys are hashes.

The paper's "from a clean commit" stays. The signed protocol document is not
edited from this repository.

**D3 — provenance and anonymity. Documented** (EVIDENCE §0.4 items 7 and 9).
- Item 9 now also says that the `.tex` comments name the harness checkout.
- The generated and snapshot files keep `source_repo` by design, and editing
  them would fail `make check`.
- *Rebuttal (partial):* I did not strip the `.tex` comments. They are the
  provenance trail that ties each paragraph to the protocol, the gate commit
  and EVIDENCE. The plan stays: submit the PDF only, or strip comments and
  those lines from any uploaded source bundle.
- The stale status line 3 of `P4_PREREGISTRATION.md` is in the harness
  repository. It stays an owner item (§0.4 item 8).

**D4 — minor points. Fixed.**
- (a) Results: the random ranking hit `\res{bl-rand-hits}` queries against
  `\res{bl-rand-exp}` expected, "(probability of at least as many hits:
  `\res{bl-rand-p}`)". This is a new key over `p_chance_at_least_hits`, as
  §8d note 5 asks.
- (b) The street-table caption now says "Not a domain effect alone."
- (c) "On robotic capsules and robotic endoscopes".
- (d) The nanorobot sentence now reads "which are localized by external
  medical imaging [aziz2020medical]; even a recent sub-millimetre robot with
  on-board computation carries no imager [lassiter2025microscopic]". The
  lassiter key was already in the bib and the lock; bibcheck passes.
  "Carry no camera" is no longer attributed to aziz.
- (e) The chance threshold is now printed as "5 percentage points" in
  Methods and "5 points" in the Table 1 caption. It comes from a derived key,
  `gate-minmargin-chance-pts` (`gate-minmargin-chance * 100`), so no number
  is typed. The raw key stays as the derive's input.
- (f) Limitations: "on the `\res{val-ncases}` validation cases
  `\res{val-nnontriv}` of `\res{val-nzoo}` members were non-trivial".

## Cuts made to keep the body at 8 pages (nothing substantive removed)

The revision added about 25 lines. These removals and compressions paid for
them.
- **Removed restatements** (each is still stated where named):
  - "As the split condition was disabled, GO rests on this count alone"
    (Results). Methods §3.3 keeps it.
  - "The case-level intervals rest on these clusters…" (Results). The
    limitations keep the power caveat.
  - "The split condition of the gate was disabled" and "the zoo ceiling
    bounds only per-query selection among these members" (Limitations).
    §3.3 and §3.4 keep them.
  - "The headline stays at the pre-registered window" and "that set changes
    with the window". The sweep caption keeps both ("The row W = 10 is the
    pre-registered headline"; "Query sets differ between rows").
  - "the thumbnail's recall falls" in the sweep text; Table 5 shows it.
  - "the window and scope were derived from the ground truth" (Protocol).
    Methods §3.3 keeps it, and the protocol points to it.
- **Shortened:**
  - C1's history clause, since §3.5 has it;
  - the Stage B fact list;
  - the file-format sentence;
  - the Table 2 and Table 3 captions;
  - the per-case paragraph;
  - the AnyLoc Δ_m sentence;
  - the conclusion.
- **Dropped:** "the window removed 11 queries of case 06, leaving 12". Its keys
  `pc-drop-c06` and `pc-n-c06` stay in `numbers.yaml` but are no longer
  printed; `pc-n-c13` likewise.
- **Layout:**
  - Tables 3 (per case), 4 (street) and 5 (sweep) share one float. The street
    table is now Table 4, and the text order is per case, street, then the
    secondary sweep.
  - Table `sweep-counts` lost its `role` column so both sweep tables fit side
    by side. The caption names the headline row instead. A reviewer who wants
    the column back costs about four lines.

## Every change made

- `numbers.yaml`: +`gate-minmargin-chance-pts` (derive), +`bl-rand-p`,
  +`pc-ndb-c08`, +`pc-ndb-c14`; `sweep-counts` without `reporting_role`.
  Now 81 values and 8 tables. `generated/` was regenerated with `make numbers`.
- `paper/main.tex`: title, running title, header comment.
- `abstract.tex`: S6 scope, S1 "offline".
- `introduction.tex`: S1 scoped example, D4(d) nanorobots, M1 credit and
  novelty sentence, "offline", shorter C1.
- `related.tex`: M1 (Colon10k quotes, unread table, no numbers compared),
  D4(c).
- `methods.tex`: S1 database, S6 MegaLoc, S7 input, D4(e) threshold in
  points, S4 ρ and oracle headroom, shorter format and split sentences.
- `protocol.tex`: S5 Stage A disclosure, shorter Stage B list and gate-run
  sentence, D2 comment.
- `results.tex`: D4(e) caption, D4(a) P(X ≥ hits), S4 ρ wording, D1 H-E1a
  sentence, D4(b), float reorganisation, cuts.
- `limitations.tex`: S1 new paragraph, S2 masked run and H-E1b, D4(f),
  merged zoo / not-run paragraph, cuts.
- `conclusion.tex`: S3 scope, S4 oracle, shorter.
- `notes/EVIDENCE.md`:
  - header;
  - §0.1 spec count;
  - §0.2 rows G, C1, B, C2, C-R;
  - §0.3 new items;
  - §0.4 new items 0 and 10–12, and items 1, 6 and 9 updated;
  - §0.5 new rules;
  - §0.6 paper state;
  - new §0.7 (D2);
  - §11 change log.
- `notes/positioning.md`: superseded marker on the robot "safe novelty
  phrasing" and the nanorobot citation note.
- `notes/review_response.md`: this section.
- Not changed: `bib/` (lassiter2025microscopic was already verified in the
  lock), `snapshot/`, `Makefile`, `notes/literature.md`, and anything in
  vpr-testtime.

---

# Paper 4 — Response to Reviewer 2 (2026-09-25)

Scope: the staged, zero-result MICCAI draft at `5f51940`. Nothing was run, no
data or weights were downloaded, and no number was added. The harness branch
`paper/p4-endoscopy-loaders` (another agent's worktree) was **read, not
edited**. `make check` and `make pdf` pass after the revision
(texlint 0 violations, 0 pragmas; bibcheck 0 errors; PDF 10 pages).

Verdicts: **Fixed** (as suggested), **Fixed differently** (the problem is
removed another way, with reason), **Partly fixed** (what remains and why),
**Cannot fix here** (needs an owner action or a source nobody can read). No
finding is rejected outright. The partial disagreements (M13, S9, S5, M9, D3,
D4) each have a rebuttal paragraph below.

## Must-fix

**M1 — two incompatible gates. Fixed.** The harness document
`docs/papers/P4_PREREGISTRATION.md` plus `vprbench/analysis/preregistration.py`
(`eac266d`, as cited; the branch moved on, and the paper is matched to its
head `eeba592`) is now canonical for the gate, the ground truths and the
baselines, because it is the version with an implementation, tests and a
sign-off slot. The paper was made to match it:
- GO / NO_GO / OWNER_REVIEW, `min_models_passing`, and the "meaningful split"
  (LB of I > `min_irreducible_frac`, LB of the best member's
  selection-recoverable part > `min_recoverable_frac`; best member chosen once
  on the full data).
- NO_GO is "no member beats random" and the handcrafted baseline plays no part
  in it. OWNER_REVIEW has no defined action, and the paper says anything done
  under it is post hoc.
- Old G2 (chance-ceiling test) and the PARTIAL branch are gone from the gate;
  the chance ceiling is reported beside the split, as in the code.
- ONE handcrafted baseline (thumbnail NCC or Hellinger RGB histogram).
- H1a (per-member transfer gap) is a two-sided test, with the caveat that the
  ground truths differ in kind.
- Table 1's left block lists the document's fields by their code names (`k`,
  `exclusion_window`, `handcrafted_baseline`, `min_margin_vs_random`,
  `min_margin_vs_handcrafted`, `min_models_passing`, `min_recoverable_frac`,
  `min_irreducible_frac`, `ci_level`, `n_bootstrap`, `bootstrap_seed`,
  `db_scope`) plus §8b (oracle-zoo membership and AnyLoc vocabulary, street
  data, preprocessing).
- The validation split V is removed: the document has none, and nothing is
  tuned.
- The branch changed after `eac266d`, and the paper follows its head
  `eeba592`:
  - the window is fixed in frames of the sorted image list (§8), with the
    id-unit value recorded after acquisition;
  - `db_scope` is a document field;
  - a split bound of −∞ disables that half (the paper notes that otherwise a
    zoo that solves every query cannot reach GO);
  - ties are counted against the model;
  - the document is signed in two dated stages: thresholds before
    acquisition, file facts after acquisition but before any descriptor.
  The branch is still being worked on, so the paper must be re-checked
  against it before signing.

**Amendments the owner must merge into the canonical document before signing**
(the paper states these as additions; until merged, the two still differ on
them only):
1. the E2 verdict rules: "large", ΔI beyond chance (δ_Δ), "stable" (ε),
   "saturated" (η);
2. the ground-truth audit (n_a, γ, annotators) and the quality strata;
3. the C3VD/C3VDv2 design: video pairs, clusters = phantom segments, world
   frames, overlap GT (o*, ε_d, direction, valid pixels, fisheye model);
4. E4(a)/(b) and the C4 street statistics;
5. the rule that sets `ci_level`: α_CI = 2α/|Z_gate| for the gate
   (Bonferroni over the gate zoo), 2α elsewhere;
6. the Holm families (H1a, H1b, H4b) and the bootstrap p-value definition;
7. backbone-matched raw DINOv2 for H1b (both CLS and GeM, as the document
   already lists);
8. family means for H1c.

Optional amendments the owner may prefer: a chance-ceiling gate term, defined
OWNER_REVIEW actions, a simultaneous (max-statistic) bound instead of
Bonferroni, BoQ-ResNet-50 in H1c's CNN side (the document lists only NetVLAD,
CosPlace, EigenPlaces and MixVPR), and an outdoor-vs-medical hypothesis (the
paper reports it descriptively because the document has no such hypothesis).
Each must go into the document and the code first, then the paper.

**M2 — "pre-registered" is false. Fixed in the paper; registration is an owner
action.** Title "Pre-Registered" → "Pre-Specified". Keyword "Pre-registration"
→ "Pre-specified protocol". The section is now "Pre-Specified Protocol".
The abstract says the thresholds "are to be fixed and publicly registered
before any data are acquired, and none is set yet"; the introduction says "no
threshold is set yet"; the conclusion says they "remain to be fixed and
registered". The protocol section calls the harness document "an unsigned
draft" that "is to be signed and publicly registered with timestamps in two
stages". Filing the OSF/AsPredicted registration after the owner fills and
signs the document (citing its commit) cannot be done here. It is listed as
blocking in EVIDENCE §6.

**M3 — C4 assumes an unestablished street structure. Fixed.** C4 is now a
descriptive side-by-side: E2's statistics, with the same estimator and zoo, on
the street data of H1a, beside the colon values. No recurrence verdict is
drawn and "as on streets" is gone. The confound with set-up is stated. The
TOPO-Bench-style score is dropped from the protocol: its definition was read
once from the arXiv HTML and cannot be pre-specified.

**M4 — invented "the loader checks". Fixed.** Removed. The shared phantom
frame is now "an unverified precondition of every cross-recording comparison".
The cross-texture contrast runs "only if the textures' shared frame is
confirmed". View-overlap GT is marked "not yet implemented", pose+angle
"implemented". Both are listed as blocking (EVIDENCE §6; paper §6).

**M5 — "any available representation". Fixed** with the suggested wording:
"How much of the remaining error a diverse zoo of frozen representations
could recover has, as far as we found, not been measured."

**M6 — what the ceiling bounds. Fixed.** §3.3 now has a "What C(Z) bounds"
paragraph with the four directions, from P3's EVIDENCE §3:
(i) upper bound only on per-query selectors that return one member's top-k
list; (ii) lower bound on recognizability only up to chance hits and GT
artefacts; (iii) no bound on models outside Z; (iv) no bound on fusion,
ranked-list voting, re-ranking or adaptation. "Selection-recoverable" is
defined as the only sense of "recoverable" in the paper. The title now asks
how much error "model selection" could recover. The "points to model
selection or fusion" outcome text is gone, since fusion is not bounded.

**M7 — "I shrinks when members join" fires by construction. Fixed.** The rule
now compares against chance: representation failure is read only if
LB(ΔI − ΔI_rand) > δ_Δ. Here ΔI_rand(Z, n') = mean_q (1 − o_Z(q))[1 − (1 − p_q)^{n'}]
is the expected drop from adding n' independent random rankers, defined in
§3.3. The text says "Adding members never increases I".

**M8 — "irreducible" read as ambiguity without a GT check. Fixed.**
- A blinded audit is pre-specified: n_a random zoo-unsolved Colon10k queries,
  each shown with every member's top-1 and labelled GT miss / ambiguous view /
  low quality / representation failure, each with a one-line definition.
- Ambiguity is read only from the "ambiguous" share, and not at all if UB of
  the miss share exceeds γ. n_a, γ and the annotators are in Table 1.
- GT incompleteness is in Limitations and in the Colon10k paragraph.
- Terminology is P3's "zoo-unsolved" throughout, with the qualifier in the
  abstract.

**M9 — wei2023stereo is not zero-shot. Fixed differently.** The sentence is
removed and the citation was cut (space). EVIDENCE §2 C1 is corrected so it
no longer lists wei2023stereo as off-the-shelf. *Rebuttal on the method:* the
reviewer asked to move and redescribe it. With the reference budget at 2
pages it is a "cite as space allows" item (positioning.md), and removing it
fixes the misattribution just as completely. It stays in EVIDENCE C0 for a
longer version.

**M10 — wei2025breaking for GT overestimation. Fixed.** larsen2026longterm
alone now carries "distance-threshold ground truth can overestimate recall",
and the tube argument in §3.2 cites only larsen. wei2025breaking is no longer
cited.

**M11 — "compared only for object-level retrieval". Fixed** as suggested:
"compared for object- and class-level retrieval in GI endoscopy
[parolari2026contrastive, kim2025improving] … but as far as we found never for
same-place retrieval". kim2025improving is newly cited; it is already in the
bib and lock. "GI endoscopy" replaces "colonoscopy" because kim2025improving
uses Kvasir/HyperKvasir.

**M12 — "None measures per-model retrieval quality". Fixed.** Now: "Apart from
that baseline [morlana2021's off-the-shelf model], ColonSLAM's off-the-shelf
LightGlue baseline and Colon10k's unread evaluation, we found no measurement
of an off-the-shelf model's place-recognition accuracy in the body, and no
oracle ceiling (for [soberanismukul2026global], as far as its abstract
shows)."

**M13 — venue: references and space. Partly fixed.**
- The PDF is now 10 pages: the body ends on page 8 and the references run
  from page 8 to page 10 (was 13 pages, references on 9–13).
- E3 (section probe) and E5 (sequence priors) are removed; E3 is the canonical
  NO_GO fallback and is to be reported separately.
- §6 (Expected Outcomes) is merged into the protocol as reading rules.
- Cited keys go from 52 to 32 (21 removed, 1 added; list in EVIDENCE §7).
- Two presentation-only changes to `paper/splncs04p4.bst`: first author +
  "et al." for lists of more than three authors, and no URL for arXiv entries
  whose `howpublished` already prints the id.

*Rebuttal (partial):* I did not retarget, and I did not move Table 1 out. For
a staged protocol paper, the threshold table is the content a reviewer must
check, and the registration it would move to does not exist yet. The honest
state is:
- the paper fits 8 + 2 pages now, but results will **not** fit as it stands;
- when results exist, Table 1 must move to the public registration (cited),
  or the paper must go to TMI/MedIA, and that is the owner's call;
- whether MICCAI accepts truncated author lists was not verified; restoring
  full lists (`max.names`) costs 17 reference lines, about a third of a
  page (measured).

## Should-fix

**S1 — Huix overstated. Fixed differently:** the sentence and citation were
removed (space). No claim about Huix et al. remains.

**S2 — FeeBee stretched to I(Z). Fixed differently:** the citation is removed.
The paper says I(Z) is zoo-relative by construction and reports it per arm and
per backbone family, and "I(Z) is an oracle miss rate, not a Bayes error, and
nothing in this paper estimates one".

**S3 — Vasconcelos's irreducible term. Fixed differently:** the attribution is
removed from the introduction and methods (space), and the difference is
stated without it ("an oracle miss rate, not a Bayes error"). EVIDENCE §2 C2
records that any future citation must say "conceptually analogous".

**S4 — loose intro citations. Fixed:** "VPR-trained models degrade off-street,
while DINOv2-based ones, including training-free AnyLoc, hold up best
[keetha2024anyloc, larsen2026longterm]". Repetition is now cited to
jiang2025c3vdreg as "repetitive tubular anatomy", its recorded wording
(literature.md:407). I could not confirm the reviewer's quoted "haustral
folds are repetitive" from the notes, so I did not use it. Low texture,
specularities and deformation stay on schmidt2024tracking, whose summary lists
them.

**S5 — unhedged, uncited "no public dataset …". Fixed differently:** the
universal negative is gone from both places and replaced by a dataset-specific
fact: "Real-patient evidence is Colon10k …, which carries no pose". *Rebuttal:*
adding "to our knowledge" plus rau2024simcol3d would cost two references for a
claim the design no longer needs. The protocol only needs to explain why
geometric GT is phantom-only here, and the dataset-specific statement does
that without a universal claim.

**S6 — "in silico". Fixed:** both places now say phantom "results make no
claim about patients" (abstract; Limitations, which also says the phantoms are
rigid silicone). EVIDENCE §5 forbids "in silico" for the phantoms.

**S7 — C3VD/C3VDv2 protocol. Fixed, except one item that cannot be verified
here.**
- "Adds two geometries" → "C3VDv2 has two sculpted geometries with four
  textures each".
- E2 pairs recordings of one phantom and texture on different trajectories;
  twins (same trajectory) enter only E4.
- Clusters are phantom segments, not recordings.
- Overlap GT is fully specified: directional query→database, valid pixels =
  in FOV with depth in the released valid range, released fisheye
  calibration, depth tolerance ε_d.
- Video pairs, clusters and world frames are Table 1 items fixed from the
  release structure.

I could not verify the release's per-segment video layout (the reviewer's
v1/v2/v3 and "7–8 regions"). The loader docstring confirms only v3 = debris
on v2's trajectory, so the paper does not state that layout; EVIDENCE §6 lists
reading it as blocking.

**S8 — H1b and "family". Fixed:**
- Raw DINOv2 runs "at the backbone size and input resolution of each model it
  is contrasted with"; the per-model pairs are a Table 1 item. The harness
  confirms AnyLoc is ViT-G/14 and SALAD DINOv2-B. The MegaLoc and BoQ sizes
  are not stated in the wrappers, so I did not assert ViT-B/14 for them.
- Both CLS and GeM variants enter H1b (as in the canonical document), in one
  Holm family.
- *Backbone family* (CNN / DINOv2 incl. the generic arm / medical) is defined
  separately from *arm*, and E2's "two or more families" is over families.
- H1b's label reads "VPR training or aggregation versus backbone", because the
  canonical document puts training-free AnyLoc in H1b.

**S9 — multiplicity and bootstrap details. Partly fixed.**
- The gate's per-member bounds are now Bonferroni-adjusted through the one
  free knob the canonical code has: α_CI = 2α/|Z_gate|, i.e. a one-sided
  (1 − α/|Z_gate|) bound per member.
- It is stated that LB/UB are the ends of a central interval (one-sided level
  1 − α_CI/2), that the bootstrap is a cluster percentile bootstrap with the
  pooled mean per replicate, and what the Holm families are.
- V is removed, so no statistic excludes any case.
- Percentile intervals with twenty or fewer clusters may under-cover; this is
  stated.

*Rebuttal (partial):* I did not switch to a max-statistic bootstrap, a
small-sample-corrected interval, or a different bootstrap type. Any of those
would make the paper diverge from the canonical code again (re-creating M1),
and they require a code change on a branch this revision does not own.
Bonferroni through `ci_level` is conservative, and implementable without
touching the code. The residual under-coverage is disclosed, not corrected.

**S10 — E2 verdict definitions. Fixed:**
- "Stable" is the UB of the max−min spread of I(Z) across the windows (and
  across the two geometric GTs on phantoms), at fixed zoo; zoo size is
  explicitly not a stability axis.
- "Saturated" is UB(last increment of the mean zoo-size curve − g) < η, where
  g is the expected gain of one random ranker, averaged over the subsets of
  size |Z|−1.
- The endoscopist/geometric GT contrast is flagged as confounded with real vs
  phantom data ("a conjunction, not a comparison").

**S11 — E3 underspecified; CAS-Colon dropped. Fixed differently:** E3 is no
longer in this paper (M13). EVIDENCE §4 keeps its full plan, including
CAS-Colon as the secondary set, so nothing is silently dropped. It also lists
the S11 checklist to resolve before E3 runs: label set, chance macro-F1
definition, kNN k and probe regularisation with their selection data, "kNN is
not linear", and per-frame vs temporal ColonTCN.

**S12 — E4 design defects. Fixed:**
- (a) Uses the wrong top-1 of the dataset's best member.
- The null is distance-matched (one non-positive frame per query from the
  retrieved frame's distance bin).
- The axis is the phantom centreline from the released mesh; if no mesh is
  released, E4(a) is not run. Mesh availability is unverified and listed as
  blocking.
- (b) The DAR construction follows kim2026visual: debris queries against
  their clean twins (same places) plus debris frames of other segments as
  distractors (same condition, different places). Twins are never
  distractors.
- (c) "Confident wrong matches" is dropped.
- The cue-suppression operators are "the operators of
  [burgert2025imagenettrained]", fixed in Table 1. I have not read that
  paper's operator definitions, so the paper does not describe them.
- The false dichotomy is removed: "no excess would not by itself identify a
  cause".

**S13 — AnyLoc conditions vs harness. Fixed:**
- The zero-shot condition is now AnyLoc-VLAD with a released off-domain
  vocabulary. That is what the harness implements: ViT-G/14, layer 31, value
  facet, 32 clusters; vocabularies aerial, indoor, urban, hawkins and
  laurel_caverns.
- Target-vocabulary AnyLoc-VLAD is the separate target-adapted condition.
- AnyLoc-GeM "joins if a wrapper is written".
- The missing wrappers are listed in Limitations and in EVIDENCE §3/§6.

**S14 — preprocessing not reproducible. Fixed:**
- The algorithm is named from `vprbench/preprocess/endoscopy.py` as of
  `eeba592`: convex hull of the large lit components after a max-channel
  threshold and opening (fix F9 replaced the earlier largest-component +
  hole-filling rule); specular = bright, near-achromatic HSV thresholds,
  dilated.
- The masking mechanism is constant fill-colour, then mask-aware crop/resize;
  no inpainting or token dropping.
- Defaults are "untuned". On/off, parameters and undistortion are a Table 1
  row, matching the document's owner choice.
- "Not wired into run()" is a Limitations item.
- The review-article citation for the mask is removed.

**S15 — Table 1 omissions. Fixed.** Added:
- the gate k;
- W in frame ids, and the sweep;
- DB scope;
- the handcrafted baseline identity and settings;
- ε_d;
- the street data (and resampling unit, in the text);
- the α that sets `ci_level`, B and the seed;
- the preprocessing row;
- gate-zoo membership including the AnyLoc vocabulary;
- the raw-DINOv2 pairs, δ_Δ/ε/η, n_a/γ/annotators, strata, and the E4
  operators, centreline and distance bins.

The Holm families and bootstrap type are fixed in the text. The E3
hyperparameters and the TOPO-Bench score left with those parts.

**S16 — E5 depends on withdrawn TPR. Fixed:** E5 is dropped. The reasons are in
EVIDENCE §4: P3 withdrew the St Lucia run, Urban-MM TPR is synthetic-only, and
TPR is pre-empted.

**S17 — companion study. Fixed:**
- "The estimator of a companion street-scene study, reused unchanged" is
  removed; the paper no longer references Paper 3 at all.
- The estimator is fully defined in §3.3.
- Implementation: `oracle_decomposition` at vpr-testtime `main@08b3212`. I
  checked that its code (AST without docstring) is identical on
  `paper/p3-ceiling-methodology`; only its docstring changes there.
- Terminology is aligned with P3: zoo ceiling, zoo-unsolved,
  selection-recoverable, headroom.
- No anonymized companion copy is needed while P4 does not cite P3.

**S18 — wording errors. Fixed:**
(1) "some zoo-unsolved error may be solved by them" (adaptation);
(2) NO-GO: "no signal detected above the chance margin";
(3) the "no large drop is hypothesized" sentence is gone. E1 predicts no
direction for Δ_m, so the in-colon gap of [morlana2021selfsupervised] no
longer serves as a rationale. A clarifying sentence ("the in-colon gap is not
Δ_m") was drafted and then cut for space; the misuse it guarded against no
longer exists.

**S19 — Colon10k's protocol unread. Cannot fix here.** The ISBI paper is
paywalled, and reading it remains blocking (EVIDENCE §6; canonical document
§10(2)). The paper now says this is "our reading of its release, and we
compare with none of its numbers". It also says that the release's interval
syntax, id convention and end inclusivity are undocumented and will be read
off the first matchings file before any model runs.

## Document items

- **D1:** k is in Table 1, as the document's `k` field.
- **D2:** No change needed. The slots were tightened to four precise
  `\pending{}`s, and the results comment says to delete "Nothing has been run"
  when results land.
- **D3:** Partly fixed.
  - `Makefile` PATTERNS is now empty, and `make snapshot` stops with an error
    until it is set to P4 result files. A dry run confirmed this; nothing was
    exported.
  - renggli2021evaluating is no longer cited.
  - *Not fixed:* the casing artefacts ("Large-Scale", "Local-to-Local",
    "Self-Supervision") come from braces in the registry-derived bib titles.
    Editing them would invalidate those entries' `verified.json` fingerprints
    and require a networked `make bib-online` re-verification, which I did not
    run for a cosmetic item.
  - The page size (US letter) and the harmless amsmath `\vec` warning are
    unchanged.
- **D4:** Not added. *Rebuttal:* the one-clause zaffar2024estimation
  distinction was drafted and then cut for the reference budget. The paper no
  longer claims any recognizability or difficulty measure (it says "we propose
  no such measure"), which lowers the risk. EVIDENCE keeps the distinction for
  a longer version.
- **D5:** All still unresolved. They are listed in paper §6 and EVIDENCE §6,
  with new items: overlap GT, shared frame, meshes, video layout, audit
  annotators, wrappers, preprocessing wiring, signing and registration.
- **D6:** The companion reference is removed. The PDF metadata has empty
  Title/Author, and no identifying strings were found in the PDF text or
  binary.

## Every change made

- `paper/main.tex`:
  - new title and running title (M2, M6);
  - header comment on canonical document and wording;
  - `\UB` and `\Zgate` macros;
  - `outcomes` input removed.
- `paper/sections/abstract.tex`: M2, M5, M6/M8 terms, S6; E3 removed;
  keywords.
- `paper/sections/introduction.tex`:
  - S4 citations;
  - duplicated not-first-use sentence moved to related work (pointer kept);
  - contributions reworded for M2, M3, M6, S3, S17;
  - no companion reference.
- `paper/sections/related.tex`: M9, M10, M11, M12, S1; zoo/genre paragraph
  trimmed; TOPO-Bench sentence ("we propose no such measure").
- `paper/sections/methods.tex`:
  - arms, backbone families and AnyLoc conditions (S8, S13); S18(1);
  - Colon10k format facts, DB scope, GT incompleteness, "our reading" (M8,
    S19);
  - C3VD design and overlap GT spec; M4 fix (S6, S7);
  - preprocessing algorithm (S14);
  - §3.3: bound directions, zoo-unsolved/selection-recoverable, chance with
    ΔI_rand, no Bayes/Vasconcelos/FeeBee (M6, M7, S2, S3);
  - §3.4: canonical baselines, bootstrap type, one-sided bounds, Bonferroni,
    Holm families, no V (M1, S9).
- `paper/sections/protocol.tex`:
  - rewritten: canonical-document framing (M1, M2);
  - two-block Table 1 (S15, D1);
  - E1 with canonical H1a–c and gate (M1, S18(2,3));
  - E2 with chance-adjusted verdicts and the audit (M7, M8, S10);
  - E4 redesign (S12);
  - C4 descriptive (M3);
  - E3/E5 removed (M13, S11, S16).
- `paper/sections/outcomes.tex`: deleted (`git rm`); its reading rules are now
  in `protocol.tex` (M13).
- `paper/sections/results.tex`: slots for E1, E2+C4 and E4; E3 and E5 removed.
- `paper/sections/limitations.tex`:
  - phantom-only wording (S6);
  - dataset-specific pose statement (S5);
  - GT incompleteness (M8);
  - unread Colon10k table (S19);
  - unbuilt parts (M4, S13, S14, D5).
- `paper/sections/conclusion.tex`: M2, M6 wording.
- `paper/splncs04p4.bst`: presentation changes 3 (author truncation) and 4
  (no duplicate arXiv URL; `eprint` added to ENTRY); header updated (M13).
- `Makefile`: empty PATTERNS plus a guard on `snapshot` (D3).
- `notes/EVIDENCE.md`:
  - canonical-document header;
  - §1 C4 note; §2 C1/C2/C4 rows;
  - §3 verified harness facts;
  - §4 binding decisions (gate, zoo, E2 rules, audit, phantom design, E3
    checklist, E5 dropped, C3/C4 protocols);
  - §5 new must-nots; §6 new blocking items; §7 venue;
  - §9 change log.
- `notes/review_response.md`: this file.
- Second commit: `paper/sections/{introduction,methods,protocol,limitations,
  conclusion,results}.tex` synced to the canonical branch head `eeba592`
  (window in frames, `db_scope`, −∞ split bounds, pessimistic ties, two-stage
  signing, FOV convex hull), with line-neutral tightening to keep 8 + 2 pages.
  The notes are updated to match.
- Not changed: `bib/references.bib`, `bib/verified.json`,
  `notes/positioning.md`, `notes/literature.md`, `generated/vprresults.sty`,
  and anything in vpr-testtime.
