import Foundation
import SwiftUI

public struct Localization {
    public static var shared = Self()
    
    public enum Language: String, CaseIterable {
        case english = "en"
        case spanish = "es"
        case french = "fr"
        case german = "de"
        case chinese = "zh"
        case japanese = "ja"
        case korean = "ko"
        case arabic = "ar"
        case hindi = "hi"
        case portuguese = "pt"
    }
    
    public var currentLanguage: Language {
        get {
            if let languageCode = UserDefaults.standard.string(forKey: "AppLanguage"),
               let language = Language(rawValue: languageCode) {
                return language
            }
            return .english
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "AppLanguage")
        }
    }
    
    public func localizedString(for key: StringKey, comment: String = "") -> String {
        let bundle = Bundle.main
        let languageCode = currentLanguage.rawValue
        
        if let path = bundle.path(forResource: languageCode, ofType: "lproj"),
           let languageBundle = Bundle(path: path) {
            return languageBundle.localizedString(forKey: key.rawValue, value: key.rawValue, table: nil)
        }
        
        return NSLocalizedString(key.rawValue, comment: comment)
    }
    
    public func localizedString(for key: StringKey, arguments: [CVarArg]) -> String {
        let format = localizedString(for: key)
        return String(format: format, arguments: arguments)
    }
}

public enum StringKey: String, CaseIterable {
    case ok = "ok"
    case cancel = "cancel"
    case save = "save"
    case delete = "delete"
    case edit = "edit"
    case add = "add"
    case close = "close"
    case back = "back"
    case next = "next"
    case previous = "previous"
    case done = "done"
    case loading = "loading"
    case error = "error"
    case success = "success"
    case warning = "warning"
    case info = "info"
    
    case home = "home"
    case settings = "settings"
    case profile = "profile"
    case search = "search"
    case filter = "filter"
    case sort = "sort"
    case refresh = "refresh"
    case share = "share"
 
    case task = "task"
    case tasks = "tasks"
    case taskList = "task_list"
    case createTask = "create_task"
    case editTask = "edit_task"
    case deleteTask = "delete_task"
    case taskTitle = "task_title"
    case taskDescription = "task_description"
    case taskPriority = "task_priority"
    case taskDueDate = "task_due_date"
    case taskLocation = "task_location"
    case taskCompleted = "task_completed"
    case taskPending = "task_pending"
    case taskOverdue = "task_overdue"

    case priorityLow = "priority_low"
    case priorityMedium = "priority_medium"
    case priorityHigh = "priority_high"
    case priorityUrgent = "priority_urgent"

    case location = "location"
    case map = "map"
    case selectLocation = "select_location"
    case currentLocation = "current_location"
    case locationPicker = "location_picker"
    case address = "address"
    case coordinates = "coordinates"
    
    case today = "today"
    case tomorrow = "tomorrow"
    case yesterday = "yesterday"
    case thisWeek = "this_week"
    case nextWeek = "next_week"
    case thisMonth = "this_month"
    case nextMonth = "next_month"
    case dueDate = "due_date"
    case createdAt = "created_at"
    case updatedAt = "updated_at"

    case statistics = "statistics"
    case totalTasks = "total_tasks"
    case completedTasks = "completed_tasks"
    case pendingTasks = "pending_tasks"
    case overdueTasks = "overdue_tasks"
    case completionRate = "completion_rate"

    case create = "create"
    case update = "update"
    case remove = "remove"
    case select = "select"
    case choose = "choose"
    case view = "view"
    case show = "show"
    case hide = "hide"
    case enable = "enable"
    case disable = "disable"

    case noTasks = "no_tasks"
    case noTasksMessage = "no_tasks_message"
    case taskCreated = "task_created"
    case taskUpdated = "task_updated"
    case taskDeleted = "task_deleted"
    case taskUncompleted = "task_uncompleted"
    case locationRequired = "location_required"
    case titleRequired = "title_required"
    case descriptionOptional = "description_optional"
    
    case errorCreatingTask = "error_creating_task"
    case errorUpdatingTask = "error_updating_task"
    case errorDeletingTask = "error_deleting_task"
    case errorLoadingTasks = "error_loading_tasks"
    case errorSavingData = "error_saving_data"
    case errorLoadingData = "error_loading_data"
    case errorNetworkConnection = "error_network_connection"
    case errorLocationPermission = "error_location_permission"
    case errorCameraPermission = "error_camera_permission"

    case locationPermissionTitle = "location_permission_title"
    case locationPermissionMessage = "location_permission_message"
    case cameraPermissionTitle = "camera_permission_title"
    case cameraPermissionMessage = "camera_permission_message"
    case notificationPermissionTitle = "notification_permission_title"
    case notificationPermissionMessage = "notification_permission_message"
    
    case general = "general"
    case appearance = "appearance"
    case notifications = "notifications"
    case privacy = "privacy"
    case data = "data"
    case about = "about"
    case help = "help"
    case feedback = "feedback"
    case rateApp = "rate_app"
    case shareApp = "share_app"

    case lightMode = "light_mode"
    case darkMode = "dark_mode"
    case systemMode = "system_mode"
    case theme = "theme"
    case accentColor = "accent_color"

    case exportData = "export_data"
    case importData = "import_data"
    case clearData = "clear_data"
    case backupData = "backup_data"
    case restoreData = "restore_data"
    case dataManagement = "data_management"

    case appName = "app_name"
    case appVersion = "app_version"
    case appBuild = "app_build"
    case developer = "developer"
    case copyright = "copyright"
    case termsOfService = "terms_of_service"
    case privacyPolicy = "privacy_policy"
    case license = "license"
}

extension String {
    public var localized: String {
        return Localization.shared.localizedString(for: StringKey(rawValue: self) ?? .ok)
    }
    
    public func localized(with arguments: [CVarArg]) -> String {
        return Localization.shared.localizedString(for: StringKey(rawValue: self) ?? .ok, arguments: arguments)
    }
}

extension StringKey {
    public var localized: String {
        return Localization.shared.localizedString(for: self)
    }
    
    public func localized(with arguments: [CVarArg]) -> String {
        return Localization.shared.localizedString(for: self, arguments: arguments)
    }
} 
