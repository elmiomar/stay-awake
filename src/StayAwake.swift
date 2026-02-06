import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var caffeinateProcess: Process?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            if let image = NSImage(systemSymbolName: "moon.zzz.fill", accessibilityDescription: "StayAwake") {
                image.isTemplate = true
                button.image = image
            }
            button.toolTip = "StayAwake — Mac will not sleep"
        }

        let menu = NSMenu()
        let infoItem = NSMenuItem(title: "StayAwake is ON", action: nil, keyEquivalent: "")
        infoItem.isEnabled = false
        menu.addItem(infoItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Turn Off & Quit", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu

        let caffeinatePath = "/usr/bin/caffeinate"
        guard FileManager.default.fileExists(atPath: caffeinatePath) else {
            let alert = NSAlert()
            alert.messageText = "Cannot Run StayAwake"
            alert.informativeText = "'caffeinate' was not found at \(caffeinatePath). This built-in macOS utility is required for StayAwake to work."
            alert.alertStyle = .critical
            alert.runModal()
            NSApp.terminate(nil)
            return
        }

        caffeinateProcess = Process()
        caffeinateProcess?.executableURL = URL(fileURLWithPath: caffeinatePath)
        caffeinateProcess?.arguments = ["-d"]
        try? caffeinateProcess?.run()
    }

    func applicationWillTerminate(_ notification: Notification) {
        caffeinateProcess?.terminate()
    }

    @objc func quit() {
        caffeinateProcess?.terminate()
        NSApp.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
