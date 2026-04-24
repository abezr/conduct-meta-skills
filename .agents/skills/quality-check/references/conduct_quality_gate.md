# Conduct Quality Gate

A conducted task passes quality only when:

- task goal and acceptance criteria are documented;
- routing decision is documented;
- budget check passed or conservative mode was intentionally used;
- plan exists for high-risk or large tasks;
- implementation final report exists;
- read-only review exists or was explicitly waived;
- validation output is captured;
- deployment logs are checked when deployment happened;
- context files are updated;
- repeated failure produced `SKILL_CANDIDATE.md`;
- no unresolved blocker remains.

Blockers:
- no final report;
- no review for a risky code-changing task;
- budget unknown but expensive execution was started;
- deployment happened without post-deploy log check;
- same failure repeated without skill preservation.
