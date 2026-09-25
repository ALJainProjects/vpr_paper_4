# Paper 4 — Positioning, novelty verdicts, reviewer attack surface

**Scope.** STAGED, zero results. This file judges novelty *before* any experiment. Every statement is about prior work, cited by the keys in `bib/references.bib`; the evidence is in `notes/literature.md`.

**Contributions assessed.** Those in `vpr-testtime/docs/papers/PAPER4_OUTLINE.md` §2, which `notes/EVIDENCE.md` points to as the plan:
- C1: zero-shot zoo benchmark;
- C2: ceiling in the body;
- C3: representation diagnosis;
- C4: domain-generality of the ceiling.

The formulation that EVIDENCE §2 already concedes is assessed as C0.

**Search cut-off.** Searches ran to 2026-09-25. "Not found" means not found in arXiv, CrossRef, OpenAlex (partly rate-limited), PubMed and web searches as of that date. It does not mean "does not exist".

**Bottom line (blunt).** No work was found that benchmarks the outdoor-trained VPR zoo, frozen, on endoscopic place-recognition ground truth. No work was found that applies a recoverable/irreducible ceiling decomposition in the body. Both gaps are real but **narrow**. Four facts shrink C1:
1. The *protocol* (frozen zoo moved to a new texture-poor domain) is an established genre: AnyLoc, SEALOC, SQUIDLE+.
2. Zero-shot or training-free models are *already used* inside endoscopic localization: Soberanis-Mukul 2026, NetVLAD in ureteroscopy hloc pipelines, outdoor LoFTR and off-the-shelf LightGlue in ColonMapper and ColonSLAM.
3. The Colon10k paper's baseline table has **not been read by anyone**. If it lists off-the-shelf outdoor retrieval baselines, "first zero-shot" is dead.
4. Frozen DINOv2 features are already known to be strong in endoscopy. The outline's pre-registered "large drop" may not happen for half the zoo.

C2 is the paper's real contribution. The strength of C3 and C4 depends entirely on how C2 comes out.

---

## C0 — "Endoscopic localization as place recognition / retrieval"

- **Closest prior:**
  - [ma2021colon10k], [azagra2023endomapper], [morlana2024colonmapper], [morlana2024topological];
  - bronchoscopy localization lines: [tomasini2025online], [tomasini2026bronchotop], [keuth2024airway];
  - the MIDL 2021 colonoscopy VPR paper by Morlana et al. It is unverified and not in the bib; see literature.md §15.
- **What they did:** a benchmark with endoscopist-verified same-place GT; SfM-covisibility-supervised retrieval networks; topological mapping with Bayesian relocalization in real colonoscopies; whole-colon topological SLAM.
- **What we add:** nothing. Conceded.
- **Verdict: pre-empted.** Already conceded in EVIDENCE §2; do not reopen.
- **Never write:**
  - "first place recognition in the body / in endoscopy";
  - "we introduce anatomical place recognition";
  - "we formulate endoscopic localization as retrieval".

## C1 — Zero-shot benchmark of the frozen outdoor VPR zoo on anatomy (+ transfer gap)

- **Closest prior.**
  - **Genre:** [keetha2024anyloc], [larsen2026longterm], [gorry2025imagebased], [haitz2026evaluation].
  - **Zero-shot inside the body:** [soberanismukul2026global], [li2026raul], [li2026automated], [teufel2024oneslam].
  - **Colon-trained retrieval:** [ma2021colon10k], [morlana2024colonmapper], [morlana2024topological].
  - **Frozen-FM comparisons on colonoscopy retrieval (object-level):** [parolari2026contrastive], [kim2025improving].
- **What they did.**
  - **AnyLoc** shows that VPR-trained models (MixVPR) collapse off-street while frozen DINOv2+VLAD transfers. It covers aerial, subterranean, underwater and degraded data, but no medical data. Its VLAD vocabulary is built from target-domain images.
  - **SEALOC and SQUIDLE+** benchmark 8 and 6 off-the-shelf VPR models underwater, with no retraining. They find much lower recall than on land, with DINOv2-based models strongest.
  - **Soberanis-Mukul et al.** re-identify regions *training-free* with "advanced foundation models" in cadaver endoscopy. The model identity is unknown from the abstract.
  - **Li et al. (two papers)** run NetVLAD as the retrieval stage of hloc in ureteroscopy phantoms, without measuring its retrieval accuracy.
  - **ColonMapper and ColonSLAM** fine-tune their global descriptors (ImageNet R50 GeM/NetVLAD; Endo-FM), but run outdoor LoFTR and off-the-shelf LightGlue zero-shot.
  - **Colon10k's** baselines are fine-tuned after Radenović, per its dataset page. **Whether it also reports non-fine-tuned baselines is UNKNOWN.**
