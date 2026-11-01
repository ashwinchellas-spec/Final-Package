function ax = plot_performance_map(t,metric,throttle,ax)
%PLOT_PERFORMANCE_MAP Display one throttle slice without filling rejected grid points.
% Inputs: performance table, metric field, throttle, optional axes. Output: axes.
% Coordinates: geopotential m and Mach; colour: selected SI metric. NaN holes retained.
if nargin<4 || isempty(ax), figure('Color','w'); ax=axes; end
part=t(abs(t.Throttle-throttle)<1e-8,:); h=unique(part.GeopotentialAltitude_m); m=unique(part.Mach);
z=nan(numel(h),numel(m));
for i=1:height(part)
    if part.Valid(i), z(h==part.GeopotentialAltitude_m(i),m==part.Mach(i))=part.(metric)(i); end
end
surf(ax,m,h,z,'EdgeColor','none'); view(ax,2); colorbar(ax);
xlabel(ax,'Mach'); ylabel(ax,'Geopotential altitude (m)'); title(ax,strrep(metric,'_',' '));
end
