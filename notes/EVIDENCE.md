# Paper 4 — Evidence Brief ("Generalization": anatomical VPR)

> Status: **STAGED — zero results.** No data downloaded; no dataset access
> agreements signed. The plan is `vpr-testtime/docs/papers/PAPER4_OUTLINE.md`.
>
> **Hard rule:** this paper has *no* results section content until the Colon10k
> go/no-go probe runs, and that needs the user's explicit go-ahead (plus data
> access agreements). The scaffold may contain the method, protocol, and
> related work. Every results/number slot must be a `\res{}` placeholder that
> fails the build.

## 1. Thesis
Test whether Paper 3's two central results transfer from outdoor streets to
anatomical place recognition (endoscopy): (a) frozen VPR representations are
strong, and (b) error is bounded by a model-independent recognizability ceiling.
In other words: is the ceiling a property of recognition, or of cities?

## 2. Honest novelty position
- "Endoscopic localization as place recognition/retrieval" is **pre-empted**
  (Colon10k ISBI'21, EndoMapper, ColonMapper ICRA'24, ColonSLAM MICCAI'24,
  bronchoscopy retrieval). **Not claimed.**
- **Open:** a zero-shot benchmark of the *frozen, outdoor-trained* VPR zoo on
  anatomy, with no medical fine-tuning.
- **Open:** the recoverable/irreducible ceiling decomposition applied in the body.

## 3. What exists
- Reusable code in vpr-testtime: `vprbench/analysis/recognizability.py`
  (ceiling estimator, dataset-agnostic), the model zoo, provenance store, guard.
- Nothing dataset-specific: no loaders for Colon10k, EndoMapper, or C3VD.

## 4. What the scaffold may do now
- Write the method and protocol (E1–E5 from the outline), the related work, and
  the threats-to-validity section.
- Draft *loader interface specs*: the ground-truth format for each dataset,
  per the dataset papers. **Verify** every format claim against the dataset
  paper or official repo, and cite it.
- Write the go/no-go criteria as a pre-registration: fix the decision rule
  *before* seeing data.

## 5. Must not
- Download any dataset or model weights.
- Write any number as a result.
- Claim clinical utility.
- Claim "first place recognition in the body".

## 6. Positioning questions for the literature review
- Endoscopic place recognition / relocalization / loop closure: Colon10k;
  EndoMapper dataset; ColonMapper; ColonSLAM; bronchoscopy retrieval;
  capsule-endoscopy localization.
- Endoscopy datasets with pose: C3VD (MedIA'23), SimCol3D, EndoSLAM, Hamlyn.
- Endoscopy foundation models (e.g. Endo-FM, EndoViT, GastroNet-style
  pretraining) — the "medical-pretrained" comparator the zero-shot study
  contrasts against.
- Transfer of natural-image features to medical imaging (Raghu et al. 2019
  "Transfusion"; DINOv2 on medical).
- Perceptual aliasing in texture-poor / repetitive environments (the analogue of
  the outdoor ceiling).

## 7. Target venue
MICCAI (LNCS `llncs.cls`, 8 pages + refs) as default; IEEE TMI / MedIA as the
journal alternative.
