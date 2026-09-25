# Paper 4 — Annotated literature review

**Paper 4, "Generalization":** zero-shot transfer of frozen outdoor VPR models to anatomical place recognition, plus the recognizability ceiling in the body.
**Status:** STAGED, with zero results. This file is related work only. Nothing here is a P4 result.
**Bibliography:** `bib/references.bib`, 105 entries. Cite by bib key only.
**Audit:** `notes/citation_audit.tsv`. There is one row per checked identifier: 105 primary records plus 40 secondary arXiv eprints, and every one passed.
**Positioning and novelty verdicts:** `notes/positioning.md`.

## How this review was produced (read before citing anything)

- **Sources.** Three independent literature searches were merged: endoscopic place recognition; endoscopy datasets and foundation models; universal VPR and aliasing. Works were deduplicated by DOI, by arXiv id, or by near-identical normalized title. Where a work had both a preprint and a peer-reviewed version, one entry was kept: the published version with its DOI, plus the eprint.
- **Re-verification.** Every surviving entry was re-verified by script against the arXiv export API (batches of at most 20) and CrossRef. OpenAlex and DataCite were available as fallbacks but were not needed. The rules:
  - Normalized title difflib ratio ≥ 0.90.
  - First-author surname matches.
  - Year matches. For arXiv-only records, a one-year preprint-to-venue lag is tolerated. For a secondary eprint, the arXiv v1 year may be 0–2 years before publication.
- **Negative control.** The same checks were run on mutated claims: swapped DOI, swapped arXiv id, year ±2, wrong first author, near-miss title, and a sibling paper by the same authors. All were rejected, so the 100% pass rate is not a vacuous check.
- **Bib fields.** Every bib field (full author list, title, venue, volume, pages, year) comes from the fetched registry record, not from the researchers' notes. DOI-less works are `@misc`. Any venue they claim (an arXiv comment such as "Accepted to MICCAI 2026") is kept in `note` and marked as not confirmed in a DOI registry.
- **Summaries.** Summaries below condense what the researchers reported from the abstract or full text. Entries marked **[FT]** were re-checked against the full text during this synthesis: ColonMapper, ColonSLAM, EndoMapper, AnyLoc, SEALOC, the underwater benchmark of Gorry et al., CudaSIFT-SLAM, RAUL, and Li et al. 2026. For Colon10k, the official dataset page was re-read, but the paper itself was not.
- **Integrity rule.** Nothing below is a P4 result. Numbers quoted are *other papers'* reported numbers, attributed.

---

## 1. Place recognition and relocalization in colonoscopy (closest prior)

**Synthesis.** Colonoscopy place recognition as image retrieval is established, and P4 must not claim it. Colon10k [ma2021colon10k] framed it as a benchmark in 2021. EndoMapper [azagra2023endomapper] supplied the real-procedure data, with COLMAP covisibility supervision and same-patient repeat procedures. ColonMapper [morlana2024colonmapper] and ColonSLAM [morlana2024topological] built topological mapping and relocalization on top of retrieval.

Every retrieval descriptor in this line that we could inspect is **trained or fine-tuned on colonoscopy**:
- Colon10k fine-tunes following the Radenović recipe (per its dataset page).
- ColonMapper fine-tunes ImageNet R50-GeM/NetVLAD on EndoMapper **[FT]**.
- ColonSLAM fine-tunes the last two layers of Endo-FM **[FT]**.
- The MIDL 2021 predecessor (Morlana et al.) is SfM-supervised. It is *unverified in any registry* and is not in the bib; see §15.

Natural-image *local* matchers are, however, already used off-the-shelf inside these pipelines: ColonMapper uses LoFTR with outdoor weights, and ColonSLAM uses LightGlue/SuperPoint **[FT]**.

**What is open.** We found no work that evaluates the modern outdoor-trained VPR zoo (NetVLAD, CosPlace, EigenPlaces, MixVPR, BoQ, SALAD, MegaLoc, AnyLoc) zero-shot on any colonoscopy place-recognition ground truth. We found no oracle-ceiling or Bayes-error decomposition for endoscopic place recognition either.

**Open risk.** The Colon10k ISBI paper itself could not be read by any researcher. It is therefore **unknown** whether it already reports off-the-shelf, non-fine-tuned baselines.

- **[ma2021colon10k]** Colon10k is the first colonoscopy place-recognition benchmark: 20 short real sequences with endoscopist-verified same-place matches.
  - GT is one `<CASE-ID>-matchings.txt` per case, with lines `query_id | positive intervals`.
  - Images are 270×216, undistorted from 1350×1080 fisheye to pinhole. One pinhole intrinsic is given (fx = fy = 145.441, cx = 135.70, cy = 107.89). Copyright belongs to UNC Medical School.
  - The authors' retrievers were fine-tuned after Radenović et al.
  - **Image count is unreconciled.** The paper abstract (per search snippets) and EndoMapper's Table 1 **[FT]** say 10,126. The 20 per-case counts on the official dataset page (re-read 2026-09-25) sum to **10,216**, ranging 104–879 per case. Both researchers' figures, 10,464 and 10,264, are wrong; neither matches the page. The loader spec must count the files it actually has.
  - *Bearing:* this is P4's primary E1/E2 dataset. It pre-empts the formulation (conceded in EVIDENCE §2). Its unread baseline table is the main open threat to any "first" wording.
- **[morlana2024colonmapper]** ColonMapper **[FT]** is a topological map (nodes are image sets) plus Bayesian relocalization in real colonoscopies.
  - Its global descriptors are R50-GeM and R50-NetVLAD. They are "pretrained on ImageNet and fine-tuned in our colonoscopy data", with layer 1 frozen, trained on EndoMapper covisibility plus manual pairs.
  - Retrieval is tested on EndoMapper Seq_027 vs Seq_035 (same patient, two weeks apart; 84/78 queries) with mAP. R50-NV-H scores 75.7/33.0 intra/cross and R50-GeM-H 73.3/38.5, against 53.7/21.7 for the MIDL'21 model. (The two researchers' differing numbers are both real rows of the same Table I.)
  - Short-term matching uses LoFTR with outdoor weights.
  - Frames that are "not visually recognizable" are hand-labelled `none` and excluded, and a 25-image "reject node" absorbs confusing frames.
  - *Bearing:* this is the fine-tuned in-domain comparator and a shared test protocol for a head-to-head. Its `none` labels are a human-judged "unrecognizable" set, a natural external check on our irreducible fraction. It already shows outdoor-trained local matchers running zero-shot in the colon.
