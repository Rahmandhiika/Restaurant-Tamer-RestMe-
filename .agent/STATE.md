# State
## Last updated
2026-09-08
## Last agent
Codex
## Summary
Slices 1–3 and the revised tap-based feeding loop are committed on `main`. Plate/bun/isian use taps, raw meat moves to Pan and advances through SpriteKit `update(_:)`, turns into DoneMeat on entering the green zone, and becomes BurnMeat at 100% until dragged to Trash. A filled plate can be dragged to Trash to discard it, and a completed plate plus burger can be dragged to the creature. The creature now waits offscreen, fades in, then shows its hungry emotion and Burger bubble; after a serve it briefly shows the happy emotion, fades out, and restarts after cooldown. Combination imagesets are imported; the standalone state spec and iOS build pass. Manual iPad verification remains before acceptance.

**Figma reference inspected (2026-09-08).** MCP read frame `1:2` in `HiFi-RestMe` at the same 1194×834 canvas size. It depicts four active pans and four plate slots, a future FIFO direction. The developer confirmed this slice remains one creature, one upper-left pan, and one upper-left plate slot. Do not expand to multi-order behavior in this slice.

The single plate slot is now centered at `(910, 285)` through `GameConfig.serveArea`; the developer's Pan remains `(518, 320)`. The iOS build passed after this Figma-aligned position update.

Pan patty size is `175pt` with a `(-8pt, -4pt)` calibration offset. The Pan renderer uses the emitted Combine value directly, so clearing DoneMeat now immediately hides the Pan sprite and reaching 100% immediately displays BurnMeat. The Pan, patty, progress fill, and green-zone outline share the same tap target. A raw patty cannot be collected before the green zone. The BurnMeat node is the only Pan state draggable to Trash.

Current dev timing is deterministic: creature appearance begins at 3 seconds; the hungry emotion and Burger bubble appear 1 second after appearance begins. Bubble Burger is 120pt. Food-sprite calibration is `BunIsian +12pt`, `BunDoneMeat +20pt`, and `BurgerV2 +18pt`.

**Docs moved out for privacy (2026-09-07).** `PRD.md`, `PROGRESS.md`, and `ARCHITECTURE.md` now live at:
`/Users/rahmandhika/Library/Mobile Documents/com~apple~CloudDocs/Documents/Kehidupan Dika/02 Projects/RestMe/docs/`
`ARCHITECTURE.md` was extracted from `AGENTS.md`'s old "Arsitektur — MVVM, wajib" section (moved whole, no gotcha/bug-log entanglement to sort out here unlike ROBLOX-PRALAYA — it was already a clean, self-contained block).
They were already gitignored locally before this (deliberate, predates this convention) — this just moves the actual files off this machine's local-only copy into the backed-up vault instead, consistent with how ROBLOX-PRALAYA was retrofitted the same day. `CLAUDE.md`/`AGENTS.md` were also consolidated: `AGENTS.md` is now the single canonical rules file (was two near-duplicate files, Claude/Codex find-replaced from each other), `CLAUDE.md` is now a 1-line pointer to it, and both are pushed (previously `CLAUDE.md` was gitignored). **`.agent/` itself is now pushed too** (was untracked). Reminder for any agent working here: this repo's `AGENTS.md` explicitly forbids adding a `Co-Authored-By` trailer to commits — likely an academic-integrity requirement for the Apple Developer Academy submission — don't apply the usual default attribution here.
