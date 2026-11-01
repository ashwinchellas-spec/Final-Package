p = project_paths();
calibrationFolder = tempname(p.reports);
mkdir(calibrationFolder);

db = DB_Interface(p.database_file);
ids = [10 11];
targets = [2178 3458];
calibrationRows = cell(2,1);

try
    for k = 1:2
        original = db_get_engine(db,ids(k));
        condition = flight_condition(0,0,1,'geometric');
        baseline = simulate_engine(original,condition);

        assert(baseline.Valid && ...
            isfinite(baseline.ShaftPower_kW) && ...
            baseline.ShaftPower_kW > 0, ...
            'Baseline power is unavailable.');

        candidate = original;
        candidate.Params.MassFlow_kgs = ...
            original.Params.MassFlow_kgs * ...
            targets(k) / baseline.ShaftPower_kW;

        mask = string(candidate.Provenance.Parameter_Name) ...
            == "MassFlow_kgs";
        assert(nnz(mask) == 1,'Airflow provenance is not unique.');

        candidate.Provenance.Parameter_Value(mask) = ...
            candidate.Params.MassFlow_kgs;
        candidate.Provenance.Source_Type(mask) = "Assumed";
        candidate.Provenance.Confidence_Level(mask) = "Low";
        candidate.Provenance.Verified(mask) = false;
        candidate.Provenance.Source_Reference(mask) = ...
            "Single-point power fit; effective airflow, not measured airflow";

        candidate.Estimated = true;
        candidate.Confidence = 'Low';
        candidate.Fingerprint = model_fingerprint(candidate);

        fitted = simulate_engine(candidate,condition);
        assert(fitted.Valid && isfinite(fitted.ShaftPower_kW), ...
            'Calibrated candidate did not produce valid power.');

        fitError = 100 * abs(fitted.ShaftPower_kW-targets(k)) ...
            / targets(k);

        label = "Experimental single-point calibration; independent validation pending";
        if ids(k) == 11
            label = label + "; AE target provisional";
        end

        targetPower_kW = targets(k);
        save(fullfile(calibrationFolder, ...
            sprintf('engine_%d_calibration_candidate.mat',ids(k))), ...
            'original','candidate','condition','baseline','fitted', ...
            'targetPower_kW','label');

        calibrationRows{k} = table(ids(k),string(original.Name), ...
            original.Params.MassFlow_kgs, ...
            candidate.Params.MassFlow_kgs, ...
            baseline.ShaftPower_kW,targets(k), ...
            fitted.ShaftPower_kW,fitError,label, ...
            'VariableNames',{'Engine_ID','Engine', ...
            'OriginalFlow_kgs','EffectiveFittedFlow_kgs', ...
            'OriginalPower_kW','FitTarget_kW', ...
            'FittedPower_kW','CalibrationErrorPercent','Label'});
    end
catch exception
    delete(db);
    rethrow(exception);
end

delete(db);

calibrationSummary = vertcat(calibrationRows{:});
writetable(calibrationSummary, ...
    fullfile(calibrationFolder,'CALIBRATION_SUMMARY.csv'));
disp(calibrationSummary);
fprintf('\nCandidate files saved to:\n%s\n',calibrationFolder);