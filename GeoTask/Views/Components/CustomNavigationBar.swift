import SwiftUI

public struct CustomNavigationBar: View {
    let title: String
    let leftButton: NavigationBarButton?
    let rightButtons: [NavigationBarButton]
    let backgroundColor: Color
    let titleColor: Color
    let showDivider: Bool
    let barBackgroundColor: Color
    let containerBackgroundColor: Color
    
    public init(
        title: String,
        leftButton: NavigationBarButton? = nil,
        rightButtons: [NavigationBarButton] = [],
        backgroundColor: Color = AppColors.shared.white,
        titleColor: Color = AppColors.shared.black,
        showDivider: Bool = false,
        barBackgroundColor: Color = AppColors.shared.white,
        containerBackgroundColor: Color = AppColors.shared.white
    ) {
        self.title = title
        self.leftButton = leftButton
        self.rightButtons = rightButtons
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.showDivider = showDivider
        self.barBackgroundColor = barBackgroundColor
        self.containerBackgroundColor = containerBackgroundColor
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                if let leftButton = leftButton {
                    leftButton
                        .frame(width: 44, height: 44)
                } else {
                    Spacer()
                        .frame(width: 44)
                }
                
                Spacer()
                
                Text(title)
                    .font(AppFonts.shared.titleLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(titleColor)
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(Array(rightButtons.enumerated()), id: \.offset) { _, button in
                        button
                            .frame(width: 44, height: 44)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(barBackgroundColor)
            
            if showDivider {
                Divider()
                    .background(AppColors.shared.whiteShades90)
            }
        }
        .background(containerBackgroundColor)
    }
}

public struct NavigationBarButton: View {
    let icon: String
    let title: String?
    let action: () -> Void
    let backgroundColor: Color
    let iconColor: Color
    let titleColor: Color
    
    public init(
        icon: String,
        title: String? = nil,
        backgroundColor: Color = AppColors.shared.black,
        iconColor: Color = AppColors.shared.white,
        titleColor: Color = AppColors.shared.white,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.backgroundColor = backgroundColor
        self.iconColor = iconColor
        self.titleColor = titleColor
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            if let title = title {
                HStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(iconColor)
                    
                    Text(title)
                        .font(AppFonts.shared.bodySmall)
                        .fontWeight(.medium)
                        .foregroundColor(titleColor)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(backgroundColor)
                .cornerRadius(16)
            } else {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: 36, height: 36)
                    .background(backgroundColor)
                    .clipShape(Circle())
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

public struct ProfileNavigationBar: View {
    let userName: String
    let leftButton: NavigationBarButton?
    let rightButtons: [NavigationBarButton]
    let iconHeight: CGFloat
    
    public init(
        userName: String,
        leftButton: NavigationBarButton? = nil,
        rightButtons: [NavigationBarButton] = [],
        iconHeight: CGFloat = 40
    ) {
        self.userName = userName
        self.leftButton = leftButton
        self.rightButtons = rightButtons
        self.iconHeight = iconHeight
    }
    
    public var body: some View {
        HStack {
            if let leftButton = leftButton {
                leftButton
                    .frame(width: 44, height: 44)
            }
            
            HStack(spacing: 12) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: iconHeight, weight: .regular))
                    .foregroundColor(AppColors.shared.whiteShades90)
                    .frame(width: iconHeight, height: iconHeight)
                    .background(AppColors.shared.whiteShades99)
                    .clipShape(Circle())
                
                Text(userName)
                    .font(AppFonts.shared.titleMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.shared.black)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                ForEach(Array(rightButtons.enumerated()), id: \.offset) { _, button in
                    button
                        .frame(width: 44, height: 44)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.shared.white)
    }
}

public struct SearchNavigationBar: View {
    @Binding var searchText: String
    let placeholder: String
    let onSearch: () -> Void
    let onFilter: () -> Void
    let leftButton: NavigationBarButton?
    
    public init(
        searchText: Binding<String>,
        placeholder: String = "Search...",
        onSearch: @escaping () -> Void,
        onFilter: @escaping () -> Void,
        leftButton: NavigationBarButton? = nil
    ) {
        self._searchText = searchText
        self.placeholder = placeholder
        self.onSearch = onSearch
        self.onFilter = onFilter
        self.leftButton = leftButton
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            if let leftButton = leftButton {
                leftButton
                    .frame(width: 44, height: 44)
            }
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.shared.whiteShades90)
                
