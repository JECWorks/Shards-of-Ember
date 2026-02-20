import Foundation
import SpriteKit
import GameCore

/// SpriteKit scene responsible for visualizing the current `GameState`.
/// Important: this scene never decides game rules; it only renders/animates.
@MainActor
public final class GameScene: SKScene {
    /// Pixel size of one tile in the visual world.
    private let tileSize: CGFloat
    /// Parent container for map tiles + player sprite.
    private let worldNode = SKNode()
    /// Scene camera that follows the player.
    private let cameraNode2D = SKCameraNode()
    /// Placeholder player sprite (simple shape for vertical slice).
    private let playerNode = SKShapeNode(rectOf: CGSize(width: 24, height: 24), cornerRadius: 4)

    /// Last map used to build tile visuals.
    private var currentMap: MapData?
    /// Prevents rebuilding map every frame/state update.
    private var hasBuiltMap = false
    /// Tracks which movement event has already been animated.
    private var lastAppliedMoveSequence = -1

    public init(tileSize: CGFloat = 32) {
        self.tileSize = tileSize
        super.init(size: CGSize(width: 960, height: 720))
        scaleMode = .resizeFill
        backgroundColor = .black
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func didMove(to view: SKView) {
        // Attach world graph once.
        if worldNode.parent == nil {
            addChild(worldNode)
        }

        // Attach camera once.
        if camera == nil {
            addChild(cameraNode2D)
            camera = cameraNode2D
        }
    }

    /// Sync entry point from SwiftUI/GameStore.
    /// Rebuilds map when needed and animates only when a new move is published.
    public func synchronize(with state: GameState, animated: Bool = true) {
        // Rebuild visual map if first sync or map changed.
        if !hasBuiltMap || currentMap?.name != state.map.name {
            buildMap(state.map)
            positionPlayer(at: state.playerPosition)
            centerCamera(on: state.playerPosition)
            lastAppliedMoveSequence = state.moveSequenceNumber
            return
        }

        // Animate only successful, not-yet-rendered move events.
        if state.moveSequenceNumber != lastAppliedMoveSequence,
           let move = state.lastMoveEvent {
            lastAppliedMoveSequence = state.moveSequenceNumber
            animateMove(move, animated: animated)
        } else {
            // Keep visuals snapped to canonical state.
            positionPlayer(at: state.playerPosition)
            centerCamera(on: state.playerPosition)
        }
    }

    /// Builds the tile map as simple sprite nodes from map tile IDs.
    private func buildMap(_ map: MapData) {
        worldNode.removeAllChildren()

        let mapWidth = CGFloat(map.width) * tileSize
        let mapHeight = CGFloat(map.height) * tileSize
        // Center map around world origin for simpler camera math.
        let origin = CGPoint(x: -mapWidth / 2, y: -mapHeight / 2)

        for y in 0..<map.height {
            for x in 0..<map.width {
                let pos = GridPos(x: x, y: y)
                // Placeholder colored tiles until art pipeline is introduced.
                let tile = SKSpriteNode(color: color(for: map.tileID(at: pos) ?? 0, map: map), size: CGSize(width: tileSize, height: tileSize))
                tile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                tile.position = CGPoint(
                    x: origin.x + (CGFloat(x) * tileSize) + tileSize / 2,
                    y: origin.y + (CGFloat(y) * tileSize) + tileSize / 2
                )
                worldNode.addChild(tile)
            }
        }

        setupPlayerNode()
        worldNode.addChild(playerNode)

        hasBuiltMap = true
        currentMap = map
    }

    /// Styles the player placeholder shape.
    private func setupPlayerNode() {
        playerNode.fillColor = .systemYellow
        playerNode.strokeColor = .white
        playerNode.lineWidth = 2
        playerNode.zPosition = 10
    }

    /// Runs short linear movement animation for player + camera.
    private func animateMove(_ move: MoveEvent, animated: Bool) {
        let toPoint = point(for: move.to)
        playerNode.removeAllActions()
        cameraNode2D.removeAllActions()

        // Target snappy feel (~0.08-0.12 sec per tile).
        let duration: TimeInterval = animated ? 0.1 : 0.0
        let playerMove = SKAction.move(to: toPoint, duration: duration)
        playerMove.timingMode = .linear

        let cameraMove = SKAction.move(to: toPoint, duration: duration)
        cameraMove.timingMode = .linear

        playerNode.run(playerMove)
        cameraNode2D.run(cameraMove)
    }

    /// Instantly positions player node at a grid tile.
    private func positionPlayer(at gridPos: GridPos) {
        playerNode.position = point(for: gridPos)
    }

    /// Instantly centers camera on a grid tile.
    private func centerCamera(on gridPos: GridPos) {
        cameraNode2D.position = point(for: gridPos)
    }

    /// Converts grid coordinates to SpriteKit world coordinates.
    private func point(for gridPos: GridPos) -> CGPoint {
        guard let map = currentMap else { return .zero }

        let mapWidth = CGFloat(map.width) * tileSize
        let mapHeight = CGFloat(map.height) * tileSize
        let origin = CGPoint(x: -mapWidth / 2, y: -mapHeight / 2)

        return CGPoint(
            x: origin.x + (CGFloat(gridPos.x) * tileSize) + tileSize / 2,
            y: origin.y + (CGFloat(gridPos.y) * tileSize) + tileSize / 2
        )
    }

    /// Temporary color palette keyed by tile ID.
    /// Blocked tiles use a darker tone for readability.
    private func color(for tileID: Int, map: MapData) -> SKColor {
        if map.blockedTileIds.contains(tileID) {
            return SKColor(red: 0.23, green: 0.23, blue: 0.27, alpha: 1.0)
        }

        switch tileID {
        case 0: return SKColor(red: 0.18, green: 0.62, blue: 0.26, alpha: 1.0)
        case 1: return SKColor(red: 0.20, green: 0.45, blue: 0.82, alpha: 1.0)
        case 2: return SKColor(red: 0.55, green: 0.45, blue: 0.31, alpha: 1.0)
        default: return SKColor(red: 0.16, green: 0.58, blue: 0.22, alpha: 1.0)
        }
    }
}
