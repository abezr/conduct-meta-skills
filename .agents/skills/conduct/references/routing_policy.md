# Routing Policy

Choose the cheapest safe provider route balancing premium requests, estimated token burn, time-window limits, steering needs, review needs, risk, and context-transfer cost.

Routes:
- Copilot large-session.
- Claude/Codex token-window.
- Mixed plan → Copilot → review.
- Read-only plan-only.

## Matrix

| Task shape | Route | Reason |
|---|---|---|
| Small localized bug | Claude/Codex | Cheaper than a full Copilot session |
| Large coherent feature/app | Copilot large-session | Premium request can be amortized |
| Broad refactor with clear rules | Copilot or mixed | Good if steering is low |
| Ambiguous design | Read-only plan first | Avoid expensive unclear execution |
| High-risk production | Plan → implement → review | Control matters more than raw cost |
| Repeated failures | Stop and preserve skill | Do not spend more before extracting lesson |
