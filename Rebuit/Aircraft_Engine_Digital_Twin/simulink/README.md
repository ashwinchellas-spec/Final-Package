# Steady-state Simulink wrappers

The three .mdl files are real text-form model definitions. build_simulink_models constructs equivalent connected .slx files using Simulink APIs; run_simulink_model executes them. abacus_sfun reads [engine ID; geometric altitude m; Mach; throttle], calls the shared backend and returns its documented output vector. Inspect abacus_sfun.m for exact output order and validity handling.

Neither model load nor compilation nor execution has run on the delivery host. Do not treat an .mdl filename or successful static reference check as a Simulink test pass. No continuous states, transient engine dynamics, code generation or hardware interface is provided.
