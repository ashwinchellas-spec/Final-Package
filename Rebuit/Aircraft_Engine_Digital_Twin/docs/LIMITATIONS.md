# Limitations and unresolved acceptance work

1. MATLAB R2023b, Database Toolbox, Statistics and Machine Learning Toolbox, graphical app execution and Simulink were unavailable on the delivery host. Source parsing and native host SQLite checks cannot establish that those APIs execute correctly. All 64 MATLAB tests remain unexecuted here.
2. Engine data is Low-confidence secondary/assumed input. There are no independently verified manufacturer measurements in the supplied seed. Track A reference acceptance and all runtime output accuracy remain unresolved.
3. ML training is blocked until actual internal tests and reviewed in-tolerance reference comparisons produce a current certificate. No trained model, R2, RMSE, MAPE, timing or predicted performance is delivered as an experimental result.
4. The GUI is programmatic AppBase source, not a .mlapp Design View project. Its eight-tab layout and backend wiring need runtime desktop review. Source inspection is not a GUI walkthrough.
5. Three text .mdl wrappers and the .slx builder are delivered. .slx generation and model loading/running have not occurred. The wrappers provide steady-state shared-backend evaluations, no physical transient dynamics or code generation support.
6. Constant gas properties, assumed efficiencies/TIT/flow, algebraic throttle laws and fixed corrected-flow scaling exclude detailed component-map matching. Afterburners, variable geometry, cooling and bleed, surge/stall, installation losses, nozzle area schedules, emissions and combustion chemistry are absent.
7. Propeller static blending and residual-jet pressure allocation are explicit academic assumptions. They do not model a complete propeller map. Turboprop rating agreement must be checked; secondary mass flow and TIT can yield substantial excess predicted power.
8. Piston modelling is an optional, naturally aspirated extension with assumed parameters. It is not a manufacturer dynamometer map.
9. Mission selection is relative to feasible database entries and selected weights. Envelope ceiling is a model input; it is not an aircraft service ceiling. No drag, takeoff distance, payload/range, flight-path integration or airframe installation compatibility is solved.
10. Confidence flags are categorical provenance labels, not quantified uncertainty. Fingerprints detect changes for reproducibility, not malicious modification. The database is a local academic store, not a multi-user access-control service.
11. Dynamic HTML reports and static PDF documentation are included. A comprehensive thesis with real experimental validation, benchmark plots or trained-model results cannot be completed without those experiments. The technical PDF's source appendix is explicitly labelled.
12. Source and documentation are ready to place in a Git repository, but no remote repository, fabricated commit history or publication was created.

Do not treat host audit PASS as acceptance of all implementation phases. FINAL_VERIFICATION_REPORT.md lists each phase separately and identifies what was actually executed.
