# Sources and verification scope

## Primary project specification

ABACUS specification / blueprint v1.1, 77 pages, supplied by the user in two byte-identical PDF attachments. A single original copy is retained as ABACUS_specification_v1_1.pdf. It is the authority for architecture, terminology, engine set, database, Digital Twin levels, methodology and academic scope. Engine values transcribed from this secondary document remain unverified.

The user's accompanying text request adds the 15 implementation phases, piston support, packaging and explicit no-fabrication requirements. Conflicts are recorded in CHANGELOG.md.

## Official implementation references consulted

- MathWorks native SQLite interface: https://www.mathworks.com/help/database/ug/sqlite.html
- MathWorks sqlread: https://www.mathworks.com/help/database/ug/sqlite.sqlread.html
- MathWorks sqlwrite: https://www.mathworks.com/help/database/ug/sqlite.sqlwrite.html
- MathWorks JDBC prepared statements, used to distinguish that API from the delivered native interface: https://www.mathworks.com/help/database/sql-prepared-statements.html
- MathWorks fitrnet: https://www.mathworks.com/help/stats/fitrnet.html
- MathWorks Level-2 MATLAB S-functions: https://www.mathworks.com/help/simulink/sfg/writing-level-2-matlab-s-functions.html
- NASA Glenn isentropic-flow relations: https://www.grc.nasa.gov/www/k-12/airplane/isentrop.html
- NASA Glenn compressible mass-flow relations: https://www.grc.nasa.gov/www/k-12/airplane/wcora.html

These sources support API/physical formulation choices. They are not evidence that a particular engine's proprietary parameters or the generated implementation have been experimentally validated. No cited engine source was promoted to independently verified manufacturer status.
