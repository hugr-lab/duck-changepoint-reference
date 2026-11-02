# Reference data

Written by `tools/export_reference.R` from R 4.4.2 with changepoint 2.3. Not covered by this
repository's GPL-2.0-or-later license where upstream terms apply; see each source.

| File | Source | Upstream terms |
|---|---|---|
| `nile.csv` | `datasets::Nile` (base R): annual Nile flow at Aswan 1871–1970, Cobb (1978), Durbin & Koopman (2001) | R is GPL-2 \| GPL-3; the series is a long-published measurement record |
| `lai2005fig4.csv` | `changepoint::Lai2005fig4`: aCGH data, Lai et al. (2005), *Bioinformatics* 21(19) | changepoint package, GPL |
| `wave_c44137.csv` | `changepoint::wave.c44137`: significant wave height, buoy C44137, Fisheries and Oceans Canada | changepoint package, GPL; originally Government of Canada data |
| `ftse100.csv` | `changepoint::ftse100`: FTSE 100 daily returns | changepoint package, GPL |
| `expected_*.json` | output of `cpt.mean` / `cpt.meanvar` (changepoint 2.3) on the series above | program output |

Each `expected_*.json` holds, per result, the changepoint call, its penalty value, `cpts`
(changepoint's convention: last index of every segment except the final one) and `bkps` (cpt's
convention: 1-based segment ends including n).
