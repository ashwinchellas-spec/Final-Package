classdef EngineAnalyser_v1 < matlab.apps.AppBase
%ENGINEANALYSER_V1 Eight-tab App Designer-framework academic propulsion application.
% Input: optional DB path. Output: interactive app object. SI backend, display conversions.
% Programmatic AppBase source; not a binary .mlapp Design View file (see CHANGELOG).
    properties
        UIFigure
        DT
        Controls=struct()
        LastResults=table()
        LastResult=struct()
        LastSelection=struct()
        LastML=table()
    end
    methods
        function app=EngineAnalyser_v1(databaseFile)
            % Build the UI only after the backend connection succeeds.
            if nargin<1, p=project_paths(); databaseFile=p.database_file; end
            app.DT=DT_Coordinator(databaseFile);
            app.UIFigure=uifigure('Name','ABACUS | Aircraft Engine Analysis','Position',[80,60,1240,850],...
                'Color',[.95,.97,.99],'Visible','off');
            app.UIFigure.CloseRequestFcn=@(~,~) delete(app);
            gui_build(app); registerApp(app,app.UIFigure); gui_refresh_engine(app);
            app.UIFigure.Visible='on';
        end
        function delete(app)
            % Close this app's DB and figure; other coordinators remain independent.
            if ~isempty(app.DT), delete(app.DT); app.DT=[]; end
            if ~isempty(app.UIFigure) && isvalid(app.UIFigure), delete(app.UIFigure); end
        end
    end
end
