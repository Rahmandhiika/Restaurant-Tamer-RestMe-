# Handoff
## Date
2026-09-08
## From
Codex
## Objective
Finish manual iPad verification of the committed one-lane feeding loop after the cooking-state and creature-lifecycle correction.
## Context & constraints
- MVVM is enforced: `ViewModels/` must never `import SpriteKit` or hold an `SKNode` — only expose state/decisions. `Views/` only renders and forwards input, no decision logic. See root `CLAUDE.md` / `AGENTS.md`.
- Dev/testing parameter values live in `Models/GameConfig.swift` (seconds, not the final minutes — see PRD §6 table for final values before demo).
- Never add AI co-authorship trailers to commits (explicit repo convention).
- Don't commit `docs/*.md` (gitignored, local-only) or add new root-level markdown besides `CLAUDE.md`/`AGENTS.md`.
- Scene is landscape-only by design (`INFOPLIST_KEY_UISupportedInterfaceOrientations_i{Phone,iPad}` restricted in `project.pbxproj`) — this is intentional, not a bug, matches the hi-fi Figma reference (iPad Pro 11").
- The `docs/PRD.md` §5 exclusion list is real scope discipline — don't add pantry/inventory systems, Boss, breeding, exploration, multi-creature, or screen navigation without checking it first.
- Simulator testing quirk (not a code issue): a freshly booted simulator resets to portrait "hardware" orientation even though the app is landscape-locked, which renders content sideways until you rotate the simulator itself (Simulator app → Device → Rotate Right, or Cmd+Right Arrow). Do this after every fresh boot before screenshotting.
- Building `xcodebuild` with `-derivedDataPath` pointed inside the iCloud-synced project folder fails codesign (`resource fork, Finder information... not allowed`) — iCloud stamps xattrs that codesign rejects. Always build to a path outside iCloud sync, e.g. `-derivedDataPath /tmp/RestMe-build`.

## What was done
- Imported `BunIsian`, `BunDoneMeat`, and `DoneMeatIsian` imagesets from the developer's exported PNGs. All are 512×512 RGBA and the iOS asset build passed.
- Recorded the mid-review design revision: assembly inputs become taps, cooking will demonstrate SpriteKit touch/update, and only the completed plate plus burger remains draggable.
- **Mid-review revision** (committed): replaced ingredient drag-to-serve with `FeedingViewModel.tap(_:)` plate-first assembly. `AssemblyVisual` maps all seven food states to a single sprite above the separate `Plate`; `GameScene.update(_:)` advances Pan cooking. RawMeat changes to DoneMeat at the green-zone entry and only then can be tapped into the plate. At 100%, it becomes BurnMeat that must be dragged to Trash. A filled dish can be dragged to Trash, and the `Plate` + `BurgerV2` parent node can be dragged to the creature. The developer's layout edits are preserved.
- **Creature lifecycle correction** (committed): `FeedingState` now represents cooldown, appearance, waiting, hungry, and celebration. `GameScene` renders initial appearance at 3 seconds, then `Emotion4` + `BubbleChat` Burger order 1 second after appearance begins, and short `Emotion2` happy response before fade-out/cooldown. No new creatures or FIFO lanes were added.
- **Pan rendering correction** (committed): `GameScene` previously re-read `@Published` properties from Combine sinks, which displayed the old value because `@Published` emits in `willSet`. Each sink now passes its emitted value into the renderer. DoneMeat therefore hides immediately after transfer, and BurnMeat shows immediately at 100%. Patty offset is `(-8, -4)` with 175pt node size. Food calibration is BunIsian +12pt, BunDoneMeat +20pt, BurgerV2 +18pt; Bubble Burger is 120pt.
- **Progress-bar asset integration** (uncommitted): `ProgressBarTrack` and `ProgressBarFill` now render in a reusable SpriteKit crop node. The Pan bar fills left-to-right while cooking and retains the code-native green-zone marker, sized and offset from the 512px asset's actual visible pill (`120×14.5pt`, `y: -2.4pt`) so it does not float. A second bar above the Burger bubble starts full and shrinks during the creature's `feedingCycleTimeout`. `FeedingViewModel` owns `orderProgress`; expiration clears food/cooking and begins cooldown. State spec and iOS build pass.
- **10-Day scope audit**: Core loop mechanics are present. The remaining completion work is visible `Perfect`/`Good`/`Low` meat feedback, a grade-specific creature reaction, blocking dispenser input outside `.hungry`, and a brief timeout result before cooldown. Keep all four additions inside the existing MVVM boundaries; no new systems or content are authorized by this audit.
- **Slice 1** (commit `067e235`): `GameConfig`/`Grade` models, `GameScene` renders `FullBackground` + `CreatureNode` (fades in), `ContentView` moved into `Views/` and embeds `SpriteView`. Locked iPhone/iPad orientation to landscape-only.
- **Slice 2** (commit `e53254e`): `FeedingState` enum, `FeedingViewModel` (ObservableObject, no SpriteKit import) schedules `.hungry` after `initialHungerDelay + random(hungerRandomWindow)`. `GameScene` subscribes via Combine and shows `Emotion4` above the creature when hungry.
- **Slice 3** (commit `245487b`, fixed in `5362c0c`): 4 static dispenser sprites (Plate/PlateBun/PlateIsian/PlateRawMeat) rendered as a 2x2 grid on the left kitchen counter, matching the hi-fi mockup — not draggable yet. (First attempt split them 2-and-2 flanking the stove; developer caught this from a reference screenshot and it was corrected same session.)
- **Uncommitted, hand-edited by the developer directly in Xcode** (not by an agent): in `RestMe/Views/GameScene.swift` — creature position moved from `(0.62, 0.68)` to `(0.38, 0.62)` of scene size (now left-of-center instead of right), hunger indicator x-offset changed from `+0` to `+20` relative to creature, dispenser grid row y-values changed from `290/110` to `280/160`. Also, 5 other files (`FeedingState.swift`, `GameConfig.swift`, `Grade.swift`, `FeedingViewModel.swift`, `CreatureNode.swift`) picked up Xcode's auto-generated file-header comments with no functional change — safe to ignore or commit as-is.
- Ran the `cross-agent-handoff` bootstrap this session (`.agent/` and `AGENTS.md` already existed from a prior Codex session — read, not recreated).

## Evidence / tests
- No XCTest target in the project — verification has been build (`xcodebuild ... -derivedDataPath /tmp/RestMe-build`) + launch on iPad Pro 11-inch (M5) simulator + screenshot, for each slice, checked against docs/PRD.md acceptance criteria and the hi-fi mockup reference the developer shared inline.
- The uncommitted layout tweak (creature/hunger-indicator/dispenser positions) was run and visually confirmed by the developer per Codex's prior `DECISIONS.md` D-002. MCP Figma inspection then set the single plate slot to `(910, 285)` and retained the developer-set Pan at `(518, 320)`; the iOS build passed.
- `RestMeTests/FeedingViewModelAssemblySpec.swift` first failed for the new food offsets and deterministic spawn parameters, then passed after implementation. It also covers plate-first rejection, all seven food visuals, green-zone gating before DoneMeat transfer, BurnMeat discard/retry, filled-plate discard, and serving reset. `xcodebuild` for the iOS Simulator also passes. UI automation could not capture the Simulator interaction because it timed out.

## Decisions
See `.agent/DECISIONS.md` D-001 through D-015. D-008 is superseded by D-010.

## Files changed
- Committed: `RestMe/Models/{GameConfig,Grade,FeedingState}.swift`, `RestMe/ViewModels/FeedingViewModel.swift`, `RestMe/Views/{ContentView,GameScene,CreatureNode}.swift`, `RestMe.xcodeproj/project.pbxproj` (orientation lock), `.gitignore` (added `build/`).
- Committed: the developer's retained layout/header edits, revised tap/cooking source, `RestMeTests/FeedingViewModelAssemblySpec.swift`, and `RestMe/Assets.xcassets/{BunIsian,BunDoneMeat,DoneMeatIsian}.imageset`.

## Blockers
Manual iPad verification is still needed. Do not reintroduce the superseded ingredient drag-to-serve flow, automatic expired-meat reset, or multi-lane flow. Figma frame `1:2` was inspected through MCP and shows four pans plus four plate slots; the developer confirmed the current slice intentionally uses only its upper-left Pan and plate slot.

## What to do next
1. Add a minimal visible Perfect/Good/Low result and grade-specific creature response, without moving decision logic into `GameScene`.
2. Reject all ingredient taps until state is `.hungry`.
3. Show a short timeout result before cooldown, then verify both bars and timeout on iPad.
4. Keep the developer's `GameConfig.swift` and `GameScene.swift` timing/position edits intact.
