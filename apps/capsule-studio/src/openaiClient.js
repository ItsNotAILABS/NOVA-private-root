import { config } from './config.js';

export function openAiStatus() {
  return {
    configured: Boolean(process.env.OPENAI_API_KEY),
    model: config.openaiModel,
    mode: process.env.OPENAI_API_KEY ? 'openai' : 'local-fallback'
  };
}

export async function callOpenAIJson({ system, prompt, temperature = 0.35 }) {
  if (!process.env.OPENAI_API_KEY) throw new Error('OPENAI_API_KEY is not configured');
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'content-type': 'application/json',
      authorization: `Bearer ${process.env.OPENAI_API_KEY}`
    },
    body: JSON.stringify({
      model: config.openaiModel,
      temperature,
      messages: [
        { role: 'system', content: system },
        { role: 'user', content: prompt }
      ]
    })
  });
  const data = await response.json();
  if (!response.ok) throw new Error(data.error?.message || 'OpenAI request failed');
  const content = data.choices?.[0]?.message?.content || '';
  const start = content.indexOf('{');
  const end = content.lastIndexOf('}');
  if (start < 0 || end <= start) throw new Error('model response did not contain JSON');
  return JSON.parse(content.slice(start, end + 1));
}
