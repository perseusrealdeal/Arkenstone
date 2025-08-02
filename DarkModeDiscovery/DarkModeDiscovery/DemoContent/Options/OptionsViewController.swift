//
//  OptionsViewController.swift, Options.storyboard
//  DarkModeDiscovery
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
//

import Cocoa

import ConsolePerseusLogger
import PerseusDarkMode

class OptionsViewController: NSViewController {

    @IBOutlet private(set) weak var labelLog: MessageLabel!

    @IBOutlet private(set) weak var boxPerseusDarkMode: NSBox!
    @IBOutlet private(set) weak var boxSystemDarkMode: NSBox!
    @IBOutlet private(set) weak var boxCustomCode: NSBox!

    @IBOutlet private(set) weak var labelInformation: NSTextField!
    @IBOutlet private(set) weak var segmentedControl: NSSegmentedControl!

    @IBAction func segmentedControlValueChanged(_ sender: NSSegmentedCell) {
        applyDarkMode(selected: sender.selectedSegment)
    }

    // MARK: - System Dark Mode Group Actions

    @IBAction func button1Tapped(_ sender: NSButton) {
        let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "nil"
        let text = "1 = \(isDark)"

        labelInformation.stringValue = text
        log.message(text)
    }

    @IBAction func button2Tapped(_ sender: NSButton) {
        let text = "2 = \(printApperance(NSApp.windows.first?.effectiveAppearance))"

        labelInformation.stringValue = text
        log.message(text)
    }

    @IBAction func button3Tapped(_ sender: NSButton) {
        var text = "3 = tapped"

        if #available(macOS 10.14, *) {
            text = "3 = \(printApperance(NSApplication.shared.appearance))"
        } else {
            text = "3 = only available in macOS 10.14 or newer"
        }

        labelInformation.stringValue = text
        log.message(text)
    }

    @IBAction func button4Tapped(_ sender: NSButton) {
        var text = "4 = tapped"

        if #available(macOS 11.0, *) {
            text = "4 = \(printApperance(NSAppearance.currentDrawing()))"
        } else {
            text = "4 = only available in macOS 11.0 or newer"
        }

        labelInformation.stringValue = text
        log.message(text)
    }

    // MARK: - Perseus Dark Mode Group Actions

    @IBAction func button5Tapped(_ sender: NSButton) {
        let text = "5 = \(DarkModeAgent.shared.style)"

        labelInformation.stringValue = text
        log.message(text)
    }

    @IBAction func button6Tapped(_ sender: NSButton) {
        let observableNumber = DarkModeAgent.shared.styleObservable
        let observableName = AppearanceStyle(rawValue: DarkModeAgent.shared.styleObservable)!

        let text = "6 = \(observableName) (\(observableNumber))"

        labelInformation.stringValue = text
        log.message(text)
    }

    @IBAction func button7Tapped(_ sender: NSButton) {
        let userChoice = DarkModeAgent.DarkModeUserChoice
        let text = "7 = \(userChoice)"

        labelInformation.stringValue = text
        log.message(text)
    }

    // MARK: - Custom Code Group Actions

    @IBAction func buttonATapped(_ sender: NSButton) {
        var text = "A = tapped"

        if #available(macOS 10.14, *) {
            NSApplication.shared.appearance = nil
            text = "A = NSApplication.shared.appearance = nil"
        } else {
            text = "4 = only available in macOS 10.14 or newer"
        }

        labelInformation.stringValue = text
        log.message(text)
    }

    @IBAction func buttonBTapped(_ sender: NSButton) {
        let text = "B = tapped"

        // TODO: - Anymore?

        labelInformation.stringValue = text
        log.message(text)
    }

    // MARK: - Content

    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredContentSize = NSSize(width: self.view.frame.size.width,
                                           height: self.view.frame.size.height)

        if #unavailable(macOS 10.14) { // For HighSierra only.
            boxPerseusDarkMode.isTransparent = true
            boxSystemDarkMode.isTransparent = true
            boxCustomCode.isTransparent = true
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
            labelLog.message = "Auto"
        case .on:
            segmentedControl.selectedSegment = 1
            labelLog.message = "On"
        case .off:
            segmentedControl.selectedSegment = 0
            labelLog.message = "Off"
        }
    }

    private func applyDarkMode(selected: Int) {
        switch selected {
        case 0:
            DarkModeAgent.force(.off)
            labelLog.message = "Off"
        case 1:
            DarkModeAgent.force(.on)
            labelLog.message = "On"
        case 2:
            DarkModeAgent.force(.auto)
            labelLog.message = "Auto"
        default:
            break
        }
    }
}

public func printApperance(_ appearance: NSAppearance?) -> String {
    if #available(macOS 10.14, *) {
        if appearance != nil {
            if let match = appearance?.bestMatch(from: [.darkAqua, .vibrantDark]) {
                return "\(match.rawValue)"
            }

            if let match = appearance?.bestMatch(from: [.aqua, .vibrantLight]) {
                return "\(match.rawValue)"
            }
        } else {
            return "appearance == nil"
        }
    }

    return "only available in macOS 10.14 or newer"
}
