# Aircraft Engine Digital Twin - ABACUS

Academic steady-state software Digital Twin for engine performance analysis, comparison, constrained mission selection and physics-based ML surrogates. This implementation follows the attached ABACUS v1.1 specification; every deliberate correction or scope extension is recorded in CHANGELOG.md.

## Delivery status

All 15 requested implementation areas have source, integration interfaces, documentation and relevant tests. **This is an implementation package awaiting MATLAB runtime acceptance, not a claim that all phases have passed.** The executed host audit passed 28 checks, including real SQLite schema, seed, transaction, provenance and integrity checks. The 64 MATLAB test functions have not been executed in this environment. MATLAB, GUI, Simulink and ML training results are not supplied as successful results.

The default database contains the PDF's 11 engines and 192 populated numerical parameters with matching provenance. All engine inputs copied from the secondary specification or introduced as assumptions retain Low confidence. No primary manufacturer data was independently verified during this implementation. Missing TSFC values remain NULL. The Kaveri warning is mandatory. Two optional piston entries implement the additional user request without changing the PDF's default catalogue.

## Requirements

- MATLAB R2023b or newer.
- Database Toolbox, for the native SQLite interface, sqlread and sqlwrite.
- Statistics and Machine Learning Toolbox for RF, GPR and ANN training. The ANN implementation uses fitrnet with a separate network for each output; Deep Learning Toolbox is not required.
- Simulink only for the three Simulink wrappers.
- A graphical MATLAB desktop for the eight-tab app. A JVM is used for SHA-256 fingerprints.

No Python, Node.js, external SQLite JDBC driver or network connection is needed to run the MATLAB application. The optional host auditor uses Node.js 24 or newer with its built-in SQLite module.

## Start

Unzip, open MATLAB, and set Current Folder to the extracted Aircraft_Engine_Digital_Twin directory. Then run:

```matlab
run_project('gui')
```

That command calls setup_project, adds the authoritative folders, checks MATLAB version, and initializes/seeds the database if necessary. Existing compatible data is preserved. The GUI is a programmatic AppBase application in gui/EngineAnalyser_v1.m; it is not an App Designer .mlapp Design View file.

For an explicit installation and acceptance sequence:

```matlab
p = setup_project;
db_initialize(p.database_file);
db_seed(p.database_file);
installation = verify_project;
tests = run_all_tests;
validation = run_project('validate');
app = run_project('gui');
```

Do not call a runtime phase accepted until its actual tests and reference review have been completed. Read FINAL_VERIFICATION_REPORT.md before presenting results.

## Reproducible workflows

```matlab
demo = run_project('demo');             % Single point, comparison, mission, HTML report
grid = run_project('grid');             % Architecture grids; may take time
db_seed_piston_extension;              % Explicitly add the two optional piston engines
models = run_project('simulink');        % Build actual .slx files with licensed Simulink
simout = run_simulink_model;            % Execute the turbojet wrapper
training = run_project('train');        % Requires accepted, current physics validation
```

The default ML gate is intentionally closed: the supplied secondary reference ratings are unverified. See docs/ML_WORKFLOW.md for the source-review and validation requirements. L5 falls back to physics with an explicit warning when an accepted model is unavailable. No pretrained MAT files, fabricated accuracy values, measured engine outputs or generated validation certificates are included.

## Structure

| Folder | Purpose |
| --- | --- |
| database | Reproducible SQL, production/test SQLite files, provenance and reference policy |
| matlab/setup | Native SQLite access, seeding, constants and typed persistence |
| matlab/atmosphere | Three-layer ISA with explicit altitude convention |
| matlab/engines | Common cycle components and piston/TJ/TF/TP adapters |
| matlab/validation | Input/output checks, reference validation, sensitivity and regression |
| matlab/digital_twin | Shared coordinator and architecture dispatch |
| matlab/performance | Architecture grids and validity-aware evaluation |
| matlab/comparison, matlab/mission | Comparisons and constraint-first mission scoring |
| matlab/ml | Dataset, splitting, four surrogate families, prediction and metrics |
| matlab/reporting, matlab/utilities | Tables, plots, HTML reports, paths and fingerprints |
| gui, simulink | Eight-tab app and three steady-state model wrappers |
| tests, scripts | MATLAB tests, phase runner, static/host audit tools |
| docs, reports | Manuals, technical report, specification and actual verification evidence |
| results, plots, tables, ml_models | Runtime output destinations; no invented results |

## Scope

Uninstalled, constant-property, separate-exhaust, steady-state models. No afterburner, compressor maps, transient dynamics, surge/stall, cooling/bleed, inlet distortion, detailed propeller map, flight-range solver, engine degradation, hardware interface or certification claim. Rated thrust/power is never used to force model outputs to match a target. Mission results compare catalogue candidates under an academic model and do not establish aircraft suitability.

See docs/USER_MANUAL.md, docs/ARCHITECTURE.md, docs/ASSUMPTIONS.md, docs/DATA_PROVENANCE.md, docs/TESTING.md and docs/LIMITATIONS.md. The PDF technical report includes a labelled source-code appendix, not experimental results.
