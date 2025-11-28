//
//  LoggerViewController.swift
//  The Technological Tree
//
//  Created by Mikhail Zhigulin of Novosibirsk in 7534 (23.11.2025).
//
//  The year starts from the creation of the world in the Star temple
//  according to a Slavic calendar. September, the 1st of Slavic year.
//
//  Unlicensed Free Software
//
//  INFO:
//   Architectural points. MVP.
//   Based on [Gist](https://gist.github.com/PerseusRealDeal/5301e90881732f0cd0040e2083a78a3d).
//
//  This is LoggerViewController.swift
//
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any
//  means.
//
//  In jurisdictions that recognize copyright laws, the author or authors
//  of this software dedicate any and all copyright interest in the
//  software to the public domain. We make this dedication for the benefit
//  of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  software under copyright law.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  For more information, please refer to <http://unlicense.org/>
//

import Cocoa
import ConsolePerseusLogger
import PerseusDarkMode

class LoggerViewController: NSViewController {

    // MARK: - Presenter

    var presenter: LoggerViewPresenter?

    // MARK: - Life Circle

    override func viewDidAppear() {
        super.viewDidAppear()

        presenter?.viewDidAppear()
    }

    // MARK: - Outlets

    @IBOutlet private(set) weak var buttonClose: NSButton!

    @IBOutlet private(set) weak var buttonTurned: NSButton!
    @IBOutlet private(set) weak var buttonMarks: NSButton!
    @IBOutlet private(set) weak var buttonTime: NSButton!
    @IBOutlet private(set) weak var buttonOwner: NSButton!
    @IBOutlet private(set) weak var buttonDirrectives: NSButton!

    @IBOutlet private(set) weak var texViewMessages: NSTextView!
    @IBOutlet private(set) weak var segmentedControlOutput: NSSegmentedControl!
    @IBOutlet private(set) weak var comboBoxFormat: NSComboBox!
    @IBOutlet private(set) weak var comboBoxLevel: NSComboBox!

    // MARK: - Actions

    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.view.window?.close()
    }

    @IBAction func buttonTurnedTapped(_ sender: NSButton) {
        presenter?.forceTurned(sender.state == .on ? true : false)
    }

    @IBAction func buttonMarksTapped(_ sender: NSButton) {
        presenter?.forceMarks(sender.state == .on ? true : false)
    }

    @IBAction func buttonTimeTapped(_ sender: NSButton) {
        presenter?.forceTime(sender.state == .on ? true : false)
    }

    @IBAction func buttonOwnerTapped(_ sender: NSButton) {
        presenter?.forceOwner(sender.state == .on ? true : false)
    }

    @IBAction func buttonDirrectivesTapped(_ sender: NSButton) {
        presenter?.forceDirrectives(sender.state == .on ? true : false)
    }

    @IBAction func actionOutputDidChanged(_ sender: NSSegmentedControl) {
        presenter?.forceOutput(sender.selectedSegment)
    }

    @IBAction func actionFormatDidChanged(_ sender: NSComboBox) {
        presenter?.forceFormat(sender.stringValue)
    }

    @IBAction func actionLevelDidChanged(_ sender: NSComboBox) {
        presenter?.forceLevel(sender.indexOfSelectedItem)
    }
}

// MARK: - MVP View

extension LoggerViewController: LoggerViewDelegate {

    // MARK: - LoggerViewDelegate

    func onViewDidAppear() {
        reload()
    }

    func reloadMessages() {
        texViewMessages.string = report.text
    }

    func clear() {
        texViewMessages.string = ""
    }

    // MARK: - MVPViewDelegate

    func setupUI() {
        self.view.window?.title = "The Logger"

        buttonClose.title = "Close"

        texViewMessages.backgroundColor = .clear
        texViewMessages.textColor = .darkGray
    }

    func makeUp() {
        if isHighSierra {
            view.window?.appearance = DarkModeAgent.DarkModeUserChoice == .on ?
            DARK_APPEARANCE_DEFAULT_IN_USE : LIGHT_APPEARANCE_DEFAULT_IN_USE
        }
    }
}

// MARK: - Reload

extension LoggerViewController {

    private func reload() {

        buttonTurned.state = log.turned == .on ? .on : .off

        buttonMarks.state = log.marks == true ? .on : .off
        buttonTime.state = log.time == true ? .on : .off
        buttonOwner.state = log.owner == true ? .on : .off
        buttonDirrectives.state = log.directives == true ? .on : .off

        comboBoxFormat.removeAllItems()
        comboBoxLevel.removeAllItems()

        for item in log.MessageFormat.allCases {
            comboBoxFormat.addItem(withObjectValue: "\(item)")
        }

        for item in log.Level.allCases {
            comboBoxLevel.addItem(withObjectValue: "\(item)")
        }

        comboBoxFormat.selectItem(withObjectValue: "\(log.format)")
        comboBoxLevel.selectItem(withObjectValue: "\(log.level)")

        switch log.output {
        case .standard:
            segmentedControlOutput.selectedSegment = 0
        case .consoleapp:
            segmentedControlOutput.selectedSegment = 1
        case .custom:
            segmentedControlOutput.selectedSegment = 2
        }
    }
}
