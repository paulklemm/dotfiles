// Tints each screen's menu bar in the colour of its visible rift workspace:
// solid on the focused screen, faint on the others. Refreshes on SIGUSR1, sent by
// the subscriptions in ~/.config/rift/config.toml. Needs "Show menu bar background" turned off in
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

// The display UUID as rift reports it, e.g. "A891EEEC-ACC9-44BD-9BD6-17526B8CF185".
func displayUUID(_ screen: NSScreen) -> String? {
    guard let number = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber,
          let uuid = CGDisplayCreateUUIDFromDisplayID(number.uint32Value)?.takeRetainedValue() else { return nil }
    return CFUUIDCreateString(nil, uuid) as String
}

func refresh() {
    let rift = Process()
    let output = Pipe()
    rift.executableURL = URL(fileURLWithPath: "/opt/homebrew/bin/rift-cli")
    rift.arguments = ["query", "workspaces"]
    rift.standardOutput = output
    guard (try? rift.run()) != nil else { return }
    let data = output.fileHandleForReading.readDataToEndOfFile()
    guard let workspaces = (try? JSONSerialization.jsonObject(with: data)) as? [[String: Any]] else { return }
    let screens = NSScreen.screens.map(displayUUID)
    for workspace in workspaces where workspace["is_active"] as? Bool == true {
        guard let name = workspace["name"] as? String, let uuid = workspace["display_uuid"] as? String,
              let screen = screens.firstIndex(of: uuid), bands.indices.contains(screen) else { continue }
        let color = colors[name] ?? otherWorkspaces
        let alpha = workspace["is_focused"] as? Bool == true ? focusedAlpha : unfocusedAlpha
        bands[screen].backgroundColor = color.withAlphaComponent(alpha)
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
