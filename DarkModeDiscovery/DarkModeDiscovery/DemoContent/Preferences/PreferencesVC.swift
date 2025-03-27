//
//  PreferencesVC.swift
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

import ConsolePerseusLogger
import PerseusDarkMode

class PreferencesViewController: NSViewController {

    @IBOutlet private(set) weak var buttonNSAppAppearance: NSButton!
    @IBOutlet private(set) weak var buttonEffectiveAppearance: NSButton!
    @IBOutlet private(set) weak var segmentedControl: NSSegmentedControl!

    @IBAction func segmentedControlValueChanged(_ sender: NSSegmentedCell) {
        changeDarkModeValue(selected: sender.selectedSegment)
    }

    @IBAction func buttonPDMStyleTapped(_ sender: NSButton) {
        log.message("1 = \(DarkModeAgent.shared.style)")
    }

    @IBAction func buttonPDMSystemStyleTapped(_ sender: NSButton) {
        log.message("2 = \(DarkModeAgent.shared.systemStyle)")
    }

    @IBAction func buttonAppleInterfaceStyleTapped(_ sender: NSButton) {
        let value = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
        log.message("3 = \(String(describing: value))")
    }

    @IBAction func buttonNSAppAppearanceTapped(_ sender: NSButton) {
        if #available(macOS 10.14, *) {
            log.message("4 = \(String(describing: NSApp.appearance))")
        }
    }

    @IBAction func buttonEffectiveAppearanceTapped(_ sender: NSButton) {
        if #available(macOS 10.14, *) {
            let dm = NSApp.windows.first?.effectiveAppearance.bestMatch(
                from: [.darkAqua, .vibrantDark])
            log.message("5 = \(String(describing: dm))")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredContentSize = NSSize(width: self.view.frame.size.width,
                                           height: self.view.frame.size.height)

        if #unavailable(macOS 10.14) {
            buttonNSAppAppearance.isEnabled = false
            buttonEffectiveAppearance.isEnabled = false
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.blue.cgColor

        self.parent?.view.window?.title = self.title!
        updateDarkModeOption()
    }

    private func updateDarkModeOption() {
        switch DarkModeAgent.DarkModeUserChoice {
        case .auto:
            segmentedControl.selectedSegment = 2
        case .on:
            segmentedControl.selectedSegment = 1
        case .off:
            segmentedControl.selectedSegment = 0
        }
    }

    private func changeDarkModeValue(selected: Int) {
        switch selected {
        case 0:
            DarkModeAgent.forceDarkMode(.off)
        case 1:
            DarkModeAgent.forceDarkMode(.on)
        case 2:
            DarkModeAgent.forceDarkMode(.auto)
        default:
            break
        }
    }
}