- **[morlana2024topological]** ColonSLAM **[FT]** links CudaSIFT-SLAM submaps into a whole-colon topological map.
  - It uses a same-place network that fine-tunes the last two layers of Endo-FM plus an MLP, with off-the-shelf LightGlue for verification.
  - Its baselines are Morlana21, ColonMapper R50-NV-H and LightGlue. There is no frozen outdoor-VPR baseline.
  - *Bearing:* this is the current SOTA and the "medical-FM, fine-tuned" reference point that P4 contrasts against.
- **[elvira2024cudasiftslam]** CudaSIFT-SLAM **[FT]** reports that ORB-SLAM3 cannot relocalize or merge maps in colonoscopy "due to the poor performance of its place recognition algorithm based on ORB features and DBoW2 bag-of-words". It replaces them with GPU SIFT and brute-force matching.
  - *Bearing:* classical place recognition fails in the colon, which motivates measuring learned global descriptors. It is also the SLAM backbone under ColonSLAM.
- **[kim2026lesioncentered]** Assembles published components on C3VDv2 and REAL-Colon videos: a ColonMapper-style topological map with Bayesian localization, lesion tracks, and local 3D. An endoscopy-specific depth model beats a general foundation model there.
  - *Bearing:* shows ColonMapper-style place recognition being reused in 2026. It has no frozen-VPR benchmark, and its general-vs-specific result concerns depth, not retrieval.
- **[barbed2025automated]** BYOL descriptors (ImageNet ResNet-50, then self-supervised on EndoMapper frames) to cluster and summarize complete procedures.
  - *Bearing:* an additional in-domain, self-supervised descriptor. It is not place-recognition GT and not a pre-emption.

## 2. Off-the-shelf / zero-shot models already inside endoscopic localization (the "not first use" evidence)

**Synthesis.** Zero-shot use of natural-image or general models inside the body is *already practised*:
- training-free foundation-model re-identification after scope reinsertion [soberanismukul2026global];
- hloc-style NetVLAD retrieval in ureteroscopy [li2026raul, li2026automated] **[FT]**;
- TAP foundation models for SLAM across four endoscopic domains [teufel2024oneslam];
- outdoor LoFTR and off-the-shelf LightGlue in ColonMapper and ColonSLAM (§1).

None of these *measures* retrieval quality per model or decomposes the error. So P4 can claim a **systematic benchmark plus ceiling diagnosis**, never "first use" and never "all prior work fine-tunes".

- **[soberanismukul2026global]** A training-free method that "combines advanced foundation models with classical techniques" to re-identify the region of interest after endoscope reinsertion. Pose then comes from feature matching and PnP against CT. It reports 1.74 mm mean translation error on 8 cadaver sequences from 3 studies.
  - Only the abstract was read (the paper is paywalled). **Which foundation model it uses is unknown.**
  - *Bearing:* it directly falsifies the outline's §1 sentence "all prior work fine-tunes a medical descriptor or uses an endoscopy foundation model". It must be read, and its model identified, before related work is written.
- **[li2026raul]** RAUL **[FT]** localizes phantom ureteroscopy against an hloc/COLMAP reference. NetVLAD "is used to retrieve candidate covisible" images, then ALIKED+LightGlue. It reaches 0.5 mm RMSE against EM tracking.
  - NetVLAD's weights are not stated in the text, and its retrieval accuracy is not measured.
  - *Bearing:* an outdoor-trained VPR model used silently as a component, which motivates measuring it.
- **[li2026automated]** A sibling paper from the same group **[FT]**: "First, NetVLAD retrieves candidate covisible reference images", followed by local-feature filtering, in kidney-phantom ureteroscopy.
  - *Bearing:* as above; it is the earlier of the two.
- **[teufel2024oneslam]** OneSLAM is monocular SLAM on tracking-any-point foundation models. It works "out of the box" across sinus, colon, arthroscopy and laparoscopy, and names global loop detection as future work.
  - *Bearing:* a precedent that general models transfer zero-shot into endoscopy, and an explicit statement that loop closure (place recognition) is still open.
- **[hernandez2023investigating]** 6-DoF relocalization in cadaveric sinus endoscopy with local descriptors and PnP. A patient-specific learned descriptor is compared with HardNet++, and only 21.86% of cameras are localized.
  - *Bearing:* a non-colon relocalization precedent with local, not global, descriptors. It supports an "intrinsically hard" framing.
- **[barbed2022superpoint]** Evaluates SIFT and off-the-shelf SuperPoint on EndoMapper colonoscopy, and adapts SuperPoint to avoid specularities. SuperPoint-based matching beats handcrafted features.
  - *Bearing:* the keypoint-level analogue of P4's transfer question, answered for local features.
- **[yang2026endomatcher]** EndoMatcher is a dense matcher pre-trained on ~1.2M endoscopic image pairs across 6 domains. It reports strong zero-shot cross-dataset generalization.
  - *Bearing:* the medical-pretrained counterpart at the matching or re-ranking level, if P4 adds re-ranking.

## 3. Colonoscopy reconstruction, coverage and SLAM (why relocalization matters)

**Synthesis.** Relocalization matters because colon reconstruction is fragmented into chunks, and coverage gaps cause missed lesions [ma2019realtime, ma2021rnnslam, freedman2020detecting, leifman2023colonoscopy]. Place recognition is what links chunks and detects revisits. Endoscopic scenes break the rigid-world assumptions behind outdoor VPR: low texture, specularities from the co-located light, and deformation [schmidt2024tracking, lamarca2021defslam, gomezrodriguez2024nrslam]. These are background and threats-to-validity citations, not competitors.

- **[ma2019realtime]** Real-time dense chunk reconstruction (DSO plus an RNN for depth and pose) that visualizes unsurveyed regions. It comes from the Colon10k group.
  - *Bearing:* motivation (long-range correspondence and loop closure).
- **[ma2021rnnslam]** RNNSLAM, the journal version: a colonoscopy-fine-tuned depth and pose RNN fused with DSO. It reconstructs dense chunks and leaves unsurveyed parts empty.
  - *Bearing:* the standard citation for colon reconstruction and coverage. Place recognition is what connects its chunks.
- **[posner2023c3fusion]** C³Fusion is a colon SLAM with in-domain contrastive features and consistent depth. It recovers from frequent tracking failures.
  - *Bearing:* background on in-domain learned features for relocalization.
- **[freedman2020detecting]** C2D2 estimates depth and pose to flag deficient coverage and prompt a revisit.
  - *Bearing:* the clinical motivation for revisit detection. Background only.
- **[leifman2023colonoscopy]** Real-time detection of skipped segments without dense 3D, on data from 2,500 procedures.
  - *Bearing:* the field is moving towards appearance-based localization signals. Background.
