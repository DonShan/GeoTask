import Foundation

public class UserDefaultsManager {
    public static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // String Operations
    public func saveString(_ value: String, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func getString(forKey key: String) -> String? {
        return userDefaults.string(forKey: key)
    }
    
    public func getString(forKey key: String, defaultValue: String) -> String {
        return userDefaults.string(forKey: key) ?? defaultValue
    }
    
    public func removeString(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // Integer Operations
    public func saveInteger(_ value: Int, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func getInteger(forKey key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
    
    public func getInteger(forKey key: String, defaultValue: Int) -> Int {
        return userDefaults.object(forKey: key) as? Int ?? defaultValue
    }
    
    public func removeInteger(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // Double Operations
    public func saveDouble(_ value: Double, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func getDouble(forKey key: String) -> Double {
        return userDefaults.double(forKey: key)
    }
    
    public func getDouble(forKey key: String, defaultValue: Double) -> Double {
        return userDefaults.object(forKey: key) as? Double ?? defaultValue
    }
    
    public func removeDouble(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // Boolean Operations
    public func saveBoolean(_ value: Bool, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func getBoolean(forKey key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
    
    public func getBoolean(forKey key: String, defaultValue: Bool) -> Bool {
        return userDefaults.object(forKey: key) as? Bool ?? defaultValue
    }
    
    public func removeBoolean(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // Array Operations
    public func saveStringArray(_ value: [String], forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func getStringArray(forKey key: String) -> [String]? {
        return userDefaults.stringArray(forKey: key)
    }
    
    public func getStringArray(forKey key: String, defaultValue: [String]) -> [String] {
        return userDefaults.stringArray(forKey: key) ?? defaultValue
    }
    
    public func saveIntegerArray(_ value: [Int], forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func getIntegerArray(forKey key: String) -> [Int]? {
        return userDefaults.array(forKey: key) as? [Int]
    }
    
    public func getIntegerArray(forKey key: String, defaultValue: [Int]) -> [Int] {
        return userDefaults.array(forKey: key) as? [Int] ?? defaultValue
    }
    
    public func removeArray(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // Dictionary Operations
    public func saveDictionary(_ value: [String: Any], forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func getDictionary(forKey key: String) -> [String: Any]? {
        return userDefaults.dictionary(forKey: key)
    }
    
    public func getDictionary(forKey key: String, defaultValue: [String: Any]) -> [String: Any] {
        return userDefaults.dictionary(forKey: key) ?? defaultValue
    }
    
    public func removeDictionary(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // Data Operations
    public func saveData(_ value: Data, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func getData(forKey key: String) -> Data? {
        return userDefaults.data(forKey: key)
    }
    
    public func getData(forKey key: String, defaultValue: Data) -> Data {
        return userDefaults.data(forKey: key) ?? defaultValue
    }
    
    public func removeData(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // URL Operations
    public func saveURL(_ value: URL, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func getURL(forKey key: String) -> URL? {
        return userDefaults.url(forKey: key)
    }
    
    public func getURL(forKey key: String, defaultValue: URL) -> URL {
        return userDefaults.url(forKey: key) ?? defaultValue
    }
    
    public func removeURL(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // Date Operations
    public func saveDate(_ value: Date, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func getDate(forKey key: String) -> Date? {
        return userDefaults.object(forKey: key) as? Date
    }
    
    public func getDate(forKey key: String, defaultValue: Date) -> Date {
        return userDefaults.object(forKey: key) as? Date ?? defaultValue
    }
    
    public func removeDate(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // Codable Operations
    public func saveCodable<T: Codable>(_ value: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Error saving codable object: \(error)")
        }
    }
    
    public func getCodable<T: Codable>(forKey key: String, type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Error decoding codable object: \(error)")
            return nil
        }
    }
    
    public func getCodable<T: Codable>(forKey key: String, type: T.Type, defaultValue: T) -> T {
        return getCodable(forKey: key, type: type) ?? defaultValue
    }
    
    public func removeCodable(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // Generic Operations
    public func saveObject(_ value: Any, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func getObject(forKey key: String) -> Any? {
        return userDefaults.object(forKey: key)
    }
    
    public func getObject<T>(forKey key: String, type: T.Type) -> T? {
        return userDefaults.object(forKey: key) as? T
    }
    
    public func getObject<T>(forKey key: String, type: T.Type, defaultValue: T) -> T {
        return userDefaults.object(forKey: key) as? T ?? defaultValue
    }
    
    public func removeObject(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // Utility Operations
    public func hasValue(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
    
    public func clearAll() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleIdentifier)
        }
    }
    
    public func clearKeys(_ keys: [String]) {
        for key in keys {
            userDefaults.removeObject(forKey: key)
        }
    }
    
    public func synchronize() {
        userDefaults.synchronize()
    }
    
    public func getAllKeys() -> [String] {
        return Array(userDefaults.dictionaryRepresentation().keys)
    }
    
    public func getAllValues() -> [String: Any] {
        return userDefaults.dictionaryRepresentation()
    }
}

// UserDefaults Keys
public struct UserDefaultsKeys {
    // User related keys
    public static let userId = "userId"
    public static let userName = "userName"
    public static let userEmail = "userEmail"
    public static let userPhone = "userPhone"
    public static let userProfileImage = "userProfileImage"
    
    // App settings keys
    public static let isFirstLaunch = "isFirstLaunch"
    public static let appVersion = "appVersion"
    public static let buildNumber = "buildNumber"
    public static let lastLaunchDate = "lastLaunchDate"
    
    // Theme and UI keys
    public static let isDarkMode = "isDarkMode"
    public static let selectedTheme = "selectedTheme"
    public static let fontSize = "fontSize"
    public static let language = "language"
    
    // Authentication keys
    public static let isLoggedIn = "isLoggedIn"
    public static let authToken = "authToken"
    public static let refreshToken = "refreshToken"
    public static let tokenExpiryDate = "tokenExpiryDate"
    
    // Notification keys
    public static let pushNotificationsEnabled = "pushNotificationsEnabled"
    public static let emailNotificationsEnabled = "emailNotificationsEnabled"
    public static let notificationSound = "notificationSound"
    public static let notificationVibration = "notificationVibration"
    
    // Data keys
    public static let cachedData = "cachedData"
    public static let lastSyncDate = "lastSyncDate"
    public static let offlineData = "offlineData"
    
    // Feature flags
    public static let featureFlags = "featureFlags"
    public static let betaFeaturesEnabled = "betaFeaturesEnabled"
    
    // Analytics and tracking
    public static let analyticsEnabled = "analyticsEnabled"
    public static let crashReportingEnabled = "crashReportingEnabled"
    public static let userConsent = "userConsent"
}

// UserDefaults Extensions
extension UserDefaultsManager {
    
    // User Management
    public func saveUser(_ user: User) {
        saveCodable(user, forKey: UserDefaultsKeys.userId)
    }
    
    public func getUser() -> User? {
        return getCodable(forKey: UserDefaultsKeys.userId, type: User.self)
    }
    
    public func clearUser() {
        removeObject(forKey: UserDefaultsKeys.userId)
        removeString(forKey: UserDefaultsKeys.userName)
        removeString(forKey: UserDefaultsKeys.userEmail)
        removeString(forKey: UserDefaultsKeys.userPhone)
        removeString(forKey: UserDefaultsKeys.userProfileImage)
    }
    
    // App Settings
    public func isFirstLaunch() -> Bool {
        let isFirst = getBoolean(forKey: UserDefaultsKeys.isFirstLaunch, defaultValue: true)
        if isFirst {
            saveBoolean(false, forKey: UserDefaultsKeys.isFirstLaunch)
        }
        return isFirst
    }
    
    public func saveAppVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            saveString(version, forKey: UserDefaultsKeys.appVersion)
        }
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            saveString(build, forKey: UserDefaultsKeys.buildNumber)
        }
    }
    
    public func updateLastLaunchDate() {
        saveDate(Date(), forKey: UserDefaultsKeys.lastLaunchDate)
    }
    
    // Authentication
    public func saveAuthToken(_ token: String) {
        saveString(token, forKey: UserDefaultsKeys.authToken)
    }
    
    public func getAuthToken() -> String? {
        return getString(forKey: UserDefaultsKeys.authToken)
    }
    
    public func saveRefreshToken(_ token: String) {
        saveString(token, forKey: UserDefaultsKeys.refreshToken)
    }
    
    public func getRefreshToken() -> String? {
        return getString(forKey: UserDefaultsKeys.refreshToken)
    }
    
    public func setLoggedIn(_ isLoggedIn: Bool) {
        saveBoolean(isLoggedIn, forKey: UserDefaultsKeys.isLoggedIn)
    }
    
    public func isLoggedIn() -> Bool {
        return getBoolean(forKey: UserDefaultsKeys.isLoggedIn)
    }
    
    public func clearAuthData() {
        removeString(forKey: UserDefaultsKeys.authToken)
        removeString(forKey: UserDefaultsKeys.refreshToken)
        removeDate(forKey: UserDefaultsKeys.tokenExpiryDate)
        setLoggedIn(false)
    }
    
    // Theme and UI
    public func setDarkMode(_ isDark: Bool) {
        saveBoolean(isDark, forKey: UserDefaultsKeys.isDarkMode)
    }
    
    public func isDarkMode() -> Bool {
        return getBoolean(forKey: UserDefaultsKeys.isDarkMode)
    }
    
    public func saveLanguage(_ language: String) {
        saveString(language, forKey: UserDefaultsKeys.language)
    }
    
    public func getLanguage() -> String {
        return getString(forKey: UserDefaultsKeys.language, defaultValue: "en")
    }
    
    // Notifications
    public func setPushNotificationsEnabled(_ enabled: Bool) {
        saveBoolean(enabled, forKey: UserDefaultsKeys.pushNotificationsEnabled)
    }
    
    public func arePushNotificationsEnabled() -> Bool {
        return getBoolean(forKey: UserDefaultsKeys.pushNotificationsEnabled, defaultValue: true)
    }
    
    // Data Management
    public func saveCachedData(_ data: [String: Any]) {
        saveDictionary(data, forKey: UserDefaultsKeys.cachedData)
    }
    
    public func getCachedData() -> [String: Any]? {
        return getDictionary(forKey: UserDefaultsKeys.cachedData)
    }
    
    public func updateLastSyncDate() {
        saveDate(Date(), forKey: UserDefaultsKeys.lastSyncDate)
    }
    
    public func getLastSyncDate() -> Date? {
        return getDate(forKey: UserDefaultsKeys.lastSyncDate)
    }
}

 
