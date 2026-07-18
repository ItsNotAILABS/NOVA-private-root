import json, tempfile, unittest
from pathlib import Path
from core import Hooks, Library, clean, sha, cj
from forge import CURATED, CODE_DRILLS, curriculum_records

class T(unittest.TestCase):
    def setUp(self):
        self.t=tempfile.TemporaryDirectory(); root=Path(self.t.name); self.roots={}
        samples={'ItsNotAILABS/MatDaemon':'math formula benchmark proof metric','ItsNotAILABS/CAPSULA':'sandbox governed execution wasm worker receipt','FreddyCreates/BRAIN-AI-':'brain memory salience identity recurrence atlas','ItsNotAILABS/NOVA-private-root':'NOVA MESIE spectral phase repository code skill route','ItsNotAILABS/Auro14B':'Auro model train tokenizer corpus checkpoint serve'}
        for index,(repo,text) in enumerate(samples.items()):
            path=root/f'r{index}'; path.mkdir(); (path/'README.md').write_text('# '+text); (path/'docs').mkdir(); (path/'docs'/'x.md').write_text(text); self.roots[repo]=path
        self.lib,self.rec=Library.build(self.roots)
    def tearDown(self): self.t.cleanup()
    def test_integrity(self):
        self.assertEqual(len(self.lib.skills),7); self.assertEqual(len(self.lib.library_hash),64); self.assertEqual(self.rec['missing_repositories'],[]); self.assertGreaterEqual(self.rec['source_files'],10)
        assertions=0
        for skill in self.lib.skills.values():
            for value in (skill.name,skill.description,skill.organ,skill.repo,skill.triggers,skill.capabilities,skill.source_hash,skill.body): self.assertTrue(value); assertions+=1
            self.assertIn(skill.risk,{'read_only','governed_execution','model_change'}); assertions+=1
            self.assertTrue(all(dep in self.lib.skills for dep in skill.dependencies)); assertions+=1
            self.assertGreaterEqual(len(skill.sources),1); assertions+=1
            for _ in range(6): self.assertEqual(len(skill.source_hash),64); assertions+=1
        self.assertGreaterEqual(assertions,100)
    def test_routes(self):
        cases={'derive a formula and benchmark score':'matdaemon-math-verification','run in sandbox with receipt':'capsula-governed-execution','memory identity salience':'brain-ai-cognitive-continuity','MESIE phase coherence':'mesie-spectral-reasoning','patch repository and test API':'nova-code-execution','train tokenizer checkpoint':'auro-model-production','route skill library':'skill-library-routing'}
        for query,want in cases.items():
            decision=self.lib.route(query,4); self.assertIn(want,{match.name for match in decision.matches}); self.assertEqual(len(decision.library_hash),64); self.assertTrue(all(match.reasons for match in decision.matches))
    def test_dependencies_hooks_save(self):
        decision=self.lib.route('train Auro and execute code in a sandbox',4); names={match.name for match in decision.matches}; self.assertIn('auro-model-production',names); self.assertIn('capsula-governed-execution',names); self.assertIn('matdaemon-math-verification',names)
        log=Path(self.t.name)/'u.jsonl'; hooks=Hooks(self.lib,log); prompt,decision=hooks.before('brain memory with MESIE coherence',4); self.assertIn('<skill_library>',prompt); receipt=hooks.after(decision,True,'ok'); self.assertEqual(len(receipt['receipt_hash']),64); self.assertEqual(len(log.read_text().splitlines()),2)
        out=Path(self.t.name)/'out'; self.lib.save(out,self.rec); self.assertTrue((out/'skill-library.json').exists()); self.assertEqual(Library.load(out/'skill-library.json').library_hash,self.lib.library_hash)
    def test_curriculum_is_compact_and_executable(self):
        records=curriculum_records(self.lib); self.assertGreaterEqual(len(records),180)
        self.assertTrue(all(len(system)<200 for system,_,_,_,_ in records)); self.assertLess(max(len(user)+len(assistant) for _,user,assistant,_,_ in records),1800)
        kinds={kind for *_,kind in records}; self.assertTrue({'routing','demonstration','code-drill','composition','organ-card','reference-excerpt'} <= kinds)
        code=[assistant for _,_,assistant,_,kind in records if kind=='code-drill']; self.assertGreaterEqual(len(code),24)
        for block in code:
            source=block.split('```python\n',1)[1].rsplit('```',1)[0]
            compile(source,'<curriculum>','exec')
        self.assertEqual(set(CURATED),set(self.lib.skills)); self.assertGreaterEqual(len(CODE_DRILLS),4)
    def test_redaction_hash(self):
        value,count=clean('ok\nAPI_KEY=abcdefghijklmnop1234'); self.assertEqual(count,1); self.assertNotIn('abcdefghijklmnop1234',value); self.assertEqual(sha(cj({'b':2,'a':1})),sha(cj({'a':1,'b':2})))
if __name__=='__main__': unittest.main(verbosity=2)
