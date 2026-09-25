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

> **(adversarial pass, 2026-09-25)** Fact 3 has been resolved *against* "first". [morlana2021selfsupervised] (MIDL 2021, read in full) evaluates an off-the-shelf landmark/city-trained retrieval CNN on real-colonoscopy GT. The Colon10k abstract states that the paper evaluates "different existing place recognition techniques" [ma2021colon10k]. C2's oracle is [waheed2021improving]'s construction. See "Adversarial novelty pass" at the end of this file.

C2 is the paper's real contribution. The strength of C3 and C4 depends entirely on how C2 comes out.

---

## C0 — "Endoscopic localization as place recognition / retrieval"

- **Closest prior:**
  - [ma2021colon10k], [azagra2023endomapper], [morlana2024colonmapper], [morlana2024topological];
  - bronchoscopy localization lines: [tomasini2025online], [tomasini2026bronchotop], [keuth2024airway];
  - the MIDL 2021 colonoscopy VPR paper by Morlana et al. It is unverified and not in the bib; see literature.md §15.
    - **(adversarial pass)** It is now verified via the OpenReview record and in the bib as [morlana2021selfsupervised]. See also [ye2017image] (2017 GI retrieval-based retargeting) and [gaubatz2022location] (laparoscopic location recognition).
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
    - **(adversarial pass)** Its abstract (IEEE Xplore / OpenAlex) says it performs "an extensive evaluation on different existing place recognition techniques using different metrics", and that "traditional image retrieval techniques do not generalize well in colonic images". Which techniques, and whether off-the-shelf, is still unread.
  - **(adversarial pass)** **[morlana2021selfsupervised]** reports the off-the-shelf Radenović R101-GeM ("trained with images of popular landmarks and cities") on a held-out real colonoscopy. Its R@1 is 92.2/83.7/77.3 at inter-frame distance D = 5/10/15, against 96.1/90.5/85.3 fine-tuned.
- **Exactly what we add** (if executed):
  1. Per-model retrieval recall of the *modern* outdoor VPR zoo, frozen with no medical fine-tuning, on endoscopist-verified same-place GT (Colon10k) and on pose- or overlap-derived GT (C3VD/C3VDv2). The zoo: NetVLAD, CosPlace, EigenPlaces, MixVPR, BoQ, SALAD, MegaLoc, AnyLoc, and raw DINOv2.
  2. A transfer gap against each model's standard street numbers, measured with the [berton2022deep] protocol.
  3. Reference points that make the gap interpretable:
     - a frozen *medical-pretrained* arm ([batic2024endovit], [wang2023foundation], [hirsch2023selfsupervised]; [jong2026gastronet5m] and [dermyer2025endodino] only if weights are obtainable);
     - where labels allow, a fine-tuned in-domain reference on ColonMapper's EndoMapper Seq_027/Seq_035 protocol. Label availability is **unverified**.
- **Verdict: incremental.** This is a new domain for an established benchmark genre. It is not pre-empted by any paper found, but three conditions apply:
  - **(i)** the Colon10k ISBI paper must be read. If it reports off-the-shelf outdoor or landmark-trained retrieval, cite it as the first zero-shot evidence and narrow C1 to "the modern (2022–2025) frozen zoo".
  - **(ii)** the MIDL 2021 paper and Morlana's 2025 thesis must be checked the same way.
    - **(adversarial pass)** The MIDL 2021 paper is checked: it *does* report an off-the-shelf outdoor-trained baseline. C1 is therefore narrowed to "the modern (2022–2025) frozen zoo" in any case. The thesis is still unchecked.
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
  - **(adversarial pass) Correction.**
    - The oracle-ceiling construction predates Paper 3: it is [waheed2021improving] (RA-L 2021, "maximum VPR performance that may be achieved"). Paper 3's own positioning credits it.
    - The "irreducible + recoverable" retrieval split has a theoretical precedent in [vasconcelos2004minimum].
    - "Model-independent" (in "What we add") is false by construction: the ceiling is zoo-relative.
    - "The kNN-BER bracket agrees" is not independent evidence, because the kNN BER is far outside its reliable sample regime [wheat2025bayes].
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
    - **(adversarial pass)** contested by [burgert2025imagenettrained]: CNNs "predominantly rely on local shape features", and medical-imaging models emphasize colour;
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
  - **(adversarial pass) Qualification.** [wang2025topobench] already publishes a quantitative perceptual-aliasing ("dataset ambiguity") measure across 25 indoor and outdoor environments. It argues that the measure is largely method-independent, from an inter-method correlation across 11 VPR methods. The sentence above holds only for the *oracle-ceiling* construct.
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
  - **(adversarial pass)** It is now [morlana2021selfsupervised], and the answer is **yes**: it reports an off-the-shelf landmark-trained baseline on real colonoscopy. Cite it as prior zero-shot evidence; C1 is restricted to the modern frozen zoo plus the ceiling. For Colon10k, the abstract confirms an evaluation of "different existing place recognition techniques"; the specific methods remain unread.
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
- **(adversarial pass) Added must-cites:**
  - [morlana2021selfsupervised]: closest prior and prior zero-shot evidence; never drop it;
  - [waheed2021improving]: the ceiling definition;
  - [wang2025topobench]: cross-environment aliasing, for C4;
  - [burgert2025imagenettrained]: needed if C3 keeps any texture/shape claim.

  Cite-and-distinguish, as space allows: [vasconcelos2004minimum], [wheat2025bayes], [kim2026visual], [ismagilov2026channel], [nedov2026geometryconditioned], [schubert2021makes], [wei2023stereo], [ye2017image], [gaubatz2022location].

