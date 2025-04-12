//
//  CustomColors.swift
//  DarkModeDiscovery
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7531 PerseusRealDeal
//
//  Licensed under the special license. See LICENSE file.
//  All rights reserved.
//

import AppKit
// import PerseusDarkMode

public protocol CustomColorsProtocol {

    static var customChosenOne: NSColor { get }

    static var customLabel: NSColor { get }

    static var customShortText: NSColor { get }

    static var customLongText: NSColor { get }

}

extension NSColor: CustomColorsProtocol {

    public static var customChosenOne: NSColor {
        return DarkModeAgent.shared.style == .light ?
            rgba255(255, 255, 255) : rgba255(255, 255, 255, 0.6)
    }

    public static var customLabel: NSColor {
        return DarkModeAgent.shared.style == .light ?
            rgba255(255, 255, 255, 0.9) : rgba255(235, 235, 245, 0.6)
    }

    public static var customShortText: NSColor {
        return DarkModeAgent.shared.style == .light ?
            rgba255(255, 255, 255) : rgba255(235, 235, 245, 0.6)
    }

    public static var customLongText: NSColor {
        return DarkModeAgent.shared.style == .light ?
        rgba255(255, 255, 255, 0.9) : rgba255(235, 235, 245, 0.6)
    }
}
