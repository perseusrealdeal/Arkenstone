//
//  CompanionCollectionViewItem.swift, CompanionCollectionViewItem.xib
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
import PerseusDarkMode

class CompanionCollectionViewItem: NSCollectionViewItem {

    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected

            imageView?.layer?.borderWidth = isSelected ? 5.0 : 0.0
            callDarkModeSensitiveColours()
        }
    }

    var companion: Companion? {
        didSet {
            guard isViewLoaded else { return }

            updateCompanionView()
        }
    }

    let darkModeObserver = DarkModeObserver()

    override func viewDidLoad() {
        super.viewDidLoad()

        darkModeObserver.action = { _ in self.callDarkModeSensitiveColours() }

        callDarkModeSensitiveColours()
        updateCompanionView()
    }

    func updateCompanionView() {
        guard let friend = self.companion else { return }

        textField?.stringValue = friend.name
        imageView?.image = NSImage(named: friend.iconName)
    }

    private func callDarkModeSensitiveColours() {
        imageView?.layer?.borderColor = NSColor.customChosenOne.cgColor
        textField?.textColor = isSelected ? NSColor.customChosenOne : NSColor.black
    }
}
