import Foundation
import GameCore

/// Main-actor observable wrapper around `GameState` for SwiftUI.
/// UI sends input actions through this store; store mutates core state.
@MainActor
public final class GameStore: ObservableObject {
    /// Published so SwiftUI redraws HUD/scene bindings after state changes.
    @Published public private(set) var state: GameState

    public init(initialState: GameState) {
        self.state = initialState
    }

    /// Handles one input action by forwarding it to core logic.
    public func send(_ action: InputAction) {
        state.handle(action: action)
    }

    /// Convenience value for HUD display.
    public var lastLogLine: String {
        state.gameLog.last ?? ""
    }
}