This comes to 39 bib keys plus two external items (MIDL 2021 and Paper 3). The core shrinks to about 33 if the conditional ones are dropped: [li2026raul] as an alternate, and [golhar2026c3vdv2], [song2025cascolon], [jong2026gastronet5m], [dermyer2025endodino] and [biffi2024realcolon] only if they are used. MICCAI allows about 2 reference pages. If space forces cuts, drop in this order: [gorry2025imagebased], then [wei2025breaking], then [lamarca2021defslam]. Never drop closest prior or not-first-use evidence.

---

## Recommended changes to the planning documents (NOT applied; the owner decides)

`notes/EVIDENCE.md` is committed unchanged. Its §2 "Open" statements remain accurate as written. The outline needs these corrections:

1. **Outline §1 table.** "all prior work *fine-tunes* a medical descriptor or uses an endoscopy foundation model" is false. Replace it with: "no prior work *systematically benchmarks* the frozen outdoor VPR zoo on endoscopic place-recognition GT; off-the-shelf models appear only as unmeasured pipeline components [li2026automated, morlana2024colonmapper] or in training-free re-identification [soberanismukul2026global]."
2. **Outline §2, C1 "First zero-shot benchmark".** Keep "first" only after the Colon10k, MIDL 2021 and thesis checks (Attack 3). Default wording: "a systematic zero-shot benchmark of the modern frozen VPR zoo".
   - **(adversarial pass)** The MIDL 2021 check failed "first" [morlana2021selfsupervised]. Drop "first" from C1 permanently.
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

---

## Adversarial novelty pass

**Date and stance.** 2026-09-25. A skeptical-reviewer pass that tried to reject P4 for lack of novelty. It used phrasings the first review did not: oracle, upper bound, irreducible error, Bayes error, localizability, query difficulty; off-the-shelf, frozen, landmark-trained; relocalization, retargeting, re-identification, loop closure, revisit; surgical, laparoscopic, ureteroscopy, sinus, arthroscopy, capsule, sewer pipe; texture bias, shape bias, condition bias, colour reliance. It also followed the citation graphs of Colon10k, ColonMapper, EndoMapper and AnyLoc.

