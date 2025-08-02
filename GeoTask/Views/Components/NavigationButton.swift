import SwiftUI

// MARK: - Navigation Button Styles
struct NavigationButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let cornerRadius: CGFloat
    
    init(
        backgroundColor: Color = DesignSystemColors.shared.green,
        foregroundColor: Color = DesignSystemColors.shared.white,
        cornerRadius: CGFloat = DesignSystemCornerRadius.shared.md
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor)
            .padding(.horizontal, DesignSystemSpacing.shared.md)
            .padding(.vertical, DesignSystemSpacing.shared.sm)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Primary Navigation Button
struct PrimaryNavigationButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DesignSystemTypography.shared.bodyMedium)
                .fontWeight(.semibold)
        }
        .buttonStyle(NavigationButtonStyle())
    }
}

// MARK: - Secondary Navigation Button
struct SecondaryNavigationButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DesignSystemTypography.shared.bodySmall)
                .fontWeight(.medium)
        }
        .buttonStyle(NavigationButtonStyle(
            backgroundColor: .clear,
            foregroundColor: DesignSystemColors.shared.green
        ))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystemCornerRadius.shared.md)
                .stroke(DesignSystemColors.shared.green, lineWidth: 1)
        )
    }
}

// MARK: - Icon Navigation Button
struct IconNavigationButton: View {
    let systemName: String
    let action: () -> Void
    let color: Color
    
    init(systemName: String, color: Color = DesignSystemColors.shared.green, action: @escaping () -> Void) {
        self.systemName = systemName
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title2)
                .foregroundColor(color)
        }
    }
}

// MARK: - Floating Action Button
struct FloatingActionButton: View {
    let systemName: String
    let action: () -> Void
    let backgroundColor: Color
    
    init(systemName: String, backgroundColor: Color = DesignSystemColors.shared.green, action: @escaping () -> Void) {
        self.systemName = systemName
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title2)
                .foregroundColor(DesignSystemColors.shared.white)
                .frame(width: 56, height: 56)
                .background(backgroundColor)
                .clipShape(Circle())
                .shadow(color: DesignSystemShadows.shared.large.color, radius: DesignSystemShadows.shared.large.radius, x: DesignSystemShadows.shared.large.x, y: DesignSystemShadows.shared.large.y)
        }
    }
}

// MARK: - Navigation Bar Button
struct NavigationBarButton: View {
    let systemName: String
    let action: () -> Void
    let color: Color
    
    init(systemName: String, color: Color = DesignSystemColors.shared.green, action: @escaping () -> Void) {
        self.systemName = systemName
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title3)
                .foregroundColor(color)
        }
    }
}

// MARK: - Back Button
struct BackButton: View {
    @EnvironmentObject var coordinator: AppNavigationCoordinator
    
    var body: some View {
        Button(action: {
            coordinator.navigateBack()
        }) {
            Image(systemName: DesignSystemIcons.shared.backArrow)
                .font(.title3)
                .foregroundColor(DesignSystemColors.shared.green)
        }
    }
}

// MARK: - Close Button
struct CloseButton: View {
    @EnvironmentObject var coordinator: AppNavigationCoordinator
    
    var body: some View {
        Button(action: {
            coordinator.dismissSheet()
        }) {
            Image(systemName: DesignSystemIcons.shared.close)
                .font(.title3)
                .foregroundColor(DesignSystemColors.shared.green)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        PrimaryNavigationButton(title: "Primary Button") {
            print("Primary tapped")
        }
        
        SecondaryNavigationButton(title: "Secondary Button") {
            print("Secondary tapped")
        }
        
        IconNavigationButton(systemName: DesignSystemIcons.shared.add) {
            print("Icon tapped")
        }
        
        FloatingActionButton(systemName: DesignSystemIcons.shared.add) {
            print("FAB tapped")
        }
    }
    .padding()
} 