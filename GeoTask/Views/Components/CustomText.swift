import SwiftUI

public struct BoldText: View {
    let text: String
    let color: Color
    
    public init(_ text: String, color: Color = AppColors.shared.black) {
        self.text = text
        self.color = color
    }
    
    public var body: some View {
        Text(text)
            .font(AppFonts.shared.bodyMedium)
            .fontWeight(.bold)
            .foregroundColor(color)
    }
}

public struct SemiBoldText: View {
    let text: String
    let color: Color
    
    public init(_ text: String, color: Color = AppColors.shared.black) {
        self.text = text
        self.color = color
    }
    
    public var body: some View {
        Text(text)
            .font(AppFonts.shared.bodyMedium)
            .fontWeight(.semibold)
            .foregroundColor(color)
    }
}

public struct MediumText: View {
    let text: String
    let color: Color
    
    public init(_ text: String, color: Color = AppColors.shared.black) {
        self.text = text
        self.color = color
    }
    
    public var body: some View {
        Text(text)
            .font(AppFonts.shared.bodyMedium)
            .fontWeight(.medium)
            .foregroundColor(color)
    }
}

public struct RegularText: View {
    let text: String
    let color: Color
    
    public init(_ text: String, color: Color = AppColors.shared.black) {
        self.text = text
        self.color = color
    }
    
    public var body: some View {
        Text(text)
            .font(AppFonts.shared.bodyMedium)
            .fontWeight(.regular)
            .foregroundColor(color)
    }
}

public struct CustomText: View {
    let text: String
    let font: Font
    let fontWeight: Font.Weight
    let color: Color
    
    public init(
        _ text: String,
        font: Font = AppFonts.shared.bodyMedium,
        fontWeight: Font.Weight = .regular,
        color: Color = AppColors.shared.black
    ) {
        self.text = text
        self.font = font
        self.fontWeight = fontWeight
        self.color = color
    }
    
    public var body: some View {
        Text(text)
            .font(font)
            .fontWeight(fontWeight)
            .foregroundColor(color)
    }
}

public struct TitleText: View {
    let text: String
    let color: Color
    
    public init(_ text: String, color: Color = AppColors.shared.black) {
        self.text = text
        self.color = color
    }
    
    public var body: some View {
        Text(text)
            .font(AppFonts.shared.titleLarge)
            .fontWeight(.semibold)
            .foregroundColor(color)
    }
}

public struct SubtitleText: View {
    let text: String
    let color: Color
    
    public init(_ text: String, color: Color = AppColors.shared.whiteShades90) {
        self.text = text
        self.color = color
    }
    
    public var body: some View {
        Text(text)
            .font(AppFonts.shared.bodyMedium)
            .fontWeight(.regular)
            .foregroundColor(color)
    }
}

public struct CaptionText: View {
    let text: String
    let color: Color
    
    public init(_ text: String, color: Color = AppColors.shared.whiteShades90) {
        self.text = text
        self.color = color
    }
    
    public var body: some View {
        Text(text)
            .font(AppFonts.shared.bodySmall)
            .fontWeight(.regular)
            .foregroundColor(color)
    }
}

public struct LabelText: View {
    let text: String
    let color: Color
    
    public init(_ text: String, color: Color = AppColors.shared.whiteShades90) {
        self.text = text
        self.color = color
    }
    
    public var body: some View {
        Text(text)
            .font(AppFonts.shared.labelMedium)
            .fontWeight(.medium)
            .foregroundColor(color)
    }
}

#Preview {
    VStack(spacing: 20) {
        BoldText("This is Bold Text")
        
        SemiBoldText("This is Semi Bold Text")
        
        MediumText("This is Medium Text")
        
        RegularText("This is Regular Text")
        
        TitleText("This is a Title")
        
        SubtitleText("This is a subtitle with secondary color")
        
        CaptionText("This is a caption text")
        
        LabelText("This is a label text")
        
        CustomText(
            "Custom Text with Heavy Weight",
            font: AppFonts.shared.titleLarge,
            fontWeight: .heavy,
            color: AppColors.shared.alertGreen
        )
        
        CustomText(
            "Custom Text with Light Weight",
            font: AppFonts.shared.bodyLarge,
            fontWeight: .light,
            color: AppColors.shared.alertRed
        )
    }
    .padding()
    .background(AppColors.shared.white)
} 