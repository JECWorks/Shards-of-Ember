# Shards of Ember - Systems

This document defines gameplay mechanics and systemic progression rules.

## Core Systems Goals

- Reward restoration-oriented play
- Make progression feel systemic, not purely statistical
- Keep mechanics deterministic and testable where possible
- Provide clear, fair feedback for consequence systems

## Crown and Shard Progression

- The Crown is the central progression framework.
- Each shard corresponds to one major systemic capability.
- Recovered shards should unlock:
  - Traversal opportunities
  - Puzzle interactions
  - Dialogue/quest options
  - Safety or control in hostile zones

## Shard Unlock Summary

- Concord: social de-escalation, companion trust, economic goodwill effects
- Justice: lawful resolution paths, civic authority challenges, tribunal outcomes
- Illumination: hints, illusion/corruption reveal, light puzzle interaction
- Stewardship: land restoration, blight clearing, resource/healing quality
- Clarity: hidden path detection, code/rune deciphering, lie detection
- Resolve: fear/corruption resistance, ambush mitigation, "stand firm" branches

## Greed System (Hidden Worthiness Metric)

Design intent:

- Prevent pure extraction play from trivially reaching true restoration ending
- Reinforce thematic distinction between stewardship and domination

Rules:

- Certain luxury loot increases hidden Greed.
- Survival-oriented gear and essentials do not increase Greed.
- Repeated warning signals are provided via hermit dialogue and context clues.
- Excessive Greed gates final progression (information withheld or seal rejection).

Fairness requirements:

- Consistent cause/effect patterns
- Multiple warning opportunities before lockout risk
- No single irreversible "gotcha" action

## Restoration State System

- Track restoration progress globally and by county.
- Returning shards should drive:
  - Visual world-state updates
  - NPC disposition changes
  - Service/economy improvements
  - New safe routes or reduced hazards

## Implementation Direction

- Keep core progression state in `GameCore`.
- Keep unlock definitions data-driven (JSON or static data tables).
- Prefer composable rule checks over hardcoded scene-specific logic.
- Add unit tests for:
  - Unlock gating rules
  - Greed threshold behavior
  - Restoration state transitions
