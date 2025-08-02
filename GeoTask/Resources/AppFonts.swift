import SwiftUI

public struct AppFonts {
    public static let shared = AppFonts()
    
    private init() {}
    
    public func sfProDisplay(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight, design: .default)
    }

    public func sfProText(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight, design: .default)
    }

    public var displayLarge: Font { sfProDisplay(size: 57, weight: .regular) }
    public var displayMedium: Font { sfProDisplay(size: 45, weight: .regular) }
    public var displaySmall: Font { sfProDisplay(size: 36, weight: .regular) }
    
    public var headlineLarge: Font { sfProDisplay(size: 32, weight: .regular) }
    public var headlineMedium: Font { sfProDisplay(size: 28, weight: .regular) }
    public var headlineSmall: Font { sfProDisplay(size: 24, weight: .regular) }
    
    public var titleLarge: Font { sfProDisplay(size: 22, weight: .medium) }
    public var titleMedium: Font { sfProDisplay(size: 16, weight: .medium) }
    public var titleSmall: Font { sfProDisplay(size: 14, weight: .medium) }

    public var bodyLarge: Font { sfProText(size: 16, weight: .regular) }
    public var bodyMedium: Font { sfProText(size: 14, weight: .regular) }
    public var bodySmall: Font { sfProText(size: 12, weight: .regular) }
    
    public var labelLarge: Font { sfProText(size: 14, weight: .medium) }
    public var labelMedium: Font { sfProText(size: 12, weight: .medium) }
    public var labelSmall: Font { sfProText(size: 11, weight: .medium) }

    public let bold = Font.Weight.bold
    public let semibold = Font.Weight.semibold
    public let medium = Font.Weight.medium
    public let regular = Font.Weight.regular
} 
