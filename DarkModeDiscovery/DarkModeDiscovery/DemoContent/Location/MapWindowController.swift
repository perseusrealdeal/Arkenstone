//
//  MapWindowController.swift, Map.storyboard
//  Arkenstone
//
//  Created by Mikhail Zhigulin in 7533 (18.03.2025).
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7531 - 7533 PerseusRealDeal
//
//  Licensed under the special license. See LICENSE file.
//  All rights reserved.
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

        DarkModeAgent.register(stakeholder: self, selector: #selector(makeUp))
        makeUp()
    }

    @objc private func makeUp() {
        log.message("[\(type(of: self))].\(#function)")
        if #unavailable(macOS 10.14) { // For HighSierra only.

            let isDark = DarkMode.style == .dark

            window?.appearance = isDark ?
            DARK_APPEARANCE_DEFAULT_IN_USE : LIGHT_APPEARANCE_DEFAULT_IN_USE
        }
    }
}
