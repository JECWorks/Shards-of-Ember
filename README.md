# Shards of Ember

Shards of Ember is a Swift/SwiftUI + SpriteKit project building a fun 2D RPG that recalls favorites from the 80's.

The current goal is a clean, deterministic vertical slice with fast tile movement, exploration-ready map scaffolding, and a solid foundation for future systems (NPCs, puzzles, battles, dialogue, and world progression).

## Current Scope

- Tile/grid-based movement (one tile per input)
- Collision checks (blocked tiles + map bounds)
- Data-driven map loading from JSON
- SpriteKit world rendering embedded in SwiftUI
- Camera follow and quick movement animation
- Keyboard controls on macOS (arrow keys + WASD)
- Basic HUD (map name, coordinates, latest log line)
- Unit tests for core movement and map loading rules

## Architecture

The project is intentionally separated into layers:

- `GameCore` (pure Swift)
  - Game rules, map/grid types, deterministic state updates
  - No SwiftUI or SpriteKit dependencies
- `GameClient` (SwiftUI + SpriteKit)
  - Rendering, input mapping, HUD, scene sync/animation
- `ShardsApp`
  - Native app entry point and window lifecycle
- `GameCoreTests`
  - Unit tests for core logic

## Repository Layout

- `Sources/GameCore/Core`
- `Sources/GameClient/Client`
- `Sources/GameClient/Resources/Maps`
- `Sources/ShardsApp/App`
- `Tests/GameCoreTests`
- `ShardsApp.xcodeproj` (native Xcode project)
- `Package.swift` (SwiftPM build/test support)

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

## Map Data

Default map file:

- `Sources/GameClient/Resources/Maps/overworld.json`

Map JSON includes:

- `name`
- `width`, `height`
- `tiles` (flattened row-major tile IDs)
- `blockedTileIds`
- optional `spawn` (`x`, `y`)

## Project Intent

Shards of Ember prioritizes:

- Readable, beginner-friendly code
- Clear separation of game logic from rendering
- Deterministic behavior that is easy to test
- A fast, responsive feel even with placeholder visuals

