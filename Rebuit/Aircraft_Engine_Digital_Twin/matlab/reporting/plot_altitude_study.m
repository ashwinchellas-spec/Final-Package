function files = plot_altitude_study(results, outputFolder)
%PLOT_ALTITUDE_STUDY Plot comparable metrics separately by engine architecture.
% Input: actual study table. Invalid values become NaN, preserving plot gaps.
types = unique(string(results.Architecture),'stable'); files = strings(0,1);
for i = 1:numel(types)
    kind = types(i); t = results(string(results.Architecture)==kind,:);
    isPropeller = ismember(kind,["Piston","Turboprop"]);
    if isPropeller
        metrics = {'ShaftPower_kW','FuelFlow_kgs','BSFC_kgkWh'};
        labels = {'Shaft power (kW)','Fuel flow (kg/s)','BSFC (kg/kWh)'};
        scales = [1,1,1];
    else
        metrics = {'Thrust_N','FuelFlow_kgs','TSFC_kgNs'};
        labels = {'Net thrust (kN)','Fuel flow (kg/s)','TSFC (kg/(kN h))'};
        scales = [0.001,1,3.6e6];
    end
    fig = figure('Name',char(kind),'Color','w','Position',[100,100,1150,470]);
    layout = tiledlayout(fig,1,3,'TileSpacing','compact','Padding','compact');
    title(layout,sprintf('%s | Mach %.2f | throttle %.2f',kind,t.Mach(1),t.Throttle(1)),'Interpreter','none');
    subtitle(layout,'Academic predictions; gaps indicate invalid points. Source confidence remains Low.');
    ids = unique(t.Engine_ID,'stable');
    for panel = 1:3
        ax = nexttile(layout); hold(ax,'on');
        for j = 1:numel(ids)
            e = sortrows(t(t.Engine_ID==ids(j),:),'Altitude_m');
            y = e.(metrics{panel})*scales(panel);
            y(~logical(e.Valid)) = NaN;
            plot(ax,e.Altitude_m/1000,y,'-o','LineWidth',1.4,'MarkerSize',3, ...
                'DisplayName',char(e.Engine(1)));
        end
        xlabel(ax,'Geometric altitude (km)'); ylabel(ax,labels{panel}); grid(ax,'on');
        if panel == 1, legend(ax,'show','Location','best','Interpreter','none'); end
    end
    file = fullfile(outputFolder,['altitude_',char(kind),'.png']);
    exportgraphics(fig,file,'Resolution',160); files(end+1,1) = string(file);
end
end
