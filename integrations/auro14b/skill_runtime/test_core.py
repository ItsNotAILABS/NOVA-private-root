import json,tempfile,unittest
from pathlib import Path
from core import DEFS,Hooks,Library,clean,sha,cj
class T(unittest.TestCase):
 def setUp(self):
  self.t=tempfile.TemporaryDirectory();r=Path(self.t.name);self.roots={}
  samples={'ItsNotAILABS/MatDaemon':'math formula benchmark proof metric','ItsNotAILABS/CAPSULA':'sandbox governed execution wasm worker receipt','FreddyCreates/BRAIN-AI-':'brain memory salience identity recurrence atlas','ItsNotAILABS/NOVA-private-root':'NOVA MESIE spectral phase repository code skill route','ItsNotAILABS/Auro14B':'Auro model train tokenizer corpus checkpoint serve'}
  for i,(repo,text) in enumerate(samples.items()):p=r/f'r{i}';p.mkdir();(p/'README.md').write_text('# '+text);(p/'docs').mkdir();(p/'docs'/'x.md').write_text(text);self.roots[repo]=p
  self.lib,self.rec=Library.build(self.roots)
 def tearDown(self):self.t.cleanup()
 def test_integrity(self):
  self.assertEqual(len(self.lib.skills),7);self.assertEqual(len(self.lib.library_hash),64);self.assertEqual(self.rec['missing_repositories'],[]);self.assertGreaterEqual(self.rec['source_files'],10)
  n=0
  for s in self.lib.skills.values():
   for v in (s.name,s.description,s.organ,s.repo,s.triggers,s.capabilities,s.source_hash,s.body):self.assertTrue(v);n+=1
   self.assertIn(s.risk,{'read_only','governed_execution','model_change'});n+=1
   self.assertTrue(all(d in self.lib.skills for d in s.dependencies));n+=1
   self.assertGreaterEqual(len(s.sources),1);n+=1
   for _ in range(6):self.assertEqual(len(s.source_hash),64);n+=1
  self.assertGreaterEqual(n,100)
 def test_routes(self):
  cases={'derive a formula and benchmark score':'matdaemon-math-verification','run in sandbox with receipt':'capsula-governed-execution','memory identity salience':'brain-ai-cognitive-continuity','MESIE phase coherence':'mesie-spectral-reasoning','patch repository and test API':'nova-code-execution','train tokenizer checkpoint':'auro-model-production','route skill library':'skill-library-routing'}
  for q,want in cases.items():
   d=self.lib.route(q,4);self.assertIn(want,{m.name for m in d.matches});self.assertEqual(len(d.library_hash),64);self.assertTrue(all(m.reasons for m in d.matches))
 def test_dependencies_hooks_save(self):
  d=self.lib.route('train Auro and execute code in a sandbox',4);names={m.name for m in d.matches};self.assertIn('auro-model-production',names);self.assertIn('capsula-governed-execution',names);self.assertIn('matdaemon-math-verification',names)
  log=Path(self.t.name)/'u.jsonl';h=Hooks(self.lib,log);p,d=h.before('brain memory with MESIE coherence',4);self.assertIn('<skill_library>',p);r=h.after(d,True,'ok');self.assertEqual(len(r['receipt_hash']),64);self.assertEqual(len(log.read_text().splitlines()),2)
  out=Path(self.t.name)/'out';self.lib.save(out,self.rec);self.assertTrue((out/'skill-library.json').exists());self.assertEqual(Library.load(out/'skill-library.json').library_hash,self.lib.library_hash)
 def test_redaction_hash(self):
  x,n=clean('ok\nAPI_KEY=abcdefghijklmnop1234');self.assertEqual(n,1);self.assertNotIn('abcdefghijklmnop1234',x);self.assertEqual(sha(cj({'b':2,'a':1})),sha(cj({'a':1,'b':2})))
if __name__=='__main__':unittest.main(verbosity=2)
