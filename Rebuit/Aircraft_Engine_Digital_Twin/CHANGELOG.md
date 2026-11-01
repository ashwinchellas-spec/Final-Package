# Rebuild revision 1.1

- Added START_HERE.m with extraction/path/dependency checks.
- Included explicit SQL transaction helper; retained original errors during cleanup.
- Included both piston entries in the delivered main database.
- Added catalogue/parameter/source CSV exports and altitude study with SQLite persistence.
- Added transaction and altitude-study regression tests (MATLAB execution pending).
- Preserved existing physics, GUI, ML validation gates and gas-turbine Simulink wrappers.

## Historical changelog

# Changelog

## Implementation 1.0 - 2026-09-16

The 77-page ABACUS v1.1 PDF remains the primary specification. The two uploaded PDF copies are byte-identical; one is retained in docs. The implementation adds the following explicit clarifications/corrections.

| ID | Issue | Implemented decision and consequence |
| --- | --- | --- |
| C01 | The blueprint illustrates JDBC parameter markers; the requested stack also allows native SQLite. | Use Database Toolbox native sqlite, allowlisted table identifiers, typed sqlread/sqlwrite, and MATLAB-side filtering. No user value is interpolated into SQL. This is not a claim to implement JDBC prepared-query APIs. |
| C02 | Earlier schema lists three data classes; later corrections require four. | Reference, Simulated, ML_Predicted and Simulated_Estimated are all constrained values. |
| C03 | The PDF contains geometric/geopotential atmosphere values and pressure checkpoints that do not consistently follow its equations. | Internal geopotential altitude, explicit conversion at the GUI, R=287.058 J/(kg K), and continuous layer equations. At 15 km geopotential the pressure is about 12045 Pa, not 12111; at 25 km about 2511 Pa, not 2549. The geometric/geopotential difference at 32 km is about 0.5%, not 0.16%. |
| C04 | Stated cp, gamma and R values are not fully thermodynamically consistent. | Derive cp=gamma*R/(gamma-1) for each constant-property gas. Results can therefore differ from arithmetic using rounded independent cp. |
| C05 | Turbofan work expression multiplies fan specific work by cp again. | Fan Work_Jkg already contains cp. Demand per kg core air equals compressor work plus (1+BPR)*fan work. |
| C06 | Non-ideal nozzle and choking equations need a consistent sonic boundary. | Derive the efficiency-adjusted sonic pressure ratio; retain the classical ratio at eta=1. Compute exit total pressure from actual exit static state and Mach. |
| C07 | Turboprop energy/momentum expressions omit fuel mass in places. | Use gas mass flow = core air*(1+fuel-air ratio) for turbine power and nozzle momentum. |
| C08 | Setting power-turbine exit total pressure equal to ambient removes the pressure head for a residual nozzle. | An explicit assumed back-pressure ratio of 1.05 permits residual jet expansion. This is a modelling choice, not a manufacturer parameter. |
| C09 | Propeller eta*P/V is singular at zero flight speed. | Use an actuator-disc static limit with a smooth blend to the cruise expression by Mach 0.05. Retain the propeller geometry assumption in provenance. |
| C10 | The printed ESHP expression places propeller efficiency inconsistently. | ESHP=(propeller-shaft power + residual thrust*speed/eta_propeller)/745.6998716. Static residual thrust contributes zero equivalent power. |
| C11 | Throttle and off-design compressor behaviour are underspecified. | Document explicit pressure-ratio, temperature-rise and corrected-flow laws; these are academic assumptions, not compressor maps. Zero throttle uses an engine-off convention. |
| C12 | Catalogue variants/ratings conflict within the PDF. | Use CF6-80C2B1F label; PT6A-67D 1119 kW from later Table 23 rather than 895; AE2100D3 3458 kW rather than 3459. All remain unverified secondary values. Kaveri uses the 53400 N estimated dry target, not the 81000 N afterburning target. |
| C13 | User requests piston engines, but the PDF final core is 11 gas turbines. | Provide a separate opt-in two-engine piston seed and model. Default catalogue remains the PDF's 11 engines. |
| C14 | User requests a Trainer mission in addition to the PDF presets. | Preserve six PDF presets and add an explicitly academic Trainer preset. |
| C15 | Desktop binary .mlapp cannot be generated/validated here. | Deliver a complete programmatic AppBase .m application with eight tabs and shared backend callbacks. App Designer Design View editing is not delivered. |
| C16 | MATLAB/Simulink is absent on the execution host. | Deliver three text .mdl models plus a real .slx builder and execution test. No generated .slx, claimed execution or fake binary is supplied. |
| C17 | Primary engine sources were not independently established. | All seed engine parameters stay Estimated/Assumed and Low, all secondary reference rows stay unverified. Training requires actual internal tests plus a reviewed in-tolerance reference/explicit estimated target. |
| C18 | A reviewed estimate must not be called measured validation. | Reference_Kind separates Measured, PublishedRating and EstimatedTarget from UnverifiedSecondary. Kaveri can only use EstimatedTarget. Acceptance against an estimate remains academic. |
| C19 | A repository history cannot be recovered/generated honestly from files. | Deliver GitHub-ready source, license and ignore rules without fabricated commits or publication. |

No reference rating is used to tune the engine equations. No numerical validation result, accuracy, timing, GUI screenshot or trained model is fabricated.
