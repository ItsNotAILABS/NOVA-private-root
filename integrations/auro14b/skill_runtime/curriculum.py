from __future__ import annotations
import json
SYSTEM = "You are Auro. Route to named skills, answer concisely, and never claim execution without a receipt."
CURATED = {
 "matdaemon-math-verification":[("Compute accuracy from 17 correct of 20.","Accuracy = 17/20 = 0.85. Record numerator, denominator, formula, and result in the receipt."),("Validate a benchmark mean of 0.7, 0.8, and 0.9.","Arithmetic mean = (0.7 + 0.8 + 0.9) / 3 = 0.8. Preserve all inputs in the proof receipt.")],
 "capsula-governed-execution":[("Run an untrusted script.","Route to CAPSULA. Deny direct host execution, use an isolated sandbox, enforce limits, and return an execution receipt."),("A command requests a private key.","Refuse the command. Secret access is outside the governed execution boundary; emit a denial receipt.")],
 "brain-ai-cognitive-continuity":[("Preserve identity after a restart.","Persist identity anchors, unresolved tensions, salient memories, and adaptation weights; resume from the latest verified snapshot."),("Stress is high and energy is low.","Lower action intensity, prioritize recovery, retain the unresolved goal, and record the state transition.")],
 "mesie-spectral-reasoning":[("Coherence drops during a burst.","Measure phase dispersion, reduce integration pressure, enter recovery, and consolidate only after coherence stabilizes."),("Describe the MESIE cycle.","latent -> attentive -> burst -> integration -> consolidation -> recovery, with receipts at each transition.")],
 "nova-code-execution":[("Patch a repository safely.","Inspect the failing path, make one focused change, run targeted tests, then the full gate, and preserve the diff and test receipt."),("An API test fails.","Reproduce the failure, isolate the contract mismatch, patch the smallest surface, and rerun the exact test before release.")],
 "auro-model-production":[("Improve a noisy checkpoint.","Identify the weakest critical gate, change one falsifiable data or architecture variable, retrain, and compare exact-checkpoint evidence."),("Can this micro model be called 14B?","No. Parameter count must be proven by the checkpoint configuration and manifest; architecture-lane membership is not parameter evidence.")],
 "skill-library-routing":[("Route a model-training request that also executes code.","Primary: auro-model-production. Dependencies: capsula-governed-execution and matdaemon-math-verification."),("Route a memory-and-coherence request.","Use brain-ai-cognitive-continuity with mesie-spectral-reasoning; inject only those skill contexts.")],
}
CODE_DRILLS=[("Write add_integers(a, b).","def add_integers(a: int, b: int) -> int:\n    return a + b"),("Write reverse_text(value).","def reverse_text(value: str) -> str:\n    return value[::-1]"),("Write factorial(n) with validation.","def factorial(n: int) -> int:\n    if n < 0:\n        raise ValueError('n must be non-negative')\n    result = 1\n    for value in range(2, n + 1):\n        result *= value\n    return result"),("Write mean(values) and reject empty input.","def mean(values: list[float]) -> float:\n    if not values:\n        raise ValueError('values must not be empty')\n    return sum(values) / len(values)")]
COMPOSE=[("Train, benchmark, and sandbox generated code.",["auro-model-production","matdaemon-math-verification","capsula-governed-execution"]),("Patch a repository and produce quantitative proof.",["nova-code-execution","matdaemon-math-verification","capsula-governed-execution"]),("Preserve identity while analyzing MESIE coherence.",["brain-ai-cognitive-continuity","mesie-spectral-reasoning"]),("Discover and route the best organs for a task.",["skill-library-routing"])]
IMPECCABLE=[
 ("Audit a generated dashboard for AI design slop.","Route to impeccable-design-quality. Preserve the existing design system, detect excessive cards, gratuitous gradients, weak hierarchy, inaccessible contrast, and non-responsive layout; return a design-quality receipt."),
 ("Improve a frontend without replacing its visual identity.","Use IMPECCABLE to inherit tokens, typography, spacing, and component conventions. Change only evidence-backed defects and verify responsive and accessible behavior."),
 ("How should adaptive organ weights change after a successful UI repair?","Apply a bounded Hebbian increase to the active IMPECCABLE and CODEX organs, strengthen their co-activation link, then use Kuramoto phase coupling to update coherence gain. Persist an adaptation receipt."),
 ("How should failed organ routing affect weights?","Apply a bounded negative reward, decay all weights toward the neutral prior, preserve floor and ceiling limits, update phases, and record the failure receipt without rewriting checkpoint parameters."),
]
def curriculum_records(lib):
 rows=[]
 def add(user,assistant,skill,kind): rows.append((SYSTEM,user,assistant,skill,kind))
 for name,skill in lib.skills.items():
  for trigger in skill.triggers[:4]:
   for variant in range(4): add(f"Task {variant+1}: handle {trigger} using the correct internal organ.",f'<|skill_call|>{{"skills":["{name}"]}}<|skill_result|> Route to {name} ({skill.organ}). {skill.description}',name,"routing")
  for user,answer in CURATED[name]:
   for variant in range(3): add(f"{user} Variation {variant+1}.",answer,name,"demonstration")
  add(f"State the scope of {name}.",f"{name} is the {skill.organ} organ. Capabilities: {', '.join(skill.capabilities)}. Risk: {skill.risk}.",name,"organ-card")
  add(f"Summarize one trusted reference for {name}.",skill.body[:900].replace("<|","["),name,"reference-excerpt")
 for user,source in CODE_DRILLS:
  for variant in range(6): add(f"{user} Return only valid Python. Drill {variant+1}.",f"```python\n{source}\n```","nova-code-execution","code-drill")
 for user,skills in COMPOSE:
  for variant in range(4): add(f"{user} Composition {variant+1}.",f"<|skill_call|>{json.dumps({'skills':skills},separators=(',',':'))}<|skill_result|> Use the listed organs in order and preserve receipts.","composed","composition")
 for user,answer in IMPECCABLE:
  for variant in range(8): add(f"{user} Design cycle {variant+1}.",answer,"impeccable-design-quality","design-adaptation")
 return rows
