# minion-master

Execution rules for one frozen, bounded repository mission.

<!------------------------------------------------------------------------------------------------->
## Design intent
<!------------------------------------------------------------------------------------------------->

Keep nested execution local: caller freezes intent; executor plans, optionally uses leaf workers, integrates, and validates.

<!------------------------------------------------------------------------------------------------->
## When it triggers
<!------------------------------------------------------------------------------------------------->

Complete multi-step repository mission needs an integration owner without user dialogue.

<!------------------------------------------------------------------------------------------------->
## Maintainer constraints
<!------------------------------------------------------------------------------------------------->

Keep this skill small. Put only executor behavior here; ordinary worker selection stays in `minion-delegation`.

<!------------------------------------------------------------------------------------------------->
## See also
<!------------------------------------------------------------------------------------------------->

- [`../minion-delegation/SKILL.md`](../minion-delegation/SKILL.md)
- [`../../agents/minion-master.md`](../../agents/minion-master.md)
