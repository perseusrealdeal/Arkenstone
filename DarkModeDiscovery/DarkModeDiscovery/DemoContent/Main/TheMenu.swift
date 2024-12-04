//
//  TheMenu.swift, MainMenu.xib
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

class TheMenu: NSMenu {

    @IBOutlet private weak var settingsMenuItem: NSMenuItem! {
        didSet {
            if #available(macOS 10.14, *) {
                settingsMenuItem.title = "Settings..."
            }
        }
    }
}
