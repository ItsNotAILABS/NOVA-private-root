from __future__ import annotations
import argparse,hashlib,json,shutil
from pathlib import Path
import torch

def sha256(path:Path)->str:
 digest=hashlib.sha256()
 with path.open('rb') as handle:
  for chunk in iter(lambda:handle.read(1024*1024),b''): digest.update(chunk)
 return digest.hexdigest()

def main()->None:
 parser=argparse.ArgumentParser();parser.add_argument('--workspace',required=True);parser.add_argument('--release',required=True);args=parser.parse_args()
 workspace=Path(args.workspace).resolve();release=Path(args.release).resolve();model_dir,evidence_dir,runtime_dir=release/'model',release/'evidence',release/'runtime'
 model_dir.mkdir(parents=True,exist_ok=True);evidence_dir.mkdir(parents=True,exist_ok=True);runtime_dir.mkdir(parents=True,exist_ok=True)
 source_checkpoint=workspace/'runs'/'auro-real-run'/'final.pt';source_tokenizer=workspace/'tokenizer.json';target_checkpoint,target_tokenizer=model_dir/'final.pt',model_dir/'tokenizer.json'
 shutil.copy2(source_tokenizer,target_tokenizer);payload=torch.load(source_checkpoint,map_location='cpu',weights_only=False);config=payload.get('config') or payload.get('train_config')
 if config: config['tokenizer_path']='tokenizer.json';config['output_dir']='runs';config['dataset_dir']='dataset'
 torch.save(payload,target_checkpoint);target_checkpoint.with_suffix('.pt.sha256').write_text(sha256(target_checkpoint)+'\n',encoding='utf-8')
 for source in [workspace/'corpus'/'manifest.json',workspace/'dataset'/'dataset-manifest.json',workspace/'end-to-end-receipt.json',workspace/'runs'/'auro-real-run'/'training-receipt.json']:
  if source.exists(): shutil.copy2(source,evidence_dir/source.name)
 skill_runtime=Path(__file__).resolve().parents[1]/'skill_runtime'
 for name in ('core.py','adaptive.py','server.py'):
  source=skill_runtime/name
  if source.exists(): shutil.copy2(source,runtime_dir/name)
 initial={'schema':'medina.auro.adaptive_weights.v1','version':1,'weights':{},'phases':{},'links':{}}
 (runtime_dir/'adaptive-weights.json').write_text(json.dumps(initial,indent=2),encoding='utf-8')
 manifest={'schema':'medina.auro.usable_release.v2','checkpoint':'model/final.pt','checkpoint_sha256':sha256(target_checkpoint),'tokenizer':'model/tokenizer.json','tokenizer_sha256':sha256(target_tokenizer),'runtime':['runtime/core.py','runtime/adaptive.py','runtime/server.py'],'adaptive_state':'runtime/adaptive-weights.json','truth_boundary':'CPU-trained Auro micro checkpoint with runtime Hebbian-Kuramoto organ adaptation; not a 14B or 200B checkpoint.'}
 (release/'release-manifest.json').write_text(json.dumps(manifest,indent=2,sort_keys=True),encoding='utf-8')
if __name__=='__main__':main()
