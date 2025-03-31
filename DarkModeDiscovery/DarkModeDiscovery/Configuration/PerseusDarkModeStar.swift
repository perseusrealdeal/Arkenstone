//
//  PerseusDarkModeStar.swift
//  Version: 2.0.0
//
//  Created by Mikhail Zhigulin in 7530.
//
//  Copyright © 7530 - 7533 Mikhail Zhigulin of Novosibirsk.
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

import ConsolePerseusLogger

#if canImport(UIKit)
import UIKit
#elseif canImport(Cocoa)
import Cocoa
#endif

#if os(iOS)
public typealias Responder = UIResponder
#elseif os(macOS)
public typealias Responder = NSResponder
#endif

public extension Notification.Name {
    static let MakeAppearanceUpNotification =
    Notification.Name("MakeAppearanceUpNotification")
#if os(macOS)
    static let AppleInterfaceThemeChangedNotification =
    Notification.Name("AppleInterfaceThemeChangedNotification")
#endif
}

#if os(macOS)
public var DARK_OS_DEFAULT: NSAppearance.Name {
    if #available(macOS 10.14, *) {
        return .darkAqua
    }
    return .vibrantDark
}
public let LIGHT_OS_DEFAULT: NSAppearance.Name = .aqua
#endif

// swiftlint:disable identifier_name
public extension Responder {
    var DarkMode: DarkModeProtocol { return DarkModeAgent.shared }
}
// swiftlint:enable identifier_name

public class DarkModeAgent {

    public static var shared: DarkMode = { _ = it; return DarkMode() }()

    private(set) static var it = { DarkModeAgent() }()

    private init() {
#if os(macOS)
        if #available(macOS 10.14, *) {
            DarkModeAgent.distributedNCenter.addObserver(
                self,
                selector: #selector(processAppleInterfaceThemeChanged),
                name: .AppleInterfaceThemeChangedNotification,
                object: nil
            )
        }
#endif
    }

    /// TRUE if Appearance.makeUp once called otherwise FALSE.
    ///
    /// Value is false by default and changed only once
    /// when Appearance.makeUp called for the first time, then always true in run time.
    public static var isEnabled: Bool { return hidden_isEnabled }

    private(set) static var hidden_isEnabled: Bool = false {
        willSet {
            if newValue == false { return }
        }
    }

    internal static var hidden_changeManually: Bool = false

#if DEBUG && os(macOS)
    public static var distributedNCenter: NotificationCenterProtocol =
        DistributedNotificationCenter.default
#elseif os(macOS)
    public static var distributedNCenter = DistributedNotificationCenter.default
#endif

#if DEBUG // Isolated for unit testing
    public static var nCenter: NotificationCenterProtocol = NotificationCenter.default
    public static var ud: UserDefaultsProtocol = UserDefaults.standard
#else
    public static var nCenter = NotificationCenter.default
    public static var ud = UserDefaults.standard
#endif

    public static var DarkModeUserChoice: DarkModeOption {
        get {
            let rawValue = ud.valueExists(forKey: DARK_MODE_USER_CHOICE_KEY) ?
                ud.integer(forKey: DARK_MODE_USER_CHOICE_KEY) :
                DARK_MODE_USER_CHOICE_DEFAULT.rawValue

            if let result = DarkModeOption.init(rawValue: rawValue) { return result }
            return DARK_MODE_USER_CHOICE_DEFAULT
        }
        set {
            ud.setValue(newValue.rawValue, forKey: DARK_MODE_USER_CHOICE_KEY)
            recalculatePerseusDarkModeIfNeeded(DarkModeAgent.currentSystemStyle())
        }
    }

    public static func register(stakeholder: Any, selector: Selector) {
        nCenter.addObserver(stakeholder,
                            selector: selector,
                            name: .MakeAppearanceUpNotification,
                            object: nil)
    }

    public static func makeUp() {
        hidden_isEnabled = true
        hidden_changeManually = true

        if #available(iOS 13.0, macOS 10.14, *) { refreshKeyScreenAppearance() }
        recalculatePerseusDarkModeIfNeeded(DarkModeAgent.currentSystemStyle())

        nCenter.post(name: .MakeAppearanceUpNotification, object: nil)
        hidden_changeManually = false
    }

#if os(iOS)
    @available(iOS 13.0, *)
    public static func processTraitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?) {
            if hidden_changeManually { return }

            let current = DarkModeAgent.currentSystemStyle()

            guard let previousSystemStyle = previousTraitCollection?.userInterfaceStyle,
                  previousSystemStyle.rawValue != current.rawValue
            else { return }

            DarkModeAgent.it.processAppleInterfaceThemeChanged()
        }
