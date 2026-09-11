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

## D-004 — Plate stays separate from combination food sprites
Decision: Keep `Plate` as the persistent base node and swap one food sprite (`Bun`, pair combinations, or `BurgerV2`) above it.
Reason: Mid-review feedback calls for tap-based assembly and combination visuals without layering individual toppings; the final plate plus burger can still move as one group.
Status: Accepted
Date: 2026-09-07

## D-005 — Only the completed dish uses drag
Decision: Plate, bun, isian, and raw meat are selected through SpriteKit taps; only the completed plate plus `BurgerV2` is draggable to the creature.
Reason: This follows the mid-review feedback while keeping `touchesBegan`, `touchesMoved`, `touchesEnded`, and `update(_:)` visible in the vertical slice.
Status: Accepted
Date: 2026-09-08

## D-006 — Figma's four slots are deferred FIFO capacity
Decision: Keep one upper-left Pan and one upper-left plate slot for this slice; treat the other three Pan and plate positions in Figma as future FIFO capacity.
Reason: The current loop has one creature and one sequential order, while the fuller Figma visual anticipates simultaneous preparation later.
Status: Accepted
Date: 2026-09-08

## D-007 — Single plate uses Figma's upper-left slot
Decision: Center the slice's only serve plate at `(910, 285)` and retain the developer-set upper-left Pan at `(518, 320)`.
Reason: These coordinates align the one-lane slice with Figma frame `1:2` while keeping the remaining slots out of scope.
Status: Accepted
Date: 2026-09-08

## D-008 — Superseded: expired meat resets; Trash discards a filled plate
Decision: At the end of the cooking bar, raw meat disappears and the player may tap raw meat again. Trash accepts a dragged plate only after it has an ingredient, clearing the whole dish.
Reason: Superseded by D-010 after direct playtest feedback.
Status: Superseded
Date: 2026-09-08

## D-009 — Pan overlay remains tappable
Decision: Use the ingredient-sized patty in Pan and name the Pan, progress fill, and green-zone outline as the same tap target.
Reason: The player should be able to tap any visible part of the cooking station to move DoneMeat to the plate, without a small sprite or bar overlay blocking input.
Status: Accepted
Date: 2026-09-08

## D-010 — Cooking has visible raw, done, and burned states
Decision: RawMeat remains raw before the green zone, switches to DoneMeat as soon as it enters that zone, and switches to BurnMeat at 100%. Only DoneMeat can be tapped into the plate; BurnMeat must be dragged to Trash before another raw meat can start.
Reason: This keeps the timing skill check legible and prevents a premature Pan tap from bypassing it.
Status: Accepted
Date: 2026-09-08

## D-011 — Creature enters and leaves as a visible order cycle
Decision: Start with no visible creature, fade it in after a short delay, then show hungry emotion plus the Burger bubble. A successful serve shows the happy emotion briefly, followed by fade-out and cooldown before the next appearance.
Reason: The lifecycle makes one creature/order feel intentional while remaining within the single-lane slice.
Status: Accepted
Date: 2026-09-08

## D-012 — Pan renderer uses emitted values, not a re-read of `@Published`
Decision: Each cooking publisher sends its emitted progress, cooking flag, or visual directly to its SpriteKit rendering method.
Reason: `@Published` emits before its wrapped property stores the new value. Re-reading the ViewModel inside the subscriber displayed DoneMeat one transition late, leaving it visible after transfer and delaying BurnMeat until another interaction.
Status: Accepted
Date: 2026-09-08

## D-013 — Progress bar uses separate track and fill assets
Decision: Use `ProgressBarTrack` for the static gray bar and dynamically reveal `ProgressBarFill` from left to right for cooking progress. Keep the green-zone marker code-native.
Reason: Separating static pixel art from changing progress preserves the rounded fill artwork while still communicating live cooking state.
Status: Accepted
Date: 2026-09-08

## D-014 — Creature order bar counts down above the BubbleChat
Decision: Reuse the track/fill asset pair above the Burger bubble while the creature is hungry. It starts full and shrinks to empty over `feedingCycleTimeout`; expiration clears the active food/cooking state and enters cooldown.
Reason: The visible countdown communicates the order deadline using the same visual language as the cooking timing bar without adding another screen element.
Status: Accepted
Date: 2026-09-08

## D-015 — Finish acceptance gaps before adding content
Decision: The next implementation work is limited to visible meat grade feedback, grade-specific creature reaction, a `.hungry` gate for dispenser input, and a short timeout result before cooldown.
Reason: These are the remaining PRD completion criteria. Inventory, multiple creature lanes, audio, and navigation do not strengthen this 10-Day vertical slice and remain out of scope.
Status: Accepted
Date: 2026-09-08

## D-016 — App icon pairs the companion with its burger
Decision: Use a happy red-orange creature hugging a large burger as the single app-icon concept, with warm pixel-art styling, brown outlines, a small blue plate accent, no text, and an opaque square background.
Reason: The combined silhouette conveys cooking and creature companionship at small sizes; the user delegated selection of one direction. Deliver the PNG separately without changing gameplay or assigning the Xcode catalog.
Status: Superseded by D-017
Date: 2026-09-08

## D-017 — Original sprite identity guides the revised app icon
Decision: Keep the creature-and-burger concept, using the user's original Aseprite exports as references for the longer muzzle, left curled tail, burger layers and white-gray plate. Deliver V2 separately and preserve V1.
Reason: The source sprites provide a more faithful visual reference than the earlier descriptive brief; their plate color replaces the invented blue accent. Imagegen still interprets the sprites rather than reproducing their exact pixels.
Status: Accepted
Date: 2026-09-08

## D-018 — Supplied artwork becomes the universal iOS app icon
Decision: Assign the exact supplied artwork to the universal `AppIcon` slot after a proportional resize from 1254×1254 to 1024×1024. Leave optional dark and tinted variants empty.
Reason: One opaque 1024×1024 source is sufficient for Xcode to generate the required iPhone and iPad icon sizes, while preserving the approved composition and avoiding unrequested alternate artwork.
Status: Accepted
Date: 2026-09-08

## D-019 — Burned meat remains serveable as Low
Decision: A player may drag BurnMeat to a plate that has no meat, completing the fixed recipe with a Low grade; it may still be dragged to Trash. Meat taken in the green zone is Perfect, while meat taken after the zone and before burning is Good. The monster shows Emotion3 while awaiting food, then Emotion1/Emotion2/Emotion4 for Perfect/Good/Low respectively; timeout also uses Emotion4 briefly.
Reason: This preserves the grill timing consequence without forcing a full restart after one burned patty. It supersedes D-010 only where that decision required BurnMeat to go exclusively to Trash.
Status: Accepted
Date: 2026-09-10

## D-020 — Grill uses a Good threshold and a final Perfect zone
Decision: Replace the middle green zone with a white Good threshold at 50%. Meat remains unavailable before the threshold, becomes tappable as Good after it, and is Perfect only in the final 15% green zone. Missing that final zone automatically inserts Low meat into the current plate; neither DoneMeat nor BurnMeat is draggable.
Reason: The player has a clear fallback choice at mid-bar, while Perfect remains a deliberate last-moment risk. Automatic Low keeps the player choosing with the completed dish instead of making them manage a separate failed-meat object.
Status: Accepted
Date: 2026-09-10
