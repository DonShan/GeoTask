import SwiftUI

public struct SearchScreen: View {
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
                        },
                        leftButton: NavigationBarButton(
                            icon: "chevron.left",
                            action: { print("Back tapped") }
                        )
                    )
                    
                    VStack(spacing: 16) {
                        BoldText("Search for performers")
                            .padding(.horizontal, 16)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(0..<5, id: \.self) { index in
                                PerformerCard(
                                    name: performerNames[index],
                                    rating: performerRatings[index],
                                    reviews: performerReviews[index],
                                    profession: performerProfessions[index],
                                    services: performerServices[index]
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
    
    private var performerNames: [String] {
        ["Anastasia", "Dmitriy", "Alexander", "Maria", "Sergey"]
    }
    
    private var performerRatings: [String] {
        ["5.0", "5.0", "4.7", "4.9", "4.8"]
    }
    
    private var performerReviews: [String] {
        ["24 Reviews", "6 Reviews", "13 Reviews", "18 Reviews", "9 Reviews"]
    }
    
    private var performerProfessions: [String] {
        ["Interior designer Engineer", "Molyap Plasterer Builder", "Electrician", "Plumber", "Carpenter"]
    }
    
    private var performerServices: [[String]] {
        [
            ["Prepares estimates", "Takes measurements", "Does a design project", "Brigade"],
            ["Prepares estimates", "Takes measurements", "Brigade"],
            ["Electrical work", "Installation", "Repair"],
            ["Plumbing", "Installation", "Repair"],
            ["Carpentry", "Installation", "Custom work"]
        ]
    }
}

private struct PerformerCard: View {
    let name: String
    let rating: String
    let reviews: String
    let profession: String
    let services: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 50, weight: .regular))
                    .foregroundColor(AppColors.shared.whiteShades90)
                
                VStack(alignment: .leading, spacing: 4) {
                    BoldText(name)
                        .font(AppFonts.shared.titleMedium)
                    
                    MediumText(profession)
                        .font(AppFonts.shared.bodySmall)
                        .foregroundColor(AppColors.shared.alertGreen)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.shared.alertYellow)
                        
                        MediumText("\(rating) (\(reviews))")
                            .font(AppFonts.shared.bodySmall)
                    }
                }
                
                Spacer()
                
                ReusableSmallButton(
                    title: "Contact",
                    backgroundColor: AppColors.shared.alertGreen
                ) {
                    print("Contact \(name) tapped")
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                MediumText("Services:")
                    .font(AppFonts.shared.bodySmall)
                    .foregroundColor(AppColors.shared.whiteShades90)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(services, id: \.self) { service in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.shared.alertGreen)
                            
                            MediumText(service)
                                .font(AppFonts.shared.bodySmall)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(AppColors.shared.whiteShades98)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    SearchScreen()
} 