                TextField(placeholder, text: $searchText)
                    .font(AppFonts.shared.bodyMedium)
                    .foregroundColor(AppColors.shared.black)
                    .onSubmit {
                        onSearch()
                    }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(AppColors.shared.whiteShades98)
            .cornerRadius(8)
       
            Button(action: onFilter) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.shared.black)
                    .frame(width: 44, height: 44)
                    .background(AppColors.shared.white)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.shared.white)
    }
}

public struct ProgressNavigationBar: View {
    let title: String
    let currentStep: Int
    let totalSteps: Int
    let leftButton: NavigationBarButton?
    let rightButtons: [NavigationBarButton]
    
    public init(
        title: String,
        currentStep: Int,
        totalSteps: Int,
        leftButton: NavigationBarButton? = nil,
        rightButtons: [NavigationBarButton] = []
    ) {
        self.title = title
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.leftButton = leftButton
        self.rightButtons = rightButtons
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                if let leftButton = leftButton {
                    leftButton
                        .frame(width: 44, height: 44)
                } else {
                    Spacer()
                        .frame(width: 44)
                }
                
                Spacer()
                
                Text(title)
                    .font(AppFonts.shared.titleLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.shared.black)
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(Array(rightButtons.enumerated()), id: \.offset) { _, button in
                        button
                            .frame(width: 44, height: 44)
                    }
                }
            }
            
            HStack {
                Text("Step \(currentStep) of \(totalSteps)")
                    .font(AppFonts.shared.bodySmall)
                    .foregroundColor(AppColors.shared.whiteShades90)
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.shared.white)
    }
}

public struct FilterNavigationBar: View {
    let onBack: () -> Void
    let onReset: () -> Void
    let onClose: () -> Void
    
    public init(
        onBack: @escaping () -> Void,
        onReset: @escaping () -> Void,
        onClose: @escaping () -> Void
    ) {
        self.onBack = onBack
        self.onReset = onReset
        self.onClose = onClose
    }
    
    public var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.shared.black)
                    .frame(width: 44, height: 44)
                    .background(AppColors.shared.white)
                    .clipShape(Circle())
            }
            
            Text("Filter")
                .font(AppFonts.shared.titleLarge)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.shared.black)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: onReset) {
                    Text("Reset filter")
                        .font(AppFonts.shared.bodyMedium)
                        .foregroundColor(AppColors.shared.whiteShades90)
                }
                
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.shared.black)
                        .frame(width: 44, height: 44)
                        .background(AppColors.shared.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.shared.white)
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomNavigationBar(
            title: "Profile",
            leftButton: NavigationBarButton(
                icon: "chevron.left",
                action: { print("Back tapped") }
            ),
            rightButtons: [
                NavigationBarButton(
                    icon: "ellipsis",
                    action: { print("More tapped") }
                )
            ]
        )
        
        ProfileNavigationBar(
            userName: "Anastasia",
            leftButton: NavigationBarButton(
                icon: "chevron.left",
                action: { print("Back tapped") }
            ),
            rightButtons: [
                NavigationBarButton(
                    icon: "ellipsis",
                    action: { print("More tapped") }
                )
            ]
        )
        
        SearchNavigationBar(
            searchText: .constant(""),
            placeholder: "Search for performers",
            onSearch: { print("Search performed") },
            onFilter: { print("Filter tapped") },
            leftButton: NavigationBarButton(
                icon: "chevron.left",
                action: { print("Back tapped") }
            )
        )
        
        ProgressNavigationBar(
            title: "information about order",
            currentStep: 2,
            totalSteps: 4,
            leftButton: NavigationBarButton(
                icon: "chevron.left",
                action: { print("Back tapped") }
            )
        )
        
        FilterNavigationBar(
            onBack: { print("Back tapped") },
            onReset: { print("Reset tapped") },
            onClose: { print("Close tapped") }
        )
        
        ReusableActionButton(
            title: "Become a performer",
            iconName: "person.badge.plus",
            backgroundColor: AppColors.shared.black,
            textColor: AppColors.shared.white
        ) {
            print("Become performer tapped")
        }
    }
    .background(AppColors.shared.white)
} 