- **Exactly what we add** (if executed):
  1. Per-model retrieval recall of the *modern* outdoor VPR zoo, frozen with no medical fine-tuning, on endoscopist-verified same-place GT (Colon10k) and on pose- or overlap-derived GT (C3VD/C3VDv2). The zoo: NetVLAD, CosPlace, EigenPlaces, MixVPR, BoQ, SALAD, MegaLoc, AnyLoc, and raw DINOv2.
  2. A transfer gap against each model's standard street numbers, measured with the [berton2022deep] protocol.
  3. Reference points that make the gap interpretable:
     - a frozen *medical-pretrained* arm ([batic2024endovit], [wang2023foundation], [hirsch2023selfsupervised]; [jong2026gastronet5m] and [dermyer2025endodino] only if weights are obtainable);
     - where labels allow, a fine-tuned in-domain reference on ColonMapper's EndoMapper Seq_027/Seq_035 protocol. Label availability is **unverified**.
- **Verdict: incremental.** This is a new domain for an established benchmark genre. It is not pre-empted by any paper found, but three conditions apply:
  - **(i)** the Colon10k ISBI paper must be read. If it reports off-the-shelf outdoor or landmark-trained retrieval, cite it as the first zero-shot evidence and narrow C1 to "the modern (2022–2025) frozen zoo".
  - **(ii)** the MIDL 2021 paper and Morlana's 2025 thesis must be checked the same way.
  - **(iii)** Soberanis-Mukul 2026 must be read and its foundation model named. If it is DINOv2 or AnyLoc-style, say so in related work.
- **Never write:**
  - "first zero-shot / training-free localization in endoscopy";
  - "first use of outdoor VPR models in the body";
  - "all prior work fine-tunes a medical descriptor or uses an endoscopy foundation model". This outline §1 sentence is **false**: see [soberanismukul2026global], [li2026automated], and outdoor LoFTR in [morlana2024colonmapper].
  - "we show a large domain gap" presented as a discovery; [keetha2024anyloc] and [chen2023coloscrl] already establish that such gaps exist;
  - "outdoor VPR fails in the body" as a blanket statement;
  - "universal" in any title-level claim.
- **Safe phrasing:** "To our knowledge (search to Sept. 2026), no prior work systematically benchmarks outdoor-trained VPR models, frozen and without medical fine-tuning, against endoscopic place-recognition ground truth. Off-the-shelf models do appear as unmeasured components of endoscopic localization pipelines [li2026automated, morlana2024colonmapper], and training-free foundation-model re-identification has been demonstrated in cadaver endoscopy [soberanismukul2026global]."

## C2 — The recognizability ceiling in the body (oracle ceiling, kNN-BER bracket, recoverable/irreducible split)

- **Closest prior:**
  - geometric: [jiang2025c3vdreg];
  - qualitative, in-body: [morlana2024colonmapper], with its hand-labelled "not visually recognizable" frames and reject node; [elvira2024cudasiftslam], where DBoW2 place recognition fails;
  - VPR-internal, per query: [zaffar2024estimation];
  - estimator theory and caveats: [cover1967nearest], [renggli2021evaluating];
  - GT caveats: [larsen2026longterm], [wei2025breaking];
  - Paper 3 (ours, companion; not in this bib).
