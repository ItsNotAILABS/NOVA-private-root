import argparse,json,time
from http.server import BaseHTTPRequestHandler,ThreadingHTTPServer
from pathlib import Path
from core import Hooks,Library
from adaptive import AdaptiveHooks,AdaptiveWeights
class App:
 def __init__(self,library,checkpoint,log,weights):
  from auro_foundry.generation import TextGenerator
  self.lib=Library.load(Path(library));self.weights=AdaptiveWeights(self.lib.skills,weights);self.h=AdaptiveHooks(Hooks(self.lib,log),self.weights);self.g=TextGenerator(checkpoint,device='cpu')
 def route(self,q):
  d=self.lib.route(q,4);return self.weights.rank(d,q)
 def chat(self,messages,max_tokens=128,temp=.2):
  q='\n'.join(x.get('content','') for x in messages if x.get('role')=='user');p,d=self.h.before(q,4,8000);text=self.g.generate(p,max_new_tokens=max_tokens,temperature=temp,top_k=20,top_p=.9);r=self.h.after(d,bool(text.strip()),text)
  return {'id':f'auro-skill-{int(time.time()*1000)}','object':'chat.completion','model':self.g.metadata.get('model_id','auro'),'choices':[{'index':0,'message':{'role':'assistant','content':text},'finish_reason':'stop'}],'skill_route':{'library_hash':d.library_hash,'matches':[m.__dict__ for m in d.matches]},'execution_receipt':r}
class H(BaseHTTPRequestHandler):
 app=None
 def sendj(self,n,p):
  b=json.dumps(p).encode();self.send_response(n);self.send_header('Content-Type','application/json');self.send_header('Content-Length',str(len(b)));self.end_headers();self.wfile.write(b)
 def do_GET(self):
  if self.path=='/health':self.sendj(200,{'ok':True,'skills':len(self.app.lib.skills)+1,'library_hash':self.app.lib.library_hash,'adaptive_version':self.app.weights.version})
  elif self.path=='/v1/skills':self.sendj(200,{'skills':[s.__dict__ for s in self.app.lib.skills.values()]+[{'name':'impeccable-design-quality','organ':'IMPECCABLE','adaptive':True}]})
  else:self.sendj(404,{'error':'not_found'})
 def do_POST(self):
  try:b=json.loads(self.rfile.read(int(self.headers.get('Content-Length','0'))) or b'{}')
  except Exception:return self.sendj(400,{'error':'invalid_json'})
  if self.path=='/v1/skills/route':d=self.app.route(str(b.get('query','')));return self.sendj(200,{'library_hash':d.library_hash,'matches':[m.__dict__ for m in d.matches]})
  if self.path=='/v1/chat/completions':return self.sendj(200,self.app.chat(b.get('messages',[]),min(int(b.get('max_tokens',128)),1024),float(b.get('temperature',.2))))
  self.sendj(404,{'error':'not_found'})
 def log_message(self,*a):pass
def main():
 p=argparse.ArgumentParser();p.add_argument('--library',required=True);p.add_argument('--checkpoint',required=True);p.add_argument('--host',default='127.0.0.1');p.add_argument('--port',type=int,default=8091);p.add_argument('--usage-log',default='artifacts/skill-usage.jsonl');p.add_argument('--adaptive-weights',default='artifacts/adaptive-weights.json');a=p.parse_args();H.app=App(a.library,a.checkpoint,Path(a.usage_log),Path(a.adaptive_weights));s=ThreadingHTTPServer((a.host,a.port),H);print(json.dumps({'ready':True,'url':f'http://{a.host}:{a.port}'}));s.serve_forever()
if __name__=='__main__':main()
