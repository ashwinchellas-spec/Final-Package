INSERT OR IGNORE INTO "Project_Metadata" ("Key","Value") VALUES ('Schema_Version','2');

-- @statement
INSERT OR IGNORE INTO "Project_Metadata" ("Key","Value") VALUES ('Model_Version','ABACUS-1.1-rebuild-1.1');

-- @statement
INSERT OR IGNORE INTO "Project_Metadata" ("Key","Value") VALUES ('Reference_Status','Blueprint values are unverified secondary inputs, not manufacturer measurements.');

-- @statement
INSERT OR IGNORE INTO "Manufacturers" ("Manufacturer_ID","Name","Country","Notes") VALUES (1,'General Electric Aviation','USA','Catalogue identity only; no claim of current corporate or certification status.');

-- @statement
INSERT OR IGNORE INTO "Manufacturers" ("Manufacturer_ID","Name","Country","Notes") VALUES (2,'Safran Aircraft Engines (SNECMA)','France','Catalogue identity only; no claim of current corporate or certification status.');

-- @statement
INSERT OR IGNORE INTO "Manufacturers" ("Manufacturer_ID","Name","Country","Notes") VALUES (3,'Pratt & Whitney','USA','Catalogue identity only; no claim of current corporate or certification status.');

-- @statement
INSERT OR IGNORE INTO "Manufacturers" ("Manufacturer_ID","Name","Country","Notes") VALUES (4,'Pratt & Whitney Canada','Canada','Catalogue identity only; no claim of current corporate or certification status.');

-- @statement
INSERT OR IGNORE INTO "Manufacturers" ("Manufacturer_ID","Name","Country","Notes") VALUES (5,'Rolls-Royce','UK','Catalogue identity only; no claim of current corporate or certification status.');

-- @statement
INSERT OR IGNORE INTO "Manufacturers" ("Manufacturer_ID","Name","Country","Notes") VALUES (6,'Tumansky / Soviet design family','Russia','Catalogue identity only; no claim of current corporate or certification status.');

-- @statement
INSERT OR IGNORE INTO "Manufacturers" ("Manufacturer_ID","Name","Country","Notes") VALUES (7,'GTRE / DRDO','India','Catalogue identity only; no claim of current corporate or certification status.');

-- @statement
INSERT OR IGNORE INTO "Manufacturers" ("Manufacturer_ID","Name","Country","Notes") VALUES (8,'CFM International','France / USA','Catalogue identity only; no claim of current corporate or certification status.');

-- @statement
INSERT OR IGNORE INTO "Engine_Types" ("Type_ID","Type_Name","Phase","Description") VALUES (1,'Turbojet',1,'Turbojet');

-- @statement
INSERT OR IGNORE INTO "Engine_Types" ("Type_ID","Type_Name","Phase","Description") VALUES (2,'Turbofan_HighBPR',1,'Turbofan_HighBPR');

-- @statement
INSERT OR IGNORE INTO "Engine_Types" ("Type_ID","Type_Name","Phase","Description") VALUES (3,'Turbofan_LowBPR',1,'Turbofan_LowBPR');

-- @statement
INSERT OR IGNORE INTO "Engine_Types" ("Type_ID","Type_Name","Phase","Description") VALUES (4,'Turboprop',1,'Turboprop');

-- @statement
INSERT OR IGNORE INTO "Engine_Types" ("Type_ID","Type_Name","Phase","Description") VALUES (5,'Piston',2,'Optional user-requested extension outside ABACUS 11-engine core');

-- @statement
INSERT OR IGNORE INTO "References" ("Ref_ID","Short_Tag","Authors","Title","Publisher","Year","Source_Type","URL_DOI","Notes") VALUES (1,'ABACUS_v1_1','User-supplied project specification','Project Definition and Architecture Document v1.1','Academic project blueprint',2026,'User_Specification',NULL,'77 pages. Original third-party citations were not independently verified; copied numerical values remain Estimated/Low.');

-- @statement
INSERT OR IGNORE INTO "References" ("Ref_ID","Short_Tag","Authors","Title","Publisher","Year","Source_Type","URL_DOI","Notes") VALUES (2,'Implementation_Assumptions','Project implementation','Explicit academic component and off-design assumptions','docs/ASSUMPTIONS.md',2026,'Engineering_Assumption',NULL,'Assumptions are not measured engine data and are not fitted to force reference agreement.');

-- @statement
INSERT OR IGNORE INTO "References" ("Ref_ID","Short_Tag","Authors","Title","Publisher","Year","Source_Type","URL_DOI","Notes") VALUES (3,'NASA_Isentropic','NASA Glenn Research Center','Isentropic Flow Equations','NASA',NULL,'Government_Report','https://www.grc.nasa.gov/www/k-12/airplane/isentrop.html','Supports ideal gas identities and choked-flow relations, not engine-specific ratings.');

