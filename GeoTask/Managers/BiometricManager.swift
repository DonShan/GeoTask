import Foundation
import LocalAuthentication
import Combine

//  Biometric Type
public enum BiometricType: String, CaseIterable {
    case none = "none"
    case touchID = "touchid"
    case faceID = "faceid"
    case unknown = "unknown"
    
    public var displayName: String {
        switch self {
        case .none: return "None"
        case .touchID: return "Touch ID"
        case .faceID: return "Face ID"
        case .unknown: return "Unknown"
        }
    }
    
    public var iconName: String {
        switch self {
        case .none: return "lock"
        case .touchID: return "touchid"
        case .faceID: return "faceid"
        case .unknown: return "lock"
        }
    }
}

// Biometric Error
public enum BiometricError: LocalizedError {
    case notAvailable
    case notEnrolled
    case lockedOut
    case cancelled
    case failed
    case userFallback
    case systemCancel
    case passcodeNotSet
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case appCancel
    case invalidContext
    case notInteractive
    case other(Error)
    
    public var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Biometric authentication is not available on this device"
        case .notEnrolled:
            return "No biometric data is enrolled"
        case .lockedOut:
            return "Biometric authentication is locked out"
        case .cancelled:
            return "Authentication was cancelled by the user"
        case .failed:
            return "Authentication failed"
        case .userFallback:
            return "User chose to use fallback authentication"
        case .systemCancel:
            return "Authentication was cancelled by the system"
        case .passcodeNotSet:
            return "Passcode is not set on the device"
        case .biometryNotAvailable:
            return "Biometric authentication is not available"
        case .biometryNotEnrolled:
            return "No biometric data is enrolled"
        case .biometryLockout:
            return "Biometric authentication is locked out"
        case .appCancel:
            return "Authentication was cancelled by the app"
        case .invalidContext:
            return "Invalid authentication context"
        case .notInteractive:
            return "Authentication is not interactive"
        case .other(let error):
            return error.localizedDescription
        }
    }
}

//  Biometric Manager
@MainActor
public class BiometricManager: ObservableObject {
    public static let shared = BiometricManager()
    
    // MARK: - Published Properties
    @Published public private(set) var biometricType: BiometricType = .none
    @Published public private(set) var isAvailable: Bool = false
    @Published public private(set) var isEnrolled: Bool = false
    @Published public private(set) var isLockedOut: Bool = false
    
    // Private Properties
    private let context = LAContext()
    private let userDefaults = UserDefaultsManager.shared
    
    // Constants
    private enum Constants {
        static let biometricEnabledKey = "biometric_enabled"
        static let biometricTypeKey = "biometric_type"
        static let lastAuthenticationKey = "last_biometric_auth"
    }
    
    // Initialization
    public init() {
        setupBiometricType()
        checkAvailability()
    }
    
