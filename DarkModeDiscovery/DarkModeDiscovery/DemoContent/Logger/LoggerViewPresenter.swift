//
//  LoggerViewPresenter.swift
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
//  This is LoggerViewPresenter.swift
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

import Foundation
import ConsolePerseusLogger

// MARK: - LoggerWindow Communication

protocol LoggerViewDelegate: MVPViewDelegate {
    func onViewDidAppear()
    func reloadMessages()
    func clear()
}

// MARK: - LoggerWindow Business Logic

class LoggerViewPresenter: MVPPresenter {

    private var reportObservation: NSKeyValueObservation?

    // MARK: - Initialization

    init(view: LoggerViewDelegate) {
        super.init(view: view)
    }

    // MARK: - Life Circle

    func viewDidLoad() {

        log.message("[\(type(of: self))].\(#function)")

        view?.setupUI()

        view?.makeUp()

        reportObservation = report.observe(\.lastMessage, options: .new) { _, _ in

            // Debug for debug leads to the code crash case. Don't try like this...

            // Infinite recursion leads to stack overflow.
            // You must be careful to avoid infinite recursion.

            // log.message("[\(type(of: self))].\(#function)") // Case to the code crash! 
            (self.view as? LoggerViewDelegate)?.reloadMessages()
        }
    }

    func viewDidAppear() {

        log.message("[\(type(of: self))].\(#function)")
        (view as? LoggerViewDelegate)?.onViewDidAppear()
    }

    // MARK: - Business Contract

    func forceTurned(_ turned: Bool) {

        log.message("[\(type(of: self))].\(#function)")
        log.turned = turned == true ? .on : .off

        if log.turned == .off {
            report.clear()
            (view as? LoggerViewDelegate)?.clear()
        }
    }

    func forceMarks(_ marks: Bool) {
        log.message("[\(type(of: self))].\(#function)")
        log.marks = marks
    }

    func forceTime(_ time: Bool) {
        log.message("[\(type(of: self))].\(#function)")
        log.time = time
    }

    func forceOwner(_ owner: Bool) {
        log.message("[\(type(of: self))].\(#function)")
        log.owner = owner
    }

    func forceDirrectives(_ dirrectives: Bool) {
        log.message("[\(type(of: self))].\(#function)")
        log.directives = dirrectives
    }

    func forceOutput(_ selected: Int) {

        log.message("[\(type(of: self))].\(#function)")
        switch selected {
        case 0:
            log.output = .standard
        case 1:
            log.output = .consoleapp
        case 2:
            log.output = .custom
        default:
            return
        }
    }

    func forceFormat(_ stringFormat: String) {

        log.message("[\(type(of: self))].\(#function)")
        guard let item = PerseusLogger.MessageFormat(rawValue: stringFormat)
        else {
            log.message("[\(type(of: self))].\(#function)", .error)
            return
        }

        log.format = item
    }

    func forceLevel(_ number: Int) {

        log.message("[\(type(of: self))].\(#function)")
        guard let item = PerseusLogger.Level(rawValue: abs(number - 5))
        else {
            log.message("[\(type(of: self))].\(#function)", .error)
            return
        }

        log.level = item
    }
}
