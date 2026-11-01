import sqlite3,pathlib,re,json,datetime,csv
p=pathlib.Path(__file__).resolve().parents[1]
checks=[]
def check(name,f):
    try: f(); checks.append({'name':name,'status':'PASS'})
    except Exception as e: checks.append({'name':name,'status':'FAIL','message':str(e)})
def require(x):
    if not x: raise AssertionError('Check failed')
c=sqlite3.connect(':memory:',isolation_level=None)
def script(name,fail=False):
    c.execute('PRAGMA foreign_keys = ON');c.execute('BEGIN IMMEDIATE TRANSACTION')
    try:
        for command in re.split(r'^-- @statement[^\S\r\n]*\r?$',(p/'database'/name).read_text(),flags=re.M):
            command=command.strip()
            if command and command.lower()!='pragma foreign_keys = on;':c.execute(command)
        if fail:c.execute('INSERT INTO deliberately_missing_table VALUES(1)')
        c.execute('COMMIT')
    except:
        c.execute('ROLLBACK');raise
check('Explicit transaction executes complete schema',lambda:script('schema.sql'))
check('Explicit transaction seeds core catalogue',lambda:script('seed_data.sql'))
check('Explicit transaction repeats core seed without missing-transaction error',lambda:script('seed_data.sql'))
def rollback():
    before=list(c.iterdump())
    try:script('seed_piston_extension.sql',True)
    except sqlite3.OperationalError:pass
    else:raise AssertionError('Injected error not raised')
    require(list(c.iterdump())==before)
check('Injected failure rolls back all optional-piston additions',rollback)
check('Explicit transaction enables piston engines',lambda:script('seed_piston_extension.sql'))
check('Explicit transaction repeats piston extension',lambda:script('seed_piston_extension.sql'))
check('Fresh extended database contains 13 engines',lambda:require(c.execute('SELECT count(*) FROM Engines').fetchone()[0]==13))
d=sqlite3.connect('file:'+str(p/'database/engine_analysis.db')+'?mode=ro',uri=True)
check('Delivered database integrity',lambda:require(d.execute('PRAGMA integrity_check').fetchone()[0]=='ok'))
check('Delivered database foreign keys',lambda:require(not d.execute('PRAGMA foreign_key_check').fetchall()))
check('218 parameter provenance records',lambda:require(d.execute('SELECT count(*) FROM Parameter_Provenance').fetchone()[0]==218))
check('No fabricated simulation results shipped',lambda:require(d.execute("SELECT count(*) FROM Performance_Data WHERE Data_Type!='Reference'").fetchone()[0]==0))
check('No fabricated verified references',lambda:require(d.execute('SELECT count(*) FROM Performance_Data WHERE Reference_Verified=1').fetchone()[0]==0))
def provenance():
    for row in d.execute('SELECT * FROM Engine_Thermo_Params'):
        cols=[x[0] for x in d.execute('SELECT * FROM Engine_Thermo_Params LIMIT 0').description]
        fields=dict(zip(cols,row))
        for name,value in fields.items():
            if name in ['Engine_ID','Param_ID'] or not isinstance(value,(float,int)):continue
            q=d.execute('SELECT Parameter_Value,Unit FROM Parameter_Provenance WHERE Engine_ID=? AND Parameter_Name=?',(fields['Engine_ID'],name)).fetchall()
            require(len(q)==1 and q[0][0]==value and bool(q[0][1]))
check('Every numerical model input has a matching source record and unit',provenance)
check('Catalogue CSV contains all 13 engines',lambda:require(len(list(csv.DictReader((p/'database/exports/engine_catalogue.csv').open())))==13))
r={'timestamp_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'scope':'Python SQLite regression and delivered-data checks; NOT MATLAB execution','checks':checks}
(p/'reports/REBUILD_SQL_CHECKS.json').write_text(json.dumps(r,indent=2))
print(json.dumps({'passed':sum(x['status']=='PASS' for x in checks),'failed':[x for x in checks if x['status']=='FAIL']},indent=2))
assert all(x['status']=='PASS' for x in checks)
