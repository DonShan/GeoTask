import SwiftUI

public struct ReusableButton: View {
    let title: String
    let backgroundColor: Color
    let textColor: Color
    let cornerRadius: CGFloat
    let action: () -> Void
    
    public init(
        title: String,
        backgroundColor: Color = AppColors.shared.black,
        textColor: Color = AppColors.shared.white,
        cornerRadius: CGFloat = 12,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.shared.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct ReusableActionButton: View {
    let title: String
    let iconName: String
    let backgroundColor: Color
    let textColor: Color
    let iconColor: Color
    let cornerRadius: CGFloat
    let action: () -> Void
    
    public init(
        title: String,
        iconName: String,
        backgroundColor: Color = AppColors.shared.black,
        textColor: Color = AppColors.shared.white,
        iconColor: Color? = nil,
        cornerRadius: CGFloat = 12,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.iconColor = iconColor ?? textColor
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(AppFonts.shared.bodyMedium)
                    .fontWeight(.medium)
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct ReusableOutlinedButton: View {
    let title: String
    let backgroundColor: Color
    let textColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let action: () -> Void
    
    public init(
        title: String,
        backgroundColor: Color = AppColors.shared.white,
        textColor: Color = AppColors.shared.black,
        borderColor: Color = AppColors.shared.grey60,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 12,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.shared.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .cornerRadius(cornerRadius)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct ReusableIconButton: View {
    let title: String
    let iconName: String
    let backgroundColor: Color
    let textColor: Color
    let cornerRadius: CGFloat
    let action: () -> Void
    
    public init(
        title: String,
        iconName: String,
        backgroundColor: Color = AppColors.shared.black,
        textColor: Color = AppColors.shared.white,
        cornerRadius: CGFloat = 12,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(textColor)
                
                Text(title)
                    .font(AppFonts.shared.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct ReusableSmallButton: View {
    let title: String
    let backgroundColor: Color
    let textColor: Color
    let cornerRadius: CGFloat
    let action: () -> Void
    
    public init(
        title: String,
        backgroundColor: Color = AppColors.shared.black,
        textColor: Color = AppColors.shared.white,
        cornerRadius: CGFloat = 8,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.shared.bodySmall)
                .fontWeight(.medium)
                .foregroundColor(textColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct ReusableSmallOutlinedButton: View {
    let title: String
    let backgroundColor: Color
    let textColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let action: () -> Void
    
    public init(
        title: String,
        backgroundColor: Color = AppColors.shared.white,
        textColor: Color = AppColors.shared.black,
        borderColor: Color = AppColors.shared.grey60,
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 8,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.shared.bodySmall)
                .fontWeight(.medium)
                .foregroundColor(textColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .cornerRadius(cornerRadius)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        ReusableButton(title: "Accept request") {
            print("Accept request tapped")
        }
        
        ReusableActionButton(
            title: "Reply",
            iconName: "exclamationmark.circle",
            backgroundColor: AppColors.shared.black,
            textColor: AppColors.shared.white,
            iconColor: AppColors.shared.white
        ) {
            print("Reply tapped")
        }
        
        ReusableOutlinedButton(title: "Reject") {
            print("Reject tapped")
        }
        
        ReusableButton(
            title: "Custom Button",
            backgroundColor: AppColors.shared.green,
            textColor: AppColors.shared.white
        ) {
            print("Custom button tapped")
        }
        
        ReusableOutlinedButton(
            title: "Custom Outlined",
            backgroundColor: AppColors.shared.white,
            textColor: AppColors.shared.red,
            borderColor: AppColors.shared.red
        ) {
            print("Custom outlined tapped")
        }
        
        ReusableIconButton(
            title: "Add Item",
            iconName: AppImages.shared.add,
            backgroundColor: AppColors.shared.blue
        ) {
            print("Add item tapped")
        }
        
        ReusableActionButton(
            title: "Send Message",
            iconName: "paperplane",
            backgroundColor: AppColors.shared.green,
            textColor: AppColors.shared.white
        ) {
            print("Send message tapped")
        }
        
        ReusableSmallButton(
            title: "Small Button",
            backgroundColor: AppColors.shared.grey90
        ) {
            print("Small button tapped")
        }
        
        ReusableSmallOutlinedButton(
            title: "Small Outlined",
            backgroundColor: AppColors.shared.white,
            textColor: AppColors.shared.grey90
        ) {
            print("Small outlined tapped")
        }
    }
    .padding()
} 