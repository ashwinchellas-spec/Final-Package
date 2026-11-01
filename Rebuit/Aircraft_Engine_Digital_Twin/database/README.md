# SQLite database

engine_analysis.db is the seeded application database; engine_test.db is a separate seeded inspection copy. Automated MATLAB tests create disposable databases and do not mutate the production catalogue. schema.sql and seed_data.sql reproduce the 11-engine core. seed_piston_extension.sql is optional. PRAGMA user_version is 2.

The 11 required tables are Manufacturers, Engine_Types, Engines, Engine_Thermo_Params, Parameter_Provenance, Aircraft, Engine_Aircraft_Map, Performance_Data, Mission_Profiles, References and Simulation_Log. Project_Metadata is an additional table. Three views expose catalogue, reference rows and joined provenance; three indexes support condition/provenance/log lookups. Foreign keys are explicitly enabled on every connection. CHECK constraints guard architecture parameters, efficiencies, enum values, flight conditions and mission weight sum. Triggers make Reference rows immutable and Simulation_Log append-only.

Recreate in a new filename with setup_project(newDatabaseFile), or use db_initialize followed by db_seed. Both seed scripts are idempotent. Existing database files are never automatically deleted; an incompatible schema raises an error. No destructive migration utility is included.

The distributed SQL scripts use -- @statement delimiters so complete trigger bodies remain intact when MATLAB executes statements. Runtime values travel through typed sqlwrite tables; they are not concatenated into SQL. MATLAB NaN numeric data maps to SQLite NULL. The host SQL quoting test uses Node prepared bindings and therefore does not substitute for executing MATLAB sqlwrite tests.

The delivered databases have 11 engines, 192 numerical provenance records, 13 unverified secondary reference rows, 7 mission presets, 11 aircraft records and 11 engine-aircraft mappings. There are no supplied simulated or ML-predicted performance rows. Aircraft mappings are secondary catalogue associations, not flight suitability evidence.

See ../docs/DATA_PROVENANCE.md before interpreting a reference or changing an engine input.
