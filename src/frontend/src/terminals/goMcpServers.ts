// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — GO SYSTEM MCP Server Registry
// 30 Model Context Protocol servers for AI assistants
// Terminal commands · File operations · Process management · Transports ·
// Data extraction · Error monitoring · Development tools
// ═══════════════════════════════════════════════════════════════════════════════

import type { GoMcpServer } from './types';

export const GO_MCP_SERVERS: GoMcpServer[] = [

  // ═══════════════════════════════════════════════════════════════════════════
  // TERMINAL & SYSTEM MCP SERVERS (1-6)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'MCP-01', name: 'go-mcp-terminal',
    division: 'DESKTOP_COMMAND',
    description: 'Terminal MCP server: execute shell commands, manage sessions, and parse output for AI assistants',
    transport: 'stdio',
    capabilities: ['command-execution', 'session-management', 'output-parsing', 'history-access', 'environment-vars'],
    commands: ['execute', 'spawn', 'kill', 'history', 'env-get', 'env-set', 'cwd', 'which'],
    integrations: ['bash', 'zsh', 'powershell', 'cmd'],
  },
  {
    id: 'MCP-02', name: 'go-mcp-filesystem',
    division: 'DESKTOP_COMMAND',
    description: 'File system MCP server: read, write, search, and manage files with sandboxed access',
    transport: 'stdio',
    capabilities: ['file-read', 'file-write', 'file-search', 'directory-listing', 'file-watch', 'permission-check'],
    commands: ['read', 'write', 'append', 'delete', 'mkdir', 'list', 'search', 'glob', 'watch', 'stat'],
    integrations: ['fs', 'path', 'glob', 'chokidar'],
  },
  {
    id: 'MCP-03', name: 'go-mcp-process',
    division: 'DESKTOP_COMMAND',
    description: 'Process management MCP server: spawn, monitor, signal, and manage system processes',
    transport: 'stdio',
    capabilities: ['process-spawn', 'process-list', 'process-kill', 'resource-monitoring', 'signal-handling'],
    commands: ['spawn', 'list', 'kill', 'signal', 'info', 'tree', 'top', 'ports'],
    integrations: ['child_process', 'ps-list', 'fkill', 'find-process'],
  },
  {
    id: 'MCP-04', name: 'go-mcp-git',
    division: 'DESKTOP_COMMAND',
    description: 'Git MCP server: version control operations for AI coding agents',
    transport: 'stdio',
    capabilities: ['git-status', 'git-diff', 'git-commit', 'git-branch', 'git-log', 'git-merge', 'git-rebase'],
    commands: ['status', 'diff', 'commit', 'branch', 'log', 'merge', 'rebase', 'stash', 'cherry-pick', 'blame'],
    integrations: ['git', 'GitHub-API', 'GitLab-API'],
  },
  {
    id: 'MCP-05', name: 'go-mcp-docker',
    division: 'DESKTOP_COMMAND',
    description: 'Docker MCP server: container lifecycle, image management, and compose operations',
    transport: 'stdio',
    capabilities: ['container-run', 'container-stop', 'image-pull', 'compose-up', 'logs', 'exec'],
    commands: ['run', 'stop', 'rm', 'pull', 'build', 'logs', 'exec', 'compose-up', 'compose-down', 'ps'],
    integrations: ['Docker', 'Docker-Compose', 'Podman'],
  },
  {
    id: 'MCP-06', name: 'go-mcp-kubernetes',
    division: 'DESKTOP_COMMAND',
    description: 'Kubernetes MCP server: cluster management, pod operations, and resource monitoring',
    transport: 'stdio',
    capabilities: ['pod-management', 'deployment-ops', 'service-ops', 'config-management', 'log-streaming'],
    commands: ['get', 'apply', 'delete', 'logs', 'exec', 'port-forward', 'describe', 'scale', 'rollout'],
    integrations: ['kubectl', 'Kubernetes-API', 'Helm'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // DATA EXTRACTION MCP SERVERS (7-12)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'MCP-07', name: 'go-mcp-web-scraper',
    division: 'SCRAPING',
    description: 'Web scraping MCP server: extract structured data from any website with CSS/XPath selectors',
    transport: 'sse',
    capabilities: ['html-parsing', 'css-selection', 'xpath-selection', 'pagination', 'data-extraction'],
    commands: ['scrape', 'scrape-list', 'scrape-table', 'scrape-links', 'extract-text', 'extract-media'],
    integrations: ['Cheerio', 'jsdom', 'Playwright'],
  },
  {
    id: 'MCP-08', name: 'go-mcp-browser',
    division: 'SCRAPING',
    description: 'Browser automation MCP server: Playwright-powered browser control for AI assistants',
    transport: 'sse',
    capabilities: ['page-navigation', 'element-interaction', 'screenshot', 'a11y-tree', 'network-interception'],
    commands: ['navigate', 'click', 'type', 'screenshot', 'a11y-snapshot', 'evaluate', 'wait', 'intercept'],
    integrations: ['Playwright', 'Chrome-DevTools-Protocol'],
  },
  {
    id: 'MCP-09', name: 'go-mcp-api-client',
    division: 'SCRAPING',
    description: 'API client MCP server: make HTTP requests, manage auth, and parse API responses',
    transport: 'stdio',
    capabilities: ['http-requests', 'auth-management', 'response-parsing', 'pagination', 'rate-limiting'],
    commands: ['get', 'post', 'put', 'delete', 'patch', 'auth-setup', 'paginate', 'download'],
    integrations: ['fetch', 'axios', 'got', 'OAuth'],
  },
  {
    id: 'MCP-10', name: 'go-mcp-database',
    division: 'SCRAPING',
    description: 'Database MCP server: query, inspect, and manage databases for AI data extraction',
    transport: 'stdio',
    capabilities: ['sql-query', 'schema-inspection', 'data-export', 'migration-management', 'connection-pooling'],
    commands: ['query', 'schema', 'tables', 'export', 'import', 'migrate', 'describe', 'count'],
    integrations: ['PostgreSQL', 'MySQL', 'SQLite', 'MongoDB', 'Redis'],
  },
  {
    id: 'MCP-11', name: 'go-mcp-pdf-extract',
    division: 'SCRAPING',
    description: 'PDF extraction MCP server: extract text, tables, images, and metadata from PDF documents',
    transport: 'stdio',
    capabilities: ['text-extraction', 'table-extraction', 'image-extraction', 'metadata-parsing', 'ocr'],
    commands: ['extract-text', 'extract-tables', 'extract-images', 'get-metadata', 'ocr-page', 'to-markdown'],
    integrations: ['pdf-parse', 'tabula', 'Tesseract', 'pdfjs'],
  },
  {
    id: 'MCP-12', name: 'go-mcp-spreadsheet',
    division: 'SCRAPING',
    description: 'Spreadsheet MCP server: read, write, and analyze Excel/CSV/Google Sheets data',
    transport: 'stdio',
    capabilities: ['cell-reading', 'range-operations', 'formula-evaluation', 'chart-extraction', 'pivot-analysis'],
    commands: ['read-sheet', 'read-range', 'write-cell', 'write-range', 'list-sheets', 'export-csv', 'analyze'],
    integrations: ['xlsx', 'csv-parse', 'Google-Sheets-API'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR MONITORING MCP SERVERS (13-16)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'MCP-13', name: 'go-mcp-sentry',
    division: 'ERROR_MONITORING',
    description: 'Sentry MCP server: query errors, issues, and performance data from Sentry for AI debugging',
    transport: 'stdio',
    capabilities: ['issue-query', 'error-details', 'stack-trace-access', 'release-info', 'performance-data'],
    commands: ['list-issues', 'get-issue', 'get-events', 'get-stacktrace', 'get-releases', 'get-transactions'],
    integrations: ['Sentry-API', 'Sentry-CLI'],
  },
  {
    id: 'MCP-14', name: 'go-mcp-logs',
    division: 'ERROR_MONITORING',
    description: 'Log analysis MCP server: search, filter, and analyze application logs for AI troubleshooting',
    transport: 'sse',
    capabilities: ['log-search', 'log-filter', 'log-tail', 'pattern-detection', 'correlation'],
    commands: ['search', 'tail', 'filter', 'count', 'histogram', 'patterns', 'correlate', 'export'],
    integrations: ['Elasticsearch', 'Loki', 'CloudWatch', 'file-logs'],
  },
  {
    id: 'MCP-15', name: 'go-mcp-metrics',
    division: 'INFRASTRUCTURE',
    description: 'Metrics query MCP server: query Prometheus/Grafana metrics for AI monitoring assistants',
    transport: 'stdio',
    capabilities: ['promql-query', 'metric-discovery', 'dashboard-access', 'alert-status', 'recording-rules'],
    commands: ['query', 'query-range', 'series', 'labels', 'dashboards', 'alerts', 'rules'],
    integrations: ['Prometheus', 'Grafana', 'VictoriaMetrics'],
  },
  {
    id: 'MCP-16', name: 'go-mcp-tracing',
    division: 'INFRASTRUCTURE',
    description: 'Distributed tracing MCP server: query traces and spans for AI performance analysis',
    transport: 'stdio',
    capabilities: ['trace-query', 'span-analysis', 'service-map', 'latency-breakdown', 'error-analysis'],
    commands: ['get-trace', 'search-traces', 'service-map', 'latency-stats', 'error-spans', 'dependencies'],
    integrations: ['Jaeger', 'Zipkin', 'Tempo', 'X-Ray'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // CODING AGENT MCP SERVERS (17-22)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'MCP-17', name: 'go-mcp-code-search',
    division: 'CODING_AGENTS',
    description: 'Semantic code search MCP server: find code by meaning across repos for AI coding agents',
    transport: 'stdio',
    capabilities: ['semantic-search', 'regex-search', 'symbol-search', 'file-search', 'reference-search'],
    commands: ['search', 'find-symbol', 'find-references', 'find-definition', 'find-implementations', 'grep'],
    integrations: ['tree-sitter', 'ripgrep', 'LSP', 'ast-grep'],
  },
  {
    id: 'MCP-18', name: 'go-mcp-code-edit',
    division: 'CODING_AGENTS',
    description: 'Code editing MCP server: apply semantic edits, refactors, and transformations for AI agents',
    transport: 'stdio',
    capabilities: ['file-edit', 'multi-file-edit', 'refactor', 'rename-symbol', 'extract-function', 'inline'],
    commands: ['edit', 'replace', 'insert', 'delete', 'rename', 'extract', 'inline', 'move', 'format'],
    integrations: ['tree-sitter', 'LSP', 'Prettier', 'jscodeshift'],
  },
  {
    id: 'MCP-19', name: 'go-mcp-lsp',
    division: 'CODING_AGENTS',
    description: 'LSP bridge MCP server: expose Language Server Protocol features to AI assistants',
    transport: 'stdio',
    capabilities: ['completion', 'diagnostics', 'hover', 'signature-help', 'code-actions', 'formatting'],
    commands: ['complete', 'diagnose', 'hover', 'signature', 'actions', 'format', 'organize-imports'],
    integrations: ['TypeScript-LSP', 'rust-analyzer', 'gopls', 'pylsp'],
  },
  {
    id: 'MCP-20', name: 'go-mcp-test-runner',
    division: 'CODING_AGENTS',
    description: 'Test runner MCP server: run tests, collect results, and report coverage for AI agents',
    transport: 'stdio',
    capabilities: ['test-execution', 'test-discovery', 'coverage-collection', 'failure-analysis', 'watch-mode'],
    commands: ['run', 'run-file', 'run-suite', 'coverage', 'list-tests', 'watch', 'debug'],
    integrations: ['Jest', 'Vitest', 'pytest', 'go-test', 'cargo-test'],
  },
  {
    id: 'MCP-21', name: 'go-mcp-package-manager',
    division: 'CODING_AGENTS',
    description: 'Package manager MCP server: install, update, and audit dependencies for AI agents',
    transport: 'stdio',
    capabilities: ['install', 'update', 'remove', 'audit', 'search', 'version-check'],
    commands: ['install', 'add', 'remove', 'update', 'audit', 'search', 'outdated', 'lock'],
    integrations: ['npm', 'yarn', 'pnpm', 'pip', 'cargo'],
  },
  {
    id: 'MCP-22', name: 'go-mcp-build',
    division: 'CODING_AGENTS',
    description: 'Build system MCP server: trigger builds, analyze output, and manage artifacts for AI agents',
    transport: 'stdio',
    capabilities: ['build-trigger', 'output-analysis', 'artifact-management', 'cache-control', 'incremental-build'],
    commands: ['build', 'clean', 'rebuild', 'artifacts', 'cache-clear', 'analyze-output', 'watch'],
    integrations: ['Vite', 'webpack', 'esbuild', 'tsc', 'cargo', 'go-build'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // WORKFLOW & AUTOMATION MCP SERVERS (23-27)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'MCP-23', name: 'go-mcp-terraform',
    division: 'WORKFLOWS',
    description: 'Terraform MCP server: plan, apply, and manage infrastructure as code for AI assistants',
    transport: 'stdio',
    capabilities: ['plan', 'apply', 'destroy', 'state-management', 'module-management', 'drift-detection'],
    commands: ['init', 'plan', 'apply', 'destroy', 'state-list', 'state-show', 'import', 'validate'],
    integrations: ['Terraform', 'OpenTofu', 'Terraform-Cloud'],
  },
  {
    id: 'MCP-24', name: 'go-mcp-ci-cd',
    division: 'WORKFLOWS',
    description: 'CI/CD MCP server: trigger pipelines, check status, and manage deployments for AI agents',
    transport: 'stdio',
    capabilities: ['pipeline-trigger', 'status-check', 'artifact-download', 'deployment-management', 'rollback'],
    commands: ['trigger', 'status', 'logs', 'artifacts', 'deploy', 'rollback', 'cancel', 'retry'],
    integrations: ['GitHub-Actions', 'GitLab-CI', 'Jenkins', 'CircleCI'],
  },
  {
    id: 'MCP-25', name: 'go-mcp-cloud',
    division: 'WORKFLOWS',
    description: 'Cloud provider MCP server: manage AWS/GCP/Azure resources for AI infrastructure agents',
    transport: 'stdio',
    capabilities: ['resource-management', 'cost-querying', 'iam-management', 'service-discovery', 'billing-analysis'],
    commands: ['list-resources', 'create', 'delete', 'describe', 'cost', 'iam-roles', 'services'],
    integrations: ['AWS-SDK', 'GCP-SDK', 'Azure-SDK'],
  },
  {
    id: 'MCP-26', name: 'go-mcp-notification',
    division: 'WORKFLOWS',
    description: 'Notification MCP server: send alerts via Slack, Teams, email, PagerDuty for AI automation',
    transport: 'stdio',
    capabilities: ['slack-messaging', 'email-sending', 'pagerduty-alerts', 'teams-messaging', 'webhook-firing'],
    commands: ['slack-send', 'email-send', 'pagerduty-trigger', 'teams-send', 'webhook-fire', 'sms-send'],
    integrations: ['Slack-API', 'SendGrid', 'PagerDuty-API', 'Teams-API'],
  },
  {
    id: 'MCP-27', name: 'go-mcp-scheduler',
    division: 'WORKFLOWS',
    description: 'Task scheduler MCP server: schedule, manage, and monitor recurring tasks for AI workflows',
    transport: 'stdio',
    capabilities: ['cron-scheduling', 'task-management', 'execution-history', 'retry-logic', 'dependency-chains'],
    commands: ['schedule', 'list-tasks', 'run-now', 'pause', 'resume', 'history', 'cancel', 'chain'],
    integrations: ['cron', 'node-cron', 'Temporal', 'Bull'],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTEXT & DOCUMENTATION MCP SERVERS (28-30)
  // ═══════════════════════════════════════════════════════════════════════════
  {
    id: 'MCP-28', name: 'go-mcp-docs',
    division: 'CONTEXT_DOCS',
    description: 'Documentation MCP server: fetch, search, and inject up-to-date docs into AI agent context',
    transport: 'stdio',
    capabilities: ['doc-search', 'api-lookup', 'version-check', 'changelog-access', 'example-retrieval'],
    commands: ['search', 'lookup', 'versions', 'changelog', 'examples', 'types', 'guides'],
    integrations: ['DevDocs', 'MDN', 'npm-docs', 'PyPI-docs'],
  },
  {
    id: 'MCP-29', name: 'go-mcp-knowledge-base',
    division: 'CONTEXT_DOCS',
    description: 'Knowledge base MCP server: RAG-powered retrieval from internal docs, wikis, and runbooks',
    transport: 'sse',
    capabilities: ['semantic-retrieval', 'keyword-search', 'document-ingestion', 'chunk-management', 'relevance-scoring'],
    commands: ['search', 'ingest', 'list-sources', 'get-document', 'update-index', 'delete-source'],
    integrations: ['Pinecone', 'Weaviate', 'Chroma', 'pgvector'],
  },
  {
    id: 'MCP-30', name: 'go-mcp-context-manager',
    division: 'CONTEXT_DOCS',
    description: 'Context management MCP server: manage AI agent context windows with smart retrieval and caching',
    transport: 'stdio',
    capabilities: ['context-assembly', 'token-counting', 'relevance-ranking', 'cache-management', 'context-compression'],
    commands: ['assemble', 'count-tokens', 'rank', 'cache-get', 'cache-set', 'compress', 'summarize'],
    integrations: ['tiktoken', 'LLM-APIs', 'vector-stores'],
  },
];

/** Get MCP server by ID */
export function getMcpServerById(id: string): GoMcpServer | undefined {
  return GO_MCP_SERVERS.find(s => s.id === id);
}

/** Get MCP servers by division */
export function getMcpServersByDivision(division: string): GoMcpServer[] {
  return GO_MCP_SERVERS.filter(s => s.division === division);
}
