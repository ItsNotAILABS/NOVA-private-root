const state = { workspaceId: null, file: null, session: localStorage.getItem('nova_ide_session') || '' };
const $ = (id) => document.getElementById(id);
function log(value){ $('output').textContent = typeof value === 'string' ? value : JSON.stringify(value,null,2); }
function authHeaders(){ return state.session ? { authorization: `Bearer ${state.session}` } : {}; }
async function api(path, options={}){
  const res = await fetch(path,{...options,headers:{'content-type':'application/json',...authHeaders(),...(options.headers||{})}});
  const body = await res.json();
  if(!res.ok) throw new Error(body.error || 'request_failed');
  return body;
}
function renderWorkspaces(items=[]){
  $('workspaces').innerHTML = items.map(w=>`<div class="item" data-id="${w.id}"><strong>${w.name}</strong><small>${w.id}</small></div>`).join('') || '<p>No workspaces yet.</p>';
  [...document.querySelectorAll('#workspaces .item')].forEach(el=>el.onclick=()=>selectWorkspace(el.dataset.id));
}
function renderFiles(items=[]){
  $('files').innerHTML = items.map(f=>`<div class="item" data-file="${f.file}"><strong>${f.file}</strong><small>${f.bytes} bytes · ${f.hash.slice(0,12)}</small></div>`).join('') || '<p>No files.</p>';
  [...document.querySelectorAll('#files .item')].forEach(el=>el.onclick=()=>selectFile(el.dataset.file));
}
function inferCommand(files=[]){
  const paths = new Set(files.map(f=>f.file));
  if(paths.has('tests/service.test.js')) return 'node-service-test';
  if(paths.has('tests/extension.test.js')) return 'extension-test';
  if(paths.has('tests/app.test.js')) return 'node-test';
  return 'validate-static';
}
async function refresh(){
  const status = await api('/api/ide/status');
  const list = await api('/api/ide/workspaces');
  $('template').innerHTML = status.templates.map(t=>`<option value="${t.id}">${t.name}</option>`).join('');
  renderWorkspaces(list.workspaces);
  log(status);
}
async function selectWorkspace(id){
  state.workspaceId = id;
  const res = await api(`/api/ide/workspace/${id}/files`);
  state.files = res.files;
  renderFiles(res.files);
  log({selectedWorkspace:id, files:res.files});
}
async function selectFile(file){
  state.file = file;
  const res = await api(`/api/ide/workspace/${state.workspaceId}/file?file=${encodeURIComponent(file)}`);
  $('editor').value = res.content;
  log({file, meta:res.meta});
}
$('connect').onclick=async()=>{ const token=$('operatorToken').value.trim(); if(!token) return log('Enter operator token.'); const res=await api('/api/session',{method:'POST',body:JSON.stringify({operatorToken:token,label:'nova-ide-commercial'})}); state.session=res.session.id; localStorage.setItem('nova_ide_session',state.session); log({connected:true, session:res.session}); };
$('refresh').onclick=()=>refresh().catch((err)=>log(err.message));
$('newWorkspace').onclick=async()=>{ const name = prompt('Workspace name','NOVA Workspace'); if(!name) return; const res=await api('/api/ide/workspaces',{method:'POST',body:JSON.stringify({name})}); await refresh(); await selectWorkspace(res.workspace.id); };
$('generate').onclick=async()=>{ const promptText=$('prompt').value.trim(); const res=await api('/api/apps/generate',{method:'POST',body:JSON.stringify({prompt:promptText,templateId:$('template').value})}); await refresh(); await selectWorkspace(res.workspace.id); log(res); };
$('saveFile').onclick=async()=>{ if(!state.workspaceId||!state.file) return log('Select a workspace and file first.'); const res=await api(`/api/ide/workspace/${state.workspaceId}/file`,{method:'PUT',body:JSON.stringify({file:state.file,content:$('editor').value})}); await selectWorkspace(state.workspaceId); log(res); };
$('quality').onclick=async()=>{ if(!state.workspaceId) return log('Select a workspace first.'); log(await api(`/api/quality/check-workspace`,{method:'POST',body:JSON.stringify({workspaceId:state.workspaceId})})); };
$('runTest').onclick=async()=>{ if(!state.workspaceId) return log('Select a workspace first.'); const commandId=inferCommand(state.files||[]); log(await api(`/api/ide/workspace/${state.workspaceId}/run`,{method:'POST',body:JSON.stringify({commandId})})); };
$('package').onclick=async()=>{ if(!state.workspaceId) return log('Select a workspace first.'); log(await api(`/api/apps/package`,{method:'POST',body:JSON.stringify({workspaceId:state.workspaceId,lane:'local-preview'})})); };
$('readiness').onclick=async()=>{ if(!state.workspaceId) return log('Select a workspace first.'); log(await api('/api/commercial/readiness',{method:'POST',body:JSON.stringify({workspaceId:state.workspaceId})})); };
$('audit').onclick=async()=>{ log(await api(`/api/ide/audit${state.workspaceId ? `?workspaceId=${encodeURIComponent(state.workspaceId)}` : ''}`)); };
refresh().catch((err)=>log(err.message));
