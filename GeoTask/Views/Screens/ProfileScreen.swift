import SwiftUI

public struct ProfileScreen: View {
    @State private var userName = "Anastasia"
    @State private var balance = "288 500 RUB"
    @State private var rating = "4.9"
    @State private var reviews = "32 Reviews"
    @State private var location = "Minsk"
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    ProfileNavigationBar(
                        userName: userName,
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
                    
                    VStack(spacing: 20) {
                        ProfileInfoCard(
                            userName: userName,
                            rating: rating,
                            reviews: reviews,
                            location: location
                        )
                        
                        BalanceCard(balance: balance)
                        
                        MenuSection()
                    }
                    .padding(.horizontal, 16)
                }
            }
            .background(AppColors.shared.white)
        }
    }
}

private struct ProfileInfoCard: View {
    let userName: String
    let rating: String
    let reviews: String
    let location: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60, weight: .regular))
                    .foregroundColor(AppColors.shared.whiteShades90)
                
                VStack(alignment: .leading, spacing: 4) {
                    BoldText(userName)
                        .font(AppFonts.shared.titleLarge)
                    
                    MediumText("Plasterer Roofer")
                        .font(AppFonts.shared.bodyMedium)
                        .foregroundColor(AppColors.shared.alertGreen)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.shared.alertYellow)
                        
                        MediumText("\(rating) (\(reviews))")
                            .font(AppFonts.shared.bodySmall)
                    }
                }
                
                Spacer()
                
                ReusableSmallButton(
                    title: "Become a customer",
                    backgroundColor: AppColors.shared.alertGreen
                ) {
                    print("Become customer tapped")
                }
            }
            
            HStack {
                Image(systemName: "location.fill")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.shared.whiteShades90)
                
                MediumText(location)
                    .font(AppFonts.shared.bodySmall)
                    .foregroundColor(AppColors.shared.whiteShades90)
            }
        }
        .padding(20)
        .background(AppColors.shared.whiteShades98)
        .cornerRadius(16)
    }
}

private struct BalanceCard: View {
    let balance: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                BoldText("Cash")
                    .font(AppFonts.shared.titleMedium)
                
                Spacer()
                
                BoldText("Balance: \(balance)")
                    .font(AppFonts.shared.titleMedium)
            }
            
            ReusableButton(
                title: "Send",
                backgroundColor: AppColors.shared.alertGreen
            ) {
                print("Send money tapped")
            }
        }
        .padding(20)
        .background(AppColors.shared.whiteShades98)
        .cornerRadius(16)
    }
}

private struct MenuSection: View {
    var body: some View {
        VStack(spacing: 0) {
            MenuItem(icon: "bell", title: "Notifications")
            MenuItem(icon: "clock", title: "Transaction history")
            MenuItem(icon: "doc.text", title: "Templates")
            MenuItem(icon: "trash", title: "Delete an account")
            MenuItem(icon: "rectangle.portrait.and.arrow.right", title: "Log out")
        }
        .background(AppColors.shared.whiteShades98)
        .cornerRadius(16)
    }
}

private struct MenuItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button(action: {
            print("\(title) tapped")
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.shared.black)
                    .frame(width: 24)
                
                MediumText(title)
                    .font(AppFonts.shared.bodyMedium)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.shared.whiteShades90)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileScreen()
} 