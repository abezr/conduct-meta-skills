# Copilot Session Economics

Copilot premium requests are not equivalent to token-priced chat calls. For coherent agentic tasks, one high-quality prompt can amortize a premium request across substantial autonomous work.

Use Copilot large-session mode when:
- the task is one coherent product slice, issue, app, scaffold, or refactor;
- the goal can be expressed upfront with strong acceptance criteria;
- the repo boundary is simple;
- output can be reviewed after completion;
- expected Claude/Codex usage is several sessions or a large token budget;
- steering comments can be avoided or limited to one blocker correction.

Avoid it when:
- task needs frequent steering;
- each correction would become another premium request;
- problem is small enough for one focused Claude/Codex pass;
- strict step-by-step supervision is required;
- task crosses multiple repositories;
- fast interactive debugging is needed.
