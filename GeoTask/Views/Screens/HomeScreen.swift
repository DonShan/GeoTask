import SwiftUI

public struct HomeScreen: View {
    @State private var searchText = ""
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    SearchNavigationBar(
                        searchText: $searchText,
                        placeholder: "Search for performers",
                        onSearch: {
                            print("Search performed")
                        },
                        onFilter: {
                            print("Filter tapped")
                        }
                    )
                    
                    VStack(spacing: 16) {
                        BoldText("Recent Orders")
                            .padding(.horizontal, 16)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(0..<3, id: \.self) { index in
                                OrderCard(
                                    title: "Repair work in the apartment",
                                    category: "Repair Work",
                                    location: "Moscow",
                                    budget: "150 000 RUB",
                                    timeAgo: "\(12 + index * 4) minutes ago"
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .background(AppColors.shared.white)
        }
    }
}

private struct OrderCard: View {
    let title: String
    let category: String
    let location: String
    let budget: String
    let timeAgo: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    BoldText(title)
                        .font(AppFonts.shared.titleMedium)
                    
                    MediumText(category)
                        .font(AppFonts.shared.bodySmall)
                        .foregroundColor(AppColors.shared.alertGreen)
                }
                
                Spacer()
                
                CaptionText(timeAgo)
            }
            
            HStack {
                LabelText(location)
                
                Spacer()
                
                BoldText(budget)
                    .font(AppFonts.shared.bodyMedium)
            }
        }
        .padding(16)
        .background(AppColors.shared.whiteShades98)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    HomeScreen()
} 