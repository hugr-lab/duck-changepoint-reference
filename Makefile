.PHONY: test reference-data help

# The cpt extension under test, built in ../duck-changepoint (https://github.com/hugr-lab/duck-changepoint).
# main is a C++ extension for DuckDB 2.0.0 and builds to build/release/extension/cpt/; the v1.5.x branch is
# the stable C API build for DuckDB 1.5.x and builds to build/release/. The first that exists is used.
CPT_BUILDS := ../duck-changepoint/build/release/extension/cpt/cpt.duckdb_extension \
	../duck-changepoint/build/release/cpt.duckdb_extension
CPT_EXTENSION ?= $(firstword $(wildcard $(CPT_BUILDS)))
DUCKDB_VERSION ?= 2.0.0
PYTHON_BIN ?= python3
VENV := configure/venv-$(DUCKDB_VERSION)

help:
	@echo "make test [CPT_EXTENSION=...] [DUCKDB_VERSION=1.5.6] - run test/sql against a cpt build"
	@echo "make reference-data                                  - regenerate test/data with R changepoint"

$(VENV):
	$(PYTHON_BIN) -m venv $(VENV)
	$(VENV)/bin/python3 -m pip install -q duckdb==$(DUCKDB_VERSION) packaging \
		git+https://github.com/duckdb/duckdb-sqllogictest-python@2ac8dbc012ddbd96a57dca37784fd8ee3c0eb021

test: $(VENV)
	@test -f "$(CPT_EXTENSION)" || (echo "cpt extension not found: '$(CPT_EXTENSION)'; looked for $(CPT_BUILDS)"; exit 1)
	$(VENV)/bin/python3 -m duckdb_sqllogictest --test-dir test/sql --external-extension $(CPT_EXTENSION)

# Regenerate test/data/*.csv and expected_*.json with R changepoint in a disposable container.
CONTAINER ?= $(shell command -v container >/dev/null 2>&1 && echo container || echo docker)
R_IMAGE ?= docker.io/rocker/r-ver:4.4.2
reference-data:
	$(CONTAINER) run --rm --volume "$(CURDIR):/work" --workdir /work $(R_IMAGE) bash -c \
		'Rscript -e "options(repos = c(CRAN = \"https://packagemanager.posit.co/cran/__linux__/noble/latest\")); \
		install.packages(c(\"changepoint\", \"jsonlite\"), quiet = TRUE)" && Rscript tools/export_reference.R'
