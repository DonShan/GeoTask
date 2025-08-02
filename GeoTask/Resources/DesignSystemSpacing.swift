import SwiftUI

public struct DesignSystemSpacing {
    public static let shared = DesignSystemSpacing()
    
    private init() {}
    
    public let xs: CGFloat = 4
    public let sm: CGFloat = 8
    public let md: CGFloat = 16
    public let lg: CGFloat = 24
    public let xl: CGFloat = 32
    public let xxl: CGFloat = 48
    public let xxxl: CGFloat = 64
} 