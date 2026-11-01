ABACUS EXPERIMENTAL GUI TAB -- additive integration

Requirements: your existing EngineAnalyser_v1 app, tested unified predictor v3,
saved unified_registry.mat, and all model files at their registered paths.

1. Extract this add-on to a separate folder. Do not replace the project gui.
2. Open your project normally: app = START_HERE('gui');
3. Change MATLAB Current Folder to this add-on folder (keep app open).
4. Run: tab = ATTACH_EXPERIMENTAL_ML(app);
5. Select unified_registry.mat, then PREDICT_UNIFIED_ENGINE.m from the working
   ABACUS_UNIFIED_PREDICTOR folder.
6. In Experimental ML choose engine 1, altitude 3000, Mach 0.4, throttle 0.8.
   Click Predict. Expected approximately 30094 N, 0.88612 kg/s, 2.9445e-5 kg/(N s).
7. Test engine 2 (boundary model) and engine 10 (original model).
8. Set throttle to 0.1: saved training bounds should reject the query.
9. Change inputs after a prediction: the previous displayed result must clear.
10. Export the session log if needed. It includes successful, unavailable and
    failed queries. No automatic database logging or database mutation occurs.

The experimental tab has its OWN engine and input controls. Global GUI engine
selection and the Single-Point Analysis controls do not control this tab.
No fallback is silently substituted here. The original L5 and physics controls,
their gates, and their existing fallback behavior are unchanged.
The tab is session-only: call ATTACH_EXPERIMENTAL_ML again after reopening the app.
Closing the app removes the tab. No installation/rollback is needed.

All models remain experimental. The registry is not a validation certificate.
PW127G and AE 2100D3 physical/reference discrepancies remain unresolved.
Original models have differing test coverage; availability is not acceptance.
This add-on neither trains models nor edits Operational flags or source data.

Verification: MATLAB syntax/static lint checked where available. No MATLAB
runtime exists in the authoring environment, so GUI execution and the smoke
checks above must be performed on your laptop. This is not completion of the
full L5 integration/acceptance plan.
