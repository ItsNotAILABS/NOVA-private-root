function escapeHtml(value = '') {
  return String(value).replace(/[&<>"']/g, (ch) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch]));
}

export const templateCatalog = Object.freeze({
  web: {
    id: 'web',
    label: 'Frontend Web App',
    entry: 'index.html',
    files(title = 'NOVA Web App') {
      const safeTitle = escapeHtml(title);
      return {
        'index.html': `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${safeTitle}</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <main class="shell">
    <p class="eyebrow">NOVA Capsule Studio</p>
    <h1>${safeTitle}</h1>
    <section class="card">
      <h2>Generated application</h2>
      <p>This app was created inside the NOVA production capsule runtime.</p>
      <button id="action">Run Action</button>
    </section>
  </main>
  <script src="app.js"></script>
</body>
</html>
`,
        'styles.css': `:root{color-scheme:dark}body{margin:0;background:radial-gradient(circle at 20% 0,#1e3a8a,#020617 40%),#020617;color:#f8fafc;font-family:Inter,system-ui,sans-serif}.shell{max-width:1000px;margin:0 auto;padding:72px 28px}.eyebrow{color:#38bdf8;text-transform:uppercase;letter-spacing:.18em;font-weight:900}h1{font-size:72px;line-height:.9;margin:12px 0 28px}.card{background:rgba(15,23,42,.82);border:1px solid rgba(56,189,248,.25);border-radius:28px;padding:28px;box-shadow:0 24px 80px rgba(0,0,0,.35)}button{border:0;border-radius:14px;padding:14px 18px;background:#2563eb;color:white;font-weight:900}`,
        'app.js': `document.getElementById('action')?.addEventListener('click',()=>alert('NOVA app action executed'));
console.log('NOVA Capsule Studio app live');
`
      };
    }
  },
  python: {
    id: 'python',
    label: 'Python Console Tool',
    entry: 'hello.py',
    files(title = 'NOVA Python Tool') {
      return { 'hello.py': `print(${JSON.stringify(title)})\nprint('NOVA Python capsule executed')\n` };
    }
  },
  cpp: {
    id: 'cpp',
    label: 'C++ Console App',
    entry: 'main.cpp',
    files() {
      return { 'main.cpp': '#include <iostream>\nint main(){ std::cout << "NOVA C++ capsule executed\\n"; return 0; }\n' };
    }
  },
  java: {
    id: 'java',
    label: 'Java Console App',
    entry: 'Main.java',
    files() {
      return { 'Main.java': 'public class Main { public static void main(String[] args){ System.out.println("NOVA Java capsule executed"); } }\n' };
    }
  }
});

export function listTemplates() {
  return Object.values(templateCatalog).map(({ id, label, entry }) => ({ id, label, entry }));
}

export function getTemplate(id = 'web') {
  return templateCatalog[id] || templateCatalog.web;
}
