import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const required = [
  'docs/wiki/README.md',
  'docs/wiki/Home.md',
  'docs/wiki/02-model-cards.md',
  'docs/wiki/03-coding-agent-model.md',
  'docs/wiki/04-tasking-mission-model.md',
  'docs/wiki/05-creation-app-factory-model.md',
  'docs/wiki/06-orches