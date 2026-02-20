import SwiftUI
import SpriteKit
import GameCore

/// Root gameplay screen.
/// Combines SpriteKit world rendering with a SwiftUI HUD overlay.
public struct GameView: View {
    /// Owns canonical game state for the view tree.
    @StateObject private var store: GameStore
    /// SpriteKit scene that renders/animates state.
    @State private var scene: GameScene

    /// Creates initial map + game state once when the view is constructed.
    public init() {
        let map = Self.loadInitialMap()
        let initialState = GameState(map: map)
        _store = StateObject(wrappedValue: GameStore(initialState: initialState))
        _scene = State(initialValue: GameScene(tileSize: 32))
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            // SpriteKit scene (playfield). We push state updates into it for animation.
            if #available(iOS 17.0, macOS 14.0, *) {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .onAppear {
                        // Initial sync: build map and place player without animation.
                        scene.synchronize(with: store.state, animated: false)
                    }
                    .onChange(of: store.state.moveSequenceNumber) { _, _ in
                        // Only animate when a new successful move is emitted by core state.
                        scene.synchronize(with: store.state, animated: true)
                    }
            } else {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .onAppear {
                        scene.synchronize(with: store.state, animated: false)
                    }
                    .onChange(of: store.state.moveSequenceNumber) { _ in
                        scene.synchronize(with: store.state, animated: true)
                    }
            }

            // SwiftUI overlay for debugging/gameplay status.
            HUDView(state: store.state, lastLog: store.lastLogLine)

            // Invisible macOS-only key capture bridge (arrow keys + WASD).
            MacKeyInputView { action in
                store.send(action)
                // Immediate sync so keyboard-driven updates feel responsive.
                scene.synchronize(with: store.state, animated: true)
            }
            .frame(width: 1, height: 1)
            .opacity(0.01)
        }
    }

    /// Loads the default map from bundle resources.
    private static func loadInitialMap() -> MapData {
        // SwiftPM resources may be available either inside the "Maps" folder
        // or flattened at the resource-bundle root depending on packaging context.
        let url =
            Bundle.module.url(forResource: "overworld", withExtension: "json", subdirectory: "Maps") ??
            Bundle.module.url(forResource: "overworld", withExtension: "json")

        guard let url else {
            // Keep app launchable even if resource packaging is broken.
            return fallbackMap()
        }

        do {
            let data = try Data(contentsOf: url)
            return try MapLoader.load(from: data)
        } catch {
            // Keep app launchable even if map data is malformed.
            return fallbackMap()
        }
    }

    /// Minimal emergency map used only when bundled JSON fails to load.
    private static func fallbackMap() -> MapData {
        let width = 10
        let height = 8
        var tiles = Array(repeating: 0, count: width * height)

        // Add a blocked border so collision rules are still visible.
        for x in 0..<width {
            tiles[x] = 1
            tiles[(height - 1) * width + x] = 1
        }
        for y in 0..<height {
            tiles[y * width] = 1
            tiles[y * width + (width - 1)] = 1
        }

        return MapData(
            name: "Fallback Map",
            width: width,
            height: height,
            tiles: tiles,
            blockedTileIds: [1],
            spawn: .init(x: 2, y: 2)
        )
    }
}
