//
//  CompanionViewController.swift
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

class CompanionViewController: NSViewController {

    @IBOutlet weak var nameValue: NSTextField!

    @IBOutlet weak var ageLabel: NSTextField!
    @IBOutlet weak var ageValue: NSTextField!

    @IBOutlet weak var raceLabel: NSTextField!
    @IBOutlet weak var raceValue: NSTextField!

    @IBOutlet var bioTextView: NSTextView!

    @IBOutlet weak var imageView: DarkModeImageView!

    let theDarknessTrigger = DarkModeObserver()

    var companion: Companion? {
        didSet {
            guard isViewLoaded else { return }

            updateCompanionView(companion)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.imageLight = NSImage(named: "BilboAndGandalf")
        imageView.imageDark = NSImage(named: "CompanyClimbing")
        imageView.customScale = .proportionallyClipToBounds

        bioTextView.backgroundColor = .clear

        updateCompanionView(nil)

        theDarknessTrigger.action = { _ in self.makeUp() }
        makeUp() // That's for now.
    }

    func updateCompanionView(_ companion: Companion?) {
        guard let friend = companion else {
            nameValue.stringValue = ""
            ageValue.stringValue = ""
            raceValue.stringValue = ""
            bioTextView.string = ""

            ageLabel.isHidden = true
            raceLabel.isHidden = true

            return
        }

        ageLabel.isHidden = false
        raceLabel.isHidden = false

        nameValue.stringValue = friend.name
        ageValue.stringValue = friend.age
        raceValue.stringValue = friend.race.single

        bioTextView.string = friend.characteristics
    }

    private func makeUp() {
        self.ageLabel.textColor = .customLabel
        self.raceLabel.textColor = .customLabel

        self.nameValue.textColor = .customShortText
        self.ageValue.textColor = .customShortText
        self.raceValue.textColor = .customShortText

        self.bioTextView.textColor = .customLongText
    }
}