    // Setup
    private func setupBiometricType() {
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            switch context.biometryType {
            case .touchID:
                biometricType = .touchID
            case .faceID:
                biometricType = .faceID
            case .none:
                biometricType = .none
            @unknown default:
                biometricType = .unknown
            }
        } else {
            biometricType = .none
        }
    }
    
    private func checkAvailability() {
        var error: NSError?
        isAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if let error = error {
            handleBiometricError(error)
        }
    }
    
    // Public Methods
    public func authenticate(reason: String = "Authenticate to continue") -> AnyPublisher<Bool, BiometricError> {
        guard isAvailable else {
            return Fail(error: BiometricError.notAvailable)
                .eraseToAnyPublisher()
        }
        
        return Future<Bool, BiometricError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.failed))
                return
            }
            
            self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.userDefaults.saveDate(Date(), forKey: Constants.lastAuthenticationKey)
                        promise(.success(true))
                    } else if let error = error {
                        let biometricError = self.handleBiometricError(error)
                        promise(.failure(biometricError))
                    } else {
                        promise(.failure(.failed))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func authenticateWithFallback(reason: String = "Authenticate to continue") -> AnyPublisher<Bool, BiometricError> {
        guard isAvailable else {
            return Fail(error: BiometricError.notAvailable)
                .eraseToAnyPublisher()
        }
        
        return Future<Bool, BiometricError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.failed))
                return
            }
            
            self.context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.userDefaults.saveDate(Date(), forKey: Constants.lastAuthenticationKey)
                        promise(.success(true))
                    } else if let error = error {
                        let biometricError = self.handleBiometricError(error)
                        promise(.failure(biometricError))
                    } else {
                        promise(.failure(.failed))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func enableBiometricAuthentication() -> AnyPublisher<Bool, BiometricError> {
        return authenticate(reason: "Enable biometric authentication")
            .map { success in
                if success {
                    self.userDefaults.saveBoolean(true, forKey: Constants.biometricEnabledKey)
                    self.userDefaults.saveString(self.biometricType.rawValue, forKey: Constants.biometricTypeKey)
                }
                return success
            }
            .eraseToAnyPublisher()
    }
    
    public func disableBiometricAuthentication() {
        userDefaults.saveBoolean(false, forKey: Constants.biometricEnabledKey)
        userDefaults.removeData(forKey: Constants.biometricTypeKey)
    }
    
    public func isBiometricEnabled() -> Bool {
        return userDefaults.getBoolean(forKey: Constants.biometricEnabledKey)
    }
    
    public func getLastAuthenticationDate() -> Date? {
        return userDefaults.getDate(forKey: Constants.lastAuthenticationKey)
    }
    
    public func clearLastAuthenticationDate() {
        userDefaults.removeData(forKey: Constants.lastAuthenticationKey)
    }
    
    // Utility Methods
    public func canUseBiometricAuthentication() -> Bool {
        return isAvailable && isBiometricEnabled()
    }
    
    public func shouldReauthenticate(interval: TimeInterval = 300) -> Bool {
        guard let lastAuth = getLastAuthenticationDate() else {
            return true
        }
        
        return Date().timeIntervalSince(lastAuth) > interval
    }
    
    public func resetContext() {
        context.invalidate()
    }
    
    // Error Handling
    private func handleBiometricError(_ error: Error) -> BiometricError {
        let laError = error as? LAError
        
        switch laError?.code {
        case .biometryNotAvailable:
            isAvailable = false
            return .biometryNotAvailable
        case .biometryNotEnrolled:
            isEnrolled = false
            return .biometryNotEnrolled
        case .biometryLockout:
            isLockedOut = true
            return .biometryLockout
        case .userCancel:
            return .cancelled
        case .userFallback:
            return .userFallback
        case .systemCancel:
            return .systemCancel
        case .passcodeNotSet:
            return .passcodeNotSet
        case .appCancel:
            return .appCancel
        case .invalidContext:
            return .invalidContext
        case .notInteractive:
            return .notInteractive
        default:
            return .other(error)
        }
    }
}

// Biometric Manager Extensions
extension BiometricManager {
    
    // MARK: - Session Integration
    public func authenticateForSession() -> AnyPublisher<UserSession, BiometricError> {
        return authenticate(reason: "Authenticate to access your account")
            .flatMap { _ -> AnyPublisher<UserSession, BiometricError> in
                let mockSession = UserSession(
                    user: User(id: "biometric_user", name: "Biometric User", email: "user@example.com"),
                    token: JWTToken(
                        accessToken: "biometric_token",
                        refreshToken: "biometric_refresh",
                        expiresAt: Date().addingTimeInterval(3600)
                    )
                )
                
                return Just(mockSession)
                    .setFailureType(to: BiometricError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // Security Levels
    public func authenticateWithSecurityLevel(_ level: SecurityLevel) -> AnyPublisher<Bool, BiometricError> {
        let reason: String
        
        switch level {
        case .low:
            reason = "Authenticate to continue"
        case .medium:
            reason = "Authenticate to access sensitive data"
        case .high:
            reason = "Authenticate to access critical data"
        case .critical:
            reason = "Authenticate to access highly sensitive data"
        }
        
        return authenticate(reason: reason)
    }
    
    // Analytics
    public func getBiometricAnalytics() -> [String: Any] {
        return [
            "biometric_type": biometricType.rawValue,
            "is_available": isAvailable,
            "is_enrolled": isEnrolled,
            "is_locked_out": isLockedOut,
            "is_enabled": isBiometricEnabled(),
            "last_authentication": getLastAuthenticationDate()?.timeIntervalSince1970 ?? 0,
            "should_reauthenticate": shouldReauthenticate()
        ]
    }
}

// Security Level
public enum SecurityLevel {
    case low
    case medium
    case high
    case critical
    
    public var reauthenticationInterval: TimeInterval {
        switch self {
        case .low: return 600    // 10 minutes
        case .medium: return 300  // 5 minutes
        case .high: return 60     // 1 minute
        case .critical: return 0  // Always reauthenticate
        }
    }
} 
