import SwiftUI

public struct DesignSystemCornerRadius {
    public static let shared = DesignSystemCornerRadius()
    
    private init() {}
    
    public let xs: CGFloat = 4
    public let sm: CGFloat = 8
    public let md: CGFloat = 12
    public let lg: CGFloat = 16
    public let xl: CGFloat = 24
    public let xxl: CGFloat = 32
} 