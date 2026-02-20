import Foundation

/// A coordinate on the tile grid.
/// - Important: `(0, 0)` is the top-left tile in map data.
public struct GridPos: Hashable, Codable, Sendable {
    /// Horizontal tile index.
    public var x: Int
    /// Vertical tile index.
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    /// Convenience value used as a default/fallback spawn.
    public static let zero = GridPos(x: 0, y: 0)
}

/// The four movement directions available in this vertical slice.
public enum Direction: String, Codable, Sendable {
    case up
    case down
    case left
    case right

    /// Converts a direction into a one-tile movement delta.
    /// Example: `.left` -> `(-1, 0)`.
    public var delta: (dx: Int, dy: Int) {
        switch self {
        case .up: return (0, -1)
        case .down: return (0, 1)
        case .left: return (-1, 0)
        case .right: return (1, 0)
        }
    }
}

/// Inputs understood by the core game rules.
/// Keep this platform-agnostic so keyboard/touch input can map into it.
public enum InputAction: Sendable {
    case move(Direction)
}

/// Event emitted when movement is accepted.
/// The client layer uses this for animation from `from` to `to`.
public struct MoveEvent: Equatable, Sendable {
    public let from: GridPos
    public let to: GridPos

    public init(from: GridPos, to: GridPos) {
        self.from = from
        self.to = to
    }
}