- **What they did.** C3VDReg finds that 3D registration fails along repetitive tubular anatomy ("translation ambiguity"), despite high GT overlap. ColonMapper *excludes* frames a human judges unrecognizable. CudaSIFT-SLAM documents place-recognition failure. Zaffar et al. estimate match uncertainty per query. FeeBee shows that Bayes-error estimates depend on the embedding. SEALOC shows that distance-threshold GT inflates recall.
- **Exactly what we add.** A model-independent, quantitative decomposition of *retrieval* error in endoscopy into a recoverable part (some model in the zoo gets it right) and an irreducible part (none does, and the kNN-BER bracket agrees), computed:
  - under endoscopist GT (Colon10k) and overlap-derived GT (C3VD/C3VDv2);
  - in more than one feature space, including a medical-pretrained one.
  An external check is possible: compare our irreducible queries with ColonMapper-style human `none` judgments.
- **Verdict: novel (as a measurement).** The estimator is not new; it is Paper 3's, reused unchanged. Its application in the body and the resulting finding are new. **C2 is the paper's core contribution; lead with it.**
- **Preconditions to keep C2 honest:**
  - (a) Do not build the C3VD GT from pose radius alone (the SEALOC failure mode). Derive view overlap from depth and pose, and report both.
  - (b) Report the irreducible fraction per feature space, because it is embedding-dependent [renggli2021evaluating].
  - (c) A small irreducible fraction is a reportable null (outline §6).
  - (d) State that deformation [lamarca2021defslam] and specularities [schmidt2024tracking] are confounded with "intrinsic aliasing" on real data. Separating them needs the phantom controls.
- **Never write:**
  - "the colon is intrinsically aliasing-bound", unless E2 shows it under both GT definitions and more than one feature space;
  - "we prove / establish the Bayes limit";
  - "first to observe axial aliasing in the colon" ([jiang2025c3vdreg] got there first for registration);
  - "irreducible" without the qualifier "under this GT and these representations".

## C3 — Representation diagnosis: what fails to transfer (geometry vs texture dependence)

- **Closest prior:**
  - [geirhos2018imagenettrained] (texture bias);
  - [matsoukas2022makes], [raghu2019transfusion] (feature reuse vs domain distance);
  - [huix2024natural], [dermyer2025endodino], [liu2025dinov3] (frozen DINOv2/v3 transfer to medical and endoscopic images);
  - [keetha2024anyloc] (feature-space analysis across domains);
  - [izquierdo2024optimal] (the SALAD dustbin discards uninformative features);
  - [morlana2024colonmapper], which already uses C3VD's same-geometry, different-texture sequences;
  - [golhar2026c3vdv2] (2 geometries × 4 textures, with clean/debris twins on identical trajectories).
- **What they did.** They established texture bias in ImageNet CNNs, the role of domain distance in transfer, and that frozen DINOv2 is at parity with an endoscopy DINOv2 on coarse landmarks. None of this concerns same-place retrieval.
- **Exactly what we add.** Per-model breakdowns of retrieval failure by colon segment and by aliasing type, contrasting CNN-based members (NetVLAD, CosPlace, EigenPlaces, MixVPR) with DINOv2-based ones (SALAD, BoQ, MegaLoc, AnyLoc, raw DINOv2). C3VDv2 is the only design that supports even a *controlled* claim, because it holds geometry fixed while varying texture and holds trajectory fixed while adding debris.
- **Verdict: incremental.** The vocabulary and hypotheses exist; the anatomical-retrieval application is new. The value depends on having the controlled C3VDv2 comparison.
- **Never write:** "VPR features rely on texture rather than geometry" as a causal claim drawn from correlational per-segment breakdowns on real data. Causal wording is allowed only for the controlled phantom contrasts, and only as "in phantoms".

## C4 — Domain-generality of the ceiling ("a property of recognition, not of cities")

- **Closest prior:**
  - Paper 3 (ours);
  - cross-domain VPR studies showing that *model* performance is strongly domain-dependent: [keetha2024anyloc], [larsen2026longterm], [gorry2025imagebased], [knights2026wildcross], [encinargonzalez2025multimodal];
  - [renggli2021evaluating].
  No prior work tests whether a *ceiling structure* recurs across domains.
- **Exactly what we add.** One additional domain (anatomy) in which the recoverable/irreducible structure either recurs or does not.
- **Verdict: novel as a question, but it is the most overreach-prone claim in the paper.** Two domains, streets and a colon (partly phantom), cannot establish "domain-general". Reframe it as a *test*: "the ceiling structure does / does not recur in anatomy", which is evidence for or against, not proof.
- **Never write:**
  - "the ceiling is a universal property of recognition";
  - "we prove the ceiling is domain-general";
  - anything that uses C4 as a headline when C2 returned a null.

