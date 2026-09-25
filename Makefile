# Makefile for a paper repo (vpr_paper_*) using vprbench paper tooling.
# Copy to the paper repo root as `Makefile`:
#     cp ../vpr-testtime/vprbench/paper/templates/Makefile.paper Makefile
#
# Provenance chain (see vpr-testtime/docs/PAPER_TOOLING.md):
#   results store -> snapshot/ + MANIFEST.json -> numbers.yaml -> generated/
#   -> the .tex uses \res{key} / \restable{name} only -> make check
#
#   make snapshot    export result files from $(RESULTS_SRC) into $(SNAPSHOT)/
#   make numbers     $(SPEC) + $(SNAPSHOT)/ -> $(GENERATED)/ (numbers.tex, tables/, vprresults.sty)
#   make sty         staged paper (no $(SPEC) yet): copy only vprresults.sty into $(GENERATED)/
#   make lint        texlint: no hand-typed results in any LaTeX source
#   make bib         offline bibcheck against $(LOCK)
#   make bib-online  verify citations on arXiv / Crossref / OpenAlex; update $(LOCK)
#   make pdf         latexmk -pdf $(MAIN).tex
#   make check       verify snapshot + generated/ freshness + texlint + offline bibcheck
#   make clean       remove LaTeX build products (keeps snapshot/ and generated/)
#
# Commit snapshot/, generated/ and bib/verified.json so the paper compiles on
# Overleaf/arXiv without Python. Never hand-type a result.

VPRBENCH    ?= ../vpr-testtime
PY          ?= $(VPRBENCH)/.venv/bin/python
MAIN        ?= paper/main
SNAPSHOT    ?= snapshot
GENERATED   ?= generated
SPEC        ?= numbers.yaml
BIB         ?= bib/references.bib
LOCK        ?= bib/verified.json
RESULTS_SRC ?= $(VPRBENCH)
# P4 is STAGED with zero results: there is no numbers.yaml and no snapshot/.
# PATTERNS is deliberately EMPTY: the template default (results/final/*) would
# export other papers' results.  Set it to the P4 result files only, once they
# exist; until then `make snapshot` refuses to run (review D3).
PATTERNS    ?=
EXCLUDE     ?= $(GENERATED) $(SNAPSHOT)

PAPERTOOL = PYTHONPATH="$(VPRBENCH)$(if $(PYTHONPATH),:$(PYTHONPATH))" "$(PY)" -m vprbench.paper
EXCLUDE_ARGS = $(foreach e,$(EXCLUDE),--exclude '$(e)')

.PHONY: snapshot numbers sty lint bib bib-online pdf check clean

snapshot:
	$(if $(strip $(PATTERNS)),,$(error PATTERNS is empty: set it to the P4 result files before exporting a snapshot))
	$(PAPERTOOL) export --src "$(RESULTS_SRC)" --dest "$(SNAPSHOT)" $(foreach p,$(PATTERNS),--pattern '$(p)')

numbers:
	$(PAPERTOOL) numbers --spec "$(SPEC)" --snapshot "$(SNAPSHOT)" --out "$(GENERATED)"

sty:
	$(PAPERTOOL) sty --out "$(GENERATED)"

lint:
	$(PAPERTOOL) texlint --root . $(EXCLUDE_ARGS) --generated "$(GENERATED)"

bib:
	$(PAPERTOOL) bibcheck --bib "$(BIB)" --tex . --lock "$(LOCK)" $(EXCLUDE_ARGS)

bib-online:
	$(PAPERTOOL) bibcheck --online --bib "$(BIB)" --tex . --lock "$(LOCK)" $(EXCLUDE_ARGS)

pdf:
	latexmk -pdf -interaction=nonstopmode -halt-on-error "$(MAIN).tex"

# numbers.yaml is optional (a staged paper with no results has none); when it
# exists, the snapshot must verify and generated/ must match it exactly; when
# it does not, generated/ may hold only an unmodified vprresults.sty.  An
# existing $(SNAPSHOT)/ is always verified (it is excluded from lint), and
# while $(RESULTS_SRC) is present its files are re-hashed against it.
check:
	$(PAPERTOOL) check --root . $(EXCLUDE_ARGS) --out "$(GENERATED)" \
	  $(if $(wildcard $(SPEC)),--spec "$(SPEC)" --snapshot "$(SNAPSHOT)",$(if $(wildcard $(SNAPSHOT)),--snapshot "$(SNAPSHOT)")) \
	  $(if $(wildcard $(RESULTS_SRC)/.git),--src "$(RESULTS_SRC)") \
	  --bib "$(BIB)" --lock "$(LOCK)"

clean:
	latexmk -C "$(MAIN).tex"
