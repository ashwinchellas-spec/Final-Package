PRAGMA foreign_keys = ON;

-- @statement
PRAGMA user_version = 2;

-- @statement
CREATE TABLE IF NOT EXISTS Manufacturers (Manufacturer_ID INTEGER PRIMARY KEY, Name TEXT NOT NULL UNIQUE, Country TEXT NOT NULL, Website TEXT, Notes TEXT);

-- @statement
CREATE TABLE IF NOT EXISTS Engine_Types (Type_ID INTEGER PRIMARY KEY, Type_Name TEXT NOT NULL UNIQUE, Phase INTEGER NOT NULL DEFAULT 1, Description TEXT);

-- @statement
CREATE TABLE IF NOT EXISTS Engines (Engine_ID INTEGER PRIMARY KEY, Designation TEXT NOT NULL UNIQUE, Manufacturer_ID INTEGER NOT NULL REFERENCES Manufacturers ON DELETE RESTRICT, Type_ID INTEGER NOT NULL REFERENCES Engine_Types ON DELETE RESTRICT, First_Run_Year INTEGER, Status TEXT NOT NULL DEFAULT 'Academic catalogue', Afterburner INTEGER NOT NULL DEFAULT 0 CHECK(Afterburner IN (0,1)), Notes TEXT);

-- @statement
CREATE TABLE IF NOT EXISTS Engine_Thermo_Params (Param_ID INTEGER PRIMARY KEY, Engine_ID INTEGER NOT NULL UNIQUE REFERENCES Engines ON DELETE RESTRICT,
  OPR REAL CHECK(OPR IS NULL OR (OPR>1 AND OPR<=50)),
  Fan_PR REAL CHECK(Fan_PR IS NULL OR (Fan_PR>1 AND Fan_PR<=5)),
  BPR REAL CHECK(BPR IS NULL OR (BPR>=0 AND BPR<=15)),
  T_t4_K REAL CHECK(T_t4_K IS NULL OR T_t4_K BETWEEN 400 AND 2500),
  MassFlow_kgs REAL CHECK(MassFlow_kgs IS NULL OR MassFlow_kgs>0),
  Eta_compressor REAL CHECK(Eta_compressor IS NULL OR (Eta_compressor>0 AND Eta_compressor<=1)),
  Eta_fan REAL CHECK(Eta_fan IS NULL OR (Eta_fan>0 AND Eta_fan<=1)),
  Eta_combustor REAL CHECK(Eta_combustor IS NULL OR (Eta_combustor>0 AND Eta_combustor<=1)),
  Eta_turbine REAL CHECK(Eta_turbine IS NULL OR (Eta_turbine>0 AND Eta_turbine<=1)),
  Eta_nozzle_core REAL CHECK(Eta_nozzle_core IS NULL OR (Eta_nozzle_core>0 AND Eta_nozzle_core<=1)),
  Eta_nozzle_bypass REAL CHECK(Eta_nozzle_bypass IS NULL OR (Eta_nozzle_bypass>0 AND Eta_nozzle_bypass<=1)),
  Eta_mechanical REAL CHECK(Eta_mechanical IS NULL OR (Eta_mechanical>0 AND Eta_mechanical<=1)),
  Eta_gearbox REAL CHECK(Eta_gearbox IS NULL OR (Eta_gearbox>0 AND Eta_gearbox<=1)),
  Eta_propeller REAL CHECK(Eta_propeller IS NULL OR (Eta_propeller>0 AND Eta_propeller<=1)),
  Eta_power_turbine REAL CHECK(Eta_power_turbine IS NULL OR (Eta_power_turbine>0 AND Eta_power_turbine<=1)),
  Volumetric_Efficiency REAL CHECK(Volumetric_Efficiency IS NULL OR (Volumetric_Efficiency>0 AND Volumetric_Efficiency<=1)),
  Brake_Thermal_Efficiency REAL CHECK(Brake_Thermal_Efficiency IS NULL OR (Brake_Thermal_Efficiency>0 AND Brake_Thermal_Efficiency<=1)),
  Prop_Diameter_m REAL CHECK(Prop_Diameter_m IS NULL OR Prop_Diameter_m>0),
  Rated_Thrust_N REAL CHECK(Rated_Thrust_N IS NULL OR Rated_Thrust_N>0),
  Rated_Power_kW REAL CHECK(Rated_Power_kW IS NULL OR Rated_Power_kW>0),
  DryWeight_kg REAL CHECK(DryWeight_kg IS NULL OR DryWeight_kg>0),
  Displacement_m3 REAL CHECK(Displacement_m3 IS NULL OR Displacement_m3>0),
  Compression_Ratio REAL CHECK(Compression_Ratio IS NULL OR Compression_Ratio>0),
  Rated_RPM REAL CHECK(Rated_RPM IS NULL OR Rated_RPM>0),
  Fuel_LHV_Jkg REAL CHECK(Fuel_LHV_Jkg IS NULL OR Fuel_LHV_Jkg>0),
  AFR REAL CHECK(AFR IS NULL OR AFR>0),
  Prop_RPM REAL CHECK(Prop_RPM IS NULL OR Prop_RPM>0),
  MaxAltitude_m REAL CHECK(MaxAltitude_m IS NULL OR MaxAltitude_m>0),
  MaxMach REAL CHECK(MaxMach IS NULL OR MaxMach>0),
  PowerTurbine_BackPressure_Ratio REAL CHECK(PowerTurbine_BackPressure_Ratio IS NULL OR PowerTurbine_BackPressure_Ratio>0),
  Burner_PR_loss REAL CHECK(Burner_PR_loss IS NULL OR Burner_PR_loss BETWEEN 0 AND 0.2),
  Inlet_PR_recovery REAL CHECK(Inlet_PR_recovery IS NULL OR (Inlet_PR_recovery>0 AND Inlet_PR_recovery<=1)),
  Strokes REAL CHECK(Strokes IS NULL OR Strokes IN (2,4)),
Overall_Confidence TEXT NOT NULL CHECK(Overall_Confidence IN ('High','Medium','Low')));

