# Shards of Ember - Versions

This file tracks meaningful project milestones and scope updates.

## 0.1.0 - Foundation Vertical Slice

- Established layered architecture:
  - `GameCore` (pure Swift rules/state)
  - `GameClient` (SwiftUI + SpriteKit rendering/input)
  - `ShardsApp` (app entry)
- Implemented data-driven map loading from JSON.
- Implemented one-tile movement with collision and bounds checks.
- Added camera-follow and snappy movement animation.
- Added macOS keyboard input (arrow keys + WASD).
- Added HUD overlay for map, coordinates, and action log.
- Added core unit tests for map loading and movement behavior.

## 0.1.1 - Naming + Runtime Stability

- Renamed app identity from legacy naming to `ShardsApp`.
- Removed duplicate app entry file.
- Fixed startup resource loading paths for SwiftPM and Xcode contexts.
- Added safe fallback map to prevent launch-time hard crash if map resource is missing.

## 0.2.0 - Native Xcode Project Setup

- Generated and committed native Xcode project: `ShardsApp.xcodeproj`.
- Preserved module separation in native targets:
  - `GameCore`
  - `GameClient`
  - `ShardsApp`
  - `GameCoreTests`
- Added `project.yml` so project generation can be reproduced with XcodeGen.

## 0.2.1 - Documentation Structure

- Reworked `README.md` as a spoiler-free project overview page.
- Added `docs/DesignBible.md` for internal design mechanics and narrative references.
- Added `versions.md` for ongoing build/progress tracking.
