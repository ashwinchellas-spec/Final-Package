# Data provenance

The default seed is an explicitly labelled academic transcription of the user-provided ABACUS v1.1 blueprint, supplemented by disclosed assumptions. No engine parameter in this delivery was independently verified against its original manufacturer/type-certificate source. An engine name or a citation appearing in the blueprint is not itself primary-source verification.

The engine catalogue contains:

| ID | Engine | Architecture | Confidence |
| --- | --- | --- | --- |
| 1 | J79-GE-17A | Turbojet | Low |
| 2 | SNECMA Atar 9C | Turbojet | Low |
| 3 | R-25-300 | Turbojet | Low |
| 4 | CFM56-5B4 | Turbofan_HighBPR | Low |
| 5 | CF6-80C2B1F | Turbofan_HighBPR | Low |
| 6 | F100-PW-229 | Turbofan_LowBPR | Low |
| 7 | SNECMA M88-2 | Turbofan_LowBPR | Low |
| 8 | GTX-35VS Kaveri | Turbofan_LowBPR | Low |
| 9 | PT6A-67D | Turboprop | Low |
| 10 | PW127G | Turboprop | Low |
| 11 | AE 2100D3 | Turboprop | Low |

Every one of the 192 populated numerical core engine parameters has a Parameter_Provenance record whose value matches the parameter table, with unit, source category, reference, notes and confidence. Estimated means a secondary/transcribed academic value; Assumed means an explicit modelling assumption. Neither means measured. The 13 Performance_Data reference rows include excluded afterburning targets for traceability; they are all UnverifiedSecondary with Reference_Verified=0. Missing measured TSFC is NULL, not an invented zero or fitted number. Defaults remain Low confidence in derived outputs.

The optional seed adds Lycoming O-360-A1A and Continental IO-550-B. The user requested their inclusion, but the primary PDF's core does not include pistons. Their supplied numerical values are explicit academic assumptions and not manufacturer-confirmed specifications.

## Source-review process

Read the original public source and verify the exact variant, configuration, dry/afterburning status, altitude convention, atmospheric condition, Mach, throttle/rating, units and measurement/rating status. Record its exact URL, title/page, conversions and reviewer note. db_add_reference appends a new immutable row after these explicit inputs; it records the caller's review, not an automated independent verification. Do not update or delete an old reference to erase a discrepancy.

Reference_Kind is Measured, PublishedRating or EstimatedTarget for newly reviewed inputs. EstimatedTarget retains Low confidence and the statement that it is not measured performance. Kaveri accepts only EstimatedTarget under this project policy. Re-run validate_physics, inspect actual errors and the applicable tolerance, then inspect each engine's fingerprinted certificate. A reviewed source alone does not make an inaccurate model pass.

## Confidence and labels

Reference identifies the origin of a comparison target, not its truth. Simulated is reserved for physics data without estimated parameter status; supplied Low-confidence seeds produce Simulated_Estimated. ML_Predicted marks surrogate outputs while retaining underlying source confidence and the surrogate's actual validation metadata. The L5 prediction source is always visible; a fallback remains Physics.

Kaveri displays: ESTIMATED / ACADEMIC MODEL - NOT MANUFACTURER-CONFIRMED PERFORMANCE. These results do NOT represent actual Kaveri engine performance.

## Reference conflicts retained

CF6 variant naming, PT6A power, AE2100 rounding, PW127 altitude, Kaveri dry/afterburner targets and atmosphere checkpoints are resolved in CHANGELOG.md. Preserve these notes when adding stronger sources. Parameter changes must update matching provenance and trigger revalidation; do not silently promote a confidence flag.
