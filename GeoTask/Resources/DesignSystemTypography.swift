import SwiftUI

public struct DesignSystemTypography {
    public static let shared = DesignSystemTypography()
    
    private init() {}
    
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