p = project_paths();
addpath(genpath(p.matlab));

candidateFolder = fullfile(p.reports, ...
    'tp3c0f490f_61e8_4e49_9d52_5d9ac7b1ae53');

comparisonFolder = tempname(p.reports);
mkdir(comparisonFolder);

[H,M,T] = ndgrid( ...
    [0 2000 4000 6000 8000], ...
    [0 0.2 0.4 0.6], ...
    [0.5 0.75 1]);

conditions = [H(:), M(:), T(:)];
ids = [10 11];
rows = cell(2*numel(ids)*height(conditions),1);
summaryRows = cell(numel(ids),1);
n = 0;

for k = 1:numel(ids)
    loaded = load(fullfile(candidateFolder, ...
        sprintf('engine_%d_calibration_candidate.mat',ids(k))));

    originalValid = 0;
    candidateValid = 0;

    fprintf('\nComparing %s: %d conditions\n', ...
        loaded.original.Name,height(conditions));

    for j = 1:height(conditions)
        f = flight_condition(conditions(j,1), ...
            conditions(j,2),conditions(j,3),'geometric');

        originalResult = simulate_engine(loaded.original,f);
        candidateResult = simulate_engine(loaded.candidate,f);

        originalValid = originalValid + logical(originalResult.Valid);
        candidateValid = candidateValid + logical(candidateResult.Valid);

        a = result_row(originalResult);
        b = result_row(candidateResult);

        a.ModelVariant = "Original";
        b.ModelVariant = "Calibrated experimental";

        usedForFit = all(conditions(j,:) == [0 0 1]);
        a.CalibrationPoint = usedForFit;
        b.CalibrationPoint = usedForFit;

        a.StudyLabel = string(loaded.label);
        b.StudyLabel = string(loaded.label);

        n = n + 1;
        rows{n} = a;
        n = n + 1;
        rows{n} = b;

        if mod(j,15) == 0
            fprintf('  Completed %d/%d conditions\n', ...
                j,height(conditions));
            drawnow;
        end
    end

    summaryRows{k} = table(ids(k),string(loaded.original.Name), ...
        height(conditions),originalValid,candidateValid, ...
        'VariableNames',{'Engine_ID','Engine','RequestedConditions', ...
        'OriginalValid','CandidateValid'});
end

comparison = vertcat(rows{1:n});
comparisonSummary = vertcat(summaryRows{:});

writetable(comparison, ...
    fullfile(comparisonFolder,'CALIBRATED_COMPARISON.csv'));
writetable(comparisonSummary, ...
    fullfile(comparisonFolder,'COMPARISON_SUMMARY.csv'));

disp(comparisonSummary);
fprintf('\nComparison saved to:\n%s\n',comparisonFolder);