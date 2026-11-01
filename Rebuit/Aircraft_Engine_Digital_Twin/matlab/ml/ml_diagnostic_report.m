function ml_diagnostic_report(data,predicted,metrics,engineID)
%ML_DIAGNOSTIC_REPORT Save test residuals and prediction/reference plots with SI labels.
% Inputs: dataset, held-out predictions, metrics, engine ID. Outputs: CSV and PNG artifacts.
% Ref: ABACUS Track B; references here are physics data only. Never used for model selection.
p=project_paths(); test=data.Split.Test; folder=fullfile(p.reports,sprintf('engine_%d_ml',engineID));
if ~isfolder(folder), mkdir(folder); end
t=array2table(data.X(test,:),'VariableNames',data.FeatureNames);
for j=1:numel(data.TargetNames)
    name=data.TargetNames{j}; ref=data.Y(test,j); pred=predicted(:,j);
    t.([name,'_Physics'])=ref; t.([name,'_ML'])=pred; t.([name,'_Residual'])=pred-ref;
    fig=figure('Visible','off','Color','w'); cleanup=onCleanup(@() close(fig));
    tiledlayout(fig,1,2); ax=nexttile; scatter(ax,ref,pred,8,'filled'); hold(ax,'on');
    limits=[min(ref),max(ref)]; plot(ax,limits,limits,'k--'); grid(ax,'on');
    xlabel(ax,'Held-out physics'); ylabel(ax,'ML prediction'); title(ax,strrep(name,'_',' '));
    ax=nexttile; scatter(ax,data.X(test,1),data.X(test,2),15,pred-ref,'filled'); colorbar(ax);
    xlabel(ax,'Mach'); ylabel(ax,'Geopotential altitude (m)'); title(ax,'Held-out residual map');
    exportgraphics(fig,fullfile(folder,[name,'.png']),'Resolution',150);
    clear cleanup
end
writetable(t,fullfile(folder,'held_out_residuals.csv')); writetable(metrics,fullfile(folder,'metrics.csv'));
end
