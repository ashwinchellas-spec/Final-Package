# Rebuild verification report

This report supersedes pre-rebuild startup and verification notes. Original PDF
reports are historical background, not evidence that this rebuild ran in MATLAB.

## Executed checks

- 28/28 existing host audit checks passed (Node.js/SQLite and static structure).
- 14/14 rebuild SQL/data checks passed: explicit transactions, repeated seeds,
  failure rollback, catalogue/provenance consistency and no invented simulations.
- 98/98 MATLAB files passed MISS_HIT parsing/lint in MATLAB 2022a language mode.
- Main SQLite database: 13 engines, 218 parameter provenance records; integrity
  and foreign-key checks passed. Core test database: 11 engines.

Evidence: reports/HOST_AUDIT_RESULTS.json, reports/REBUILD_SQL_CHECKS.json and
reports/SOURCE_PARSE_RESULTS.json. Some SQL checks overlap; these are not counts
of independently validated engineering requirements.

## Not executed here

MATLAB, the GUI, Simulink, physics performance validation, ML training and the
68 MATLAB test functions have NOT been executed in this environment. SQL logic
checks do not prove MATLAB API compatibility. No simulated engine performance,
accuracy values or manufacturer validation were invented for this delivery.

## User acceptance sequence

Extract into a new folder, restart MATLAB, open START_HERE.m and click Run.
The default altitude study must report actual valid-point counts, output paths
and database storage status. Capture the complete first error if it fails.

Then run START_HERE('tests') and inspect the actual Passed/Failed/Incomplete
columns in reports/matlab_test_results.csv. Tests use temporary databases.
Finally run app = START_HERE('gui') to check interactive use. Optional toolbox
limitations can produce incomplete tests; incomplete does not mean passed.

The original simplified engine models and unverified source assumptions remain.
A successful software run is not validation against real manufacturer data.
