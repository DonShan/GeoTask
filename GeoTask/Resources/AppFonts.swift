import SwiftUI

public struct AppFonts {
    public static let shared = AppFonts()
    
    private init() {}
    
    public func sfProDisplay(size: CGFloat, weight: Font.Weight) -> Font {
        return .system(size: size, weight: weight, design: .default)
    }
    
    public func sfProText(size: CGFloat, weight: Font.Weight) -> Font {
        return .system(size: size, weight: weight, design: .default)
    }
    
    public let displayLarge = Font.system(size: 57, weight: .regular, design: .default)
    public let displayMedium = Font.system(size: 45, weight: .regular, design: .default)
    public let displaySmall = Font.system(size: 36, weight: .regular, design: .default)
    
    public let headlineLarge = Font.system(size: 32, weight: .regular, design: .default)
    public let headlineMedium = Font.system(size: 28, weight: .regular, design: .default)
    public let headlineSmall = Font.system(size: 24, weight: .regular, design: .default)
    
    public let titleLarge = Font.system(size: 22, weight: .medium, design: .default)
    public let titleMedium = Font.system(size: 16, weight: .medium, design: .default)
    public let titleSmall = Font.system(size: 14, weight: .medium, design: .default)
    
    public let bodyLarge = Font.system(size: 16, weight: .regular, design: .default)
    public let bodyMedium = Font.system(size: 14, weight: .regular, design: .default)
    public let bodySmall = Font.system(size: 12, weight: .regular, design: .default)
    
    public let labelLarge = Font.system(size: 14, weight: .medium, design: .default)
    public let labelMedium = Font.system(size: 12, weight: .medium, design: .default)
    public let labelSmall = Font.system(size: 11, weight: .medium, design: .default)
}

extension Font.Weight {
    static let thin = Font.Weight.thin
    static let ultraLight = Font.Weight.ultraLight
    static let light = Font.Weight.light
    static let regular = Font.Weight.regular
    static let medium = Font.Weight.medium
    static let semibold = Font.Weight.semibold
    static let bold = Font.Weight.bold
    static let heavy = Font.Weight.heavy
    static let black = Font.Weight.black
} 