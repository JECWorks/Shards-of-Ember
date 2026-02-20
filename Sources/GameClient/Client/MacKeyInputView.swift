import SwiftUI
import GameCore

#if os(macOS)
import AppKit

/// AppKit bridge that captures keyboard events inside a SwiftUI hierarchy.
public struct MacKeyInputView: NSViewRepresentable {
    /// Callback used to send mapped actions into `GameStore`.
    public let onAction: (InputAction) -> Void

    public init(onAction: @escaping (InputAction) -> Void) {
        self.onAction = onAction
    }

    /// Creates the underlying `NSView` key-capture view.
    public func makeNSView(context: Context) -> KeyCaptureView {
        let view = KeyCaptureView()
        view.onAction = onAction
        DispatchQueue.main.async {
            // Ensure this view starts as first responder so key events arrive.
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    /// Keeps callback updated when SwiftUI recreates this representable.
    public func updateNSView(_ nsView: KeyCaptureView, context: Context) {
        nsView.onAction = onAction
    }
}

/// Hidden AppKit view dedicated to keyboard input.
public final class KeyCaptureView: NSView {
    var onAction: ((InputAction) -> Void)?

    /// Must be true to receive keyboard events.
    public override var acceptsFirstResponder: Bool { true }

    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.makeFirstResponder(self)
    }

    public override func keyDown(with event: NSEvent) {
        guard let action = action(for: event) else {
            super.keyDown(with: event)
            return
        }

        onAction?(action)
    }

    /// Converts key presses into platform-agnostic core actions.
    private func action(for event: NSEvent) -> InputAction? {
        switch event.keyCode {
        // macOS virtual key codes for arrow keys.
        case 123: return .move(.left)
        case 124: return .move(.right)
        case 125: return .move(.down)
        case 126: return .move(.up)
        default:
            guard let character = event.charactersIgnoringModifiers?.lowercased().first else {
                return nil
            }

            switch character {
            case "w": return .move(.up)
            case "a": return .move(.left)
            case "s": return .move(.down)
            case "d": return .move(.right)
            default: return nil
            }
        }
    }
}
#else
/// iOS/iPadOS placeholder so the same `GameView` compiles cross-platform.
public struct MacKeyInputView: View {
    public let onAction: (InputAction) -> Void

    public init(onAction: @escaping (InputAction) -> Void) {
        self.onAction = onAction
    }

    public var body: some View {
        EmptyView()
    }
}
#endif