#endif

    @objc public func processAppleInterfaceThemeChanged() {
        log.message("[\(type(of: self))].\(#function)")
        if DarkModeAgent.hidden_changeManually { return }

        DarkModeAgent.hidden_isEnabled = true

#if os(macOS)
        DarkModeAgent.refreshKeyScreenAppearance()
#endif
        let current = DarkModeAgent.currentSystemStyle()
#if os(iOS)
        DarkModeAgent.recalculatePerseusDarkModeIfNeeded(current)
#elseif os(macOS)
        let userChoice = DarkModeAgent.DarkModeUserChoice
        let requiredStyle = DarkModeAgent.makeDecision(userChoice, current)

        DarkModeAgent.shared.hidden_style = requiredStyle
#endif
        DarkModeAgent.nCenter.post(name: .MakeAppearanceUpNotification, object: nil)
    }

    public static func recalculatePerseusDarkModeIfNeeded(_ current: SystemStyle) {
        log.message("[\(type(of: self))].\(#function)")
        let requiredStyle = makeDecision(DarkModeUserChoice, current)
        if shared.hidden_style != requiredStyle { shared.hidden_style = requiredStyle }
    }

    @available(iOS 13.0, macOS 10.14, *)
    internal static func refreshKeyScreenAppearance() {
        log.message("[\(type(of: self))].\(#function)")
        if hidden_changeManually == false { return }
#if os(iOS) && compiler(>=5)
        guard let keyWindow = UIWindow.key else { return }

        var overrideStyle: UIUserInterfaceStyle = .unspecified

        switch DarkModeUserChoice {
        case .auto:
            overrideStyle = .unspecified
        case .on:
            overrideStyle = .dark
        case .off:
            overrideStyle = .light
        }

        keyWindow.overrideUserInterfaceStyle = overrideStyle

#elseif os(macOS)
        switch DarkModeUserChoice {
        case .auto:
            // NSApplication.shared.appearance = currentSystemStyle() == .light ?
            // NSAppearance(named: LIGHT_OS_DEFAULT) : NSAppearance(named: DARK_OS_DEFAULT)
            NSApplication.shared.appearance = nil
        case .on:
            NSApplication.shared.appearance = NSAppearance(named: DARK_OS_DEFAULT)
        case .off:
            NSApplication.shared.appearance = NSAppearance(named: LIGHT_OS_DEFAULT)
        }
#endif
    }
}

extension UserDefaults {
    public func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}

#if os(iOS)
extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
#endif

public protocol NotificationCenterProtocol {
    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: NSNotification.Name?,
                     object anObject: Any?)
    func post(name aName: NSNotification.Name, object anObject: Any?)
}

public protocol UserDefaultsProtocol {
    func valueExists(forKey key: String) -> Bool
    func integer(forKey defaultName: String) -> Int
    func setValue(_ value: Any?, forKey key: String)
}

extension UserDefaults: UserDefaultsProtocol { }
extension NotificationCenter: NotificationCenterProtocol { }

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

public enum SystemStyle: Int, CustomStringConvertible {

    case unspecified = 0
    case light       = 1
    case dark        = 2

    public var description: String {
        switch self {
        case .unspecified:
            return ".unspecified"
        case .light:
            return ".light"
        case .dark:
            return ".dark"
        }
    }
}

public let DARK_MODE_SETTINGS_KEY = "dark_mode_preference"
public let DARK_MODE_USER_CHOICE_KEY = "DarkModeUserChoiceOptionKey"
public let DARK_MODE_USER_CHOICE_DEFAULT = DarkModeOption.auto
public let DARK_MODE_DEFAULT = AppearanceStyle.light
public let OBSERVERED_VARIABLE_NAME = "styleObservable"

extension DarkModeAgent {

    public static func forceDarkMode(_ userChoice: DarkModeOption) {
        UserDefaults.standard.setValue(userChoice.rawValue, forKey: DARK_MODE_SETTINGS_KEY)
        DarkModeAgent.DarkModeUserChoice = userChoice
        DarkModeAgent.makeUp()
    }

    public static func isDarkModeSettingsKeyChanged() -> DarkModeOption? {
        let option = UserDefaults.standard.valueExists(forKey: DARK_MODE_SETTINGS_KEY) ?
        UserDefaults.standard.integer(forKey: DARK_MODE_SETTINGS_KEY) : -1

        guard option != -1, let settingsDarkMode = DarkModeOption.init(rawValue: option)
        else { return nil }

        return settingsDarkMode != DarkModeAgent.DarkModeUserChoice ? settingsDarkMode : nil
    }
}

public class DarkMode: NSObject {

    public var style: AppearanceStyle { return hidden_style }

    @objc public dynamic var styleObservable: Int = DARK_MODE_DEFAULT.rawValue

    internal var hidden_style: AppearanceStyle = DARK_MODE_DEFAULT {
        didSet { styleObservable = style.rawValue }
    }
}