---

## Reviewer attack surface (most likely objections, with honest answers)

### Attack 1: "This is AnyLoc/SEALOC again: VPR-trained models are known to collapse out of domain."
- **Cited by the reviewer:** [keetha2024anyloc], [larsen2026longterm], [gorry2025imagebased], [haitz2026evaluation].
- **Honest answer:** Correct, and we say so up front. The drop itself is *expected*, not a finding. What is new:
  - (i) its size and structure on endoscopist-verified *anatomical* GT;
  - (ii) the ceiling decomposition (C2), which no cross-domain VPR study provides;
  - (iii) the inclusion of AnyLoc and raw DINOv2, so the "universal VPR" claim is stress-tested in a domain it never covered.
- **Required action:** add AnyLoc and raw DINOv2 (and MixVPR, for comparability with both studies) to the zoo. Define whether AnyLoc's target-domain unsupervised vocabulary counts as zero-shot, or report it as a separate condition.

### Attack 2: "Zero-shot localization in endoscopy already exists."
- **Cited by the reviewer:** [soberanismukul2026global], [li2026automated], [li2026raul], [teufel2024oneslam]; outdoor LoFTR in [morlana2024colonmapper]; off-the-shelf LightGlue in [morlana2024topological].
- **Honest answer:** Yes, and we do not claim first use. These works use general or outdoor models as *components* and never measure per-model retrieval quality or its ceiling. Our contribution is the measurement.
- **Required action:** read Soberanis-Mukul et al. in full and name its foundation model. If it is DINOv2 or AnyLoc-like, describe the overlap explicitly.

### Attack 3: "Colon10k (or Morlana et al. MIDL 2021) already reported off-the-shelf baselines."
- **Cited by the reviewer:** [ma2021colon10k]; the MIDL 2021 paper (unverified, not in the bib).
- **Honest answer:** **We do not currently know.** No one in this program has read the Colon10k ISBI full text or the MIDL paper. If either reports non-fine-tuned outdoor or landmark-trained retrieval, we cite it as prior zero-shot evidence and restrict C1 to the modern frozen zoo plus the ceiling. This is a **blocking pre-submission check**, not a rebuttal point.

### Attack 4: "Strawman. Nobody would deploy frozen street models; in-domain methods exist for every task you run."
- **Cited by the reviewer:**
  - fine-tuned retrieval: [morlana2024colonmapper], [morlana2024topological];
  - endoscopy FMs: [wang2023foundation], [batic2024endovit], [jong2026gastronet5m], [dermyer2025endodino];
  - supervised segment recognition: [azagra2023endomapper] Table 7, [biffi2025temporal], [kim2024density];
  - target-map adaptation: [zaffar2025overlooked].
- **Honest answer:** P4 is a representation and limit study, not a deployment proposal, and makes no clinical claim. To keep the comparison fair, it includes:
  - a frozen medical-pretrained arm;
  - a fine-tuned in-domain reference where the ColonMapper protocol allows (label availability unverified);
  - supervised E3 numbers reported *beside* the frozen probe. Examples: EndoMapper's fine-tuned CNNs reach 17.61–26.08% Top-1 on Seq_094, and ColonTCN on REAL-Colon.

  Reference-set fine-tuning is excluded by design, and the paper says so.

### Attack 5: "Your 'irreducible' fraction is an artifact of the GT definition or of the embedding."
- **Cited by the reviewer:** [larsen2026longterm] (distance-threshold GT overestimates recall), [wei2025breaking] (overlap vs distance), [zaffar2021vprbench] (GT definitions change rankings), [renggli2021evaluating] (BER estimates are embedding-dependent).
- **Honest answer:** This is a real threat and the design must pre-empt it:
  - overlap-derived GT on C3VD/C3VDv2 from depth and pose, reported alongside pose-radius GT;
  - Colon10k's human same-place GT as the non-geometric check;
  - the ceiling computed in several feature spaces, including medical-pretrained ones;
  - the irreducible fraction reported with its dependence on each choice.

  If the fraction moves a lot across these choices, *that* is the finding, and C4 must be dropped.