-- @statement
CREATE TABLE IF NOT EXISTS "References" (Ref_ID INTEGER PRIMARY KEY, Short_Tag TEXT NOT NULL UNIQUE, Authors TEXT, Title TEXT NOT NULL, Publisher TEXT, Year INTEGER, Source_Type TEXT NOT NULL, URL_DOI TEXT, Notes TEXT);

-- @statement
CREATE TABLE IF NOT EXISTS Parameter_Provenance (Provenance_ID INTEGER PRIMARY KEY, Engine_ID INTEGER NOT NULL REFERENCES Engines ON DELETE RESTRICT, Parameter_Name TEXT NOT NULL, Parameter_Value REAL, Unit TEXT NOT NULL, Source_Type TEXT NOT NULL CHECK(Source_Type IN ('Manufacturer_Confirmed','Type_Certificate','Academic_Literature','Calculated','Estimated','Assumed','Unavailable')), Confidence_Level TEXT NOT NULL CHECK(Confidence_Level IN ('High','Medium','Low')), Ref_ID INTEGER NOT NULL REFERENCES "References" ON DELETE RESTRICT, Source_Reference TEXT NOT NULL, Verified INTEGER NOT NULL DEFAULT 0 CHECK(Verified IN (0,1)), Notes TEXT, Date_Added TEXT NOT NULL DEFAULT '2026-09-15', UNIQUE(Engine_ID,Parameter_Name));

-- @statement
CREATE TABLE IF NOT EXISTS Aircraft (Aircraft_ID INTEGER PRIMARY KEY, Designation TEXT NOT NULL UNIQUE, Type TEXT, Country TEXT, IAF_Service INTEGER DEFAULT 0 CHECK(IAF_Service IN (0,1)));

-- @statement
CREATE TABLE IF NOT EXISTS Engine_Aircraft_Map (Map_ID INTEGER PRIMARY KEY, Engine_ID INTEGER NOT NULL REFERENCES Engines ON DELETE RESTRICT, Aircraft_ID INTEGER NOT NULL REFERENCES Aircraft ON DELETE RESTRICT, Notes TEXT, UNIQUE(Engine_ID,Aircraft_ID));

