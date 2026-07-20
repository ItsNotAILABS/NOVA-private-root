from __future__ import annotations
import json, math, time
from dataclasses import asdict
from pathlib import Path

IMPECCABLE = "impeccable-design-quality"

class AdaptiveWeights:
    def __init__(self, names, path=None, eta=.08, coupling=.18, decay=.015, floor=.5, ceiling=1.8):
        self.names=sorted(set(names)|{IMPECCABLE}); self.path=Path(path) if path else None
        self.eta=eta; self.coupling=coupling; self.decay=decay; self.floor=floor; self.ceiling=ceiling
        self.weights={name:1.0 for name in self.names}; self.phases={name:(i*2*math.pi/max(1,len(self.names))) for i,name in enumerate(self.names)}
        self.links={}; self.version=1; self._load()
    def _load(self):
        if not self.path or not self.path.exists(): return
        data=json.loads(self.path.read_text()); self.weights.update(data.get('weights',{})); self.phases.update(data.get('phases',{})); self.links.update(data.get('links',{})); self.version=int(data.get('version',1))
    def _save(self):
        if not self.path: return
        self.path.parent.mkdir(parents=True,exist_ok=True)
        self.path.write_text(json.dumps({'schema':'medina.auro.adaptive_weights.v1','version':self.version,'weights':self.weights,'phases':self.phases,'links':self.links},indent=2))
    def gain(self,name):
        others=[self.phases[n] for n in self.names if n!=name]
        coherence=(sum(math.cos(p-self.phases[name]) for p in others)/max(1,len(others))+1)/2
        return max(self.floor,min(self.ceiling,self.weights.get(name,1.0)*(1+self.coupling*(coherence-.5))))
    def rank(self,decision,query):
        rows=[]
        for match in decision.matches:
            score=max(0.0,min(1.0,match.score*self.gain(match.name)))
            rows.append((score,match))
        if any(term in query.lower() for term in ('design','frontend','ui','ux','accessibility','responsive','polish','layout','typography','css')):
            rows.append((min(1.0,.72*self.gain(IMPECCABLE)),type('AdaptiveMatch',(),{'name':IMPECCABLE,'score':.72,'reasons':['adaptive:design-intent'],'organ':'IMPECCABLE','dependencies':[]})()))
        rows.sort(key=lambda row:(-row[0],row[1].name))
        for score,match in rows: match.score=round(score,6)
        decision.matches=[match for _,match in rows]
        return decision
    def update(self,names,success,reward=1.0):
        active=[name for name in names if name in self.weights]; signal=(1 if success else -1)*max(0,min(1,float(reward)))
        for name in self.names:
            self.weights[name]=1+(self.weights[name]-1)*(1-self.decay)
        for name in active:
            self.weights[name]=max(self.floor,min(self.ceiling,self.weights[name]+self.eta*signal))
        for i,left in enumerate(active):
            for right in active[i+1:]:
                key='|'.join(sorted((left,right))); self.links[key]=max(-1,min(1,self.links.get(key,0)+self.eta*signal))
        old=dict(self.phases)
        for name in self.names:
            force=0.0
            for other in self.names:
                if other==name: continue
                link=self.links.get('|'.join(sorted((name,other))),0.0)
                force+=link*math.sin(old[other]-old[name])
            self.phases[name]=(old[name]+self.coupling*force/max(1,len(self.names)-1))%(2*math.pi)
        self.version+=1; self._save()
        return {'schema':'medina.auro.adaptation_receipt.v1','version':self.version,'active':active,'success':bool(success),'reward':reward,'weights':{n:self.weights[n] for n in active},'created_at':time.time()}

class AdaptiveHooks:
    def __init__(self,base_hooks,weights): self.base=base_hooks; self.weights=weights
    def before(self,prompt,top_k=3,max_chars=16000):
        hooked,decision=self.base.before(prompt,top_k,max_chars); decision=self.weights.rank(decision,prompt)
        return hooked,decision
    def after(self,decision,success,summary):
        base=self.base.after(decision,success,summary); adaptive=self.weights.update([m.name for m in decision.matches],success,1.0 if success else .5)
        base['adaptive_weights']=adaptive; return base
