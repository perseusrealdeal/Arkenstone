//
//  LoggerWindowController.swift, LoggerWindowController.storyboard
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
//  This is LoggerWindowController.swift, LoggerWindowController.storyboard
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

extension LoggerWindowController {

    class func storyboardInstance() -> NSWindowController {

        let storyboard = NSStoryboard(name: String(describing: self), bundle: nil)
        let screen = storyboard.instantiateInitialController() as? NSWindowController

        if let vc = screen?.contentViewController as? LoggerViewController {
            vc.presenter = LoggerViewPresenter(view: vc)
            vc.presenter?.viewDidLoad()
        }

        // Do default setup; don't set any parameter causing loadView up, breaks unit tests

        // screen?.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        // screen?.view.backgroundColor = UIColor.yellow

        return screen ?? NSWindowController()
    }
}

public class LoggerWindowController: NSWindowController, NSWindowDelegate {

    public override func windowDidLoad() {
        super.windowDidLoad()

        log.message("[\(type(of: self))].\(#function)")

        if let window = self.window {
            window.delegate = self
        } else {
            log.message("[\(type(of: self))].\(#function) window instance is nil", .error)
        }
    }

    public func windowShouldClose(_ sender: NSWindow) -> Bool {

        log.message("[\(type(of: self))].\(#function)")
        self.window?.orderOut(sender)

        return false
    }
}
