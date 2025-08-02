import Foundation
import SwiftUI

public struct LocalizationManager {
    public static var shared = Self()

    public var onLanguageChanged: (() -> Void)?
    
    // MARK: - Change Language
    public func changeLanguage(to language: Localization.Language) {
        Localization.shared.currentLanguage = language
        onLanguageChanged?()
    }
  
    public var currentLanguage: Localization.Language {
        return Localization.shared.currentLanguage
    }
    
    public var availableLanguages: [Localization.Language] {
        return Localization.Language.allCases
    }
    
    public func displayName(for language: Localization.Language) -> String {
        switch language {
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .chinese: return "中文"
        case .japanese: return "日本語"
        case .korean: return "한국어"
        case .arabic: return "العربية"
        case .hindi: return "हिन्दी"
        case .portuguese: return "Português"
        }
    }

    public func flag(for language: Localization.Language) -> String {
        switch language {
        case .english: return "🇺🇸"
        case .spanish: return "🇪🇸"
        case .french: return "🇫🇷"
        case .german: return "🇩🇪"
        case .chinese: return "🇨🇳"
        case .japanese: return "🇯🇵"
        case .korean: return "🇰🇷"
        case .arabic: return "🇸🇦"
        case .hindi: return "🇮🇳"
        case .portuguese: return "🇵🇹"
        }
    }

    public func isRTL(_ language: Localization.Language) -> Bool {
        return language == .arabic
    }

    public var textDirection: LayoutDirection {
        return isRTL(currentLanguage) ? .rightToLeft : .leftToRight
    }

    public func formatDate(_ date: Date, style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: currentLanguage.rawValue)
        formatter.dateStyle = style
        return formatter.string(from: date)
    }

    public func formatTime(_ date: Date, style: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: currentLanguage.rawValue)
        formatter.timeStyle = style
        return formatter.string(from: date)
    }

    public func formatNumber(_ number: NSNumber, style: NumberFormatter.Style = .decimal) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: currentLanguage.rawValue)
        formatter.numberStyle = style
        return formatter.string(from: number) ?? number.stringValue
    }

    public func formatCurrency(_ amount: Double, currencyCode: String = "USD") -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: currentLanguage.rawValue)
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: NSNumber(value: amount)) ?? String(format: "%.2f", amount)
    }
}

public struct LocalizedText: View {
    private let key: StringKey
    private let arguments: [CVarArg]
    
    public init(_ key: StringKey, arguments: [CVarArg] = []) {
        self.key = key
        self.arguments = arguments
    }
    
    public var body: some View {
        if arguments.isEmpty {
            Text(key.localized)
        } else {
            Text(key.localized(with: arguments))
        }
    }
}

public struct LocalizedString: View {
    private let string: String
    
    public init(_ string: String) {
        self.string = string
    }
    
    public var body: some View {
        Text(string.localized)
    }
} 
