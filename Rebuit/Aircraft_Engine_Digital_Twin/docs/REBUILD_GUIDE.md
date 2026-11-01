# Database and altitude-study guide

## Objective

Build a traceable catalogue of representative engines from several manufacturers,
then calculate and compare their performance across specified altitudes, Mach
numbers and throttle settings. Reference ratings, model inputs, calculated
performance and ML predictions must remain distinguishable.

## Database organisation

| Table/view | Purpose |
| --- | --- |
| Manufacturers | Manufacturer identity and catalogue notes |
| Engine_Types | Turbojet, high/low-bypass turbofan, turboprop, piston |
| Engines | Engine ID, exact designation, manufacturer/type links |
| Engine_Thermo_Params | Model input values, operating limits, mass and confidence |
| Parameter_Provenance | Parameter name/value, unit, source, confidence and verification |
| References | Source bibliography and notes |
| Performance_Data | Reference ratings and calculated/ML performance, tagged by Data_Type |
| Simulation_Log | Append-only operating inputs, outputs, model identity and execution details |
| Mission_Profiles | Screening constraints and weighted mission preferences |
| Aircraft / Engine_Aircraft_Map | Secondary-specification associations; not independently verified |
| Project_Metadata | Schema and model metadata |
| v_Engine_Catalogue | Readable engine/manufacturer/type summary |

Foreign keys enforce relationships. Provenance records are required for populated
numerical inputs. Reference records are protected by triggers; simulations do not
overwrite them. The rebuilt main database ships with 13 engines and no claimed
new simulation results. Its model metadata records the rebuild revision.

`database/exports/` provides CSV inspection copies of the catalogue, parameters,
manufacturers, architecture list, provenance and source bibliography. These are
snapshots, not the authority. Editing them does not update SQLite. Refresh them
with `START_HERE('catalogue')` after a database change.

## Engine IDs

| ID | Engine | Architecture |
| --- | --- | --- |
| 1 | J79-GE-17A | Turbojet |
| 2 | SNECMA Atar 9C | Turbojet |
| 3 | R-25-300 | Turbojet |
| 4 | CFM56-5B4 | High-bypass turbofan |
| 5 | CF6-80C2B1F | High-bypass turbofan |
| 6 | F100-PW-229 | Low-bypass turbofan |
| 7 | SNECMA M88-2 | Low-bypass turbofan |
| 8 | GTX-35VS Kaveri | Low-bypass turbofan, estimated |
| 9 | PT6A-67D | Turboprop |
| 10 | PW127G | Turboprop |
| 11 | AE 2100D3 | Turboprop |
| 12 | Lycoming O-360-A1A | Piston, assumed class model |
| 13 | Continental IO-550-B | Piston, assumed class model |

## Meaning of a study

A default run holds Mach at 0.3 and throttle at 1 while changing geometric
altitude. ISA determines air temperature, pressure, density and speed of sound.
Because Mach is fixed, true airspeed changes with temperature. This is not a
constant true-airspeed study. The engine limits inherited from the project are
checked using geopotential altitude; both altitude conventions are exported.

For piston engines, the current model uses fixed rated RPM and an assumed brake
thermal efficiency. It does not solve manifold dynamics, heat transfer or
supercharging. For gas turbines, the original simplified off-design model uses
fixed corrected-flow and component-efficiency approximations, not manufacturer
compressor maps. These limitations constrain the accuracy of altitude trends.

Compare appropriate metrics at matched operating conditions:

- Turbojet/turbofan: thrust, fuel flow, TSFC, thermal/propulsive/overall efficiency.
- Piston/turboprop: shaft power, fuel flow, BSFC and modelled equivalent thrust.
- All engines: operating validity, parameter confidence and source provenance.

Station pressures/temperatures are available for gas turbines in each raw result
in the saved MAT file. Fields not applicable to an architecture remain NaN.
The new plot function separates architectures to avoid mixing shaft-power and
thrust units. Invalid points produce gaps, never fabricated extrapolations.

## Study outputs

Each run creates a unique `results/` subfolder:

- `altitude_performance.csv`: one row per engine/altitude, metrics, ambient state,
  manufacturer, units in column names, status, model fingerprint and warnings.
- `engine_summary.csv`: valid and invalid counts per engine.
- `invalid_operating_points.csv`: rejected points and reasons.
- `altitude_study.mat`: tables, settings and raw detailed result structures.
- `altitude_<architecture>.png`: plots of comparable metrics within each type.
- `database_status.txt`: whether the calculated data were stored in SQLite.
- Error text files only if a database write or plot export fails.

Valid results go into Performance_Data, and all point logs into Simulation_Log.
CSV/MAT output is saved before persistence so a database error cannot hide the
computed tables. A persistence warning is not success; inspect database_error.txt.

## Extending the database responsibly

1. Choose the exact engine variant and architecture; collect public primary sources.
2. Record each input's units, operating condition and source. A sea-level rating
   alone cannot identify all component model parameters or validate altitude trends.
3. Add or reuse manufacturer/type records and choose an unused engine ID.
4. Add Engine_Thermo_Params and matching Parameter_Provenance rows. Keep assumed,
   estimated and verified data distinct. Do not set Verified=1 without source review.
5. Add reference records with their stated operating conditions through the
   existing `db_add_reference` workflow; reference immutability is intentional.
6. Run provenance, physics and comparison tests. Only then consider ML validation.

New architectures require equations, input validation and output definitions as
well as rows in the database. Renaming an existing engine type is insufficient.
The original seeds and `db_add_reference.m` document the concrete schema.

## Startup fix and regression checks

The original script called MATLAB commit/rollback after execute-based statements
without an active SQLite transaction in the user's run. The replacement helper
uses explicit SQL BEGIN IMMEDIATE, COMMIT and ROLLBACK. BEGIN is outside the
rollback handler to avoid rolling back a caller transaction if BEGIN itself fails.
The helper retains original errors with script/statement context. The typed-write
DB_Interface.atomic path retains its existing sqlwrite transaction API, with
cleanup errors attached rather than masking the original failure.

Tests in TestRebuild cover repeated/empty scripts, rollback on failure, invalid
altitude output and persistence. Existing tests cover typed-write rollback and
integration. They are supplied but have not been executed in MATLAB here.

If MATLAB says db_execute_script is unrecognised, the wrong or incomplete folder
is in use. Restart MATLAB, open the new START_HERE.m from the fully extracted ZIP,
and run it. Do not rename or move individual dependencies. No old database needs
to be deleted. Preserve the old project until the rebuild is accepted locally.
