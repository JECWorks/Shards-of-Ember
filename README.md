# Shards of Ember

Shards of Ember is a new indie RPG project in Swift, built as a fun 2D adventure that recalls favorites from the 80's.

It blends tile-based exploration, classic role-playing progression, and modern architecture choices that keep systems clean, testable, and easy to evolve over time.

This repository contains the playable prototype and the technical foundation for the full game.

## Why This Project Exists

Shards of Ember is being developed with a focus on:

- Tight, responsive game feel
- Data-driven world design
- Clear system boundaries (game logic separated from rendering)
- Beginner-friendly, well-commented code
- Long-term maintainability as game scope grows

## Tech Stack

- Swift
- SwiftUI
- SpriteKit
- Native Xcode project (`ShardsApp.xcodeproj`)
- Swift Package support (`Package.swift`) for CLI build/test workflows

## Running the Project

### Xcode (recommended)

1. Open `ShardsApp.xcodeproj`
2. Select scheme `ShardsApp`
3. Run on `My Mac`

### SwiftPM CLI

```bash
swift run ShardsApp
```

Run tests:

```bash
swift test
```

## Repository Structure

- `Sources/GameCore/Core` - deterministic game rules/models
- `Sources/GameClient/Client` - rendering, input, UI integration
- `Sources/GameClient/Resources/Maps` - data-driven maps
- `Sources/ShardsApp/App` - app entry point and lifecycle
- `Tests/GameCoreTests` - core unit tests
- `docs/DesignBible.md` - internal game design direction (contains spoilers)
- `versions.md` - running development update log

## Documentation Notes

This README intentionally avoids story spoilers.

For development/design details, see:

- `docs/DesignBible.md` for game systems and narrative structure
- `versions.md` for feature progress and build history
