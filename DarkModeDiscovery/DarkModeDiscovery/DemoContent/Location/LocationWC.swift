//
//  LocationWC.swift, Location.storyboard
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

class LocationWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()

        if #available(macOS 10.14, *) { self.window?.title = "Map" }
    }
}