public protocol DarkModeProtocol {
    var style: AppearanceStyle { get }
    var styleObservable: Int { get }
}

extension DarkMode: DarkModeProtocol { }

extension DarkModeAgent {

    public static func currentSystemStyle() -> SystemStyle {
        if #available(iOS 13.0, macOS 10.14, *) {
#if os(iOS)
            guard let keyWindow = UIWindow.key else { return .unspecified }

            switch keyWindow.traitCollection.userInterfaceStyle {
            case .unspecified:
                return .unspecified
            case .light:
                return .light
            case .dark:
                return .dark

            @unknown default:
                return .unspecified
            }
#elseif os(macOS)
            /*
            if force == .os {

                let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
                let current: SystemStyle = isDark == "Dark" ? .dark : .light

                return current
            }

            if #available(macOS 11.0, *) {

                let current = NSAppearance.currentDrawing()
                let effectiveDark = current.bestMatch(from: [.darkAqua, .vibrantDark])

                return [.darkAqua, .vibrantDark].contains(effectiveDark) ? .dark : .light
            }

            let effectiveDark = NSApp.windows.first?.effectiveAppearance.bestMatch(
                from: [.darkAqua, .vibrantDark])

            return [.darkAqua, .vibrantDark].contains(effectiveDark) ? .dark : .light
            */

            /*
            let userDefaults = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
            let styleDefaults: SystemStyle = userDefaults == "Dark" ? .dark : .light

            guard let firstWindow = NSApp.windows.first else {
                return styleDefaults
            }

            let darkNames = [NSAppearance.Name.darkAqua, NSAppearance.Name.vibrantDark]
            if let effective = firstWindow.effectiveAppearance.bestMatch(from: darkNames) {
                let styleWindow: SystemStyle = darkNames.contains(effective) ? .dark : .light
                return styleDefaults == styleWindow ? styleDefaults : styleWindow
            }

            return styleDefaults
            */

            /* Rely just only on first window appearance!

            let effectiveDark = NSApp.windows.first?.effectiveAppearance.bestMatch(
                from: [.darkAqua, .vibrantDark])

            return [.darkAqua, .vibrantDark].contains(effectiveDark) ? .dark : .light
            */

           // Rely just only on user defaults!

            let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
            return isDark == "Dark" ? .dark : .light
#endif
        } else {
            return .unspecified // HighSierra 10.13, earlier iOS 12.0 and so on.
        }
    }

    // MARK: - Calculating Dark Mode Required

    /// Calculates the current required appearance style of the app.
    ///
    /// Dark Mode decision-making:
    ///
    ///                  | User
    ///     -------------+-----------------------
    ///     System       | auto    | on   | off
    ///     -------------+---------+------+------
    ///     .unspecified | default | dark | light
    ///     .light       | light   | dark | light
    ///     .dark        | dark    | dark | light
    ///
    public static func makeDecision(_ user: DarkModeOption,
                                    _ system: SystemStyle) -> AppearanceStyle {

        if (system == .unspecified) && (user == .auto) { return DARK_MODE_DEFAULT }
        if (system == .unspecified) && (user == .on) { return .dark }
        if (system == .unspecified) && (user == .off) { return .light }

        if (system == .light) && (user == .auto) { return .light }
        if (system == .light) && (user == .on) { return .dark }
        if (system == .light) && (user == .off) { return .light }

        if (system == .dark) && (user == .auto) { return .dark }
        if (system == .dark) && (user == .on) { return .dark }
        if (system == .dark) && (user == .off) { return .light }

        // Output default value if somethings goes out of the decision table

        return DARK_MODE_DEFAULT
    }
}

public class DarkModeObserver: NSObject {
    public var action: ((_ newStyle: AppearanceStyle) -> Void)?
    private(set) var objectToObserve = DarkModeAgent.shared

    public override init() {
        super.init()

        objectToObserve.addObserver(self,
                                    forKeyPath: OBSERVERED_VARIABLE_NAME,
                                    options: .new,
                                    context: nil)
    }

    public init(_ action: @escaping ((_ newStyle: AppearanceStyle) -> Void)) {
        super.init()

        self.action = action
        objectToObserve.addObserver(self,
                                    forKeyPath: OBSERVERED_VARIABLE_NAME,
                                    options: .new,
                                    context: nil)
    }

    // swiftlint:disable:this block_based_kvo
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey: Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard
            keyPath == OBSERVERED_VARIABLE_NAME,
            let style = change?[.newKey],
            let styleRawValue = style as? Int,
            let newStyle = AppearanceStyle.init(rawValue: styleRawValue)
        else { return }

        action?(newStyle)
    }

    deinit {
        objectToObserve.removeObserver(self, forKeyPath: OBSERVERED_VARIABLE_NAME)
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
