//
//  MainWindowController.swift, MainWindowController.storyboard
//  DarkModeDiscovery
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
//

import Cocoa

import ConsolePerseusLogger
import PerseusDarkMode

class MainWindowController: NSWindowController, NSWindowDelegate {

    private lazy var optionsController = { () -> NSWindowController in
        let name = "\(OptionsWindowController.self)"
        let storyboard = NSStoryboard(name: NSStoryboard.Name(name), bundle: nil)
        let screen = storyboard.instantiateInitialController() as? NSWindowController

        return screen ?? NSWindowController()
    }()

    private lazy var mapController = { () -> NSWindowController in
        let name = "\(MapWindowController.self)"
        let storyboard = NSStoryboard(name: NSStoryboard.Name(name), bundle: nil)
        let screen = storyboard.instantiateInitialController() as? NSWindowController

        return screen ?? NSWindowController()
    }()

    private lazy var loggerWC = { () -> NSWindowController in
        return LoggerWindowController.storyboardInstance()
    }()

    override func windowDidLoad() {
        super.windowDidLoad()

        // Connect to Dark Mode explicitly
        DarkModeAgent.register(stakeholder: self, selector: #selector(makeUp))
    }

    @objc private func makeUp() {
        log.message("[\(type(of: self))].\(#function)")

        let isDark = DarkMode.style == .dark
        let title = isDark ? "Erebor" : "The Lonely Mountain"

        if #available(macOS 10.14, *) {
            self.window?.title = title
        } else {  // For HighSierra only.
            self.windowTitle(forDocumentDisplayName: title)
        }

        if #unavailable(macOS 10.14) { // For HighSierra.
            window?.appearance = isDark ?
            DARK_APPEARANCE_DEFAULT_IN_USE : LIGHT_APPEARANCE_DEFAULT_IN_USE
        }
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        log.message("[\(type(of: self))].\(#function)", .info)
        return true
    }

    func windowWillClose(_ notification: Notification) {
        log.message("[\(type(of: self))].\(#function)", .info)
    }

    @IBAction func showOptions(_ sender: NSMenuItem) {
        optionsController.showWindow(sender)
    }

    @IBAction func showMap(_ sender: NSMenuItem) {
        mapController.showWindow(sender)
    }

    @IBAction func showLogger(_ sender: Any) {
        loggerWC.showWindow(sender)
    }
}