### Attack 6: "The data cannot carry the claims: phantom pose, 20 short sequences, 5-patient region labels, one centre."
- **Cited by the reviewer:** [bobrow2023colonoscopy], [golhar2026c3vdv2] (phantoms); [ma2021colon10k] (20 short UNC sequences); [azagra2023endomapper] (region labels on 5 sequences only); [cold2025mapping] (no public real-patient image–pose pairs).
- **Honest answer:**
  - Metric-ceiling results on C3VD/C3VDv2 are **in-silico**, and the paper says so in the abstract.
  - Real-patient evidence is limited to Colon10k's pairwise GT and EndoMapper's COLMAP covisibility (pseudo-GT).
  - E3 moves to REAL-Colon labels (60 procedures, 4 centres) [biffi2025temporal], with CAS-Colon [song2025cascolon] as a secondary set under its NC-ND licence. EndoMapper becomes a leave-one-sequence-out tertiary check.
  - Confidence intervals are per sequence and per patient.
  - The precise wording is "no public dataset pairs real-patient endoscopic images with frame-level pose" [cold2025mapping], not "real-patient pose GT does not exist".

### Attack 7: "Axial aliasing in the colon is already known."
- **Cited by the reviewer:** [jiang2025c3vdreg], [elvira2024cudasiftslam], [morlana2024colonmapper] (`none` labels and reject node), [torii2015visual], [schmidt2024tracking].
- **Honest answer:** It is known qualitatively (SLAM failures, human "unrecognizable" labels) and geometrically (registration ambiguity). It has not been *quantified model-independently for retrieval*. We cite these as motivation. Our E4 tests whether irreducible retrieval errors concentrate along the centreline, which C3VDReg's registration result predicts.

### Attack 8: "Frozen DINOv2 already transfers well to endoscopy. Your gap is small, or large only for CNNs, as everyone expects."
- **Cited by the reviewer:** [dermyer2025endodino] (generic DINOv2 = EndoDINO on HyperKvasir landmarks), [liu2025dinov3], [parolari2026contrastive] (frozen DINOv2-g as a strong colonoscopy-retrieval baseline), [huix2024natural], [chen2023coloscrl].
- **Honest answer:** The pre-registration must treat **either** outcome as reportable. It cannot state "Hypothesis: large drop (finding)", as the outline does.
  - Two contrasts isolate *VPR training* from *backbone*: raw DINOv2 vs DINOv2-based VPR models, and CNN vs DINOv2 zoo members.
  - The ceiling question (C2) stands regardless of the gap's size.
  - Coarse landmark classification (HyperKvasir) is saturated and must not be used to argue a gap.

---

## Must-cite list (the minimum a MICCAI/TMI reviewer will expect)

- **Closest prior: colon place recognition, datasets, protocol.** [ma2021colon10k], [azagra2023endomapper], [morlana2024colonmapper], [morlana2024topological]. Also Morlana et al. MIDL 2021, once registry-verified; it is not in the bib yet.
- **Not-first-use evidence.** [soberanismukul2026global], [li2026automated] (or [li2026raul]).
- **Classical place-recognition failure in the colon.** [elvira2024cudasiftslam].
- **Datasets actually used.** [bobrow2023colonoscopy], plus [golhar2026c3vdv2] if used. For E3, [biffi2025temporal] and [biffi2024realcolon], and [song2025cascolon] if used. [cold2025mapping] for the precise pose-GT statement.
- **The zoo that is actually run.** [arandjelovic2016netvlad], [berton2022rethinking], [berton2023eigenplaces], [alibey2023mixvpr], [alibey2024boq], [izquierdo2024optimal], [berton2025megaloc], [keetha2024anyloc], [oquab2023dinov2].
- **Street protocol for the transfer gap.** [berton2022deep].
- **Cross-domain zero-shot VPR precedent.** [larsen2026longterm], [gorry2025imagebased].
- **Medical-pretrained comparator** (whichever arms are run). [wang2023foundation], [batic2024endovit], [dermyer2025endodino], [jong2026gastronet5m].
- **Natural-to-medical transfer.** [raghu2019transfusion], [huix2024natural].
- **Aliasing and ground truth.** [jiang2025c3vdreg], [torii2015visual], [wei2025breaking].
- **Ceiling estimator and its caveat.** [cover1967nearest], [renggli2021evaluating]. Also Paper 3 (companion).
- **Endoscopy-specific failure modes.** [schmidt2024tracking]; [lamarca2021defslam] for deformation.

