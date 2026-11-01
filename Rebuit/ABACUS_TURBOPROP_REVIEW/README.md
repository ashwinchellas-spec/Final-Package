# Turboprop reference review and diagnostics

## Run

Extract this ZIP OUTSIDE your project folder. In MATLAB open
`RUN_TURBOPROP_REVIEW.m` and click Run. Select the existing rebuilt
`Aircraft_Engine_Digital_Twin` folder. The database compatibility fix must
already be installed; no additional toolbox is required.

The routine saves an audit snapshot of affected tables, then atomically updates
one catalogue parameter and its provenance, and appends one reviewed reference.
It preserves all existing reference and simulation records. Repeating the update
does not append a duplicate reference. The snapshot is not a full database backup.

It changes PW127G Rated_Power_kW to 2178 and verifies ONLY that parameter/source.
Overall_Confidence remains Low. It does not change mass flow, TIT, OPR, efficiencies,
operating limits or physics equations, and does not accept an ML certificate.
The source/parameter change makes any older fingerprint-based acceptance stale.

## Reference findings

**PW127G:** EASA IM.E.041 Issue 07 (20 December 2023), p.10 lists maximum take-off
and maximum continuous shaft power of 2178 kW; normal take-off is 1973 kW.
The project's 2051 kW is not the listed PW127G rating. Page 17 Note 1 states
sea-level static standard-atmosphere conditions without accessory loads or bleed.
Source: https://www.easa.europa.eu/en/downloads/7725/en

The comparison uses maximum rating and the model's throttle=1 convention.
The model lacks a certified power-control schedule; this limits the interpretation
of a reference comparison. Correcting the rating alone leaves about 88.9% error
for the user's previously reported 4114.2 kW prediction. The rating field is not
used to scale the cycle output.

**AE 2100D3:** the reviewed EASA IM.E.040 Issue 01 certificate lists A, D2 and D2A,
not D3, so it cannot directly verify the D3 variant used in this project.
https://www.easa.europa.eu/en/downloads/7727/en

The current Rolls-Royce sheet names D3, but its paired 4637 shp and 3410 kW
figures are inconsistent under the mechanical-horsepower conversion used in this
project (4637 shp is approximately 3458 kW). The sheet does not provide a numeric
inlet mass flow or the precise test condition needed here. D3 data remain
unverified rather than silently resolving that discrepancy.
https://www.rolls-royce.com/~/media/Files/R/Rolls-Royce/documents/defence/ae2100-engine-datasheet.pdf

## Diagnostic outputs

A new folder under the project's `reports/` contains:

- `turboprop_review.mat`: baseline, local sensitivities and reference comparisons.
- `turboprop_baseline.csv`: power, model inputs, work terms and conservation residuals.
- `turboprop_sensitivity.csv`: power response to independent +/-2% input changes.
- `reviewed_reference_comparison.csv`: comparisons including the new PW127G rating.
- Per-engine station-state and parameter-source CSVs.
- `before_source_update.mat`: pre-update table snapshot.
- `reviewed_reference_update.sql`: exact applied SQL, for review.

Send the MAT file or the three summary CSVs for the next review. Sensitivity
trials are not added to the engine database or training dataset. Their varied
inputs are explicitly diagnostic, not newly sourced specifications.

## Why the current discrepancy is unresolved

Power depends on airflow and available turbine work. The inspected cycle uses
input airflow, assumed TIT, compressor work, component efficiencies, and a
specified power-turbine exhaust pressure. The references reviewed do not verify
all these inputs for the selected engine variants. Conservation-test success
does not establish that these parameters describe the actual engines.

No arbitrary airflow reduction, output scaling, rating cap, tolerance relaxation
or reference verification override is applied. These would obscure the observed
model discrepancy. ML would reproduce it until the model/data are corrected.

## Checks and limits

The MATLAB source passed syntax/lint checks. The database update was checked on
a disposable SQLite copy for repeatability, foreign keys, provenance consistency,
and preservation of existing reference records. MATLAB execution of this new
review routine is still pending. No new successful simulation or training results
are supplied with this package.
