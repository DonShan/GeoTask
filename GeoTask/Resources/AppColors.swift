import SwiftUI

public struct AppColors {
    public static let shared = AppColors()
    
    private init() {}

    public let black = Color(hex: "#0C0C0D")
    public let white = Color(hex: "#FFFFFF")
 
    public let whiteShades90 = Color(hex: "#E4E4E6")
    public let whiteShades95 = Color(hex: "#F1F2F3")
    public let whiteShades97 = Color(hex: "#F7F7F8")
    public let whiteShades98 = Color(hex: "#F9F9FB")
    public let whiteShades99 = Color(hex: "#FCFCFD")

    public let alertGreen = Color(hex: "#31C455")
    public let alertYellow = Color(hex: "#FEDC34")
    public let alertRed = Color(hex: "#FF453A")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 
