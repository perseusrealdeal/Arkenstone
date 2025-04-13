//
//  MainWindowController.swift, MainWindowController.storyboard
//  DarkModeDiscovery
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7530 - 7533 PerseusRealDeal
//
//  Licensed under the special license. See LICENSE file.
//  All rights reserved.
//

import Cocoa
import ConsolePerseusLogger

class MainWindowController: NSWindowController, NSWindowDelegate {

    private lazy var optionsController = { () -> NSWindowController in
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Options"), bundle: nil)
        let screen = storyboard.instantiateInitialController() as? NSWindowController

        return screen ?? NSWindowController()
    }()

    private lazy var mapController = { () -> NSWindowController in
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Map"), bundle: nil)
        let screen = storyboard.instantiateInitialController() as? NSWindowController

        return screen ?? NSWindowController()
    }()

    override func windowDidLoad() {
        super.windowDidLoad()

        DarkModeAgent.register(stakeholder: self, selector: #selector(makeUp))
        makeUp()
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
}