- **[schmidt2024tracking]** A review of tracking and mapping in medical vision. It catalogues low texture, specular reflections, deformation and illumination change.
  - *Bearing:* the authoritative source for the failure modes P4's preprocessing and E4 taxonomy must address.
- **[lamarca2021defslam]** DefSLAM, the first real-time monocular SLAM for deforming scenes, demonstrated on endoscopy.
  - *Bearing:* deformation is a candidate source of "irreducible" error that is absent in cities. The ceiling interpretation must address it.
- **[gomezrodriguez2024nrslam]** NR-SLAM, the state of the art in non-rigid monocular SLAM.
  - *Bearing:* pairs with DefSLAM in threats to validity.

## 4. "Where in the colon" as classification (context for E3)

**Synthesis.** Anatomical-segment recognition over full colonoscopy videos is an **established supervised task**:
- EndoMapper's own region baseline [azagra2023endomapper] **[FT]**;
- ColonTCN on REAL-Colon [biffi2025temporal];
- density clustering over cascaded CNNs [kim2024density];
- ST-ColoNet [cai2026stcolonet];
- odometry-based segment localization [yao2021motionbased].

E3 must therefore be framed as a *frozen-representation probe*, not a new task. EndoMapper's region labels cover only **5 sequences**, so a cross-patient split has at most 5 folds. Larger alternatives exist: REAL-Colon labels (60 procedures, 4 centres) and CAS-Colon (78 videos).

- **[biffi2025temporal]** Adds open-access frame-level anatomical-section and procedural-phase labels (9 categories) to all 60 REAL-Colon procedures (~2.7M frames). It proposes ColonTCN with a dual k-fold multi-centre protocol.
  - *Bearing:* the best cross-patient E3 testbed found, and a supervised SOTA to report beside a frozen-feature kNN or linear probe.
- **[kim2024density]** Supervised cascaded CNNs detect the appendiceal orifice, flexures and out-of-body frames in 100 videos. Density clustering then splits the colon into right, middle and left sections.
  - *Bearing:* a supervised reference for coarse segment recognition.
- **[cai2026stcolonet]** Supervised spatio-temporal colon-segment recognition. It releases ColoSeg (EndoMapper plus 21 newly annotated withdrawal videos).
  - Its own arXiv v3 comment says "some experiments need to be updated".
  - *Bearing:* cite cautiously, if at all.
- **[yao2021motionbased]** A self-trained CNN estimates camera motion; the integrated trajectory plus a colon template classify segments.
  - *Bearing:* a non-appearance route to "where in the colon", the contrast for appearance-only E3.

