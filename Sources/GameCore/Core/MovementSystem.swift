import Foundation

/// Result of asking the movement system to move one tile.
public enum MoveResult: Equatable, Sendable {
    /// Move accepted, includes old/new positions.
    case moved(MoveEvent)
    /// Move rejected, includes a user-facing reason for HUD/log.
    case blocked(String)
}

/// Stateless movement + collision rules.
/// Keeping this pure makes behavior deterministic and easy to unit test.
public enum MovementSystem {
    /// Attempts a single tile move.
    /// - Returns: `.moved` when valid, `.blocked` when out-of-bounds or colliding.
    public static func attemptMove(playerPosition: GridPos, direction: Direction, map: MapData) -> MoveResult {
        let delta = direction.delta
        let candidate = GridPos(x: playerPosition.x + delta.dx, y: playerPosition.y + delta.dy)

        // Rule 1: prevent walking outside map bounds.
        guard map.isInBounds(candidate) else {
            return .blocked("Bumped into the edge of the world.")
        }

        // Rule 2: prevent walking onto blocked tiles.
        guard !map.isBlocked(candidate) else {
            return .blocked("The path is blocked.")
        }

        // Rule 3: accepted move emits a move event for animation/logging.
        return .moved(MoveEvent(from: playerPosition, to: candidate))
    }
}
