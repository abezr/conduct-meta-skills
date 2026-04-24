# Trigger Evaluation Protocol

Verify that the skill activates when it should and stays quiet when it should not.

Required files:

```text
references/evals/
  should_trigger.md
  should_not_trigger.md
  near_miss.md
```

Use at least 5 should-trigger prompts, 5 should-not-trigger prompts, and 3 near-miss prompts.

Pass rule:
- all should-trigger cases are covered by description/activation;
- all should-not-trigger and near-miss cases are excluded by clear boundaries;
- ambiguous cases are documented rather than ignored.
