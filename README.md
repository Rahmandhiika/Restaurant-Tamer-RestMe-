# RestMe

A vertical slice of **Restaurant Tamer** — a restaurant sim where you tame a creature by cooking for it, not fighting it.

Built for the 10-Day Foundation Challenge, Apple Developer Academy Cohort 9.

## What it is

One feeding loop, end to end: a creature gets hungry, you assemble a burger from four dispensers (plate, bun, filling, meat), grill the meat with a timing-based minigame, and serve it. Grading (Perfect/Good/Low) comes from how close you pull the meat off the pan to the ideal moment.

## Tech

- **SwiftUI** — app shell
- **SpriteKit** — game scene, nodes, drag interaction (embedded via `SpriteView`)
- **MVVM** — `Models/` (pure data + logic), `ViewModels/` (state machine, no SpriteKit import), `Views/` (SwiftUI + SpriteKit rendering only)

## Scope

This is a focused prototype, not the full game — one recipe, one creature at a time, no pantry/inventory system. It exists to prove out three things: game design (grading, timing), game logic and state (the feeding loop's state machine), and SpriteKit (drag-and-drop, physics, animation).
