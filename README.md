# duck-changepoint-reference

Reference datasets and tests that compare the [`cpt` DuckDB extension](https://github.com/hugr-lab/duck-changepoint)
with R's [changepoint](https://cran.r-project.org/package=changepoint) package.

This material lives in its own repository because three of the datasets are distributed with
changepoint, which is licensed under the GPL. The extension itself is MIT-licensed and contains no
GPL code or data; this repository is licensed GPL-2.0-or-later (see `LICENSE`, and
`test/data/README.md` for the source of each file).

## Contents

```
test/data/               Nile, Lai2005fig4, wave.c44137, ftse100 + expected_*.json from changepoint 2.3
test/sql/cpt_reference.test
tools/export_reference.R regenerates test/data
```

## Running

Build `cpt` next to this repository, in `../duck-changepoint`, then run the tests on the DuckDB that build
is for:

```sh
make test                                   # main (GEN=ninja make release): DuckDB 2.0.0
make test DUCKDB_VERSION=1.5.6              # the v1.5.x branch (make configure release): DuckDB 1.5.x
make test CPT_EXTENSION=/path/to/cpt.duckdb_extension
```

`main` is a C++ extension built with DuckDB 2.0.0, and loads only into that release; it builds to
`build/release/extension/cpt/cpt.duckdb_extension`. The `v1.5.x` branch keeps the stable C API build,
which loads into DuckDB 1.5.6 and later, at `build/release/cpt.duckdb_extension`. `make test` uses the
first of the two that exists.

## What is checked

- **Nile.** `cpt.mean` on the series scaled by its sd gives `[28, 100]` (the change after 1898) for BIC
  and MBIC. `cpt.meanvar` gives BIC `[4, 6, 28, 97, 100]` and MBIC `[4, 6, 28, 100]`. cpt matches all
  four exactly.
- **Lai2005fig4.** Column 5 (GBM29, the column used in the changepoint vignette): BIC and MBIC both
  give `[81, 85, 89, 96, 123, 133, 193]`, matched exactly.
- **wave.c44137, ftse100** (`cpt.meanvar`). changepoint's PELT prunes without regard to `minseglen`
  (2 for meanvar) and returns segmentations with a higher penalised cost than unpruned Optimal
  Partitioning. The test checks that cpt's penalised cost, computed in SQL from `cpt_segment_stats`,
  is no higher than changepoint's, and that cpt finds at least 80% of changepoint's change points.

## Regenerating the data

```sh
make reference-data    # rocker/r-ver:4.4.2 in Apple container or Docker
# or, with R installed: Rscript tools/export_reference.R
```
