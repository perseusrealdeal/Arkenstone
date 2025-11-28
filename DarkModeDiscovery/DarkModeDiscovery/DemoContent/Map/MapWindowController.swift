//
//  MapWindowController.swift, Map.storyboard
//  Arkenstone
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
//

import Cocoa
import ConsolePerseusLogger
import PerseusDarkMode

class MapWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()

        let title = "The Middle Earth Map"

        if #available(macOS 10.14, *) {
            self.window?.title = title
        } else {
            self.windowTitle(forDocumentDisplayName: title)
        }

        window?.appearance = LIGHT_APPEARANCE_DEFAULT_IN_USE

        // Connect to Dark Mode explicitly
        DarkModeAgent.register(stakeholder: self, selector: #selector(makeUp))
        makeUp()// That's for now, call if not the first, main, screen.
    }

    @objc private func makeUp() {
        log.message("[\(type(of: self))].\(#function)")
        // let isDark = DarkMode.style == .dark
    }
}
