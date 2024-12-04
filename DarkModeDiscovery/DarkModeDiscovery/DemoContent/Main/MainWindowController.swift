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

class MainWindowController: NSWindowController {

    private lazy var preferencesController = { () -> NSWindowController in
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Preferences"), bundle: nil)
        let screen = storyboard.instantiateInitialController() as? NSWindowController

        return screen ?? NSWindowController()
    }()

    @IBAction func showPreferences(_ sender: NSMenuItem) {
        preferencesController.showWindow(sender)
    }
}