This comes to 39 bib keys plus two external items (MIDL 2021 and Paper 3). The core shrinks to about 33 if the conditional ones are dropped: [li2026raul] as an alternate, and [golhar2026c3vdv2], [song2025cascolon], [jong2026gastronet5m], [dermyer2025endodino] and [biffi2024realcolon] only if they are used. MICCAI allows about 2 reference pages. If space forces cuts, drop in this order: [gorry2025imagebased], then [wei2025breaking], then [lamarca2021defslam]. Never drop closest prior or not-first-use evidence.

---

## Recommended changes to the planning documents (NOT applied; the owner decides)

`notes/EVIDENCE.md` is committed unchanged. Its §2 "Open" statements remain accurate as written. The outline needs these corrections:

1. **Outline §1 table.** "all prior work *fine-tunes* a medical descriptor or uses an endoscopy foundation model" is false. Replace it with: "no prior work *systematically benchmarks* the frozen outdoor VPR zoo on endoscopic place-recognition GT; off-the-shelf models appear only as unmeasured pipeline components [li2026automated, morlana2024colonmapper] or in training-free re-identification [soberanismukul2026global]."
2. **Outline §2, C1 "First zero-shot benchmark".** Keep "first" only after the Colon10k, MIDL 2021 and thesis checks (Attack 3). Default wording: "a systematic zero-shot benchmark of the modern frozen VPR zoo".
3. **Zoo.**
   - Add AnyLoc (define the vocabulary condition), raw DINOv2 (CLS and GeM), and MixVPR.
   - Optional: DINOv3, CliqueMining.
   - Medical arm: EndoViT, Endo-FM, and Hirsch et al. (public models). Add GastroNet-5M or EndoDINO only after weight availability is verified.
4. **E1 hypothesis.** Replace "Hypothesis: large drop (finding)" with a two-sided pre-registration, and fix "non-trivial recall" numerically before any data. For example: a margin over a random-ranking baseline and a raw-pixel or handcrafted retrieval baseline, with a sequence-level CI.
5. **E2 ground truth.**
   - Use view overlap from C3VD/C3VDv2 depth and pose, with pose-radius τ as a secondary definition (SEALOC failure mode).
   - Prefer C3VDv2 for its clean/debris twins on identical trajectories.
   - Compute the ceiling in at least two feature spaces.
6. **E3.**
   - EndoMapper's region labels cover 5 sequences (268,679 frames), and the dataset paper itself tests on Seq_094 only.
   - Move the primary cross-patient probe to REAL-Colon labels [biffi2025temporal], with CAS-Colon secondary and EndoMapper tertiary.
   - Report supervised references (EndoMapper Table 7; ColonTCN) beside the frozen probe.
   - Drop HyperKvasir landmarks as uninformative (saturated per [dermyer2025endodino]).
7. **Colon10k loader spec.** The image count is unreconciled: 10,126 in the paper abstract and in EndoMapper Table 1, versus 10,216 summed from the official page's 20 per-case counts. Count the files at acquisition, and do not hard-code either number. The GT format is `<CASE-ID>-matchings.txt` with lines `query_id | positive intervals`. Images are 270×216 undistorted pinhole, with fx = fy = 145.4410, cx = 135.6993, cy = 107.8946 (official page).
8. **Head-to-head with fine-tuned descriptors.** ColonMapper's EndoMapper Seq_027/Seq_035 retrieval protocol (84/78 queries, covisibility labels, mAP) is the natural common ground. Its images are reportedly released via the ColonMapper repository; **label availability is unverified**. Checking it needs no data download beyond reading the repository README.
9. **Outline §6, "real-patient pose GT does not publicly exist at frame level".** Reword to "no public dataset pairs real-patient endoscopic images with frame-level pose", and cite [cold2025mapping] (trajectories without video) and [rau2024simcol3d] (real data only via COLMAP pseudo-GT).
