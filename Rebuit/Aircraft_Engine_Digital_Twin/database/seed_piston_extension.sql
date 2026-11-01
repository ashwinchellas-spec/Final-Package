INSERT OR IGNORE INTO "Manufacturers" (Manufacturer_ID,Name,Country,Notes) VALUES (9,'Lycoming','USA','Optional piston academic extension');

-- @statement
INSERT OR IGNORE INTO "Engines" (Engine_ID,Designation,Manufacturer_ID,Type_ID,Afterburner,Notes) VALUES (12,'Lycoming O-360-A1A',9,5,0,'OPTIONAL / ASSUMED CLASS PARAMETERS. Not a validated manufacturer-specific piston model.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" (Engine_ID,Displacement_m3,Compression_Ratio,Rated_RPM,Strokes,Volumetric_Efficiency,Brake_Thermal_Efficiency,Fuel_LHV_Jkg,AFR,Eta_propeller,Prop_Diameter_m,DryWeight_kg,MaxAltitude_m,MaxMach,Overall_Confidence) VALUES (12,0.0059,8.5,2700,4,0.85,0.28,43500000,14.7,0.8,1.9,117,5000,0.4,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'Displacement_m3',0.0059,'m^3','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'Compression_Ratio',8.5,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'Rated_RPM',2700,'rev/min','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'Strokes',4,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'Volumetric_Efficiency',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'Brake_Thermal_Efficiency',0.28,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'Fuel_LHV_Jkg',43500000,'J/kg','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'AFR',14.7,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'Eta_propeller',0.8,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'Prop_Diameter_m',1.9,'m','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'DryWeight_kg',117,'kg','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'MaxAltitude_m',5000,'m','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (12,'MaxMach',0.4,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Manufacturers" (Manufacturer_ID,Name,Country,Notes) VALUES (10,'Continental','USA','Optional piston academic extension');

-- @statement
INSERT OR IGNORE INTO "Engines" (Engine_ID,Designation,Manufacturer_ID,Type_ID,Afterburner,Notes) VALUES (13,'Continental IO-550-B',10,5,0,'OPTIONAL / ASSUMED CLASS PARAMETERS. Not a validated manufacturer-specific piston model.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" (Engine_ID,Displacement_m3,Compression_Ratio,Rated_RPM,Strokes,Volumetric_Efficiency,Brake_Thermal_Efficiency,Fuel_LHV_Jkg,AFR,Eta_propeller,Prop_Diameter_m,DryWeight_kg,MaxAltitude_m,MaxMach,Overall_Confidence) VALUES (13,0.009,8.5,2700,4,0.85,0.3,43500000,14.7,0.8,2,200,5000,0.4,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'Displacement_m3',0.009,'m^3','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'Compression_Ratio',8.5,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'Rated_RPM',2700,'rev/min','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'Strokes',4,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'Volumetric_Efficiency',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'Brake_Thermal_Efficiency',0.3,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'Fuel_LHV_Jkg',43500000,'J/kg','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'AFR',14.7,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'Eta_propeller',0.8,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'Prop_Diameter_m',2,'m','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'DryWeight_kg',200,'kg','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'MaxAltitude_m',5000,'m','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" (Engine_ID,Parameter_Name,Parameter_Value,Unit,Source_Type,Confidence_Level,Ref_ID,Source_Reference,Verified,Notes) VALUES (13,'MaxMach',0.4,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md optional piston extension',0,'Explicit assumed class value; not a verified engine variant specification.');
