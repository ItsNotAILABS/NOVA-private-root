from __future__ import annotations
import argparse,json
from pathlib import Path
from core import DEFS,Library,sha,cj
FIX=[('derive a quantitative benchmark score and validate the formula',{'matdaemon-math-verification'}),('run this Python worker safely in an isolated sandbox and give me a receipt',{'capsula-governed-execution'}),('preserve identity and memory continuity across recurrent cognitive cycles',{'brain-ai-cognitive-continuity'}),('analyze MESIE phase coherence and spectral consolidation',{'mesie-spectral-reasoning'}),('patch this GitHub repository, run tests, and debug the API',{'nova-code-execution'}),('train the Auro tokenizer and evaluate the checkpoint',{'auro-model-production'}),('route this request to the best internal skill and dependency plan',{'skill-library-routing'}),('train Auro and execute its generated code in a sandbox',{'auro-model-production','capsula-governed-execution'}),('use brain memory with MESIE coherence',{'brain-ai-cognitive-continuity','mesie-spectral-reasoning'}),('create a proof-backed test workflow for a repository',{'nova-code-execution','matdaemon-math-verification'}),('deploy a canister worker with governed execution',{'capsula-governed-execution'}),('measure latency, score accuracy, and verify results',{'matdaemon-math-verification'}),('design salience and homeostasis for the brain atlas',{'brain-ai-cognitive-continuity'}),('serve a checkpoint behind an OpenAI-compatible API',{'auro-model-production'}),('compose worker skills and delegate a plan',{'skill-library-routing'})]
def parse_repo(v):
 n,p=v.split('=',1);return n,Path(p)
def build(a):
 lib,rec=Library.build(dict(parse_repo(v) for v in a.repo));lib.save(a.output,rec);print(json.dumps(rec,indent=2));return 0
def evaluate(a):
 lib=Library.load(a.library);tp=fp=fn=top=0;rows=[]
 for q,exp in FIX:
  d=lib.route(q,4); actual={m.name for m in d.matches}; direct={m.name for m in d.matches if not any(r.startswith('dependency:') for r in m.reasons)}; primary=d.matches[0].name if d.matches else None
  x=len(exp&actual);y=len(direct-exp);z=len(exp-actual);tp+=x;fp+=y;fn+=z;top+=int(primary in exp);rows.append({'query':q,'expected':sorted(exp),'actual':sorted(actual),'primary':primary,'tp':x,'fp':y,'fn':z})
 precision=tp/max(1,tp+fp);recall=tp/max(1,tp+fn);f1=2*precision*recall/max(1e-12,precision+recall);top1=top/len(FIX);score=.55*recall+.25*precision+.2*top1
 p={'schema':'medina.auro.skill_router_eval.v1','library_hash':lib.library_hash,'fixtures':len(FIX),'precision':precision,'recall':recall,'f1':f1,'top1_accuracy':top1,'weighted_score':score,'threshold':a.threshold,'passed':score>=a.threshold and recall>=a.threshold,'rows':rows};p['receipt_hash']=sha(cj(p));Path(a.output).parent.mkdir(parents=True,exist_ok=True);Path(a.output).write_text(json.dumps(p,indent=2));print(json.dumps(p,indent=2));return 0 if p['passed'] else 2
def corpus(a):
 lib=Library.load(a.library);out=Path(a.output);out.mkdir(parents=True,exist_ok=True);system=lib.prompt();manifest=[];i=0
 def emit(user,assistant,skill):
  nonlocal i
  text=f'<|system|>\n{system}\n<|user|>\n{user}\n<|assistant|>\n{assistant}\n<|eos|>\n';p=out/f'skill-training-{i:04d}.md';p.write_text(text);manifest.append({'path':p.name,'sha256':sha(text),'skill':skill,'chars':len(text)});i+=1
 for s in lib.skills.values():
  for t in s.triggers[:4]:
   for q in (f'Use {s.organ} to handle a task involving {t}.',f'Which internal skill should handle {t}?'):
    d=lib.route(q,3);sel=[m.name for m in d.matches];emit(q,f'<|skill_call|>{json.dumps({"skills":sel,"primary":s.name})}<|skill_result|>\nI will use {s.name}. {s.description}',s.name)
  emit(f'Describe the operational scope of {s.name}.',f'{s.name} is the {s.organ} organ. {s.description} Capabilities: {", ".join(s.capabilities)}. Risk boundary: {s.risk}. Execution claims require receipts.',s.name)
  p=out/f'organ-{s.name}.md';text=f'{system}\n\n{s.body}\n';p.write_text(text);manifest.append({'path':p.name,'sha256':sha(text),'skill':s.name,'chars':len(text)})
 for q in ('Train and benchmark Auro, then execute generated code inside a governed sandbox.','Use brain memory and MESIE coherence to preserve identity across a worker execution cycle.','Inspect a repository, patch code, run tests, and produce quantitative proof receipts.','Route this task through the skill library and explain which organs are required.'):
  d=lib.route(q,4);sel=[m.name for m in d.matches];emit(q,f'<|skill_call|>{json.dumps({"skills":sel})}<|skill_result|>\nSelected organs: {", ".join(sel)}.','composed')
 r={'schema':'medina.auro.skill_training_corpus.v1','library_hash':lib.library_hash,'records':len(manifest),'manifest':manifest};r['receipt_hash']=sha(cj(r));(out/'training-corpus-receipt.json').write_text(json.dumps(r,indent=2));print(json.dumps(r,indent=2));return 0
def main():
 p=argparse.ArgumentParser();s=p.add_subparsers(dest='cmd',required=True)
 b=s.add_parser('build');b.add_argument('--repo',action='append',default=[]);b.add_argument('--output',required=True);b.set_defaults(fn=build)
 e=s.add_parser('evaluate');e.add_argument('--library',required=True);e.add_argument('--output',required=True);e.add_argument('--threshold',type=float,default=.85);e.set_defaults(fn=evaluate)
 c=s.add_parser('corpus');c.add_argument('--library',required=True);c.add_argument('--output',required=True);c.set_defaults(fn=corpus)
 a=p.parse_args();raise SystemExit(a.fn(a))
if __name__=='__main__':main()