(EndoMapper's region baseline is summarized under [azagra2023endomapper] in §6.)

## 5. Localization beyond the colon: bronchoscopy, capsule, upper GI

**Synthesis.** Outside the colon, in-body localization comes from four routes:
- supervised classification plus temporal priors (HMMs or Bayes filters) [keuth2024airway, werner2023precise, nam2024deep, wu2019randomised];
- lumen and anatomy-structure tracking against an airway graph [tian2025bronchotrack, tomasini2026bronchotop, tomasini2025online];
- registration to CT-rendered views [mori2002tracking, sganga2019offsetnet, shu2025bronchopt, chen2026geometryaware];
- medical foundation models used as features [tian2025harnessing].

We found no appearance-based global-descriptor VPR benchmark in bronchoscopy, capsule endoscopy or gastroscopy. These are background for a one-paragraph "beyond the colon" framing. P4 does not evaluate these organs.

- **[mori2002tracking]** Foundational bronchoscope tracking: epipolar motion estimation plus intensity registration of real frames to CT-rendered virtual views.
  - *Bearing:* the historical anchor for "localize by matching to a reference view".
- **[sganga2019offsetnet]** OffsetNet: a CNN regresses bronchoscope pose offsets relative to CT-rendered views. It is trained per anatomy on phantom video and fails in less-conserved regions without simulated augmentation.
  - *Bearing:* a trained, anatomy-specific localizer, in contrast to frozen patient-agnostic retrieval.
- **[keuth2024airway]** Airway-segment likelihoods from a trained CNN feed an HMM with anatomical constraints, against a generic airway model. Phantom weighted F1 rises from 0.81 per frame to 0.98 with the HMM.
  - *Bearing:* the bronchoscopy analogue of E3 plus a sequence prior (E5).
- **[tomasini2025online]** Image-based topological localization relative to a generic airway model without patient CT. It is trained on phantom data and generalizes to real sequences.
  - *Bearing:* uses trained components, not frozen VPR.
- **[tomasini2026bronchotop]** RGB-only topological localization: training-free lumen detection and tracking, lumen-to-branch association, a Bayesian location estimate, and a small trained siamese verifier. Evaluated against expert node labels.
  - *Bearing:* the 2026 bronchoscopy SOTA, which localizes by anatomy structure, not appearance retrieval.
- **[tian2025bronchotrack]** Branch-level localization by lumen detection, multi-object tracking and training-free association with an airway graph. It reports 81.72% accuracy on 11 patients.
  - *Bearing:* background.
- **[tian2025harnessing]** PANSv2 fuses depth from EndoOmni, landmarks from EndoMamba and centreline cues for cross-patient 6-DoF bronchoscopy localization.
  - *Bearing:* the field reaches for *medical* foundation models to generalize, which is the other side of P4's contrast.
- **[shu2025bronchopt]** BronchOpt does frame-wise 2D–3D registration with a *fine-tuned* modality-invariant foundation-model encoder that scores real vs CT-rendered views.
  - *Bearing:* the closest "retrieval by learned similarity" in bronchoscopy, and again fine-tuned.
- **[chen2026geometryaware]** GABL: graph-guided coarse-to-fine 6-DoF bronchoscopy localization fusing airway structure with video.
  - Its ACM MM 2026 acceptance is an arXiv comment. Its DOI was listed on arXiv but was not resolvable in CrossRef at research time.
  - *Bearing:* body localization still relies on patient-specific CT priors.
- **[werner2023precise]** Capsule-endoscopy "localization" as GI-section classification with a small CNN plus HMM correction.
  - *Bearing:* capsule localization is classification, not retrieval.
- **[nam2024deep]** A CNN-LSTM organ classifier (stomach, small bowel, colon) with boundary calibration, on PillCam data from 126 patients.
  - *Bearing:* background for the capsule paragraph.
- **[wu2019randomised]** WISENSE: an RCT of real-time CNN-based recognition of 26 EGD anatomical sites for blind-spot monitoring.
  - *Bearing:* clinically validated supervised site recognition. P4 must not imply clinical improvement over such systems.
- **[widya2019whole]** SfM whole-stomach reconstruction with frame localization against the model.
  - *Bearing:* a geometric, map-based gastroscopy analogue. Background.

## 6. Datasets with place, pose or anatomical ground truth

**Synthesis.**
- **Same-place GT on real patients:** only Colon10k (pairwise, endoscopist-verified) and EndoMapper's COLMAP covisibility (pseudo-GT; up to scale; smooth, rigid segments only).
- **Frame-level 6-DoF pose GT:** exists only on phantoms or synthetic data (C3VD, C3VDv2, SimCol3D, C3VD-DEFCOL) or on ex-vivo tissue (EndoSLAM).
- **Real-patient scope trajectories:** exist publicly (Copenhagen CCD), **but without images**.
- **The outline's sentence** "real-patient pose GT does not publicly exist at frame level" is therefore right in substance. It should be phrased precisely: no public real-patient *image–pose pairs*. Cite [cold2025mapping].
- **C3VDv2 [golhar2026c3vdv2]** postdates the outline. Its debris-filled videos with clean twins on *identical* trajectories are an exact-pose, condition-change analogue of VPR.
- **Coarse-label sets** (HyperKvasir, Kvasir-Capsule, Galar) have no pose or revisit GT.

- **[azagra2023endomapper]** EndoMapper **[FT]**: 96 complete calibrated procedures (~24 h) on Synapse, access by request. It provides:
  - COLMAP reconstructions with cluster and covisibility files;
  - `SamePatient.json` (repeat procedures weeks apart);
  - frame-level anatomical regions in `Anatomical_Regions_XXX.txt`, with lines `Frame###;region label;` and 10 labels.
  - The region labels cover **only Seq_003/011/013/093/094 (268,679 frames)**.
  - Its own region-recognition baseline fine-tunes four ImageNet CNNs on 4 sequences and tests on Seq_094: **Top-1 17.61–26.08%, Top-3 48.00–66.77%**. The authors call region classification "a challenging research problem" because "differences between sections are very subtle".
  - *Bearing:* it is the E3 source as planned, but too small for cross-patient claims. It is also the source of ColonMapper's retrieval protocol.
- **[bobrow2023colonoscopy]** C3VD: 22 videos (10,015 frames) of silicone phantoms, plus 4 simulated screening videos.
  - Per-frame 6-DoF pose (robot log plus hand-eye calibration, aligned by 2D–3D registration), depth, normals, flow, occlusion and coverage.
  - Fisheye camera at 1350×1080.
  - *Bearing:* E2 pose-GT source, in-silico only. ColonMapper already used its same-geometry, different-texture sequences for place recognition (with region labels, not pose radius).
- **[golhar2026c3vdv2]** C3VDv2: 192 videos (169,371 frames) from 2 sculpted geometries × 4 textures; 169 videos with pixel-wise GT and 6-DoF pose.
  - Adds realism artefacts: debris, mucus, blood, foam, water on the lens.
  - Every debris-filled video has a clean twin recorded on an **identical camera trajectory**. CC BY 4.0.
  - *Bearing:* supersedes C3VD for E2. It gives exact-pose query/database pairs under appearance change, and a geometry × texture design for C3.
- **[luk2026c3vddefcol]** C3VD-DEFCOL: controlled deformations of C3VD/C3VDv2 meshes with per-frame pose and time-stamped meshes. The **RGB appearance is AI-generated** by a video model.
  - *Bearing:* the only deformation-with-pose source. Revisit appearance may be inconsistent, which would confound same-place GT. Optional at most.
- **[rau2024simcol3d]** SimCol3D: CT-derived synthetic colons rendered in Unity, with per-frame depth, absolute pose and intrinsics. Its real-data "GT" is COLMAP pseudo-GT on EndoMapper.
  - *Bearing:* a clean synthetic control with multiple trajectories through the same anatomy. It confirms that real-patient pose GT is pseudo-GT.
- **[ozyoruk2021endoslam]** EndoSLAM: ex-vivo porcine GI organs (colon, stomach, small intestine) with capsule and conventional endoscopes, robot-arm 6-DoF pose, plus synthetic VR-Caps.
  - *Bearing:* a secondary multi-organ pose source. Revisits may be sparse.
- **[allan2021stereo]** SCARED (EndoVis 2019): da Vinci porcine-cadaver abdomen, structured-light depth at keyframes, kinematic poses.
  - *Bearing:* laparoscopic, not luminal. Low priority.
- **[ye2017selfsupervised]** The source usually cited for the rectified Hamlyn laparoscopic stereo data.
  - Hamlyn has **no pose or place GT**, so it cannot serve as a P4 localization benchmark.
  - *Bearing:* cite only to say why Hamlyn is excluded.
- **[cold2025mapping]** The Copenhagen Colonoscopy Coordinate Database: 1,400 clinical plus 100 simulator colonoscopies with magnetic scope coordinates (position only) and landmark event logs. **No video released.**
  - *Bearing:* makes the "no real-patient pose GT" statement precise.
- **[biffi2024realcolon]** REAL-Colon: 60 full-procedure recordings (2.7M frames) from 4 centres, with 350k polyp boxes.
  - *Bearing:* the base of the anatomical labels in [biffi2025temporal]. A real multi-centre domain.
- **[song2025cascolon]** CAS-Colon: 78 withdrawal videos with 10-region boundaries from a single centre. Licence CC BY-NC-ND. It notes EndoMapper has only five anatomy-annotated videos.
  - *Bearing:* a second cross-patient E3 candidate. The NC-ND licence limits redistribution of derived data.
- **[borgli2020hyperkvasir]** HyperKvasir: 110,079 images and 374 videos; 23 image-level classes including 3 upper- and 3 lower-GI landmarks.
  - *Bearing:* coarse classification only. Frozen DINOv2 is already near ceiling on its landmark split [dermyer2025endodino], so it cannot separate encoders.
- **[smedsrud2021kvasircapsule]** Kvasir-Capsule: 117 capsule videos (4.7M frames), 47,238 labelled frames in 14 classes, including the pylorus and ileocecal-valve landmarks.
  - *Bearing:* auxiliary coarse probe only.
- **[lefloch2025galar]** Galar: 80 capsule videos (3.5M frames) with frame-wise labels, including anatomical sections.
  - *Bearing:* the only capsule set with whole-video section labels. Auxiliary.

## 7. Retrieval and representation learning in colonoscopy video (object- and clip-level)

**Synthesis.** Retrieval in colonoscopy exists at the **lesion or clip level**:
- polyp re-identification [intrator2023selfsupervised, parolari2026contrastive];
- cross-screening clip retrieval [chen2023coloscrl];
- landmark-class image retrieval [kim2025improving].

These delimit P4 as place-level (scene) retrieval. Two findings shape expectations:
- Colo-SCRL already states that general-domain retrieval models transfer poorly to colonoscopy. P4 must not present "a domain gap exists" as a finding.
- Parolari et al. find **frozen DINOv2 features strong** for colonoscopy retrieval. P4's E1 "large drop" hypothesis may fail for DINOv2-based VPR models.

- **[chen2023coloscrl]** Colo-SCRL: MAE plus momentum-contrast pretraining for colonoscopic clip retrieval on Colo-Pair (60 videos, 30 patients, cross-screening). It states that action-recognition-trained retrieval models give "unsatisfactory" results due to the domain gap.
  - *Bearing:* pre-empts the generic "domain gap" statement at clip level.
- **[intrator2023selfsupervised]** Self-supervised attention-based polyp re-identification across long colonoscopy video.
  - *Bearing:* the adjacent object-level line. Delimits scope.
- **[parolari2026contrastive]** Noise-aware temporal contrastive learning of polyp-tracklet embeddings.
  - Baselines are **frozen** general FMs (DINOv2 S/B/L/g, DINOv3, V-JEPA2) and endoscopy FMs (EndoFM, EndoFM-LV, EndoViT, SurgeNet).
  - The lightweight in-domain model matches or exceeds DINOv2-giant.
  - MICCAI 2026 acceptance is an arXiv comment.
  - *Bearing:* the nearest precedent for P4's comparator design (frozen natural vs endoscopy FMs on colonoscopy retrieval), but object-level. It warns that frozen DINOv2 may transfer well.
- **[kim2025improving]** Content-based retrieval of 7 documentation or landmark classes (Kvasir/HyperKvasir) using a dual DINOv2 plus GastroNet backbone with parameter-efficient metric learning. The paper reports that GastroNet beats DINOv2 zero-shot.
  - *Bearing:* the only published general-vs-GI-pretrained retrieval comparison found. It is class-level and fine-tuned, not same-place.

## 8. Endoscopy and surgical foundation models (the medical-pretrained comparator)

**Synthesis.**
- **Available models.** Endoscopy foundation models include video transformers (Endo-FM, EndoFM-LV, EndoMamba), image ViTs (EndoViT, Hirsch et al.'s MSN models, EndoDINO) and GI/surgical-scale pretraining (GastroNet-5M, SurgeNetXL).
- **How they are evaluated.** Almost always by fine-tuning or adapting on classification, segmentation, detection or phase recognition, and **never on place recognition or retrieval**. The exception is ColonSLAM, which fine-tunes Endo-FM for same-place.
- **In-domain vs natural pretraining.** In-domain pretraining beats natural-image pretraining for fine-tuned GI tasks [boers2024foundation, jong2026gastronet5m]. On frozen coarse landmark recognition, however, generic DINOv2 is already at parity [dermyer2025endodino].
- **Adaptation is the norm.** The prevailing practice is to adapt DINOv2 [cui2024surgicaldino], which makes a strictly frozen study a defensible contrast.
- **Weights.** Public weights are stated for Endo-FM, EndoViT, SurgeNetXL and Hirsch et al. EndoMamba states public code; its weights were not checked. Weights were **not verified** for GastroNet-5M or EndoDINO.

- **[wang2023foundation]** Endo-FM: a spatio-temporal video transformer pretrained self-supervised on more than 33K clips from 9 public datasets and 1 private dataset. It is evaluated by fine-tuning. Code and weights are public.
  - *Bearing:* the canonical medical arm. It is ColonSLAM's backbone.
- **[wang2025improving]** EndoFM-LV: minute-level pretraining on 6,469 long endoscopy videos.
  - *Bearing:* the successor and a candidate medical arm. Long-sequence context is relevant to E5.
- **[batic2024endovit]** EndoViT: an MAE-pretrained ViT on Endo700k (9 public minimally invasive surgery datasets). Code and models are released.
  - *Bearing:* the easiest image-level medical arm to drop into the zoo. Its pretraining is surgical or laparoscopic, not GI lumen.
- **[jong2026gastronet5m]** GastroNet-5M: 4.8M images from ~500k procedures in 8 Dutch hospitals. Its self-supervised GI FM is best on nearly all of 17 applications.
  - Weight availability is **not verified**.
  - *Bearing:* the strongest GI comparator, if it is obtainable.
- **[boers2024foundation]** In-domain self-supervised pretraining (SimCLRv2, MoCov2, DINO) on 5M GI images beats natural-image pretraining on 5 fine-tuned GI tasks.
  - *Bearing:* motivates a medical arm. It says nothing about frozen retrieval.
- **[jaspers2026scaling]** SurgeNetXL: SSL on more than 4.7M surgical frames. It beats surgical FMs and ImageNet variants on segmentation, phase and critical-view-of-safety tasks. Models are public.
  - *Bearing:* a surgical, not GI-luminal, comparator.
- **[dermyer2025endodino]** EndoDINO: DINOv2-with-registers ViTs pretrained on up to 10M GI images and evaluated **frozen**.
  - On HyperKvasir landmarks (linear probe), generic DINOv2 ViT-B/14 and ViT-g/14 reach macro-F1 0.833 and micro-F1 0.998, **identical** to EndoDINO ViT-B/14.
  - Its gains appear in few-shot and segmentation settings.
  - *Bearing:* cuts against a large-drop expectation. Coarse place classification may be saturated.
- **[tian2025endomamba]** EndoMamba: a real-time Mamba video FM with hierarchical pretraining that includes alignment to a general-domain video FM. Localization is among its downstream tasks.
  - *Bearing:* a candidate E5 medical arm. It blurs the "medical vs general" split.
- **[hirsch2023selfsupervised]** Masked Siamese Network pretraining on large private colonoscopy and laparoscopy corpora. Models are public.
  - *Bearing:* a colonoscopy-specific SSL encoder, closer to the target domain than EndoViT or SurgeNet.
- **[cui2024surgicaldino]** Surgical-DINO: LoRA-adapted DINOv2 for endoscopic depth.
  - *Bearing:* evidence that practice adapts DINOv2 rather than freezing it.

## 9. Transfer of natural-image features to medical imaging

**Synthesis.** The general literature is split.
- Transfusion [raghu2019transfusion] finds little benefit from ImageNet transfer on large medical tasks.
- Matsoukas et al. [matsoukas2022makes] show that feature reuse matters, depending on data size and domain distance.
- Large self-supervised natural-image models transfer well [azizi2021big]. DINOv2 is singled out as useful when frozen [huix2024natural, baharoon2023evaluating]. DINOv3 is competitive on endoscopy linear probes but degrades in highly specialized domains [liu2025dinov3].
- Zero-shot general-vs-in-domain comparisons in endoscopy exist for depth [han2024depth].

All of this is **classification, segmentation or depth**. None of it concerns same-place retrieval. It gives P4 vocabulary (feature reuse, domain distance, texture bias [geirhos2018imagenettrained]) for Contribution 3, not pre-emption.

- **[raghu2019transfusion]** Transfusion: on large medical tasks, ImageNet transfer gives little benefit, and meaningful feature reuse is mainly in the lowest layers. NeurIPS 2019 is an arXiv comment.
  - *Bearing:* the foundational "does natural pretraining transfer" citation. It studies fine-tuning.
- **[azizi2021big]** ImageNet SSL followed by in-domain SSL (MICLe) improves dermatology and chest-X-ray classification, and big SSL models are more robust to shift.
  - *Bearing:* supports having both general and domain-continued SSL arms.
- **[matsoukas2022makes]** Transfer benefit depends on data size, capacity, inductive bias and domain distance, and feature reuse matters.
  - *Bearing:* the method and vocabulary for the representation diagnosis. It counterbalances Transfusion.
- **[huix2024natural]** Of SAM, SEEM, DINOv2, BLIP and OpenCLIP on 4 medical classification sets, only DINOv2 consistently beats ImageNet pretraining.
  - *Bearing:* supports thesis (a), that frozen natural SSL features transfer. Classification only.
- **[baharoon2023evaluating]** More than 200 evaluations of DINOv2 on X-ray, CT and MRI under kNN, few-shot, linear-probe, fine-tuning and PEFT.
  - *Bearing:* a model for the frozen kNN and linear-probe protocol planned in E3.
- **[liu2025dinov3]** Frozen DINOv3 across medical modalities matches or beats some medical FMs but degrades in WSI, EM and PET. On endoscopy (Kvasir-Capsule, AutoLaparo linear probes) it is competitive. The researcher read this from the arXiv HTML.
  - *Bearing:* argues against expecting a catastrophic E1 drop. It motivates a raw DINOv3 arm.
- **[han2024depth]** Zero-shot Depth Anything on endoscopic and laparoscopic scenes, against general and in-domain depth models: impressive but not necessarily better.
  - *Bearing:* a methodological precedent for zero-shot general-vs-in-domain comparison in endoscopy, for geometry.
- **[oquab2023dinov2]** DINOv2: self-supervised ViTs on LVD-142M with strong frozen features.
  - *Bearing:* the backbone of SALAD, BoQ (ViT variant), MegaLoc, AnyLoc and EndoDINO. A raw frozen DINOv2 arm separates "VPR training" from "backbone" effects.
- **[simeoni2025dinov3]** DINOv3, the successor self-supervised FM.
  - *Bearing:* optional newest-backbone control.
- **[geirhos2018imagenettrained]** ImageNet CNNs rely on texture more than shape. The arXiv v1 is 2018; ICLR 2019 acceptance is an arXiv comment.
  - *Bearing:* the theoretical basis for the geometry-vs-texture diagnosis (C3). CNN-based zoo members may behave differently from DINOv2-based ones on uniform mucosa.

## 10. The outdoor VPR model zoo

**Synthesis.** These are the models P4 would run frozen. The zoo spans CNN-based and DINOv2-based models:
- CNN-based: NetVLAD, CosPlace, EigenPlaces, MixVPR.
- DINOv2-based: SALAD, BoQ-DINOv2, MegaLoc, and training-free AnyLoc.

Two cross-domain studies make the architectural split matter: AnyLoc **[FT]** and SEALOC **[FT]** (§11) both find DINOv2-based models far more robust off-street. The outline's zoo omits **AnyLoc, raw DINOv2 and MixVPR**, the three reference points reviewers will look for. Adapter and re-ranking approaches (SelaVPR, EffoVPR) mark the boundary of "zero-shot".

- **[arandjelovic2016netvlad]** NetVLAD: a trainable VLAD layer, weakly supervised on Pittsburgh Street View.
  - *Bearing:* the oldest zoo member. It is also the aggregator of ColonMapper's fine-tuned network, so zero-shot vs fine-tuned NetVLAD isolates the effect of medical fine-tuning.
- **[berton2022rethinking]** CosPlace: VPR as classification over geographic cells on SF-XL.
  - *Bearing:* a purely city-trained zoo member.
- **[berton2023eigenplaces]** EigenPlaces: viewpoint robustness from the principal directions of street-view camera positions.
  - *Bearing:* its learned viewpoint robustness is urban-geometric. Relevant to C3.
- **[alibey2023mixvpr]** MixVPR: MLP-Mixer aggregation on CNN features, trained on GSV-Cities.
  - *Bearing:* the specialized baseline that AnyLoc and SEALOC report collapsing off-street. Add it for comparability.
- **[alibey2024boq]** BoQ: learnable queries cross-attending to backbone features.
  - *Bearing:* a current-SOTA zoo member.
- **[izquierdo2024optimal]** SALAD: DINOv2 with optimal-transport (Sinkhorn) feature-to-cluster assignment and a "dustbin" for uninformative features.
  - *Bearing:* the dustbin is directly relevant to whether featureless mucosa is discarded.
- **[izquierdo2024close]** CliqueMining: batch mining of visually similar nearby places, improving short-range geographic sensitivity.
  - *Bearing:* fine-scale sensitivity maps onto mm-scale anatomical localization. It is in SEALOC's zoo. Optional.
- **[berton2025megaloc]** MegaLoc: a single DINOv2 retrieval model trained on a union of VPR and landmark datasets.
  - *Bearing:* the strongest "general" VPR model, and best overall on SEALOC.
- **[keetha2024anyloc]** AnyLoc **[FT]**: training-free "universal" VPR from frozen DINOv2 features with unsupervised VLAD or GeM. It is evaluated on urban, indoor, aerial, subterranean, degraded and underwater data.
  - VPR-trained baselines are fragile off-street. MixVPR lags AnyLoc-VLAD "by 32% and 18% on average (R@1)".
  - Its VLAD vocabulary is built per domain from **target-domain database images**.
  - It never tests medical imagery.
  - *Bearing:* the main pre-emption of the general "VPR-trained models drop out of domain" story. It is a must-include zoo member. Its domain vocabulary forces P4 to define whether a target-domain unsupervised vocabulary counts as zero-shot.
- **[lu2024seamless]** SelaVPR: parameter-efficient adapters on a frozen FM. ICLR 2024 is an arXiv comment.
  - *Bearing:* marks the boundary between zero-shot and fine-tuned. A checkout exists at `vpr-testtime/external/SelaVPR`.
- **[tzachor2024effovpr]** EffoVPR: intermediate-layer FM features as a strong zero-shot re-ranker. The arXiv journal-ref gives ICLR 2025, but no DOI.
  - *Bearing:* zero-shot is not only AnyLoc. Cite it in related work.

## 11. Zero-shot VPR in unstructured, non-urban domains (methodological precedent)

**Synthesis.** Benchmarking the frozen outdoor zoo in a new, texture-poor domain is an **established genre** in 2025–26:
- underwater: SEALOC **[FT]** and SQUIDLE+ **[FT]**;
- object-centric, indoor and driving: [haitz2026evaluation];
- forest: [knights2026wildcross];
- planetary analogue: [encinargonzalez2025multimodal].

Their shared findings:
- Recall is far below terrestrial benchmarks.
- DINOv2-based models (MegaLoc, AnyLoc) beat CNN-based ones.
- **Distance-threshold GT can overestimate recall on rugged terrain** [larsen2026longterm].

P4's protocol is therefore not novel. Its domain and its ceiling analysis are. SEALOC's GT finding directly threatens a pose-radius GT on C3VD, where two poses within τ mm in a tube may face different directions and share no view.

- **[larsen2026longterm]** SEALOC **[FT]**: an underwater long-term VPR dataset benchmarking eight models without retraining (NetVLAD, MixVPR, CosPlace, EigenPlaces, AnyLoc, CliqueMining, SALAD, MegaLoc).
  - Recall@K is much lower than on land. MegaLoc and AnyLoc are strongest.
  - It proposes footprint-overlap GT and shows location-based GT "overestimates model performance" at rugged sites.
  - *Bearing:* the closest methodological prior for C1, and the reason E2 needs view-overlap GT.
- **[gorry2025imagebased]** The SQUIDLE+ underwater benchmark **[FT]**: six off-the-shelf VPR methods (MixVPR, CosPlace, NetVLAD, AnyLoc, MegaLoc, CricaVPR) inside a relocalization and alignment pipeline.
  - *Bearing:* confirms the protocol is standard. It is also a comparison point for another weak-texture domain.
- **[haitz2026evaluation]** Evaluates NetVLAD-style methods, CosPlace, EigenPlaces, MixVPR, AnyLoc, SALAD and MegaLoc off the shelf as pair-retrieval front-ends on Tanks and Temples, ScanNet-GS and KITTI. Strengths and weaknesses are domain-dependent. ISPRS Annals 2026 is an arXiv comment.
  - *Bearing:* the zoo-transfer genre is active. There is no medical data.
- **[knights2026wildcross]** WildCross: a large forest benchmark for visual, LiDAR and cross-modal place recognition. ICRA 2026 is an arXiv comment.
  - *Bearing:* supports the premise that urban-trained VPR struggles in repetitive natural texture.
- **[encinargonzalez2025multimodal]** Loop closure in planetary-analogue terrain, where "visual place recognition often fails due to aliasing and weak textures". It uses DINOv2+SALAD with LiDAR verification. Under review per its arXiv comment.
  - *Bearing:* the same failure P4 hypothesizes in the body, in another domain.
- **[zaffar2025overlooked]** Reference-Set-Finetuning on the target map for strongly shifted VPR benchmarks. ICCV 2025 workshop is an arXiv comment.
  - *Bearing:* a cheap adaptation that P4's zero-shot protocol excludes. Part of any "recoverable" fraction may be recoverable this way; say so or ablate.

## 12. VPR evaluation methodology and ground truth

**Synthesis.**
- **Transfer gap.** It is only meaningful if the outdoor side uses the standard protocol: 25 m recall@k [berton2022deep].
- **Anatomical side.** Colon10k's pairwise "positive interval" GT is a multi-match setting [schubert2024visual].
- **What "same place" means.** GT definitions change rankings [zaffar2021vprbench]. Visual overlap, rather than camera distance, is the better "same place" definition for partial, oblique views [wei2025breaking, larsen2026longterm].

- **[berton2022deep]** The Deep Visual Geo-localization Benchmark: a standardized VPR training and evaluation framework with the distance-threshold recall protocol.
  - *Bearing:* the source of the outdoor reference numbers for the transfer gap.
- **[zaffar2021vprbench]** VPR-Bench: an evaluation framework discussing how GT definition and viewpoint or appearance variation affect results.
  - *Bearing:* GT-definition sensitivity, relevant to Colon10k pairwise vs C3VD pose GT.
- **[lowry2016visual]** The foundational VPR survey, which defines the problem including perceptual aliasing and appearance change.
  - *Bearing:* the canonical definition of the concept being transferred.
- **[schubert2024visual]** A VPR tutorial that unifies terminology, problem types and evaluation, including multi-match GT.
  - *Bearing:* methodology for evaluating pairwise all-matches GT.
- **[wei2025breaking]** VOP: VPR as patch-level overlap prediction, handling occlusion and partial overlap.
  - *Bearing:* supports an overlap-based "same place" definition for endoscopy.

## 13. Perceptual aliasing, repetition and texture

**Synthesis.**
- **Outdoors.** Aliasing from repeated structures and bursty local features is well understood [torii2015visual, jegou2009burstiness], and aliasing-induced false loop closures are costly downstream [lajoie2019modeling].
- **In the colon.** Repetitive haustral folds are the anatomical analogue. The idea that the colon is aliasing-bound *along its axis* is **partly anticipated**: C3VDReg names axial translation ambiguity as the main bottleneck for 3D registration on C3VD [jiang2025c3vdreg]. CudaSIFT-SLAM and ColonMapper report place-recognition failure and "not visually recognizable" frames (§1).
- **What remains P4's.** The quantitative, model-independent decomposition for retrieval.

- **[torii2015visual]** Repeated structures break the independence assumption of bag-of-words retrieval and cause over-counting; the paper proposes repetition-aware representations.
  - *Bearing:* the foundation for the E4 aliasing taxonomy, with haustral folds as the analogue of repeated facades.
- **[jegou2009burstiness]** "Burstiness", where repeated local features dominate similarity, is a failure mode of local aggregation.
  - *Bearing:* the mechanism by which VLAD/GeM aggregators could be dominated by repetitive mucosa or specularities.
- **[lajoie2019modeling]** Discrete–continuous graphical models of aliasing-induced spurious loop closures in SLAM.
  - *Bearing:* the downstream cost of a confident false match. Supports "representation or limit study, no clinical claim".
- **[jiang2025c3vdreg]** C3VDReg: a local-to-local registration benchmark on C3VD. Recall stays low despite 74–93% GT overlap, and "translation ambiguity along repetitive tubular anatomy" is the main bottleneck. Global retrieval is out of scope.
  - *Bearing:* independent geometric evidence for P4's intrinsic-aliasing hypothesis, and a partial anticipation of it. E4 should test whether retrieval errors concentrate along the centreline.

## 14. Bayes error, recognizability and per-query difficulty

**Synthesis.** P4 reuses Paper 3's ceiling estimator (`vprbench/analysis/recognizability.py`): an oracle-ensemble ceiling, a kNN Bayes-error bracket and a recoverable/irreducible split. The theory is classical [cover1967nearest]. The important caution is that **Bayes-error estimates depend on the embedding space** [renggli2021evaluating]. In anatomy, the embedding is exactly what may fail to transfer, so an "irreducible" fraction computed in outdoor-VPR feature space may partly be representation failure. The ceiling must be reported in more than one feature space, including a medical-pretrained one. Per-query VPR uncertainty [zaffar2024estimation] is the nearest VPR-internal notion of recognizability. It is related but not the same construct.

- **[cover1967nearest]** The asymptotic 1-NN error is at most twice the Bayes error.
  - *Bearing:* the theoretical basis of the kNN-BER bracket in the reused estimator.
- **[renggli2021evaluating]** FeeBee evaluates Bayes-error estimators on real data by injecting controlled label noise. Estimates are sensitive to hyperparameters and embeddings.
  - The researcher confirmed NeurIPS 2021 Datasets & Benchmarks on the proceedings site. In the bib it is `@misc`, because no DOI or arXiv journal-ref confirms the venue.
  - *Bearing:* the key caution for E2's interpretation.
- **[zaffar2024estimation]** Compares uncertainty estimators for VPR matches. Plain L2 descriptor distance beats data-driven estimators, and the proposed SUE uses the spatial spread of reference poses.
  - *Bearing:* the nearest per-query recognizability measure. Cite it as related, and distinguish it from the oracle-ceiling decomposition.

---

## 15. Unverified leads (NOT in the bib; do not cite until verified)

- **Morlana, Azagra, Civera, Montiel, "Self-supervised Visual Place Recognition for Colonoscopy Sequences", MIDL 2021 (short paper).**
  - It is listed as reference 30 of [azagra2023endomapper] and [22] of [morlana2024colonmapper], and appears as "Morlana21" in ColonSLAM's baselines **[FT]**. It is the first colonoscopy-trained VPR network (R101-GeM, SfM-supervised, 3 sequences, per ColonMapper).
  - No CrossRef, arXiv or registry record could be fetched. OpenAlex returned HTTP 429 during this synthesis too, OpenReview returned a bot challenge, and DBLP returned a bot wall.
  - **Must be verified and cited before submission.** It is a baseline every reviewer from this group will expect. Whether it reports off-the-shelf outdoor baselines is also unknown.
- **Colon10k's baseline table.** The ISBI paper full text has not been read by anyone in this program. See positioning.md, Attack 3.
- **Morlana PhD thesis, "SLAM and visual place recognition for colonoscopy"** (Universidad de Zaragoza, defended June 2025 per the author's homepage). There is no metadata record. It may contain descriptor comparisons, including off-the-shelf VPR.
- **CLiMB26 / Endoscopic Vision Challenge 2026** (Zenodo, a DataCite DOI, not checked). Per web text it is a SLAM/VO benchmark on EndoMapper, not place recognition.
- **Unfetched or unread records:**
  - Pueyo 2022 bachelor's thesis (AKAZE colonoscopy loop closure);
  - EndoLINA @ MICCAI 2026 accepted papers;
  - EndoFinder (arXiv 2407.11401);
  - EndoCLIP (arXiv 2607.28466);
  - woma (arXiv 2609.15130);
  - ColonAdapter (arXiv 2511.22250);
  - Representation-driven endoscopic embedding alignment (arXiv 2608.07176);
  - GalKva-2026 (arXiv 2605.15062);
  - "Acar et al. 2025" SfM-pipeline comparison;
  - the laparoscope NetVLAD localization paper (arXiv 2110.03912);
  - Gaubatz et al. 2022, "Location recognition in laparoscopic surgery" (CDBME, DOI 10.1515/cdbme-2022-0030; the CrossRef record exists but the content was not read). This would be a further early "place recognition in surgery" citation.
  - Iakovidis et al. BIBE 2013, capsule localization from visual features (the DOI resolves, but the content was not read);
  - M3GA-Wild (arXiv 2609.23003);
  - C3VDv2 preprint (arXiv 2506.24074). The published Sci Data version is in the bib, but this arXiv id was not fetched, so it was not attached as its eprint.
- **Verified by the researchers but omitted for focus** (available on request; not re-verified here): Barbed et al. MICCAI 2023 (10.1007/978-3-031-43907-0_56); PANS, MICCAI 2024 (10.1007/978-3-031-72089-5_44); SelaVPR++ TPAMI (10.1109/tpami.2025.3629287); NetVLAD TPAMI (10.1109/tpami.2017.2711011); Torii CVPR 2013 (10.1109/cvpr.2013.119); and the cluster-2 and cluster-3 "omitted" lists (e.g. RAD-DINO, EndoOmni, DBoW2, SD-DefSLAM, Revisit Anything/SegVLAD, TextInPlace, VPAir, Ishida et al. BER estimator).

## 16. Discrepancies found and resolved during synthesis

| Item | Researchers said | Resolution |
|---|---|---|
| Colon10k image count | 10,126 (abstract/EndoMapper); 10,464 (researcher 1, "UNC page"); 10,264 (researcher 2, "UNC page") | The UNC page per-case counts sum to **10,216** (re-read 2026-09-25). EndoMapper Table 1 **[FT]** says 10,126. Both "page" figures were wrong. **Unreconciled 10,126 vs 10,216**: count the files at execution time. |
| ColonMapper mAP | 75.7/33.0 (researcher 1); 73.3/38.5 (researcher 2) | Both correct: R50-NV-H and R50-GeM-H rows of Table I **[FT]**. |
| Biffi et al. (ColonTCN) venue | CMPB with DOI (researcher 1); arXiv-only (researcher 2) | CrossRef confirms CMPB, 10.1016/j.cmpb.2025.108782 (kept, with eprint). |
| PANSv2 venue | LNCS DOI (researcher 1); arXiv-only (researcher 2) | CrossRef confirms the MICCAI 2025 workshop LNCS chapter (kept, with eprint). |
| EndoMapper region baseline | not reported by any researcher | Found in the full text **[FT]**: fine-tuned CNNs, Top-1 17.61–26.08% on Seq_094 (Table 7). This is a supervised E3 reference. |
| ColonSLAM local matcher | "soft verification with LightGlue" | Full text **[FT]**: "off-the-shelf LightGlue", i.e. another natural-image model used zero-shot in the colon. |