-- @statement
CREATE TABLE IF NOT EXISTS Performance_Data (Data_ID INTEGER PRIMARY KEY, Engine_ID INTEGER NOT NULL REFERENCES Engines ON DELETE RESTRICT, Data_Type TEXT NOT NULL CHECK(Data_Type IN ('Reference','Simulated','ML_Predicted','Simulated_Estimated')), Altitude_m REAL NOT NULL CHECK(Altitude_m BETWEEN 0 AND 32200), GeopotentialAltitude_m REAL NOT NULL CHECK(GeopotentialAltitude_m BETWEEN 0 AND 32000), Mach REAL NOT NULL CHECK(Mach BETWEEN 0 AND 3), Throttle REAL NOT NULL CHECK(Throttle BETWEEN 0 AND 1), Afterburner INTEGER NOT NULL DEFAULT 0 CHECK(Afterburner IN (0,1)), Thrust_N REAL CHECK(Thrust_N IS NULL OR Thrust_N>=0), EquivalentThrust_N REAL CHECK(EquivalentThrust_N IS NULL OR EquivalentThrust_N>=0), ShaftPower_kW REAL CHECK(ShaftPower_kW IS NULL OR ShaftPower_kW>=0), FuelFlow_kgs REAL CHECK(FuelFlow_kgs IS NULL OR FuelFlow_kgs>=0), TSFC_kgNs REAL CHECK(TSFC_kgNs IS NULL OR TSFC_kgNs>=0), BSFC_kgkWh REAL CHECK(BSFC_kgkWh IS NULL OR BSFC_kgkWh>=0), Eta_thermal REAL CHECK(Eta_thermal IS NULL OR Eta_thermal BETWEEN 0 AND 1), Eta_propulsive REAL CHECK(Eta_propulsive IS NULL OR Eta_propulsive BETWEEN 0 AND 1), T_t4_K REAL, P_t3_Pa REAL, ESHP REAL, Source_Ref TEXT, Reference_Kind TEXT NOT NULL DEFAULT 'NotApplicable' CHECK(Reference_Kind IN('NotApplicable','UnverifiedSecondary','Measured','PublishedRating','EstimatedTarget')), Reference_Verified INTEGER NOT NULL DEFAULT 0 CHECK(Reference_Verified IN(0,1)), Confidence TEXT NOT NULL DEFAULT 'Low', Prediction_Source TEXT NOT NULL CHECK(Prediction_Source IN('Reference','Physics','ML')), Valid INTEGER NOT NULL DEFAULT 1 CHECK(Valid IN(0,1)), Warnings TEXT, Core_Nozzle_State TEXT, Bypass_Nozzle_State TEXT, Model_Version TEXT, Model_Fingerprint TEXT, ML_Model_Type TEXT, Timestamp_UTC TEXT NOT NULL DEFAULT (datetime('now')), CHECK(Data_Type!='Reference' OR Source_Ref IS NOT NULL), CHECK(Data_Type='Reference' OR FuelFlow_kgs IS NOT NULL));

-- @statement
CREATE TABLE IF NOT EXISTS Mission_Profiles (Mission_ID INTEGER PRIMARY KEY, Mission_Name TEXT NOT NULL UNIQUE, Category TEXT NOT NULL, Architectures TEXT NOT NULL, Altitude_m REAL NOT NULL CHECK(Altitude_m BETWEEN 0 AND 32000), Altitude_Convention TEXT NOT NULL DEFAULT 'geopotential', Mach REAL NOT NULL CHECK(Mach>=0), Min_Thrust_N REAL CHECK(Min_Thrust_N IS NULL OR Min_Thrust_N>=0), Max_TSFC_kgNs REAL CHECK(Max_TSFC_kgNs IS NULL OR Max_TSFC_kgNs>=0), Min_Power_kW REAL, Max_BSFC_kgkWh REAL CHECK(Max_BSFC_kgkWh IS NULL OR Max_BSFC_kgkWh>=0), Max_DryWeight_kg REAL, Ceiling_m REAL NOT NULL CHECK(Ceiling_m BETWEEN 0 AND 32000), W_Thrust REAL NOT NULL CHECK(W_Thrust BETWEEN 0 AND 1), W_Efficiency REAL NOT NULL CHECK(W_Efficiency BETWEEN 0 AND 1), W_Fuel REAL NOT NULL CHECK(W_Fuel BETWEEN 0 AND 1), W_Altitude REAL NOT NULL CHECK(W_Altitude BETWEEN 0 AND 1), W_TWR REAL NOT NULL CHECK(W_TWR BETWEEN 0 AND 1), Notes TEXT, CHECK(ABS(W_Thrust+W_Efficiency+W_Fuel+W_Altitude+W_TWR-1)<0.000001));