-- @statement
INSERT OR IGNORE INTO "Engines" ("Engine_ID","Designation","Manufacturer_ID","Type_ID","Afterburner","Notes") VALUES (1,'J79-GE-17A',1,1,1,'Model parameters are academic estimates; read parameter-level provenance.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" ("Engine_ID","OPR","Fan_PR","BPR","T_t4_K","MassFlow_kgs","Rated_Thrust_N","Rated_Power_kW","DryWeight_kg","MaxAltitude_m","MaxMach","Eta_compressor","Eta_combustor","Eta_turbine","Eta_nozzle_core","Eta_mechanical","Burner_PR_loss","Inlet_PR_recovery","Overall_Confidence") VALUES (1,13.5,NULL,NULL,1250,77,52489,NULL,1749,18000,2,0.85,0.99,0.9,0.98,0.99,0.05,1,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'OPR',13.5,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'T_t4_K',1250,'K','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'MassFlow_kgs',77,'kg/s','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'Rated_Thrust_N',52489,'N','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'DryWeight_kg',1749,'kg','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'MaxAltitude_m',18000,'m','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'MaxMach',2,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'Eta_compressor',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'Eta_combustor',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'Eta_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'Eta_nozzle_core',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'Eta_mechanical',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'Burner_PR_loss',0.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (1,'Inlet_PR_recovery',1,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'Section 17 subsonic value 1.0 selected over schema default 0.97.');

-- @statement
INSERT OR IGNORE INTO "Engines" ("Engine_ID","Designation","Manufacturer_ID","Type_ID","Afterburner","Notes") VALUES (2,'SNECMA Atar 9C',2,1,1,'Model parameters are academic estimates; read parameter-level provenance.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" ("Engine_ID","OPR","Fan_PR","BPR","T_t4_K","MassFlow_kgs","Rated_Thrust_N","Rated_Power_kW","DryWeight_kg","MaxAltitude_m","MaxMach","Eta_compressor","Eta_combustor","Eta_turbine","Eta_nozzle_core","Eta_mechanical","Burner_PR_loss","Inlet_PR_recovery","Overall_Confidence") VALUES (2,5.8,NULL,NULL,1150,60,41800,NULL,1438,18000,2.2,0.85,0.99,0.9,0.98,0.99,0.05,1,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'OPR',5.8,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'T_t4_K',1150,'K','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'MassFlow_kgs',60,'kg/s','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'Rated_Thrust_N',41800,'N','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'DryWeight_kg',1438,'kg','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'MaxAltitude_m',18000,'m','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'MaxMach',2.2,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'Eta_compressor',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'Eta_combustor',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'Eta_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'Eta_nozzle_core',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'Eta_mechanical',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'Burner_PR_loss',0.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (2,'Inlet_PR_recovery',1,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'Section 17 subsonic value 1.0 selected over schema default 0.97.');

-- @statement
INSERT OR IGNORE INTO "Engines" ("Engine_ID","Designation","Manufacturer_ID","Type_ID","Afterburner","Notes") VALUES (3,'R-25-300',6,1,1,'Model parameters are academic estimates; read parameter-level provenance.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" ("Engine_ID","OPR","Fan_PR","BPR","T_t4_K","MassFlow_kgs","Rated_Thrust_N","Rated_Power_kW","DryWeight_kg","MaxAltitude_m","MaxMach","Eta_compressor","Eta_combustor","Eta_turbine","Eta_nozzle_core","Eta_mechanical","Burner_PR_loss","Inlet_PR_recovery","Overall_Confidence") VALUES (3,8.8,NULL,NULL,1350,72,40200,NULL,1218,20000,2.5,0.85,0.99,0.9,0.98,0.99,0.05,1,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'OPR',8.8,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'T_t4_K',1350,'K','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'MassFlow_kgs',72,'kg/s','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'Rated_Thrust_N',40200,'N','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'DryWeight_kg',1218,'kg','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'MaxAltitude_m',20000,'m','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'MaxMach',2.5,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'Eta_compressor',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'Eta_combustor',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'Eta_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'Eta_nozzle_core',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'Eta_mechanical',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'Burner_PR_loss',0.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (3,'Inlet_PR_recovery',1,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'Section 17 subsonic value 1.0 selected over schema default 0.97.');

-- @statement
INSERT OR IGNORE INTO "Engines" ("Engine_ID","Designation","Manufacturer_ID","Type_ID","Afterburner","Notes") VALUES (4,'CFM56-5B4',8,2,0,'Model parameters are academic estimates; read parameter-level provenance.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" ("Engine_ID","OPR","Fan_PR","BPR","T_t4_K","MassFlow_kgs","Rated_Thrust_N","Rated_Power_kW","DryWeight_kg","MaxAltitude_m","MaxMach","Eta_compressor","Eta_combustor","Eta_turbine","Eta_nozzle_core","Eta_mechanical","Burner_PR_loss","Inlet_PR_recovery","Eta_fan","Eta_nozzle_bypass","Overall_Confidence") VALUES (4,27,1.735,5.4,1600,388,120100,NULL,2381,13000,0.92,0.85,0.99,0.9,0.98,0.99,0.05,1,0.88,0.98,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'OPR',27,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'Fan_PR',1.735,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'BPR',5.4,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'T_t4_K',1600,'K','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'MassFlow_kgs',388,'kg/s','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'Rated_Thrust_N',120100,'N','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'DryWeight_kg',2381,'kg','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'MaxAltitude_m',13000,'m','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'MaxMach',0.92,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'Eta_compressor',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'Eta_combustor',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'Eta_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'Eta_nozzle_core',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'Eta_mechanical',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'Burner_PR_loss',0.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'Inlet_PR_recovery',1,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'Section 17 subsonic value 1.0 selected over schema default 0.97.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'Eta_fan',0.88,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (4,'Eta_nozzle_bypass',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Engines" ("Engine_ID","Designation","Manufacturer_ID","Type_ID","Afterburner","Notes") VALUES (5,'CF6-80C2B1F',1,2,0,'Model parameters are academic estimates; read parameter-level provenance.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" ("Engine_ID","OPR","Fan_PR","BPR","T_t4_K","MassFlow_kgs","Rated_Thrust_N","Rated_Power_kW","DryWeight_kg","MaxAltitude_m","MaxMach","Eta_compressor","Eta_combustor","Eta_turbine","Eta_nozzle_core","Eta_mechanical","Burner_PR_loss","Inlet_PR_recovery","Eta_fan","Eta_nozzle_bypass","Overall_Confidence") VALUES (5,31.5,1.65,5.15,1650,787,257300,NULL,4181,13000,0.9,0.85,0.99,0.9,0.98,0.99,0.05,1,0.88,0.98,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'OPR',31.5,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'Fan_PR',1.65,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'BPR',5.15,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'T_t4_K',1650,'K','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'MassFlow_kgs',787,'kg/s','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'Rated_Thrust_N',257300,'N','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'DryWeight_kg',4181,'kg','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'MaxAltitude_m',13000,'m','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'MaxMach',0.9,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'Eta_compressor',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'Eta_combustor',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'Eta_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'Eta_nozzle_core',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'Eta_mechanical',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'Burner_PR_loss',0.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'Inlet_PR_recovery',1,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'Section 17 subsonic value 1.0 selected over schema default 0.97.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'Eta_fan',0.88,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (5,'Eta_nozzle_bypass',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Engines" ("Engine_ID","Designation","Manufacturer_ID","Type_ID","Afterburner","Notes") VALUES (6,'F100-PW-229',3,3,1,'Model parameters are academic estimates; read parameter-level provenance.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" ("Engine_ID","OPR","Fan_PR","BPR","T_t4_K","MassFlow_kgs","Rated_Thrust_N","Rated_Power_kW","DryWeight_kg","MaxAltitude_m","MaxMach","Eta_compressor","Eta_combustor","Eta_turbine","Eta_nozzle_core","Eta_mechanical","Burner_PR_loss","Inlet_PR_recovery","Eta_fan","Eta_nozzle_bypass","Overall_Confidence") VALUES (6,32,3,0.36,1750,112,79400,NULL,1696,15000,1.8,0.85,0.99,0.9,0.98,0.99,0.05,1,0.88,0.98,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'OPR',32,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'Fan_PR',3,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'BPR',0.36,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'T_t4_K',1750,'K','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'MassFlow_kgs',112,'kg/s','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'Rated_Thrust_N',79400,'N','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'DryWeight_kg',1696,'kg','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'MaxAltitude_m',15000,'m','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'MaxMach',1.8,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'Eta_compressor',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'Eta_combustor',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'Eta_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'Eta_nozzle_core',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'Eta_mechanical',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'Burner_PR_loss',0.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'Inlet_PR_recovery',1,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'Section 17 subsonic value 1.0 selected over schema default 0.97.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'Eta_fan',0.88,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (6,'Eta_nozzle_bypass',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Engines" ("Engine_ID","Designation","Manufacturer_ID","Type_ID","Afterburner","Notes") VALUES (7,'SNECMA M88-2',2,3,1,'Model parameters are academic estimates; read parameter-level provenance.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" ("Engine_ID","OPR","Fan_PR","BPR","T_t4_K","MassFlow_kgs","Rated_Thrust_N","Rated_Power_kW","DryWeight_kg","MaxAltitude_m","MaxMach","Eta_compressor","Eta_combustor","Eta_turbine","Eta_nozzle_core","Eta_mechanical","Burner_PR_loss","Inlet_PR_recovery","Eta_fan","Eta_nozzle_bypass","Overall_Confidence") VALUES (7,24.5,3.2,0.3,1800,65,50040,NULL,897,17000,1.8,0.85,0.99,0.9,0.98,0.99,0.05,1,0.88,0.98,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'OPR',24.5,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'Fan_PR',3.2,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'BPR',0.3,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'T_t4_K',1800,'K','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'MassFlow_kgs',65,'kg/s','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'Rated_Thrust_N',50040,'N','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'DryWeight_kg',897,'kg','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'MaxAltitude_m',17000,'m','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'MaxMach',1.8,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'Eta_compressor',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'Eta_combustor',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'Eta_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'Eta_nozzle_core',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'Eta_mechanical',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'Burner_PR_loss',0.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'Inlet_PR_recovery',1,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'Section 17 subsonic value 1.0 selected over schema default 0.97.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'Eta_fan',0.88,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (7,'Eta_nozzle_bypass',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Engines" ("Engine_ID","Designation","Manufacturer_ID","Type_ID","Afterburner","Notes") VALUES (8,'GTX-35VS Kaveri',7,3,1,'ESTIMATED / ACADEMIC MODEL - NOT MANUFACTURER-CONFIRMED PERFORMANCE.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" ("Engine_ID","OPR","Fan_PR","BPR","T_t4_K","MassFlow_kgs","Rated_Thrust_N","Rated_Power_kW","DryWeight_kg","MaxAltitude_m","MaxMach","Eta_compressor","Eta_combustor","Eta_turbine","Eta_nozzle_core","Eta_mechanical","Burner_PR_loss","Inlet_PR_recovery","Eta_fan","Eta_nozzle_bypass","Overall_Confidence") VALUES (8,21,3.5,0.16,1650,78,53400,NULL,1008,15000,1.8,0.85,0.99,0.9,0.98,0.99,0.05,1,0.88,0.98,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'OPR',21,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'Fan_PR',3.5,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'BPR',0.16,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'T_t4_K',1650,'K','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'MassFlow_kgs',78,'kg/s','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'Rated_Thrust_N',53400,'N','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'53.4 kN academic dry estimate from Table 23.1; 81 kN AB target is excluded.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'DryWeight_kg',1008,'kg','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'MaxAltitude_m',15000,'m','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'MaxMach',1.8,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'Eta_compressor',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'Eta_combustor',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'Eta_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'Eta_nozzle_core',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'Eta_mechanical',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'Burner_PR_loss',0.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'Inlet_PR_recovery',1,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'Section 17 subsonic value 1.0 selected over schema default 0.97.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'Eta_fan',0.88,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (8,'Eta_nozzle_bypass',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Engines" ("Engine_ID","Designation","Manufacturer_ID","Type_ID","Afterburner","Notes") VALUES (9,'PT6A-67D',4,4,0,'Model parameters are academic estimates; read parameter-level provenance.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" ("Engine_ID","OPR","Fan_PR","BPR","T_t4_K","MassFlow_kgs","Rated_Thrust_N","Rated_Power_kW","DryWeight_kg","MaxAltitude_m","MaxMach","Eta_compressor","Eta_combustor","Eta_turbine","Eta_nozzle_core","Eta_mechanical","Burner_PR_loss","Inlet_PR_recovery","Eta_gearbox","Eta_propeller","Eta_power_turbine","Prop_Diameter_m","Prop_RPM","PowerTurbine_BackPressure_Ratio","Overall_Confidence") VALUES (9,9.5,NULL,NULL,1200,5.5,NULL,1119,213,9000,0.55,0.85,0.99,0.9,0.98,0.99,0.05,1,0.98,0.8,0.9,2.67,1700,1.05,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'OPR',9.5,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'T_t4_K',1200,'K','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'MassFlow_kgs',5.5,'kg/s','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Rated_Power_kW',1119,'kW','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'Table 23.1 chosen over conflicting Table 9.4 (895 kW). NOT verified.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'DryWeight_kg',213,'kg','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'MaxAltitude_m',9000,'m','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'MaxMach',0.55,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Eta_compressor',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Eta_combustor',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Eta_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Eta_nozzle_core',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Eta_mechanical',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Burner_PR_loss',0.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Inlet_PR_recovery',1,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'Section 17 subsonic value 1.0 selected over schema default 0.97.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Eta_gearbox',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Eta_propeller',0.8,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Eta_power_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Prop_Diameter_m',2.67,'m','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'Prop_RPM',1700,'rev/min','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (9,'PowerTurbine_BackPressure_Ratio',1.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Engines" ("Engine_ID","Designation","Manufacturer_ID","Type_ID","Afterburner","Notes") VALUES (10,'PW127G',4,4,0,'Model parameters are academic estimates; read parameter-level provenance.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" ("Engine_ID","OPR","Fan_PR","BPR","T_t4_K","MassFlow_kgs","Rated_Thrust_N","Rated_Power_kW","DryWeight_kg","MaxAltitude_m","MaxMach","Eta_compressor","Eta_combustor","Eta_turbine","Eta_nozzle_core","Eta_mechanical","Burner_PR_loss","Inlet_PR_recovery","Eta_gearbox","Eta_propeller","Eta_power_turbine","Prop_Diameter_m","Prop_RPM","PowerTurbine_BackPressure_Ratio","Overall_Confidence") VALUES (10,16,NULL,NULL,1300,16,NULL,2051,481,9000,0.65,0.85,0.99,0.9,0.98,0.99,0.05,1,0.98,0.8,0.9,3.93,1200,1.05,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'OPR',16,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'T_t4_K',1300,'K','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'MassFlow_kgs',16,'kg/s','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Rated_Power_kW',2051,'kW','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'DryWeight_kg',481,'kg','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'MaxAltitude_m',9000,'m','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'MaxMach',0.65,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Eta_compressor',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Eta_combustor',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Eta_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Eta_nozzle_core',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Eta_mechanical',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Burner_PR_loss',0.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Inlet_PR_recovery',1,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'Section 17 subsonic value 1.0 selected over schema default 0.97.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Eta_gearbox',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Eta_propeller',0.8,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Eta_power_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Prop_Diameter_m',3.93,'m','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'Prop_RPM',1200,'rev/min','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (10,'PowerTurbine_BackPressure_Ratio',1.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Engines" ("Engine_ID","Designation","Manufacturer_ID","Type_ID","Afterburner","Notes") VALUES (11,'AE 2100D3',5,4,0,'Model parameters are academic estimates; read parameter-level provenance.');

-- @statement
INSERT OR IGNORE INTO "Engine_Thermo_Params" ("Engine_ID","OPR","Fan_PR","BPR","T_t4_K","MassFlow_kgs","Rated_Thrust_N","Rated_Power_kW","DryWeight_kg","MaxAltitude_m","MaxMach","Eta_compressor","Eta_combustor","Eta_turbine","Eta_nozzle_core","Eta_mechanical","Burner_PR_loss","Inlet_PR_recovery","Eta_gearbox","Eta_propeller","Eta_power_turbine","Prop_Diameter_m","Prop_RPM","PowerTurbine_BackPressure_Ratio","Overall_Confidence") VALUES (11,16.6,NULL,NULL,1350,26,NULL,3458,745,9000,0.7,0.85,0.99,0.9,0.98,0.99,0.05,1,0.98,0.8,0.9,4.11,1020,1.05,'Low');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'OPR',16.6,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'T_t4_K',1350,'K','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'MassFlow_kgs',26,'kg/s','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Rated_Power_kW',3458,'kW','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'DryWeight_kg',745,'kg','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'MaxAltitude_m',9000,'m','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'MaxMach',0.7,'1','Estimated','Low',1,'ABACUS v1.1 sections 9, 18.6, 23.2; original citation not verified',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Eta_compressor',0.85,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Eta_combustor',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Eta_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Eta_nozzle_core',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Eta_mechanical',0.99,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Burner_PR_loss',0.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Inlet_PR_recovery',1,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'Section 17 subsonic value 1.0 selected over schema default 0.97.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Eta_gearbox',0.98,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Eta_propeller',0.8,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Eta_power_turbine',0.9,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Prop_Diameter_m',4.11,'m','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'Prop_RPM',1020,'rev/min','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Parameter_Provenance" ("Engine_ID","Parameter_Name","Parameter_Value","Unit","Source_Type","Confidence_Level","Ref_ID","Source_Reference","Verified","Notes") VALUES (11,'PowerTurbine_BackPressure_Ratio',1.05,'1','Assumed','Low',2,'docs/ASSUMPTIONS.md; declared component/class assumption',0,'No measured-performance claim. Confidence deliberately lowered from unverified blueprint source labels.');

-- @statement
INSERT OR IGNORE INTO "Mission_Profiles" ("Mission_ID","Mission_Name","Category","Architectures","Mach","Altitude_m","Ceiling_m","Min_Thrust_N","W_Thrust","W_Efficiency","W_Fuel","W_Altitude","W_TWR","Notes") VALUES (1,'Subsonic Commercial Transport','Commercial','Turbofan_HighBPR',0.82,11000,11000,60000,0.15,0.3,0.35,0.1,0.1,'ABACUS Table 21.2, not an aircraft flight-planning requirement. Empty feasible set is an acceptable outcome.');

-- @statement
INSERT OR IGNORE INTO "Mission_Profiles" ("Mission_ID","Mission_Name","Category","Architectures","Mach","Altitude_m","Ceiling_m","Min_Thrust_N","W_Thrust","W_Efficiency","W_Fuel","W_Altitude","W_TWR","Notes") VALUES (2,'Air Superiority Fighter','Fighter','Turbojet,Turbofan_LowBPR',1.2,12000,12000,70000,0.4,0.05,0.1,0.2,0.25,'ABACUS Table 21.2, not an aircraft flight-planning requirement. Empty feasible set is an acceptable outcome.');

-- @statement
INSERT OR IGNORE INTO "Mission_Profiles" ("Mission_ID","Mission_Name","Category","Architectures","Mach","Altitude_m","Ceiling_m","Min_Thrust_N","W_Thrust","W_Efficiency","W_Fuel","W_Altitude","W_TWR","Notes") VALUES (3,'Ground Attack / CAS','Strike','Turbojet,Turbofan_LowBPR',0.85,5000,5000,50000,0.35,0.05,0.15,0.15,0.3,'ABACUS Table 21.2, not an aircraft flight-planning requirement. Empty feasible set is an acceptable outcome.');

-- @statement
INSERT OR IGNORE INTO "Mission_Profiles" ("Mission_ID","Mission_Name","Category","Architectures","Mach","Altitude_m","Ceiling_m","Min_Thrust_N","W_Thrust","W_Efficiency","W_Fuel","W_Altitude","W_TWR","Notes") VALUES (4,'Maritime Patrol / ISR','Transport','Turboprop',0.45,3000,3000,15000,0.1,0.2,0.4,0.1,0.2,'ABACUS Table 21.2, not an aircraft flight-planning requirement. Empty feasible set is an acceptable outcome.');

-- @statement
INSERT OR IGNORE INTO "Mission_Profiles" ("Mission_ID","Mission_Name","Category","Architectures","Mach","Altitude_m","Ceiling_m","Min_Thrust_N","W_Thrust","W_Efficiency","W_Fuel","W_Altitude","W_TWR","Notes") VALUES (5,'STOL Transport','Transport','Turboprop',0.35,2000,2000,20000,0.25,0.15,0.25,0.1,0.25,'ABACUS Table 21.2, not an aircraft flight-planning requirement. Empty feasible set is an acceptable outcome.');

-- @statement
INSERT OR IGNORE INTO "Mission_Profiles" ("Mission_ID","Mission_Name","Category","Architectures","Mach","Altitude_m","Ceiling_m","Min_Thrust_N","W_Thrust","W_Efficiency","W_Fuel","W_Altitude","W_TWR","Notes") VALUES (6,'High-Altitude Reconnaissance','Reconnaissance','Turbojet,Turbofan_LowBPR',0.8,20000,20000,20000,0.15,0.2,0.25,0.35,0.05,'ABACUS Table 21.2, not an aircraft flight-planning requirement. Empty feasible set is an acceptable outcome.');

-- @statement
INSERT OR IGNORE INTO "Mission_Profiles" ("Mission_ID","Mission_Name","Category","Architectures","Mach","Altitude_m","Ceiling_m","Min_Thrust_N","W_Thrust","W_Efficiency","W_Fuel","W_Altitude","W_TWR","Notes") VALUES (7,'Academic Trainer','Trainer','Turboprop',0.25,1500,1500,5000,0.15,0.25,0.3,0.1,0.2,'User-requested Trainer preset; all constraints and weights are assumed educational choices.');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","ShaftPower_kW","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (1,1,'Reference',0,0,0,1,52800,NULL,NULL,'ABACUS Table 23.1; unverified secondary value; NOT manufacturer-confirmed','UnverifiedSecondary',0,'Low','Reference','Reference source or conflicting rating needs independent verification. TSFC units quarantined.','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","ShaftPower_kW","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (2,2,'Reference',0,0,0,1,42200,NULL,NULL,'ABACUS Table 23.1; unverified secondary value; NOT manufacturer-confirmed','UnverifiedSecondary',0,'Low','Reference','Reference source or conflicting rating needs independent verification. TSFC units quarantined.','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","ShaftPower_kW","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (3,3,'Reference',0,0,0,1,40200,NULL,NULL,'ABACUS Table 23.1; unverified secondary value; NOT manufacturer-confirmed','UnverifiedSecondary',0,'Low','Reference','Reference source or conflicting rating needs independent verification. TSFC units quarantined.','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","ShaftPower_kW","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (4,4,'Reference',0,0,0,1,120000,NULL,NULL,'ABACUS Table 23.1; unverified secondary value; NOT manufacturer-confirmed','UnverifiedSecondary',0,'Low','Reference','Reference source or conflicting rating needs independent verification. TSFC units quarantined.','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","ShaftPower_kW","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (5,5,'Reference',0,0,0,1,258000,NULL,NULL,'ABACUS Table 23.1; unverified secondary value; NOT manufacturer-confirmed','UnverifiedSecondary',0,'Low','Reference','Reference source or conflicting rating needs independent verification. TSFC units quarantined.','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","ShaftPower_kW","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (6,6,'Reference',0,0,0,1,79200,NULL,NULL,'ABACUS Table 23.1; unverified secondary value; NOT manufacturer-confirmed','UnverifiedSecondary',0,'Low','Reference','Reference source or conflicting rating needs independent verification. TSFC units quarantined.','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","ShaftPower_kW","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (7,7,'Reference',0,0,0,1,50100,NULL,NULL,'ABACUS Table 23.1; unverified secondary value; NOT manufacturer-confirmed','UnverifiedSecondary',0,'Low','Reference','Reference source or conflicting rating needs independent verification. TSFC units quarantined.','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","ShaftPower_kW","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (8,8,'Reference',0,0,0,1,53400,NULL,NULL,'ABACUS Table 23.1; unverified secondary value; NOT manufacturer-confirmed','UnverifiedSecondary',0,'Low','Reference','Reference source or conflicting rating needs independent verification. TSFC units quarantined.','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","ShaftPower_kW","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (9,9,'Reference',0,0,0,1,NULL,1119,NULL,'ABACUS Table 23.1; unverified secondary value; NOT manufacturer-confirmed','UnverifiedSecondary',0,'Low','Reference','Reference source or conflicting rating needs independent verification. TSFC units quarantined.','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","ShaftPower_kW","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (10,10,'Reference',0,0,0,1,NULL,2051,NULL,'ABACUS Table 23.1; unverified secondary value; NOT manufacturer-confirmed','UnverifiedSecondary',0,'Low','Reference','Reference source or conflicting rating needs independent verification. TSFC units quarantined.','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","ShaftPower_kW","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (11,11,'Reference',0,0,0,1,NULL,3458,NULL,'ABACUS Table 23.1; unverified secondary value; NOT manufacturer-confirmed','UnverifiedSecondary',0,'Low','Reference','Reference source or conflicting rating needs independent verification. TSFC units quarantined.','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Thrust_N","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (12,4,'Reference',10685.933259776322,10668,0.82,0.85,27000,NULL,'ABACUS Table 23.1; estimated cruise value, NOT independent measurement','UnverifiedSecondary',0,'Low','Reference','Estimated cruise reference','Reference');

-- @statement
INSERT OR IGNORE INTO "Performance_Data" ("Data_ID","Engine_ID","Data_Type","Altitude_m","GeopotentialAltitude_m","Mach","Throttle","Afterburner","Thrust_N","FuelFlow_kgs","Source_Ref","Reference_Kind","Reference_Verified","Confidence","Prediction_Source","Warnings","Model_Version") VALUES (13,1,'Reference',0,0,0,1,1,79600,NULL,'ABACUS Table 23.1; afterburner outside implemented scope','UnverifiedSecondary',0,'Low','Reference','Afterburner case retained for traceability and excluded from validation','Reference');

-- @statement
INSERT OR IGNORE INTO Aircraft (Aircraft_ID,Designation,Type,IAF_Service) VALUES (1,'F-4 Phantom II','Unverified blueprint association',NULL);

-- @statement
INSERT OR IGNORE INTO Engine_Aircraft_Map (Map_ID,Engine_ID,Aircraft_ID,Notes) VALUES (1,1,1,'ABACUS Table 9: recorded as a blueprint claim only. Exact engine variant / aircraft pairing is unverified and excluded from selection constraints.');

-- @statement
INSERT OR IGNORE INTO Aircraft (Aircraft_ID,Designation,Type,IAF_Service) VALUES (2,'Mirage III','Unverified blueprint association',NULL);

-- @statement
INSERT OR IGNORE INTO Engine_Aircraft_Map (Map_ID,Engine_ID,Aircraft_ID,Notes) VALUES (2,2,2,'ABACUS Table 9: recorded as a blueprint claim only. Exact engine variant / aircraft pairing is unverified and excluded from selection constraints.');

-- @statement
INSERT OR IGNORE INTO Aircraft (Aircraft_ID,Designation,Type,IAF_Service) VALUES (3,'MiG-21bis','Unverified blueprint association',NULL);

-- @statement
INSERT OR IGNORE INTO Engine_Aircraft_Map (Map_ID,Engine_ID,Aircraft_ID,Notes) VALUES (3,3,3,'ABACUS Table 9: recorded as a blueprint claim only. Exact engine variant / aircraft pairing is unverified and excluded from selection constraints.');

-- @statement
INSERT OR IGNORE INTO Aircraft (Aircraft_ID,Designation,Type,IAF_Service) VALUES (4,'Airbus A320-200','Unverified blueprint association',NULL);

-- @statement
INSERT OR IGNORE INTO Engine_Aircraft_Map (Map_ID,Engine_ID,Aircraft_ID,Notes) VALUES (4,4,4,'ABACUS Table 9: recorded as a blueprint claim only. Exact engine variant / aircraft pairing is unverified and excluded from selection constraints.');

-- @statement
INSERT OR IGNORE INTO Aircraft (Aircraft_ID,Designation,Type,IAF_Service) VALUES (5,'Boeing 767-300','Unverified blueprint association',NULL);

-- @statement
INSERT OR IGNORE INTO Engine_Aircraft_Map (Map_ID,Engine_ID,Aircraft_ID,Notes) VALUES (5,5,5,'ABACUS Table 9: recorded as a blueprint claim only. Exact engine variant / aircraft pairing is unverified and excluded from selection constraints.');

-- @statement
INSERT OR IGNORE INTO Aircraft (Aircraft_ID,Designation,Type,IAF_Service) VALUES (6,'F-15E','Unverified blueprint association',NULL);

-- @statement
INSERT OR IGNORE INTO Engine_Aircraft_Map (Map_ID,Engine_ID,Aircraft_ID,Notes) VALUES (6,6,6,'ABACUS Table 9: recorded as a blueprint claim only. Exact engine variant / aircraft pairing is unverified and excluded from selection constraints.');

-- @statement
INSERT OR IGNORE INTO Aircraft (Aircraft_ID,Designation,Type,IAF_Service) VALUES (7,'Dassault Rafale','Unverified blueprint association',NULL);

-- @statement
INSERT OR IGNORE INTO Engine_Aircraft_Map (Map_ID,Engine_ID,Aircraft_ID,Notes) VALUES (7,7,7,'ABACUS Table 9: recorded as a blueprint claim only. Exact engine variant / aircraft pairing is unverified and excluded from selection constraints.');

-- @statement
INSERT OR IGNORE INTO Aircraft (Aircraft_ID,Designation,Type,IAF_Service) VALUES (8,'LCA Tejas (proposed association in blueprint)','Unverified blueprint association',NULL);

-- @statement
INSERT OR IGNORE INTO Engine_Aircraft_Map (Map_ID,Engine_ID,Aircraft_ID,Notes) VALUES (8,8,8,'ABACUS Table 9: recorded as a blueprint claim only. Exact engine variant / aircraft pairing is unverified and excluded from selection constraints.');

-- @statement
INSERT OR IGNORE INTO Aircraft (Aircraft_ID,Designation,Type,IAF_Service) VALUES (9,'Pilatus PC-12 (blueprint family association)','Unverified blueprint association',NULL);

-- @statement
INSERT OR IGNORE INTO Engine_Aircraft_Map (Map_ID,Engine_ID,Aircraft_ID,Notes) VALUES (9,9,9,'ABACUS Table 9: recorded as a blueprint claim only. Exact engine variant / aircraft pairing is unverified and excluded from selection constraints.');

-- @statement
INSERT OR IGNORE INTO Aircraft (Aircraft_ID,Designation,Type,IAF_Service) VALUES (10,'ATR 72-600 (blueprint association)','Unverified blueprint association',NULL);

-- @statement
INSERT OR IGNORE INTO Engine_Aircraft_Map (Map_ID,Engine_ID,Aircraft_ID,Notes) VALUES (10,10,10,'ABACUS Table 9: recorded as a blueprint claim only. Exact engine variant / aircraft pairing is unverified and excluded from selection constraints.');

-- @statement
INSERT OR IGNORE INTO Aircraft (Aircraft_ID,Designation,Type,IAF_Service) VALUES (11,'C-130J Super Hercules','Unverified blueprint association',NULL);

-- @statement
INSERT OR IGNORE INTO Engine_Aircraft_Map (Map_ID,Engine_ID,Aircraft_ID,Notes) VALUES (11,11,11,'ABACUS Table 9: recorded as a blueprint claim only. Exact engine variant / aircraft pairing is unverified and excluded from selection constraints.');
