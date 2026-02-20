import SwiftUI
import GameCore

/// Lightweight HUD overlay shown above the SpriteKit scene.
public struct HUDView: View {
    /// Read-only snapshot of current core state.
    public let state: GameState
    /// Preformatted most recent log line.
    public let lastLog: String

    public init(state: GameState, lastLog: String) {
        self.state = state
        self.lastLog = lastLog
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Basic diagnostics/game info for the vertical slice.
            Text("Map: \(state.map.name)")
            Text("Pos: (\(state.playerPosition.x), \(state.playerPosition.y))")
            Text("Last: \(lastLog)")
                .lineLimit(2)
        }
        // Monospaced font keeps values visually aligned while moving.
        .font(.system(size: 13, weight: .medium, design: .monospaced))
        .foregroundStyle(.white)
        .padding(10)
        .background(.black.opacity(0.65), in: RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}
