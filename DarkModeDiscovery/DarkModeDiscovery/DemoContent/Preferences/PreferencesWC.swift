//
//  PreferencesWindowController.swift, Preferences.storyboard
//  DarkModeDiscovery
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7531 - 7533 PerseusRealDeal
//
//  Licensed under the special license. See LICENSE file.
//  All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()

        window?.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        if #available(macOS 10.14, *) { self.window?.title = "Settings..." }
    }
}