-- @statement
CREATE TABLE IF NOT EXISTS Simulation_Log (Log_ID INTEGER PRIMARY KEY, Engine_ID INTEGER REFERENCES Engines ON DELETE RESTRICT, DT_Level TEXT NOT NULL CHECK(DT_Level IN('L1','L2','L3','L4','L5')), Model_Type TEXT NOT NULL CHECK(Model_Type IN('Physics','ML')), ML_Model_Name TEXT, Altitude_m REAL, Mach REAL, Throttle REAL, Inputs_JSON TEXT NOT NULL, Outputs_JSON TEXT NOT NULL, Exec_Time_ms REAL, Model_Version TEXT NOT NULL, Model_Fingerprint TEXT, Event_Type TEXT NOT NULL DEFAULT 'Simulation', Timestamp_UTC TEXT NOT NULL DEFAULT(datetime('now')));

-- @statement
CREATE TABLE IF NOT EXISTS Project_Metadata (Key TEXT PRIMARY KEY, Value TEXT NOT NULL);

-- @statement
CREATE INDEX IF NOT EXISTS ix_performance_engine_condition ON Performance_Data(Engine_ID,Data_Type,Altitude_m,Mach,Throttle);

-- @statement
CREATE INDEX IF NOT EXISTS ix_log_engine_time ON Simulation_Log(Engine_ID,Timestamp_UTC);

-- @statement
CREATE INDEX IF NOT EXISTS ix_provenance_engine ON Parameter_Provenance(Engine_ID,Parameter_Name);

-- @statement
CREATE VIEW IF NOT EXISTS v_Engine_Catalogue AS SELECT e.Engine_ID,e.Designation,t.Type_Name,m.Name AS Manufacturer,p.Overall_Confidence,p.Rated_Thrust_N,p.Rated_Power_kW,p.DryWeight_kg,p.MaxAltitude_m,p.MaxMach FROM Engines e JOIN Engine_Types t USING(Type_ID) JOIN Manufacturers m USING(Manufacturer_ID) JOIN Engine_Thermo_Params p USING(Engine_ID);

-- @statement
CREATE VIEW IF NOT EXISTS v_Reference_Data AS SELECT * FROM Performance_Data WHERE Data_Type='Reference';

-- @statement
CREATE VIEW IF NOT EXISTS v_Provenance AS SELECT p.*,r.Title,r.URL_DOI FROM Parameter_Provenance p JOIN "References" r USING(Ref_ID);

-- @statement
CREATE TRIGGER IF NOT EXISTS protect_Simulation_Log_UPDATE BEFORE UPDATE ON Simulation_Log WHEN 1 BEGIN SELECT RAISE(ABORT,'Immutable audit/reference record'); END;

-- @statement
CREATE TRIGGER IF NOT EXISTS protect_Simulation_Log_DELETE BEFORE DELETE ON Simulation_Log WHEN 1 BEGIN SELECT RAISE(ABORT,'Immutable audit/reference record'); END;

-- @statement
CREATE TRIGGER IF NOT EXISTS protect_Performance_Data_UPDATE BEFORE UPDATE ON Performance_Data WHEN OLD.Data_Type='Reference' BEGIN SELECT RAISE(ABORT,'Immutable audit/reference record'); END;

-- @statement
CREATE TRIGGER IF NOT EXISTS protect_Performance_Data_DELETE BEFORE DELETE ON Performance_Data WHEN OLD.Data_Type='Reference' BEGIN SELECT RAISE(ABORT,'Immutable audit/reference record'); END;
