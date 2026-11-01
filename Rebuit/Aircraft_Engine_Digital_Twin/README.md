# ABACUS - aircraft engine database and altitude performance analysis

Rebuilt startup package, revision 1.1. Start with **START_HERE.m**.

## First run on Windows

1. Extract the ENTIRE ZIP into a new writable folder, for example `C:\DRDO_Rebuilt`.
2. Do not copy files into the old project. Keep the old folder as a backup.
3. Restart MATLAB so old classes and paths are not reused.
4. Open the new extracted `Aircraft_Engine_Digital_Twin/START_HERE.m` in MATLAB.
5. Click Run. If prompted, choose Change Folder.

Or, with Current Folder set to this extracted project root, enter:

```matlab
study = START_HERE;
```

The default run analyses all 13 engines from 0 to 15,000 m geometric altitude in
1,000 m increments, at Mach 0.3 and full throttle. It writes a unique folder
under `results/` containing actual CSV/MAT results, a validity summary, and
separate plots by architecture. Valid performance and all execution logs are
also written to the SQLite database when persistence succeeds. A database
write failure is explicitly reported and does not discard the CSV/MAT files.

The main database is already populated, including piston engines. No manual
piston seeding or individual replacement-file installation is required.

## Other commands

```matlab
app = START_HERE('gui');          % Original eight-tab interactive app
catalogue = START_HERE('catalogue'); % Display catalogue and refresh database CSV exports
installation = START_HERE('check'); % Installation and database checks
results = START_HERE('tests');    % Actual tests in isolated temporary databases

% All engines: 0 to 5,000 m, Mach 0.2, throttle 0.8
study = run_altitude_study(0:500:5000,0.2,0.8);

% Only piston engines, IDs 12 and 13
study = run_altitude_study(0:500:5000,0.2,1,[12,13]);

% Only high-bypass turbofans, IDs 4 and 5
study = run_altitude_study(0:1000:12000,0.75,1,[4,5]);
```

Run one command at a time. If startup fails, stop and copy the complete first
error. Do not continue with commands that require a successful setup.

## Required software

- MATLAB R2023b or later and Database Toolbox: required for startup and physics.
- MATLAB JVM: required for model fingerprints.
- Statistics and Machine Learning Toolbox: only for ML training workflows.
- Simulink: only for the existing three gas-turbine Simulink wrappers.
- Aerospace Toolbox does not replace Database Toolbox; no separate SQLite server is required.

## What is in the database?

`database/engine_analysis.db` is the authoritative SQLite database. It contains
13 engines, manufacturer and architecture records, 218 numerical parameter
provenance records, mission presets and unverified reference ratings inherited
from the specification. `database/exports/engine_catalogue.csv` is an inspection
copy that can be opened without MATLAB. Parameters and sources are also exported.

The 11 gas-turbine engines come from the supplied specification. Two piston
entries extend it: Lycoming O-360-A1A and Continental IO-550-B. Their parameters
are assumed class values, not validated manufacturer-specific performance.
The fresh core schema/seed and test fixture still contain 11 engines; the
separate piston seed adds two. START_HERE applies it idempotently.

## Meaning and limits

This is an academic, steady-state software model. It computes performance
predictions at operating conditions, not physical engine tests. It is a starting
catalogue, not a database of every aircraft engine ever manufactured. Turboshaft,
ramjet/scramjet, afterburner, transient dynamics and compressor maps are outside
this implementation. The original PDF explicitly defers some of these types.

All supplied parameter confidence remains Low. No new manufacturer data has
been independently verified in this rebuild. Kaveri results retain mandatory
estimated-performance warnings. Missing values remain missing. Invalid altitude,
Mach or physical-model points remain flagged and are not silently clipped.

Jet thrust/TSFC and propeller shaft power/BSFC use different quantities and units;
they must not be directly ranked as a single metric across architectures.

ML remains gated on actual physics/reference validation. Opening the app or
producing curves does not establish real engine accuracy or validate all phases.

## Verification status

The rebuild has SQL integrity/regression and source checks, recorded in
`FINAL_VERIFICATION_REPORT.md`. MATLAB, the GUI, Simulink and ML have NOT been
executed in the assistant's environment. Run the included MATLAB tests locally.
The original reports/PDF manuals remain included for background; their source
counts and pre-rebuild instructions are historical. This README and
`docs/REBUILD_GUIDE.md` supersede their startup instructions.
