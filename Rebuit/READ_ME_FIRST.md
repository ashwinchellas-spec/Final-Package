# ABACUS final handover

Academic engine simulation and experimental ML. Independent manufacturer/test validation remains incomplete.

## Start here

1. Extract the complete ZIP into a **new writable folder**. Keep your existing project.
2. Restart MATLAB. Set Current Folder to this `Rebuit` folder (the one containing `LAUNCH_ABACUS.m`).
3. In the **Command Window**, run:

```matlab
[~, registry, smoke] = LAUNCH_ABACUS('check');
```

This is a short integration check: 13 fingerprints and 13 predictions, no training. The new launcher has been statically inspected here but has not been executed in MATLAB. Expect all 13 predictions to be available. If it fails, preserve the full error and stop; do not bypass a fingerprint or domain check.

4. Open the application:

```matlab
[app, registry] = LAUNCH_ABACUS('gui');
```

Use the engine dropdown **inside Experimental ML**, immediately below its yellow banner. The main GUI's top engine selector does not control that tab. No registry/predictor file selection is needed with this launcher.

5. An optional command-line query:

```matlab
prediction = PREDICT_UNIFIED_ENGINE(registry, 1, [3000, 0.4, 0.8]);
disp(prediction)
```

Input order is `[geometric altitude (m), Mach, throttle]`. An unavailable prediction is not permission to extrapolate: inspect its Note.

## What the launcher does

- Opens the supplied database; it does not seed, calibrate or train.
- Checks saved model fingerprints against the current source, parameters and provenance.
- Creates a new reports folder containing copies of the selected model bundles with relocated ProjectRoot metadata and a new registry. Learned model coefficients and engine snapshots are preserved.
- Leaves historical original bundles and historical registries unchanged. They retain original laptop paths and should not be used directly after relocation.
- Leaves calibrated turboprop candidates separate from the registered original-physics surrogates.

Do not use `addpath(genpath(pwd))` on the whole Rebuit folder. It contains historical alternative add-ons with duplicate public filenames. The launcher selects the needed folders explicitly.

## Requirements and limits

The user ran MATLAB R2026a Update 4 on Windows 11. Database Toolbox and JVM are needed; Statistics and Machine Learning Toolbox supports the saved GPR models. Simulink is needed for the Simulink tests, not for the experimental GUI itself.

Read `FINAL_DOCUMENTATION/ABACUS_Final_Report.pdf`, `PACKAGE_CHANGES.md`, and `FINAL_DOCUMENTATION/EVIDENCE_INDEX.csv`.

The 2178 kW PW127G fit and provisional 3458 kW AE fit are experimental single-point calibrations. They are not independent engine validation. Original Track A failures and warnings remain in the retained reports. The model has no demonstrated transient engine dynamics.

The launcher check is the remaining portability acceptance step on your laptop. It is not necessary to rerun the long training studies to use this package.
