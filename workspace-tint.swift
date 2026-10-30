// Tints each screen's menu bar in the colour of its visible AeroSpace workspace:
// solid on the focused screen, faint on the others. Refreshes on SIGUSR1, sent by
// the callbacks in aerospace.toml. Needs "Show menu bar background" turned off in
// System Settings, as that background hides the tint.
//
// Build: swiftc -O ~/.dotfiles/workspace-tint.swift -o ~/.local/bin/workspace-tint
import AppKit

func rgb(_ hex: Int) -> NSColor {
    NSColor(srgbRed: CGFloat(hex >> 16 & 255) / 255, green: CGFloat(hex >> 8 & 255) / 255,
            blue: CGFloat(hex & 255) / 255, alpha: 1)
}

let colors: [String: NSColor] = [
    // Nord, darkened to keep white menu text readable
    "1": rgb(0x5477a1), // blue
    "2": rgb(0x647d4e), // green
    "3": rgb(0xa8624d), // orange
    "4": rgb(0x8e6a88), // purple
    "5": rgb(0xb55861), // red
]
let otherWorkspaces = rgb(0x4c566a) // polar night
let focusedAlpha = 1.0
let unfocusedAlpha = 0.22

// Just below the menu bar's own level, so its text stays on top of the tint.
let bandLevel = NSWindow.Level(rawValue: NSWindow.Level.mainMenu.rawValue - 1)

// AppKit would otherwise push these windows down below the menu bar.
class Band: NSWindow {
    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect { frameRect }
}

var bands: [NSWindow] = []

func rebuildBands() {
    bands.forEach { $0.close() }
    bands = NSScreen.screens.map { screen in
        let menuBarHeight = screen.frame.maxY - screen.visibleFrame.maxY
        let frame = NSRect(x: screen.frame.minX, y: screen.frame.maxY - menuBarHeight,
                           width: screen.frame.width, height: menuBarHeight)
        let band = Band(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
        band.isReleasedWhenClosed = false
        band.level = bandLevel
        band.ignoresMouseEvents = true
        band.hasShadow = false
        band.isOpaque = false
        band.backgroundColor = .clear
        band.animationBehavior = .none
        band.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        band.orderFrontRegardless()
        return band
    }
}

func refresh() {
    let aerospace = Process()
    let output = Pipe()
    aerospace.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/aerospace")
    aerospace.arguments = ["list-workspaces", "--monitor", "all", "--visible", "--format",
                           "%{workspace}|%{workspace-is-focused}|%{monitor-appkit-nsscreen-screens-id}"]
    aerospace.standardOutput = output
    guard (try? aerospace.run()) != nil else { return }
    let text = String(decoding: output.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
    for line in text.split(separator: "\n") {
        let fields = line.split(separator: "|")
        guard fields.count == 3, let screen = Int(fields[2]), bands.indices.contains(screen - 1) else { continue }
        let color = colors[String(fields[0])] ?? otherWorkspaces
        let alpha = fields[1] == "true" ? focusedAlpha : unfocusedAlpha
        bands[screen - 1].backgroundColor = color.withAlphaComponent(alpha)
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

signal(SIGUSR1, SIG_IGN)
let refreshSignal = DispatchSource.makeSignalSource(signal: SIGUSR1, queue: .main)
refreshSignal.setEventHandler { refresh() }
refreshSignal.resume()

NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification,
                                       object: nil, queue: .main) { _ in
    rebuildBands()
    refresh()
}

rebuildBands()
refresh()
app.run()
