# Start experimental ML training

1. Extract this ZIP beside your existing project folder. Do not place a second
   copy of your complete project inside the existing project.
2. Open RUN_EXPERIMENTAL_ML.m in MATLAB. Set MATLAB's Current Folder to the folder
   containing that file (the ABACUS_EXPERIMENTAL_ML folder).
3. In the Command Window enter:

```matlab
mlRun = RUN_EXPERIMENTAL_ML;
```

4. Select your existing Aircraft_Engine_Digital_Twin folder when asked.
5. Leave MATLAB running. It prints progress every 120 simulation points and for
   each model fit. Elapsed time depends on your laptop; no runtime is promised.
6. At completion, the displayed output folder contains SUMMARY.csv and
   TEST_METRICS.csv. Send those two files for review. A failed engine has ERROR.txt
   in its own subfolder; other engines continue. Successfully completed engines
   are saved immediately. A new run gets a new folder (no automatic resume).

No replacement of existing code, database reset or reinstallation is required.
This is a separate experimental workflow. Continue using START_HERE('gui') for
existing project functions. Its ML tab retains the original validation gate;
this add-on does not populate that tab or relax that gate.

## What runs

- All catalogue engine IDs, currently 13.
- 720 random candidate conditions per engine: geometric altitude from zero to
  min(15 km, the model altitude limit), Mach zero to min(2, the model Mach limit),
  throttle 0.5 to 1. No afterburner.
- Invalid/nonfinite results remain in the exported dataset with reasons and are
  excluded from fitting. At least 150 accepted rows per engine are required.
- Accepted rows are randomly divided approximately 70% training, 15% validation,
  15% test, with a fixed engine-specific seed. Scaling is fitted on training only.
- Two polynomial settings (degrees 3 and 5) and two random-forest settings (100
  and 200 trees) are compared using validation error. Only the selected model is
  evaluated on the held-out test rows. A failed family is logged; another family
  may still succeed. This is a fast baseline, not exhaustive optimization.
- Three outputs: thrust (N), fuel flow (kg/s), TSFC (kg/(N s)) for jets; shaft
  power (kW), fuel flow (kg/s), BSFC (kg/kWh) for propeller engines.
- Separate model, dataset, input/provenance snapshot, train/validation/test row
  assignments, per-target test metrics, predictions, timing, and a 51-point
  altitude slice plot are saved for every completed engine.
- At ID 10, a separate CSV compares the existing PW127G simulation with the
  8.49 kg/s family-airflow assumption across altitude at Mach zero. That trial
  is NOT used to train the baseline model and does NOT change the database.
- A sea-level static, full-throttle catalogue comparison is exported per engine.
  It is a diagnostic comparison, not independent manufacturer validation.

## Interpret the results honestly

TRAINED means fitting and evaluation completed, not that accuracy is acceptable.
MeanRelativeRMSE = 0.02 means the average across targets of RMSE divided by the
mean absolute test reference is 2%. Inspect individual target metrics too.
MAPE excludes near-zero references; constant targets have undefined R2 (NaN),
so the inherited strict simulator criteria may be false even with tiny errors.
These are simulator comparisons, never engine certification.

Test points are random held-out interpolation samples within the same assumed
model envelope. They do not demonstrate unseen-engine generalization, extrapolation,
independent altitude-band validation or real-aircraft accuracy. The altitude plot
is a separate visualization slice and is not used to pick the winner.

RawPredictionSpeedup times individual model evaluations against individual
simulation calls after warm-up. Values below 1 mean the surrogate was slower.
Disk loading, source-fingerprint checks and the guarded prediction helper are
excluded. Timing is indicative, not a guaranteed deployment benchmark.

The PW127G baseline still contains 16 kg/s; the known 4114 vs 2178 kW mismatch
therefore remains in the baseline training data. The AE 2100D3 baseline also
retains its unresolved power mismatch. A surrogate can reproduce these inaccurate
predictions very well. Do not call it validated real-engine performance.

The 8.49 kg/s value appears in Figure 2 of the Pratt & Whitney Canada-authored
paper "The PW100 Engine: 20 Years of Gas Turbine Technology Evolution", in RTO
MP-8 (1998). It describes PW127, not specifically PW127G:
https://archive.org/stream/DTIC_ADA361702/DTIC_ADA361702_djvu.txt
PW127G rating source previously reviewed:
https://www.easa.europa.eu/en/downloads/7725/en#page=10
No new variant-specific airflow correction is claimed here. Verifying G/D3
inputs and rating conditions, then assessing altitude data, remains outstanding.

## Predict after training

Keep Current Folder on this add-on folder. Replace the placeholder with the
actual engine subfolder printed/saved by your run:

```matlab
modelFile = fullfile(mlRun.Folder,'engine_10','experimental_model.mat');
prediction = PREDICT_EXPERIMENTAL_ML(modelFile,[1000,0.3,0.8]);
disp(prediction);
```

Columns of the input are altitude in metres (geometric), Mach, throttle. The helper
checks the saved fingerprint against the current database/source, sampling bounds,
simulator validity and finite/nonnegative ML outputs. Rejected points return NaN
and a reason. These checks do not guarantee local approximation accuracy. The
helper deliberately runs a physics check and therefore is not a fast replacement
for the production digital twin. All bundles have Operational=false.

## Larger study later

Optional: use more points, selected engine IDs and all four model families:

```matlab
root = uigetdir(pwd,'Select Aircraft_Engine_Digital_Twin');
mlRun = RUN_EXPERIMENTAL_ML(root,[9 10 11],1200,{'Poly','RF','GPR','ANN'});
```

GPR and ANN can take considerably longer. All non-polynomial families require
Statistics and Machine Learning Toolbox. Polynomial-only fitting uses base MATLAB:
RUN_EXPERIMENTAL_ML(root,[],720,{'Poly'}).

## What was checked before delivery

Both new MATLAB files passed MISS_HIT syntax/lint checks. The uploaded database
was checked read-only, and helper names/result fields were checked against your
uploaded project. The original project and validation gate were not edited.
MATLAB is not available in the authoring environment: no claim is made that
MATLAB training, accuracy, plots or runtime have already been tested here.
