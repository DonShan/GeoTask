import SwiftUI

// MARK: - Base View Protocol
protocol BaseViewProtocol {
    var navigationTitle: String { get }
    var showBackButton: Bool { get }
    var showCloseButton: Bool { get }
    var toolbarItems: [ToolbarItem] { get }
}

// MARK: - Base View
struct BaseView<Content: View>: View {
    let content: Content
    let navigationTitle: String
    let showBackButton: Bool
    let showCloseButton: Bool
    let toolbarItems: [ToolbarItem]
    
    @EnvironmentObject var coordinator: AppNavigationCoordinator
    
    init(
        navigationTitle: String = "",
        showBackButton: Bool = false,
        showCloseButton: Bool = false,
        toolbarItems: [ToolbarItem] = [],
        @ViewBuilder content: () -> Content
    ) {
        self.navigationTitle = navigationTitle
        self.showBackButton = showBackButton
        self.showCloseButton = showCloseButton
        self.toolbarItems = toolbarItems
        self.content = content()
    }
    
    var body: some View {
        VStack {
            // Custom header with navigation buttons
            HStack {
                if showBackButton {
                    Button(action: {
                        coordinator.navigateBack()
                    }) {
                        Image(systemName: DesignSystemIcons.shared.backArrow)
                            .font(.title3)
                            .foregroundColor(DesignSystemColors.shared.green)
                    }
                    .padding(.leading)
                }
                
                Spacer()
                
                if showCloseButton {
                    Button(action: {
                        coordinator.dismissSheet()
                    }) {
                        Image(systemName: DesignSystemIcons.shared.close)
                            .font(.title3)
                            .foregroundColor(DesignSystemColors.shared.green)
                    }
                    .padding(.trailing)
                }
            }
            .padding(.top)
            
            // Content
            content
                .navigationTitle(navigationTitle)
                .navigationBarTitleDisplayMode(.large)
                .navigationBarHidden(true)
        }
    }
}

// MARK: - Base Sheet View
struct BaseSheetView<Content: View>: View {
    let content: Content
    let navigationTitle: String
    let showCloseButton: Bool
    let toolbarItems: [ToolbarItem]
    
    @EnvironmentObject var coordinator: AppNavigationCoordinator
    
    init(
        navigationTitle: String = "",
        showCloseButton: Bool = true,
        toolbarItems: [ToolbarItem] = [],
        @ViewBuilder content: () -> Content
    ) {
        self.navigationTitle = navigationTitle
        self.showCloseButton = showCloseButton
        self.toolbarItems = toolbarItems
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Custom header with close button
                HStack {
                    Spacer()
                    
                    if showCloseButton {
                        Button(action: {
                            coordinator.dismissSheet()
                        }) {
                            Image(systemName: DesignSystemIcons.shared.close)
                                .font(.title3)
                                .foregroundColor(DesignSystemColors.shared.green)
                        }
                        .padding(.trailing)
                    }
                }
                .padding(.top)
                
                // Content
                content
                    .navigationTitle(navigationTitle)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true)
            }
        }
    }
}

// MARK: - Toolbar Item Helper
struct ToolbarItem {
    let placement: ToolbarItemPlacement
    let content: AnyView
    
    init(placement: ToolbarItemPlacement, @ViewBuilder content: () -> some View) {
        self.placement = placement
        self.content = AnyView(content())
    }
}

// MARK: - Navigation Extensions
extension View {
    func withBaseNavigation(
        title: String = "",
        showBackButton: Bool = false,
        showCloseButton: Bool = false,
        toolbarItems: [ToolbarItem] = []
    ) -> some View {
        BaseView(
            navigationTitle: title,
            showBackButton: showBackButton,
            showCloseButton: showCloseButton,
            toolbarItems: toolbarItems
        ) {
            self
        }
    }
    
    func withBaseSheet(
        title: String = "",
        showCloseButton: Bool = true,
        toolbarItems: [ToolbarItem] = []
    ) -> some View {
        BaseSheetView(
            navigationTitle: title,
            showCloseButton: showCloseButton,
            toolbarItems: toolbarItems
        ) {
            self
        }
    }
}

// MARK: - Common Toolbar Items
extension ToolbarItem {
    static func addButton(action: @escaping () -> Void) -> ToolbarItem {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationBarButton(
                icon: DesignSystemIcons.shared.add,
                action: action
            )
        }
    }
    
    static func editButton(action: @escaping () -> Void) -> ToolbarItem {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationBarButton(
                icon: DesignSystemIcons.shared.edit,
                action: action
            )
        }
    }
    
    static func deleteButton(action: @escaping () -> Void) -> ToolbarItem {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationBarButton(
                icon: DesignSystemIcons.shared.delete,
                iconColor: DesignSystemColors.shared.red,
                action: action
            )
        }
    }
    
    static func saveButton(action: @escaping () -> Void) -> ToolbarItem {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationBarButton(
                icon: DesignSystemIcons.shared.save,
                action: action
            )
        }
    }
} 