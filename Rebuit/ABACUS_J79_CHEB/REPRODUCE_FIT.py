import numpy as np,csv,itertools,json
from numpy.polynomial.chebyshev import chebvander
from scipy.linalg import lstsq
from pathlib import Path
import argparse
parser=argparse.ArgumentParser()
parser.add_argument('--engine-folder',required=True)
parser.add_argument('--output-folder',required=True)
args=parser.parse_args()
engine_folder=Path(args.engine_folder)
output_folder=Path(args.output_folder); output_folder.mkdir(parents=True,exist_ok=True)

def read(n):
 with open(engine_folder/(n+'.csv')) as f:r=list(csv.DictReader(f))
 return np.array([[float(t[k]) for k in ['Altitude_m','Mach','Throttle']] for t in r]),np.array([[float(t[k]) for k in ['Thrust_N','FuelFlow_kgs','TSFC_kgNs']] for t in r]),np.array([t['Cohort'] for t in r])
X,Y,C=read('training');V,W,D=read('validation');Z=X/np.array([15000,2,.5])-np.array([0,0,1]);Z=2*Z-1
Zv=V/np.array([15000,2,.5])-np.array([0,0,1]);Zv=2*Zv-1
mu=Y[:,:2].mean(0);sd=Y[:,:2].std(0,ddof=1);best=None;results=[]
for degree in [5,7,9,11]:
 powers=np.array([(a,b,c) for a in range(degree+1) for b in range(degree-a+1) for c in range(degree-a-b+1)])
 def features(z):
  q=[chebvander(z[:,j],degree) for j in range(3)]
  return q[0][:,powers[:,0]]*q[1][:,powers[:,1]]*q[2][:,powers[:,2]]
 A=features(Z);B=features(Zv)
 for weight,lam in itertools.product([1,4,16,64],[1e-8,1e-5]):
  pen=np.eye(A.shape[1]);pen[0,0]=0
  weights=np.where(C=='Corner',weight,1.)[:,None]**.5
  coef=lstsq(np.vstack([A*weights,np.sqrt(lam)*pen]),np.vstack([(Y[:,:2]-mu)/sd*weights,np.zeros((len(powers),2))]),lapack_driver='gelsy')[0]
  p=B@coef*sd+mu;p=np.column_stack([p,p[:,1]/p[:,0]])
  scores=[np.max(np.sqrt(np.mean((p[D==c]-W[D==c])**2,axis=0))/np.mean(abs(W[D==c]),axis=0)) for c in np.unique(D)]
  rawscore=max(scores)
  pc=A[C=='Corner']@coef*sd+mu;pc=np.column_stack([pc,pc[:,1]/pc[:,0]])
  yc=Y[C=='Corner'];dc=pc-yc
  cnr=np.sqrt(np.mean(dc*dc,axis=0))/np.mean(abs(yc),axis=0)
  cna=np.mean(abs(dc),axis=0)/np.mean(abs(yc),axis=0)
  cmape=100*np.mean(abs(dc/yc),axis=0)
  cr2=1-np.sum(dc*dc,axis=0)/np.sum((yc-yc.mean(0))**2,axis=0)
  eligible=np.all(pc>0) and np.all(cnr<.02) and np.all(cna<.015) and np.all(cmape<5) and np.all(cr2>=.95)
  score=rawscore if np.all(p>0) and eligible else float('inf')
  print(degree,weight,lam,'worst validation NRMSE%',score*100,flush=True)
  results.append([degree,weight,lam,rawscore,bool(eligible),score])
  if best is None or score<best[0]:best=(score,degree,lam,powers,coef,weight)
score,degree,lam,powers,coef,weight=best
np.savez(output_folder/'cheb_fit.npz',degree=degree,weight=weight,lam=lam,powers=powers,coef=coef,mu=mu,sd=sd,score=score)
open(output_folder/'selection.json','w').write(json.dumps(results))
print('WINNER',degree,lam,score)
