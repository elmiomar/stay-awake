import Cocoa

struct CaffeinateOption {
    let flag: String
    let label: String
    var enabled: Bool
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var caffeinateProcess: Process?
    let caffeinatePath = "/usr/bin/caffeinate"

    var options: [CaffeinateOption] = [
        CaffeinateOption(flag: "-d", label: "Prevent display sleep", enabled: true),
        CaffeinateOption(flag: "-i", label: "Prevent idle sleep", enabled: false),
        CaffeinateOption(flag: "-s", label: "Prevent system sleep", enabled: false),
        CaffeinateOption(flag: "-m", label: "Prevent disk sleep", enabled: false),
    ]

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            if let image = NSImage(systemSymbolName: "moon.zzz.fill", accessibilityDescription: "StayAwake") {
                image.isTemplate = true
                button.image = image
            }
            button.toolTip = "StayAwake — Mac will not sleep"
        }

        guard FileManager.default.fileExists(atPath: caffeinatePath) else {
            let alert = NSAlert()
            alert.messageText = "Cannot Run StayAwake"
            alert.informativeText = "'caffeinate' was not found at \(caffeinatePath). This built-in macOS utility is required for StayAwake to work."
            alert.alertStyle = .critical
            alert.runModal()
            NSApp.terminate(nil)
            return
        }

        buildMenu()
        startCaffeinate()
    }

    func buildMenu() {
        let menu = NSMenu()

        for (index, option) in options.enumerated() {
            let item = NSMenuItem(title: option.label, action: #selector(toggleOption(_:)), keyEquivalent: "")
            item.tag = index
            item.state = option.enabled ? .on : .off
            menu.addItem(item)
        }

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Turn Off & Quit", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    @objc func toggleOption(_ sender: NSMenuItem) {
        options[sender.tag].enabled.toggle()

        // Ensure at least one option stays on
        if !options.contains(where: { $0.enabled }) {
            options[sender.tag].enabled = true
            return
        }

        buildMenu()
        startCaffeinate()
    }

    func startCaffeinate() {
        caffeinateProcess?.terminate()
        caffeinateProcess?.waitUntilExit()

        let args = options.filter { $0.enabled }.map { $0.flag }
        caffeinateProcess = Process()
        caffeinateProcess?.executableURL = URL(fileURLWithPath: caffeinatePath)
        caffeinateProcess?.arguments = args
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

// Quit if already running
let myBundleId = Bundle.main.bundleIdentifier ?? "com.one1.stayawake"
let running = NSRunningApplication.runningApplications(withBundleIdentifier: myBundleId)
if running.count > 1 {
    NSApp.terminate(nil)
}

let delegate = AppDelegate()
app.delegate = delegate
app.run()
