---
# Primary agent / AGENTS.md-adjacent agent definition.
# For standalone primary agents under agents/<name>.md.
# AGENTS.md rule-policy authoring (which rules go in AGENTS.md, reject-first discipline)
# is handled by the AGENTS.md-maintenance behavior — NOT this template.

name: <!-- agent name, lowercase-hyphenated -->

description: >
  <!-- One-sentence role. Routing agents and humans read this.
       Describe the job boundary, not the implementation.
       Example: "General-purpose execution agent. Use for multi-step coding tasks,
       research, and file edits in the workspace." -->

model: <!-- provider/model-id — pin explicitly. Same tier guide as subagents. -->

temperature: <!-- 0.2 for deterministic execution; 0.5 for planning/research -->

<!-- Permission profile — choose one base profile or build custom:
  cli:   broad terminal (mostly allow bash, git, file ops)
  build: broad workspace-dev (allow test/lint/format/install)
  files: paths/metadata/hashes only (no shell, no net)
  chat:  cloud-only (no local file or shell access)
  narrow workers: explicit deny everything not needed

  Rule order: broad "*": deny first, specific overrides last.
  Permission is approval UX, not OS sandbox — narrow allowlists still preferred. -->

tools:
  read: true
  write: <!-- true/false -->
  edit: <!-- true/false -->
  bash: <!-- true/false -->
  glob: true
  grep: true
  webfetch: <!-- true/false -->
  websearch: <!-- true/false -->
  task: <!-- true/false — only if agent should spawn subagents -->

permission:
  bash:
    "*": deny
    # Narrow allowlist:
    # "git*": allow
    # "npm*": allow
  task:
    # If task: true:
    # "<subagent-name>": allow
    "*": ask

---

# <!-- Agent Name -->

<!-- Agent body: role definition, behavioral constraints, output contract.
     Short. Cover:
     - What this agent does (role boundary)
     - What it explicitly does NOT do (boundary clarity)
     - Output format if structured (e.g. ## Plan, ## Findings)
     - Stopping / refusal conditions

     Do NOT restate AGENTS.md rule-policy here. Rule-policy is the AGENTS.md-maintenance
     behavior's job. Reference that behavior by keyword if needed.

     Remove this comment before shipping. -->
