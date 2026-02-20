import SwiftUI
import GameClient
#if os(macOS)
import AppKit
#endif

/// SwiftUI app entry point for the vertical slice.
@main
struct ShardsApp: App {
#if os(macOS)
    init() {
        // `swift run` launches from Terminal; explicitly become a regular foreground app.
        NSApplication.shared.setActivationPolicy(.regular)
    }
#endif

    var body: some Scene {
        WindowGroup {
            // Root gameplay screen.
            GameView()
                // Comfortable minimum window size for map + HUD on macOS.
                .frame(minWidth: 900, minHeight: 680)
#if os(macOS)
                .onAppear {
                    // Bring the new window to front when launched from CLI.
                    NSApplication.shared.activate(ignoringOtherApps: true)
                }
#endif
        }
    }
}
