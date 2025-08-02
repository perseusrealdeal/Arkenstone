//
//  MessageLabel.swift
//  PerseusRealDeal
//
//  Created by Mikhail Zhigulin on 23.04.2021.
//
//  INFO: Origionally from my "repost.maker" closed source project.
//
//  Copyright © 7530 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7530 - 7533 PerseusRealDeal
//
//  All rights reserved.
//
//  MIT License
//
//  Copyright © 7530 - 7533 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7530 - 7533 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. It means that "Sep 01, 2024" is the beginning of 7533.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notices and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(Cocoa)
import Cocoa
#endif

#if os(iOS)
public typealias MyCustomLabel = UILabel
#elseif os(macOS)
public typealias MyCustomLabel = NSTextField
#endif

public let DEFAULT_MESSAGE_LABEL_TEXT = "Have a great time."

public class MessageLabel: MyCustomLabel {

    private var messageDeepCounter: Int = 0

    public var messageDefaultGetter: (() -> String)?
    public var messageDefault: String {
        guard let getter = messageDefaultGetter else {
            return DEFAULT_MESSAGE_LABEL_TEXT
        }

        return getter()
    }

    public var message = "" {
        didSet {

            // for now

#if os(iOS)
            self.text = self.message
            self.alpha = 1.0
#elseif os(macOS)
            self.stringValue = self.message
            self.alphaValue = 1.0
#endif

            // for after now

            guard self.message != self.messageDefault else {
                return
            }

            self.messageDeepCounter += 1

            let messageDefaultTemp = messageDefault

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
#if os(iOS)
                UIView.animate(withDuration: 0.5) {
                    self.messageDeepCounter -= 1
                    if self.messageDeepCounter > 0 {
                        // do nothing
                    } else {
                        self.alpha = 0.0
                    }
                }
#elseif os(macOS)
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.5

                    self.messageDeepCounter -= 1

                    if self.messageDeepCounter > 0 {
                        // do nothing
                    } else {
                        self.animator().alphaValue = 0.0
                    }

                }, completionHandler: nil)
#endif
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
#if os(iOS)
                UIView.animate(withDuration: 0.5) {
                    if self.messageDeepCounter > 0 {
                        // do nothing
                    } else {
                        self.text = messageDefaultTemp
                        self.alpha = 1.0
                    }
                }
#elseif os(macOS)
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.5

                    if self.messageDeepCounter > 0 {
                        // do nothing
                    } else {
                        self.stringValue = messageDefaultTemp
                        self.animator().alphaValue = 1.0
                    }
                }, completionHandler: nil)
#endif
            })
        }
    }
}
