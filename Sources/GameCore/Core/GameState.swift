import Foundation

/// Canonical game state for the vertical slice.
/// This is the "single source of truth" the client renders from.
public struct GameState: Sendable {
    /// Current loaded map.
    public private(set) var map: MapData
    /// Player location on the tile grid.
    public private(set) var playerPosition: GridPos
    /// Last successful move (used by client to animate).
    public private(set) var lastMoveEvent: MoveEvent?
    /// Monotonic counter incremented on successful moves.
    /// Helps clients detect new movement events.
    public private(set) var moveSequenceNumber: Int
    /// Rolling action log shown in HUD.
    public private(set) var gameLog: [String]

    public init(map: MapData) {
        self.map = map
        self.playerPosition = map.defaultSpawn
        self.lastMoveEvent = nil
        self.moveSequenceNumber = 0
        self.gameLog = ["Entered \(map.name) at (\(playerPosition.x), \(playerPosition.y))."]
    }

    /// Public input entry point for all core actions.
    public mutating func handle(action: InputAction) {
        switch action {
        case let .move(direction):
            applyMove(direction)
        }
    }

    /// Applies movement rules and mutates state when successful.
    private mutating func applyMove(_ direction: Direction) {
        let result = MovementSystem.attemptMove(playerPosition: playerPosition, direction: direction, map: map)

        switch result {
        case let .moved(event):
            // Commit accepted movement to the canonical state.
            playerPosition = event.to
            lastMoveEvent = event
            moveSequenceNumber += 1
            appendLog("Moved \(direction.rawValue) to (\(event.to.x), \(event.to.y)).")
        case let .blocked(reason):
            // Keep position unchanged; clear move event because no animation should run.
            lastMoveEvent = nil
            appendLog(reason)
        }
    }

    /// Appends one line to the log and keeps only the latest ~20 entries.
    private mutating func appendLog(_ line: String) {
        gameLog.append(line)
        if gameLog.count > 20 {
            gameLog.removeFirst(gameLog.count - 20)
        }
    }
}
