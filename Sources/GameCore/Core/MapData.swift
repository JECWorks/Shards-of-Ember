import Foundation

/// Fully decoded map data loaded from JSON.
/// This type is intentionally UI-framework free so it stays testable and portable.
public struct MapData: Codable, Sendable {
    /// Optional spawn position included in map JSON.
    public struct Spawn: Codable, Sendable {
        public let x: Int
        public let y: Int

        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }

        public var gridPos: GridPos { GridPos(x: x, y: y) }
    }

    /// Display name for HUD/logging.
    public let name: String
    /// Map width in tiles.
    public let width: Int
    /// Map height in tiles.
    public let height: Int
    /// Flattened row-major tile IDs (`index = y * width + x`).
    public let tiles: [Int]
    /// Any tile IDs in this set are considered blocked/non-walkable.
    public let blockedTileIds: Set<Int>
    /// Optional spawn location from JSON.
    public let spawn: Spawn?

    public init(name: String, width: Int, height: Int, tiles: [Int], blockedTileIds: Set<Int>, spawn: Spawn?) {
        self.name = name
        self.width = width
        self.height = height
        self.tiles = tiles
        self.blockedTileIds = blockedTileIds
        self.spawn = spawn
    }

    /// Spawn position used when creating `GameState`.
    /// Falls back to `(0,0)` when the map has no explicit spawn.
    public var defaultSpawn: GridPos {
        spawn?.gridPos ?? .zero
    }

    /// Returns `true` if a grid position is inside the map bounds.
    public func isInBounds(_ pos: GridPos) -> Bool {
        pos.x >= 0 && pos.y >= 0 && pos.x < width && pos.y < height
    }

    /// Returns the tile ID at a position, or `nil` when outside bounds.
    public func tileID(at pos: GridPos) -> Int? {
        guard isInBounds(pos) else { return nil }
        return tiles[(pos.y * width) + pos.x]
    }

    /// Returns whether the position cannot be walked on.
    /// Out-of-bounds is treated as blocked for safety.
    public func isBlocked(_ pos: GridPos) -> Bool {
        guard let tileID = tileID(at: pos) else { return true }
        return blockedTileIds.contains(tileID)
    }
}

/// JSON decoding + validation helper.
/// Keeps file/resource concerns outside the `MapData` model itself.
public enum MapLoader {
    /// Decodes map JSON and validates dimensions, tile count, and spawn bounds.
    public static func load(from data: Data) throws -> MapData {
        let decoder = JSONDecoder()
        let map = try decoder.decode(MapData.self, from: data)
        try validate(map)
        return map
    }

    /// Basic structural validation so invalid maps fail fast.
    private static func validate(_ map: MapData) throws {
        guard map.width > 0, map.height > 0 else {
            throw MapError.invalidDimensions
        }
        guard map.tiles.count == map.width * map.height else {
            throw MapError.invalidTileCount(expected: map.width * map.height, actual: map.tiles.count)
        }
        if let spawn = map.spawn {
            let pos = GridPos(x: spawn.x, y: spawn.y)
            guard map.isInBounds(pos) else {
                throw MapError.invalidSpawn(pos)
            }
        }
    }
}

/// Map loading/validation failures used by tests and caller diagnostics.
public enum MapError: Error, Equatable {
    case invalidDimensions
    case invalidTileCount(expected: Int, actual: Int)
    case invalidSpawn(GridPos)
}
