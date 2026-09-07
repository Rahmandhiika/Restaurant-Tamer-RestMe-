# Decisions
## D-001 — Shared handoff files adopted
Decision: Use `.agent/STATE.md`, `CURRENT_TASK.md`, `DECISIONS.md`, and `HANDOFF.md` as the shared status record for work by the developer, Claude Code, and Codex.
Reason: Conversation history is not shared between tools, while the project directory is the source of truth.
Status: Accepted
Date: 2026-09-06

## D-002 — Current scene layout retained
Decision: Retain the current creature, hunger-emote, and dispenser positions in `GameScene.swift`.
Reason: The developer ran the app and confirmed the placement matches the intended layout.
Status: Accepted
Date: 2026-09-06

## D-003 — Assembly rejects duplicate ingredients
Decision: `FeedingViewModel` records placed ingredients and rejects a duplicate drop.
Reason: Each fixed recipe component should appear at most once before later slices replace the assembled items with one burger node.
Status: Accepted
Date: 2026-09-06
