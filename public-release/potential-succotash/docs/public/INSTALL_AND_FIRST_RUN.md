# Install and First Run

## Option 1 — Load the Browser Extension

1. Clone or download the repository.
2. Build or unzip the extension package.
3. Open Chrome or Edge.
4. Go to `chrome://extensions` or `edge://extensions`.
5. Enable Developer Mode.
6. Click **Load unpacked**.
7. Select the extension folder.
8. Pin the extension and open the side panel.

## First Run Flow

1. Open any article or documentation page.
2. Open Sonic Ninja.
3. Use the summarize flow.
4. Highlight text and ask a question.
5. Save a note or memory.
6. Open the knowledge or memory panel.
7. Run a research agent on a safe public topic.
8. Export a report if available.

## Developer Run

```bash
git clone https://github.com/FreddyCreates/potential-succotash.git
cd potential-succotash
npm install
npm run lint
npm test
npm run build
```

## Troubleshooting

- If the extension does not load, confirm the selected folder contains the extension manifest.
- If offline AI does not respond, open the Solus panel and trigger model setup.
- If a page cannot be summarized, try a simpler page or selected text.
- If an optional online connector is used, treat that connector as separate from local-only functionality.
