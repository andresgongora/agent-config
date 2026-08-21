# File tidy

Metadata-only file-collection maintenance. Keeps file bodies outside agent context while supporting inventory, duplicate review, conservative renaming, and user-approved cleanup.

Helpers default to current directory, reject outside paths, and print aggregates unless `--show`. `safe-rename-plan` stays dry-run until `--apply`; `name-audit` finds portability risks; `space-report` shows bounded size groups.

Not disk administration or Git maintenance. Git repository found during file work: route it to version-control workflow. Never add content-reading helpers, automatic collision repair, Git reports, fetch, pruning, GC, repack, or repository rewriting.

## Local artifacts

- `SKILL.md` — runtime boundary, workflow, naming rules.
- `scripts/safe-rename-plan` — reviewed rename plan; `--apply` after approval.
- `scripts/name-audit` — portable-name risks.
- `scripts/space-report` — bounded disk-usage groups.
- `scripts/common.bash` — private shared helper; not public interface.
