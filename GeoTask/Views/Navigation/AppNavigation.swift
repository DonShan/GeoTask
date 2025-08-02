import SwiftUI
import Combine

enum AppRoute: Hashable {
    case home
    case taskList
    case taskDetail(Task)
    case createTask
    case settings
    case profile
    case map
    case locationPicker
}

class AppNavigationCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var presentedSheet: AppRoute?
    @Published var presentedFullScreenCover: AppRoute?

    func navigate(to route: AppRoute) {
        navigationPath.append(route)
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func presentSheet(_ route: AppRoute) {
        presentedSheet = route
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
    
    func presentFullScreenCover(_ route: AppRoute) {
        presentedFullScreenCover = route
    }
    
    func dismissFullScreenCover() {
        presentedFullScreenCover = nil
    }
}

struct AppNavigationView: View {
    @StateObject private var coordinator = AppNavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ContentView()
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
                .sheet(item: $coordinator.presentedSheet) { route in
                    sheetView(for: route)
                }
                .fullScreenCover(item: $coordinator.presentedFullScreenCover) { route in
                    fullScreenView(for: route)
                }
        }
        .environmentObject(coordinator)
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .home:
            ContentView()
        case .taskList:
            placeholderView(title: "Task List")
        case .taskDetail(let task):
            placeholderView(title: "Task Detail: \(task.title)")
        case .createTask:
            placeholderView(title: "Create Task")
        case .settings:
            placeholderView(title: "Settings")
        case .profile:
            placeholderView(title: "Profile")
        case .map:
            placeholderView(title: "Map")
        case .locationPicker:
            placeholderView(title: "Location Picker")
        }
    }
    
    @ViewBuilder
    private func sheetView(for route: AppRoute) -> some View {
        switch route {
        case .createTask:
            placeholderSheetView(title: "Create Task")
        case .locationPicker:
            placeholderSheetView(title: "Location Picker")
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func fullScreenView(for route: AppRoute) -> some View {
        switch route {
        case .map:
            placeholderFullScreenView(title: "Map")
        default:
            EmptyView()
        }
    }
}

struct placeholderView: View {
    let title: String
    @EnvironmentObject var coordinator: AppNavigationCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            
            Text("This is a placeholder view for navigation testing")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            LazyVStack(spacing: 12) {
                PrimaryNavigationButton(title: "Navigate to Task List") {
                    coordinator.navigate(to: .taskList)
                }
                
                SecondaryNavigationButton(title: "Present Create Task") {
                    NavigationHelper.presentCreateTask(coordinator: coordinator)
                }
                
                SecondaryNavigationButton(title: "Present Map") {
                    NavigationHelper.presentMap(coordinator: coordinator)
                }
                
                SecondaryNavigationButton(title: "Go Back") {
                    coordinator.navigateBack()
                }
            }
        }
        .padding()
        .withBaseNavigation(
            title: title,
            showBackButton: true
        )
    }
}

struct placeholderSheetView: View {
    let title: String
    @EnvironmentObject var coordinator: AppNavigationCoordinator
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        coordinator.dismissSheet()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("This is a placeholder sheet view")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                PrimaryNavigationButton(title: "Dismiss") {
                    coordinator.dismissSheet()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}

struct placeholderFullScreenView: View {
    let title: String
    @EnvironmentObject var coordinator: AppNavigationCoordinator
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("This is a placeholder full-screen view")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                PrimaryNavigationButton(title: "Dismiss") {
                    coordinator.dismissFullScreenCover()
                }
            }
            .padding()
        }
    }
}

extension AppRoute: Identifiable {
    var id: String {
        switch self {
        case .home: return "home"
        case .taskList: return "taskList"
        case .taskDetail: return "taskDetail"
        case .createTask: return "createTask"
        case .settings: return "settings"
        case .profile: return "profile"
        case .map: return "map"
        case .locationPicker: return "locationPicker"
        }
    }
}


struct NavigationHelper {
    static func navigateToTaskDetail(_ task: Task, coordinator: AppNavigationCoordinator) {
        coordinator.navigate(to: .taskDetail(task))
    }
    
    static func presentCreateTask(coordinator: AppNavigationCoordinator) {
        coordinator.presentSheet(.createTask)
    }
    
    static func presentLocationPicker(coordinator: AppNavigationCoordinator) {
        coordinator.presentSheet(.locationPicker)
    }
    
    static func presentMap(coordinator: AppNavigationCoordinator) {
        coordinator.presentFullScreenCover(.map)
    }
} 
