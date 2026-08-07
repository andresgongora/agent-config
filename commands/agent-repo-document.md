---
description: Document the repository itself (files, structure, dependencies, architecture, key entry points) as durable current-state memory
license: MIT
metadata:
  author: andresgongora
---
Document the REPOSITORY, not this session, not a diff, not chat history. Target: what files exist, how they're structured, what depends on what, the architecture, and which files matter most for a future agent to know about. `$ARGUMENTS` given: limit scan and output to that subdir or topic only. Absent: whole-repo scope.

Use durable-documentation write discipline. In order:

1. `.agent/` missing, or a subfolder this command needs (e.g. `notes/`) is missing: CREATE it now unconditionally, before inventory, no ask. Folder creation is not gated on step 5's outcome — it happens regardless of whether any doc file ends up written.
2. Inventory existing durable docs. Delegate: encourage — bounded read-only locate/inventory fits.
3. Scan the repo itself: top-level layout, entry points, language/tooling, real dependencies (lockfiles/manifests, not guesses), module boundaries, files a future agent must know about first. Verify from disk, not memory. Delegate: encourage — bounded read-only locate/inventory fits.
4. Classify each candidate fact: durable repo truth (disk-verified: structure, deps, architecture) vs transient session narration (diffs, todos, chat). Write only the former. Never write an unverified claim as fact. Delegate: prohibit — needs judgment on what's durable.
5. Update or create only durable repo-state doc files. Prune stale, duplicate, resolved, or misleading info. Keep current-state snapshot present tense, not a changelog and not a session log. No durable fact to add or change: valid terminal outcome — write no doc file (folders from step 1 still stand). Delegate: allow only after classification is decided — bounded single-file edit may apply the write; main thread keeps the judgment call.

Report: docs created (including any `.agent/` folders created), docs changed, docs removed, current risks/limitations retained, and in-scope docs left untouched with reason. No commit, staging, push, or unrelated edits.
