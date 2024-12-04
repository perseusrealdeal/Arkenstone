//
//  ItemImageView.swift
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

class ItemImageView: NSImageView {

    override var image: NSImage? {
        get {
            return super.image
        }
        set {
            super.image = newValue
            self.layer?.contents = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()

        if let img = image {
            self.image = img
        }
    }

    private func configure() {
        self.layer = CALayer()
        self.layer?.cornerRadius = 25.0
        self.layer?.masksToBounds = true

        self.wantsLayer = true
    }
}
