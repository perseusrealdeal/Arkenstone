//
//  PerseusDarkModeStar.swift
//  Version: 2.0.0
//
//  Adoptation for macOS only.
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7533 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  All rights reserved.
//
//
//  MIT License
//
//  Copyright © 7530 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
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
// swiftlint:disable file_length
//

import Cocoa
import ConsolePerseusLogger

public typealias DarkModeObject = NSObject

public let APPEARANCE_DEFAULT = AppearanceStyle.light

public let DARK_MODE_USER_CHOICE_KEY = "DarkModeUserChoiceOptionKey"
public let DARK_MODE_USER_CHOICE_DEFAULT = DarkModeOption.auto

public extension Notification.Name {
    static let MakeAppearanceUpNotification =
    Notification.Name("MakeAppearanceUpNotification")
#if os(macOS)
    static let AppleInterfaceThemeChangedNotification =
    Notification.Name("AppleInterfaceThemeChangedNotification")
#endif
}

#if os(macOS)
// Default Appearance used to apply to system UI compoents i.e. buttons, borders, windows etc.
public var DARK_APPEARANCE_DEFAULT_IN_USE: NSAppearance {
    guard let darkAppearanceOS = DARK_APPEARANCE_DEFAULT else {
        if #available(macOS 10.14, *) {
            return NSAppearance(named: .darkAqua)!
        } // For HighSierra.
        return NSAppearance(named: .vibrantDark)!
    }
    return darkAppearanceOS
}
public var DARK_APPEARANCE_DEFAULT: NSAppearance?
public var LIGHT_APPEARANCE_DEFAULT_IN_USE = NSAppearance(named: .aqua)!
#endif

// swiftlint:disable identifier_name
public extension DarkModeObject {
    var DarkMode: DarkMode { return DarkModeAgent.shared }
    var DarkModeUserChoice: DarkModeOption { return DarkModeAgent.DarkModeUserChoice }
}
// swiftlint:enable identifier_name

public enum AppearanceStyle: Int, CustomStringConvertible {

    case light = 0
    case dark  = 1

    public var description: String {
        switch self {
        case .light:
            return ".light"
        case .dark:
            return ".dark"
        }
    }
}

public enum DarkModeOption: Int, CustomStringConvertible {

    case auto = 0
    case on   = 1
    case off  = 2

    public var description: String {
        switch self {
        case .auto:
            return ".auto"
        case .on:
            return ".on"
        case .off:
            return ".off"
        }
    }
}

public class DarkMode: NSObject {

    public var style: AppearanceStyle { return appearance }

    @objc public dynamic var styleObservable: Int = APPEARANCE_DEFAULT.rawValue

    internal var appearance: AppearanceStyle = APPEARANCE_DEFAULT {
        didSet { styleObservable = style.rawValue }
    }
}

public class DarkModeAgent {

    public static var shared: DarkMode = { _ = instance; return DarkMode() }()
    public static var DarkModeUserChoice: DarkModeOption {
        return userChoice
    }

    private static var userChoice: DarkModeOption {
        get {
            let rawValue = ud.valueExists(forKey: DARK_MODE_USER_CHOICE_KEY) ?
                ud.integer(forKey: DARK_MODE_USER_CHOICE_KEY) :
                DARK_MODE_USER_CHOICE_DEFAULT.rawValue

            if let result = DarkModeOption.init(rawValue: rawValue) { return result }
            return DARK_MODE_USER_CHOICE_DEFAULT
        }
        set {
            ud.setValue(newValue.rawValue, forKey: DARK_MODE_USER_CHOICE_KEY)
        }
    }

    private static var distributedNCenter = DistributedNotificationCenter.default
    private static var nCenter = NotificationCenter.default
    private static var ud = UserDefaults.standard

    private static var instance = { DarkModeAgent() }()

    private var observation: NSKeyValueObservation?
    private init() {
#if os(macOS)
        if #available(macOS 10.14, *) {
            DarkModeAgent.distributedNCenter.addObserver(
                self,
                selector: #selector(processAppleInterfaceThemeChanged),
                name: .AppleInterfaceThemeChangedNotification,
                object: nil
            )
            observation = NSApp.observe(\.effectiveAppearance) { _, _ in
                if DarkModeAgent.userChoice == .auto {

                    let effectiveAppearance = NSApplication.shared.effectiveAppearance
                    let required = self.getRequired(from: effectiveAppearance)

                    DarkModeAgent.shared.appearance = required
                }
            }
        } // For HighSierra there is no need in observation cos' system style never change.
#endif
    }

    // MARK: - Contract

    public static func register(stakeholder: Any, selector: Selector) {
        self.nCenter.addObserver(stakeholder,
                                 selector: selector,
                                 name: .MakeAppearanceUpNotification,
                                 object: nil)
    }

    public static func force(_ userChoice: DarkModeOption) {
        DarkModeAgent.userChoice = userChoice
        DarkModeAgent.instance.refresh()
        DarkModeAgent.instance.notifyAllRegistered()
    }

    public static func makeUp() {
        DarkModeAgent.instance.notifyAllRegistered()
    }

    // MARK: - Implementation

    @objc private func processAppleInterfaceThemeChanged() {
        refresh()
        notifyAllRegistered()
    }

    private func refresh() {
        let choice = DarkModeAgent.userChoice

        if #available(macOS 10.14, *) {
            switch choice {
            case .auto:
                NSApp.appearance = nil
                // DarkModeAgent is informed about new appearance by observation.
            case .on:
                NSApp.appearance = DARK_APPEARANCE_DEFAULT_IN_USE
                DarkModeAgent.shared.appearance = .dark
            case .off:
                NSApp.appearance = LIGHT_APPEARANCE_DEFAULT_IN_USE
                DarkModeAgent.shared.appearance = .light
            }
        } else { // For HighSierra.
            DarkModeAgent.shared.appearance = choice == .on ? .dark : .light
        }
    }

    private func notifyAllRegistered() {
        DarkModeAgent.nCenter.post(name: .MakeAppearanceUpNotification, object: nil)
    }

    private func getRequired(from appearance: NSAppearance?) -> AppearanceStyle {
        let choice = DarkModeAgent.userChoice

        if #available(macOS 10.14, *) {
            guard choice == .auto else {
                return choice == .off ? .light : .dark
            }

            if let match = appearance?.bestMatch(from: [.darkAqua, .vibrantDark]) {
                return [.darkAqua, .vibrantDark].contains(match) ? .dark : .light
            }

            return .light
        } else { // For HighSierra.
            return choice == .off ? .dark : .light
        }
    }
}

// MARK: - Helpers

extension UserDefaults {
    public func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}

public class DarkModeObserver: NSObject {

    public var action: ((_ newStyle: AppearanceStyle) -> Void)?

    private var objectToObserve = DarkModeAgent.shared
    private var observation: NSKeyValueObservation?

    public override init() {
        super.init()
        setupObservation()
    }

    public init(_ action: @escaping ((_ newStyle: AppearanceStyle) -> Void)) {
        super.init()

        self.action = action
        setupObservation()
    }

    private func setupObservation() {
        observation = objectToObserve.observe(\.styleObservable) { _, _  in
            self.action?(self.objectToObserve.style)
        }
    }
}
