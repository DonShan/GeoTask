import SwiftUI

public struct AppColors {
    public static let shared = AppColors()
    
    private init() {}
    
    public let absolute = Color(red: 0, green: 0, blue: 0)
    public let absoluteInverted = Color(red: 1, green: 1, blue: 1)
    
    public let grey10 = Color(hex: "#F8F9FA")
    public let grey20 = Color(hex: "#F1F3F4")
    public let grey30 = Color(hex: "#E8EAED")
    public let grey40 = Color(hex: "#DADCE0")
    public let grey50 = Color(hex: "#BDC1C6")
    public let grey60 = Color(hex: "#9AA0A6")
    public let grey70 = Color(hex: "#80868B")
    public let grey80 = Color(hex: "#5F6368")
    public let grey90 = Color(hex: "#3C4043")
    public let grey100 = Color(hex: "#202124")
    
    public let red = Color(hex: "#EA4335")
    public let green = Color(hex: "#34A853")
    public let blue = Color(hex: "#4285F4")
    public let yellow = Color(hex: "#FBBC04")
    public let orange = Color(hex: "#FF9800")
    public let purple = Color(hex: "#9C27B0")
    public let pink = Color(hex: "#E91E63")
    public let teal = Color(hex: "#009688")
    public let indigo = Color(hex: "#3F51B5")
    public let brown = Color(hex: "#795548")
    public let grey = Color(hex: "#9E9E9E")
    public let lightGrey = Color(hex: "#F5F5F5")
    public let darkGrey = Color(hex: "#424242")
    public let black = Color(hex: "#000000")
    public let white = Color(hex: "#FFFFFF")
    public let transparent = Color.clear
    public let background = Color(hex: "#FFFFFF")
    public let surface = Color(hex: "#FFFFFF")
    public let primary = Color(hex: "#34A853")
    public let secondary = Color(hex: "#4285F4")
    public let accent = Color(hex: "#FBBC04")
    public let error = Color(hex: "#EA4335")
    public let warning = Color(hex: "#FF9800")
    public let success = Color(hex: "#34A853")
    public let info = Color(hex: "#4285F4")
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