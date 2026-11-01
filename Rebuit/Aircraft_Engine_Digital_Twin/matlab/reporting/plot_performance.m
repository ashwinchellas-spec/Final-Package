function ax = plot_performance(t,xName,yName,ax)
%PLOT_PERFORMANCE Plot valid points grouped by engine, preserving source labels.
% Inputs: result table, numeric field names, optional axes. Output: axes handle.
% Units come from SI column names. Errors on missing fields or no valid points.
if nargin<4 || isempty(ax), figure('Color','w'); ax=axes; end
if ~ismember(xName,t.Properties.VariableNames) || ~ismember(yName,t.Properties.VariableNames)
    error('ABACUS:PlotField','Requested field is not in the result table.');
end
valid=logical(t.Valid)&isfinite(t.(xName))&isfinite(t.(yName));
if ~any(valid), error('ABACUS:NoPlotData','No valid results are available for this plot.'); end
cla(ax); hold(ax,'on'); engines=unique(string(t.Engine(valid)),'stable');
for i=1:numel(engines)
    part=t(valid & string(t.Engine)==engines(i),:); part=sortrows(part,xName);
    plot(ax,part.(xName),part.(yName),'-o','DisplayName',char(engines(i)),'MarkerSize',3);
end
xlabel(ax,strrep(xName,'_',' ')); ylabel(ax,strrep(yName,'_',' '));
title(ax,'Academic steady-state model'); grid(ax,'on'); legend(ax,'Location','best'); hold(ax,'off');
end
