import XCTest
@testable import GameCore

/// Unit tests for deterministic `GameCore` behavior.
final class GameCoreTests: XCTestCase {
    /// Verifies JSON decoding and basic field mapping for `MapData`.
    func testMapDecoding() throws {
        let json = """
        {
          "name": "Test Map",
          "width": 4,
          "height": 3,
          "spawn": { "x": 1, "y": 1 },
          "blockedTileIds": [9],
          "tiles": [
            0,0,0,0,
            0,9,0,0,
            0,0,0,0
          ]
        }
        """.data(using: .utf8)!

        let map = try MapLoader.load(from: json)

        XCTAssertEqual(map.name, "Test Map")
        XCTAssertEqual(map.width, 4)
        XCTAssertEqual(map.height, 3)
        XCTAssertEqual(map.defaultSpawn, GridPos(x: 1, y: 1))
        XCTAssertTrue(map.blockedTileIds.contains(9))
        XCTAssertEqual(map.tileID(at: GridPos(x: 1, y: 1)), 9)
    }

    /// Moving into a blocked tile should be rejected.
    func testBlockedCollisionPreventsMove() {
        let map = makeMap()
        let result = MovementSystem.attemptMove(playerPosition: GridPos(x: 1, y: 1), direction: .right, map: map)

        switch result {
        case .moved:
            XCTFail("Expected blocked move")
        case let .blocked(message):
            XCTAssertEqual(message, "The path is blocked.")
        }
    }

    /// Moving outside map bounds should be rejected.
    func testBoundsCollisionPreventsMove() {
        let map = makeMap()
        let result = MovementSystem.attemptMove(playerPosition: GridPos(x: 0, y: 0), direction: .left, map: map)

        switch result {
        case .moved:
            XCTFail("Expected blocked move at bounds")
        case let .blocked(message):
            XCTAssertEqual(message, "Bumped into the edge of the world.")
        }
    }

    /// Successful move should update position and emit move event.
    func testSuccessfulMoveUpdatesPositionAndEvent() {
        let map = makeMap()
        var state = GameState(map: map)

        state.handle(action: .move(.down))

        XCTAssertEqual(state.playerPosition, GridPos(x: 0, y: 1))
        XCTAssertEqual(state.lastMoveEvent, MoveEvent(from: GridPos(x: 0, y: 0), to: GridPos(x: 0, y: 1)))
        XCTAssertEqual(state.moveSequenceNumber, 1)
    }

    /// Small helper map used across movement tests.
    private func makeMap() -> MapData {
        MapData(
            name: "Movement Test",
            width: 3,
            height: 3,
            tiles: [
                0, 0, 0,
                0, 0, 9,
                0, 0, 0
            ],
            blockedTileIds: [9],
            spawn: .init(x: 0, y: 0)
        )
    }
}
