# GeoTask - Navigation Stack System

## Overview
This document describes the simplified, reusable navigation stack system implemented for the GeoTask iOS application using SwiftUI and MVVM architecture.

## Navigation Architecture

### Core Components

#### 1. AppNavigationCoordinator
- **Location**: `Views/Navigation/AppNavigation.swift`
- **Purpose**: Central navigation coordinator that manages all navigation state
- **Features**:
  - Navigation stack management
  - Sheet presentation
  - Full-screen cover presentation
  - Back navigation
  - Root navigation

#### 2. AppRoute Enum
- **Purpose**: Defines all possible navigation routes in the app
- **Routes**:
  - `home`: Main home screen
  - `taskList`: List of all tasks
  - `taskDetail(Task)`: Detailed view of a specific task
  - `createTask`: Create new task form
  - `settings`: App settings
  - `profile`: User profile
  - `map`: Full-screen map view
  - `locationPicker`: Location selection sheet

#### 3. NavigationHelper
- **Purpose**: Provides convenient helper methods for common navigation actions
- **Methods**:
  - `navigateToTaskDetail(_:coordinator:)`: Navigate to task detail
  - `presentCreateTask(coordinator:)`: Present create task sheet
  - `presentLocationPicker(coordinator:)`: Present location picker sheet
  - `presentMap(coordinator:)`: Present full-screen map

## Usage Examples

### Basic Navigation
```swift
@EnvironmentObject var coordinator: AppNavigationCoordinator

// Navigate to a new screen
coordinator.navigate(to: .taskList)

// Navigate back
coordinator.navigateBack()

// Navigate to root
coordinator.navigateToRoot()
```

### Sheet Presentation
```swift
// Present a sheet
NavigationHelper.presentCreateTask(coordinator: coordinator)

// Dismiss sheet
coordinator.dismissSheet()
```

### Full-Screen Presentation
```swift
// Present full-screen
NavigationHelper.presentMap(coordinator: coordinator)

// Dismiss full-screen
coordinator.dismissFullScreenCover()
```

## Reusable Components

### Navigation Buttons
- **Location**: `Views/Components/NavigationButton.swift`
- **Components**:
  - `PrimaryNavigationButton`: Primary action button
  - `SecondaryNavigationButton`: Secondary action button
  - `IconNavigationButton`: Icon-only button
  - `FloatingActionButton`: Floating action button
  - `NavigationBarButton`: Navigation bar button
  - `BackButton`: Back navigation button
  - `CloseButton`: Close/dismiss button

### Base Views
- **Location**: `Views/Base/BaseView.swift`
- **Components**:
  - `BaseView`: Standard navigation wrapper
  - `BaseSheetView`: Sheet navigation wrapper
  - `ToolbarItem`: Custom toolbar item helper

## View Extensions

### withBaseNavigation
```swift
YourView()
    .withBaseNavigation(
        title: "Screen Title",
        showBackButton: true,
        showCloseButton: false,
        toolbarItems: [.addButton { /* action */ }]
    )
```

### withBaseSheet
```swift
YourView()
    .withBaseSheet(
        title: "Sheet Title",
        showCloseButton: true,
        toolbarItems: [.saveButton { /* action */ }]
    )
```

## Common Toolbar Items
- `.addButton(action:)`: Add button
- `.editButton(action:)`: Edit button
- `.deleteButton(action:)`: Delete button
- `.saveButton(action:)`: Save button

## Folder Structure
```
GeoTask/
├── Models/
│   └── Task.swift
├── Views/
│   ├── Navigation/
│   │   └── AppNavigation.swift
│   ├── Components/
│   │   └── NavigationButton.swift
│   └── Base/
│       └── BaseView.swift
├── ViewModels/
├── Services/
├── Utilities/
├── Extensions/
└── Resources/
```

## Testing the Navigation System

The current setup includes:

1. **ContentView**: Main test screen with navigation buttons
2. **Placeholder Views**: Simple views for testing each navigation type
3. **Navigation Stack**: Complete navigation flow testing

### Test Navigation Types:
- ✅ **Stack Navigation**: Push/pop between screens
- ✅ **Sheet Presentation**: Modal sheets
- ✅ **Full-Screen Covers**: Full-screen modals
- ✅ **Back Navigation**: Automatic back button handling

## Adding New Screens

1. **Add route**: Add new case to `AppRoute` enum
2. **Create view**: Create your view file
3. **Update navigation**: Add destination in `AppNavigationView.destinationView(for:)`
4. **Add helper**: If needed, add helper method to `NavigationHelper`

## Example: Adding a New Screen

```swift
// 1. Add to AppRoute
enum AppRoute: Hashable {
    // ... existing cases
    case newScreen
}

// 2. Create view
struct NewScreenView: View {
    @EnvironmentObject var coordinator: AppNavigationCoordinator
    
    var body: some View {
        Text("New Screen")
            .withBaseNavigation(title: "New Screen", showBackButton: true)
    }
}

// 3. Update navigation
private func destinationView(for route: AppRoute) -> some View {
    switch route {
    // ... existing cases
    case .newScreen:
        NewScreenView()
    }
}

// 4. Navigate to it
coordinator.navigate(to: .newScreen)
```

## Best Practices

1. **Always use the coordinator**: Inject `@EnvironmentObject var coordinator: AppNavigationCoordinator` in your views
2. **Use NavigationHelper**: For common navigation patterns, use the helper methods
3. **Consistent styling**: Use the provided button components for consistent UI
4. **Base views**: Wrap your views with appropriate base views for consistent navigation
5. **Type safety**: Use the `AppRoute` enum for all navigation destinations

This navigation system provides a clean, minimal foundation for the GeoTask app with all essential navigation patterns ready to use. 