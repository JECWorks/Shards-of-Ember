# Shards of Ember - Roadmap

This is the active implementation plan and to-do tracker.

## Current Phase

Vertical slice foundation is complete (movement, map rendering, HUD, tests, docs baseline).

## Milestone 1 - World Data Backbone

- Define data models for:
  - Counties
  - Barons
  - Shards
  - Unlock conditions/effects
- Add initial JSON content for world structure.
- Load and validate world data in `GameCore`.
- Add tests for decoding and rule validation.

## Milestone 2 - Progression Skeleton

- Add shard inventory/state tracking.
- Add basic unlock gating system hooks.
- Add restoration progress tracker (global + county).
- Surface progression state in HUD/debug panel.

## Milestone 3 - Narrative Skeleton

- Build narrative state model for:
  - Story beats
  - Hermit arc stages
  - County completion state
- Implement simple event flags and quest progression checks.
- Add developer-facing debug commands for progression testing.

## Milestone 4 - Systems Integration

- Integrate first shard ability into map traversal or interaction.
- Add early Greed tracker scaffolding and warning signals.
- Add deterministic tests for progression + consequence rules.

## Milestone 5 - Content Pass (Placeholder)

- Implement one complete county loop:
  - County exploration
  - Baron dungeon
  - Shard recovery
  - Return-to-Ember restoration update
- Validate pacing and readability of progression feedback.

## Ongoing Quality Standards

- Fully comment new/modified code for beginner readability.
- Keep README spoiler-free and public-facing.
- Update `versions/` snapshots at meaningful milestones.
- Keep design docs in sync with implemented systems.
