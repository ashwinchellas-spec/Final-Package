# Machine-learning workflow

## Gate and data generation

The surrogate learns the implemented physics, not measured engine behaviour. ml_generate_dataset requires an accepted current validation certificate and uses the architecture grid through the authoritative coordinator. Invalid points, nonfinite targets and inappropriate fuel-consumption fields are excluded. The full validity mask is retained to reject prediction through invalid holes. The dataset is labelled Physics-generated synthetic data.

All default secondary targets are unverified, so no engine is automatically approved for ML. First execute validate_physics, inspect internal test results and Track A, review independent reference inputs as documented in DATA_PROVENANCE.md, resolve genuine model errors, then re-run validation. An explicitly reviewed estimated target only establishes agreement with an academic target. There is no bypass flag and no fabricated acceptance certificate in the distribution.

## Split and preprocessing

Features are Mach, geopotential altitude and throttle. Random seed is 42; prior RNG state is restored. The split is jointly stratified in Mach/altitude bins with approximate 70/15/15 allocation. Integer rounding within bins means exact global percentages can differ and are recorded. Duplicate input rows are rejected before splitting. Input and response scales are estimated exclusively from training rows. Validation and test rows are transformed using those training statistics.

## Candidate families

| Family | Candidates | Notes |
| --- | --- | --- |
| Polynomial | Degree 3 or 5 with ridge regularization | Shared explicit polynomial-feature generator |
| RF | 100 or 200 regression trees | Separate ensemble per target |
| GPR | Two kernel settings | Separate Gaussian process per target |
| ANN | Two fitrnet layer configurations | Separate network per target, compatible with R2023b |

Hyperparameter choice within a family and family selection use validation relative RMSE only. Family selection is frozen before test metrics are inspected. The selected family is not retroactively replaced by a better test score. Test results are reported for each family, while deployment acceptance additionally checks actual accuracy and single-point timing.

## Metrics and acceptance

RMSE and MAE retain the target's SI unit. R2 is undefined (NaN) for constant targets. MAPE excludes near-zero true targets and reports its included sample count. Relative errors normalize by mean absolute reference output. Criteria are R2 >=0.95, relative RMSE <2%, relative MAE <1.5%, MAPE <5%, plus measured single-point latency below 10 ms for operational use. These are thresholds, not delivered achievements. No R2 or latency is reported as achieved until training runs.

The test set evaluates approximation of the implemented physics only. It does not establish agreement with real engine data, uncertainty calibration or safety. Dense grid splits can be easier than extrapolation; the operational predictor disallows extrapolation.

## Artifacts and prediction

After execution, ml_models stores actual engine_ID_FAMILY.mat and engine_ID_best.mat bundles with trained objects, architecture, targets/features, fingerprint, validation score, grid/mask, test metrics, actual split, timing acceptance and timestamp. Reports include selection diagnostics, residuals and predicted-versus-physics plots. ml_learning_curve is an additional training-size study; it also retains the gate and is not precomputed.

ml_predict verifies architecture, current fingerprint, operational acceptance, input bounds and the validity of surrounding grid corners. Missing, stale, rejected or out-of-domain bundles cause an explicit physics fallback through DT_Coordinator L5. The interface does not silently turn a physics fallback into an ML prediction. No trained MAT bundle is supplied because MATLAB training was unavailable.

```matlab
setup_project;
validation = validate_physics;
% Review Track A and source inputs before continuing.
dt = DT_Coordinator;
data = ml_generate_dataset(dt,4);
metrics = ml_train_surrogates(dt,4,data);
delete(dt);
```

The last two commands intentionally raise a validation-required error for the unreviewed default seed.
