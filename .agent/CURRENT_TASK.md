# Current Task
## Task
Mid-review revision — cooking-state and creature-lifecycle correction
## Objective
Tap plate, bun, and isian dispensers to update one food sprite above the persistent plate; use SpriteKit touch/update for cooking; only collect DoneMeat after it reaches the green zone, drag BurnMeat to Trash, and show the creature's delayed hungry/order then post-serve happy lifecycle.
## Status
implemented — plate-first tap assembly, combination-sprite swaps, and final burger drag are implemented. RawMeat becomes DoneMeat when it reaches the green zone; it cannot transfer before then, and it becomes BurnMeat at 100% until discarded in Trash. Pan rendering consumes Combine event values directly, fixing the stale DoneMeat sprite after transfer and at timeout. Filled-plate Trash detection uses the Trash frame so the dragged dish cannot cover the target. Visual calibration: patty `(-8, -4)`, BunIsian `+12pt`, BunDoneMeat `+20pt`, BurgerV2 `+18pt`, Bubble Burger `120pt`. The creature begins appearing at 3 seconds, then shows emotion/bubble 1 second later. The state spec and iOS build pass; manual iPad verification remains.
