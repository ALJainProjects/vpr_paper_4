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
(`eac266d`) is now canonical for the gate, the ground truths and the
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
  `min_irreducible_frac`, `ci_level`, `n_bootstrap`, `bootstrap_seed`) plus
  §8b (DB scope, oracle-zoo membership and AnyLoc vocabulary, street data,
  preprocessing).
- The validation split V is removed: the document has none, and nothing is
  tuned.

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
Abstract, introduction and conclusion say the thresholds are "to be fixed and
publicly registered before any data are acquired, and none is set yet". The
protocol section calls the harness document an "unsigned draft, to be
registered". Filing the OSF/AsPredicted registration after the owner fills and
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
- The algorithm is named from `vprbench/preprocess/endoscopy.py`: largest
  bright connected component (max-channel threshold, opening, hole filling);
  specular = bright, near-achromatic HSV thresholds, dilated.
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
(3) "The small in-colon gap between off-the-shelf and fine-tuned retrieval
[morlana2021selfsupervised] is not Δ_m", with no direction hypothesized for
Δ_m.

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
- Not changed: `bib/references.bib`, `bib/verified.json`,
  `notes/positioning.md`, `notes/literature.md`, `generated/vprresults.sty`,
  and anything in vpr-testtime.
