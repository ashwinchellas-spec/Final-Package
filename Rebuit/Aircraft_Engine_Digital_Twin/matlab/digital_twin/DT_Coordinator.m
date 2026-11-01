classdef DT_Coordinator < handle
%DT_COORDINATOR Academic steady-state software Digital Twin, levels L1-L5.
% Input: optional DB path. Outputs: run result, sweep/map tables, persisted metadata.
% Model equations live only in engine modules; L5 falls back explicitly to physics.
    properties (SetAccess=private)
        Database
        DatabaseFile
    end
    methods
        function obj=DT_Coordinator(databaseFile)
            % Open a database for this coordinator, with independent connection lifetime.
            if nargin<1, p=project_paths(); databaseFile=p.database_file; end
            obj.DatabaseFile=char(databaseFile); obj.Database=DB_Interface(databaseFile);
        end
        function r=run(obj,engineID,f,level,storeResult)
            % L1 single point; L4 logs by default; L5 checks surrogate freshness/domain.
            if nargin<4, level='L4'; end
            validatestring(level,{'L1','L4','L5'});
            if nargin<5, storeResult=ismember(level,{'L4','L5'}); end
            try
                e=db_get_engine(obj.Database,engineID);
            catch exception
                if storeResult, db_log_failure(obj.Database,engineID,f,level,exception); end
                rethrow(exception);
            end
            if strcmp(level,'L5')
                [r,available,message]=ml_predict(e,f);
                if ~available
                    r=simulate_engine(e,f); r.Warnings(end+1)=string(message);
                    if r.Valid, r.Status='WARNING'; end
                end
            else
                r=simulate_engine(e,f);
            end
            if storeResult, db_store_results(obj.Database,{r},level); end
        end
        function t=sweep(obj,engineID,altitudes,mach,throttle,storeResult)
            % L2 sweep accepts geopotential altitude vector [m]. Invalid points stay flagged.
            if nargin<6, storeResult=false; end
            e=db_get_engine(obj.Database,engineID);
            t=evaluate_grid(e,altitudes,mach,throttle,obj.Database,storeResult,'L2');
        end
        function t=map(obj,engineID,storeResult)
            % L3 map uses the exact architecture grid; L4 persistence is optional.
            if nargin<3, storeResult=false; end
            e=db_get_engine(obj.Database,engineID); grid=performance_grid(e);
            t=evaluate_grid(e,grid.Altitude_m,grid.Mach,grid.Throttle,obj.Database,storeResult,'L3');
        end
        function delete(obj)
            % Release the coordinator's connection without closing other objects' DBs.
            if ~isempty(obj.Database), delete(obj.Database); obj.Database=[]; end
        end
    end
end