**Verification.** Every key below was fetched from its registry record (CrossRef, the arXiv export API, or the venue's OpenReview API record) and checked on title, first author and year; rows are in `notes/citation_audit.tsv`. The 13 new keys are appended to `bib/references.bib`. [ma2021colon10k] was already in the bib; its mischaracterization is corrected below. "Read in full" means the PDF or HTML text was read, not only the abstract.

### Net effect on the four contributions

| Contribution | Verdict before this pass | Verdict after this pass |
|---|---|---|
| C1 zero-shot zoo benchmark | incremental; "first" conditional on unread Colon10k/MIDL | **major narrowing.** "First zero-shot" is dead: [morlana2021selfsupervised] already evaluated an off-the-shelf landmark/city-trained retrieval CNN on real-colonoscopy place-recognition GT. The Colon10k abstract says it evaluated "different existing place recognition techniques". |
| C2 ceiling in the body | novel as a measurement; "model-independent" | **still the core, but re-attributed.** The oracle construction is [waheed2021improving]. "Model-independent" is wrong by construction. The kNN-BER bracket cannot corroborate it [wheat2025bayes]. |
| C3 representation diagnosis | incremental | **major.** Its texture-bias premise is contested [burgert2025imagenettrained]. A domain-agnostic feature-reliance protocol already exists and has been applied to medical imaging. |
| C4 domain-generality | novel as a question | **major.** [wang2025topobench] already publishes a cross-environment difficulty measure (25 environments) that it argues is method-independent. |

### Threats, one per key

#### C1 threats

**[morlana2021selfsupervised]: major.** The "first" qualifier is fatally pre-empted; the modern-zoo benchmark is not.
- *Overlap.* The paper was read in full (the OpenReview PDF).
  - It fine-tunes the Radenović et al. R101-GeM retrieval CNN on SfM-clustered real colonoscopies. It uses 3 procedures for training, 1 for validation and 1 for testing.
  - It compares against "the best model reported in (Radenović et al., 2018), which was trained with images of popular landmarks and cities". That model is run **off-the-shelf** on the held-out real colonoscopy: 6k test images, COLMAP-covisibility GT, every image used as a query, and a minimum inter-frame distance D.
  - Table 1, off-the-shelf R@1: 92.2 / 83.7 / 77.3 at D = 5 / 10 / 15. Fine-tuned: 96.1 / 90.5 / 85.3.
  - So a zero-shot evaluation of an outdoor-trained retrieval model on colonoscopy place-recognition GT was published in 2021. The outline's §2 C1 wording, "First zero-shot benchmark", is false.
- *Reframe.*
  - Cite it as the first zero-shot evidence. It covers one landmark-trained model, one test procedure, and intra-procedure covisibility GT.
  - Claim only a *systematic* benchmark of the *2022–2025 frozen VPR zoo*, under endoscopist GT (Colon10k) and overlap GT (C3VD/C3VDv2), with the street-protocol transfer gap.
- *Protocol consequences.* These are binding for the pre-registration.
  - (i) Adopt a temporal-exclusion window and report a sweep. In that paper, off-the-shelf R@1 falls 15 points between D = 5 and D = 15, so near-duplicate frames inflate recall.
  - (ii) The off-the-shelf to fine-tuned gap there was only 3.9–8.0 R@1 points. The E1 hypothesis must therefore be two-sided (this reinforces Attack 8).
  - (iii) If its weights are obtainable, add the Radenović GeM model as the historical anchor of the zoo.
- *Answer to Attack 3.* The MIDL 2021 half of Attack 3 is now answered: **yes**, it reports an off-the-shelf baseline.

**[ma2021colon10k]: major (jointly with the above). This was a mischaracterization in our notes.**
- *Overlap.* The abstract (IEEE Xplore record, and the OpenAlex copy of the same abstract) states: "traditional image retrieval techniques do not generalize well in colonic images". It also states: "We perform an extensive evaluation on different existing place recognition techniques using different metrics."
  - Colon10k is therefore itself a 2021 benchmark of existing place-recognition techniques on endoscopist GT.
  - Only the abstract and introduction could be read (the full text is paywalled). Which techniques were run, and whether off-the-shelf, is still unknown.
- *Reframe.*
  - Never write "first benchmark of existing VPR methods on colonoscopy".
  - The honest delta is the *modern* zoo (CosPlace to MegaLoc, DINOv2-based models, AnyLoc) plus the ceiling.
  - Reading the Colon10k results table remains a blocking pre-submission check. It is now about *which* methods, not *whether*.

**[wei2023stereo]: minor.**
- *Overlap.* Read from the arXiv HTML. It performs laparoscope relocalization on SCARED, ex-vivo and in-vivo da Vinci data, using coarse-to-fine localization.
  - The retrieval stage is a student network trained on pseudo-descriptors from **pretrained NetVLAD**, over Google Landmarks, SCARED and in-vivo clips.
  - Retrieval accuracy is never reported; only pose error is.
- *Reframe.* Add it to Attack 2's list of outdoor-VPR-derived models used as unmeasured components (laparoscopy, 2021 preprint / 2023 TBME). It supports "our contribution is the measurement".

**[ye2017image]: minor (C0, already conceded).**
- *Overlap.* Image-retrieval-based inter-examination retargeting on 13 in-vivo GI videos from six patients with serial examinations. It reports that its descriptor "outperforms a number of alternative descriptors".
  - It predates Colon10k as retrieval-based place re-identification in the GI tract, and it is long-term (across examinations).
- *Reframe.* Cite it in related work as the earliest same-patient, cross-examination retrieval precedent found. It further forbids any "first" wording for long-term GI place recognition.

**[gaubatz2022location]: minor (C0).**
- *Overlap.* Hierarchical bag-of-visual-words "location recognition" (loop closure) for stereo-laparoscope SLAM with an IMU.
- *Reframe.* Cite it as surgical place recognition outside the colon. It is handcrafted and not a zoo benchmark.

**Searched with no further C1 threat found.** No paper benchmarks NetVLAD-to-MegaLoc, AnyLoc or raw DINOv2 frozen on any endoscopic place-recognition GT. The foundation model in [soberanismukul2026global] is still unidentified: the NCBI E-utilities abstract was re-fetched, and OpenAlex marks the paper closed access.

#### C2 threats

**[waheed2021improving]: major. This was a mischaracterization in our notes.**
- *Overlap.* It publishes, for VPR, a framework that estimates "upper and lower complementarity bounds ... along with an estimate of maximum VPR performance that may be achieved", computed for 8 methods on 10 datasets (RA-L 2021). Per Paper 3's full-text reading, this is the per-query oracle (the fraction of queries that technique A *or* technique B localizes), defined for pairs of techniques.
  - C2 above says "the estimator is not new; it is Paper 3's". That attributes the construction to the wrong source.
  - C2's "model-independent ... decomposition" is false by construction: the ceiling is a union over a specific zoo. Paper 3's own positioning (`vpr_paper_3/notes/positioning.md`, C1) already concedes both points.
- *Reframe.*
  - "A zoo-relative oracle ceiling (after [waheed2021improving]; Paper 3's estimator), measured for the first time on endoscopic place-recognition GT, as far as we found."
  - Report the ceiling as a function of zoo size, with leave-one-model-out.
  - Report a random-ranking chance-hit baseline. Positive intervals in Colon10k can be wide, so chance hits are real.
  - Qualify "irreducible" as "for this zoo, this GT and this exclusion window".

**[vasconcelos2004minimum]: minor.**
- *Overlap.* It treats retrieval as classification and bounds retrieval error by a Bayes-error term plus a density-estimation term. This is the conceptual precedent for splitting retrieval error into "irreducible" and "recoverable".
- *Reframe.* Cite it in the ceiling definition. P4's contribution relative to it is empirical and domain-specific.

**[wheat2025bayes]: major for the kNN-BER sub-claim.**
- *Overlap.* kNN is the most accurate non-parametric BER estimator. Even so, a <5% 95%-CI range needs about 1000 samples per class in the binary case, and 2500 per class at only 4 features.
  - Colon10k gives a handful of positives per query, in descriptor spaces of hundreds to thousands of dimensions.
  - C2's "the kNN-BER bracket agrees" therefore cannot count as independent corroboration. Paper 3 also shows that the agreement is partly built in.
- *Reframe.* Demote the bracket to a heuristic cross-check, or drop it from P4. Never write "Bayes limit" for the oracle.

**[wang2025topobench] (for C2): minor. See C4, where it is major.** It already publishes a quantitative perceptual-aliasing measure and gives empirical evidence that it is method-independent. P4 must not call its oracle "the" aliasing measure.

**Searched with no C2 threat found.** No work computes an oracle ceiling, a Bayes-error estimate, or a recoverable/irreducible split for retrieval or relocalization in any endoscopic domain. The nearest in-body constructs remain the qualitative "not visually recognizable" labels in [morlana2024colonmapper] and the registration-level axial ambiguity in [jiang2025c3vdreg].

A **validity lead, not a novelty threat**, was also surfaced: InfoColon (Scientific Data 2026, DOI 10.1038/s41597-026-07060-2; the record was verified, but the content was not read, and it is not in the bib). Irreducible queries should be stratified by frame informativeness, because blur, bubbles and wall-contact frames would otherwise be counted as "intrinsic aliasing".

#### C3 threats

**[burgert2025imagenettrained]: major.**
- *Overlap.* NeurIPS 2025 (DOI verified). It suppresses shape, texture and colour cues in a controlled way, replacing Geirhos's cue-conflict test.
  - It finds that ImageNet CNNs "are not inherently texture-biased but predominantly rely on local shape features".
  - It finds that reliance patterns differ by domain: "medical imaging models emphasize color".
  - It therefore (i) undercuts C3's premise, taken from [geirhos2018imagenettrained], that CNN zoo members will fail on uniform mucosa *because* of texture bias. It also (ii) shows that a domain-agnostic feature-reliance protocol already exists and already covers medical imaging.
- *Reframe.*
  - C3 is "shape/texture/colour-suppression analysis (after [burgert2025imagenettrained]) of *place retrieval*, on C3VDv2's geometry × texture design".
  - State the hypotheses two-sided.
  - Never cite [geirhos2018imagenettrained] alone for a CNN-vs-ViT texture story.

**[kim2026visual]: minor.**
- *Overlap.* Distractor-Augmented Recall: across 11 VPR methods, descriptors retrieve by *condition* (illumination, weather, season) rather than place, and rankings change under DAR@1. C3VDv2's clean/debris twins test the same construct in the colon.
- *Reframe.* Adopt a DAR-style distractor analysis on the debris twins, or at least cite it as the VPR precedent for condition-vs-place bias.

**[ismagilov2026channel]: minor.**
- *Overlap.* In VPR, grayscale matches RGB. Colour helps only where "persistent and discriminative chromatic cues are present".
- *Reframe.* A grayscale ablation is the cheapest colour-reliance test in anatomy. Cite this paper as the VPR precedent, and report the ablation either way.

**[nedov2026geometryconditioned]: minor.**
- *Overlap.* Conditioning a DINOv2 VPR model on geometric-foundation-model depth improves recall in repetitive natural environments (WildCross). So "appearance vs geometry" in texture-poor, off-street VPR is already studied, as a *method*.
- *Reframe.* P4's C3 is a frozen *diagnosis*, not a method. Cite this paper in related work.

**Searched with no further C3 threat found.** No work analyses what outdoor VPR descriptors rely on when retrieving anatomical places.

#### C4 threats

**[wang2025topobench]: major.**
- *Overlap.* From the abstract, it proposes "the first quantitative measure of dataset ambiguity to enable fair comparisons across environments". It also curates a benchmark "with calibrated ambiguity levels".
  - From the arXiv HTML, read once and not re-verified:
    - it covers 25 environments (indoor OpenLORIS, Rawseeds, Habitat-Sim; outdoor Oxford RobotCar, RELLIS-3D, ROVER);
    - it reports a mean inter-method correlation of 0.83 across 11 VPR methods;
    - it concludes that ambiguity "is an intrinsic property, largely independent of the specific method used".
  - That is a published, cross-environment, method-agnostic difficulty measurement. C4's sentence "No prior work tests whether a ceiling structure recurs across domains" survives only for the *oracle-ceiling* construct. The ICRA 2026 venue is an arXiv comment and was not found in a DOI registry.
- *Reframe.* C4 becomes: "does the zoo-relative ceiling structure recur in anatomy, and does it agree with a TOPO-Bench-style ambiguity score computed on the same data?" Never write "first cross-domain measure of VPR difficulty".

**[schubert2021makes]: minor.**
- *Overlap.* Variations in the practical context and in individual design decisions make place recognition experiments "barely comparable across different papers". The paper gives an extensive list of such set-up properties (abstract only was read in this pass).
- *Reframe.* Any streets-vs-colon comparison of ceilings confounds domain with set-up: GT type, frame rate and exclusion window. C4 needs set-up-matched comparisons, or an explicit statement that it cannot separate the two.

**Searched with no further C4 threat found.** Two records were verified but not added, because they give framing only and do not overlap:
- a sewer-pipe visual localization paper (Frontiers in Robotics and AI 2023, DOI 10.3389/frobt.2023.1150508), which documents feature-sparse, tubular localization in robotics without any ceiling;
- the Milford & Fischer review "Going Places" (Annual Review of Control, Robotics, and Autonomous Systems 2026, DOI 10.1146/annurev-control-032724-014418), which gives cross-system framing without a measurement.

### Searches run in this pass (new phrasings)

**C1.**
- *arXiv API:*
  - "place recognition" × {endoscopy, endoscopic, colonoscopy, bronchoscopy, surgical, laparoscopic, medical, capsule, gastroscopy};
  - relocalization × {colonoscopy, endoscopic, endoscopy};
  - "loop closure" × {endoscopic, colonoscopy, surgical}; "loop detection" × endoscopy;
  - "image retrieval" × {colonoscopy, ureteroscopy, bronchoscopy};
  - "visual localization" × {colonoscopy, endoscopy};
  - retrieval ∧ endoscopy ∧ "zero-shot"; DINOv2 ∧ colonoscopy; AnyLoc ∧ medical;
  - NetVLAD × {endoscopy, surgical}; "global descriptor" ∧ endoscopy;
  - "re-identification" ∧ relocalization; revisit ∧ colonoscopy;
  - Colon10k; C3VD × {retrieval, "place recognition"}; EndoMapper ∧ retrieval;
  - "visual place recognition" × {"domain shift", "out-of-distribution"}.
- *OpenAlex:*
  - 8 free-text queries;
  - all citers of Colon10k (17) and ColonMapper (4);
  - AnyLoc's citers filtered by {endoscop, colonoscop, medical, surgical, anatom, bronch} (0 hits);
  - EndoMapper's citers filtered by {place recognition, retrieval, relocalization, loop closure, localization}.
- *Web:*
  - zero-shot VPR ∧ colonoscopy ∧ DINOv2;
  - off-the-shelf MegaLoc/SALAD/CosPlace ∧ endoscopy;
  - "anatomical place recognition";
  - EndoVPR / ColonVPR / SurgVPR;
  - foundation-model keyframe-retrieval benchmarks;
  - bronchoscopy / ureteroscopy / sinus global descriptors;
  - surgical scene re-identification;
  - arthroscopy / gastroscopy relocalization;
  - capsule loop closure;
  - MICCAI 2025/2026 workshops;
  - the Morlana MIDL paper and thesis.
- *Read in full:* the MIDL 2021 PDF; ColonMapper Table I and §IV-A (arXiv PDF); Wei et al. (arXiv HTML); the Colon10k abstract and introduction (IEEE Xplore).

**C2.**
- *Web:*
  - VPR oracle / ensemble / upper bound / complementarity;
  - "Bayes error" ∧ retrieval or place recognition;
  - localizability prediction / non-localizable images;
  - VPR hard or unsolvable queries;
  - endoscopy localizability / recognizability;
  - query-difficulty and aleatoric retrieval uncertainty;
  - BER estimation ∧ medical ∧ intrinsic difficulty;
  - colonoscopy informative-frame classification;
  - perceptual aliasing ∧ haustral folds.
- *OpenAlex:* "place recognition" ∧ "upper bound"; "place recognition" ∧ oracle.
- *CrossRef:* Vasconcelos; Snoopy/ease.ml.

**C3.**
- *Web:*
  - texture vs geometry in VPR descriptors / interpretability;
  - C3VD texture variation ∧ foundation features;
  - shape/texture bias ∧ DINOv2 ∧ medical;
  - texture–shape cue conflict ∧ endoscopy;
  - condition bias in VPR;
  - geometry-conditioned VPR in natural environments.
- *arXiv:* batch fetch of 12 candidate records.

**C4.**
- *Web:*
  - TOPO-Bench / quantified perceptual aliasing;
  - perceptual-aliasing measure across environments;
  - VPR in pipes, sewers and tunnels;
  - underwater / forest / planetary zero-shot VPR in 2026 (incl. M3GA-Wild);
  - "Going Places".

### Corrections applied to existing notes (no entries deleted)

1. **Colon10k.** The notes said it is UNKNOWN whether it reports non-fine-tuned baselines. Its abstract now shows it is itself an evaluation of "different existing place recognition techniques" [ma2021colon10k]. Which ones, and whether off-the-shelf, remains unread.
2. **MIDL 2021.** It was "unverified, not in the bib". It is now verified and read in full as [morlana2021selfsupervised], and it contains an off-the-shelf outdoor-trained baseline.
3. **C2's estimator.** "The estimator is not new; it is Paper 3's" and "model-independent" are corrected to a zoo-relative oracle after [waheed2021improving]. "The kNN-BER bracket agrees" is corrected to a heuristic only [wheat2025bayes].
4. **C4.** "No prior work tests whether a ceiling structure recurs across domains" is qualified by [wang2025topobench].
5. **C3's premise.** Texture bias from [geirhos2018imagenettrained] is contested by [burgert2025imagenettrained].

Inline notes marked **(adversarial pass)** were added at each of these places in this file and in `notes/literature.md`.
