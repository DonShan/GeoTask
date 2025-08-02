import SwiftUI

public struct DesignSystemShadows {
    public static let shared = DesignSystemShadows()
    
    private init() {}
    
    public let small = Shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    public let medium = Shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    public let large = Shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
}

public struct Shadow {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
} 