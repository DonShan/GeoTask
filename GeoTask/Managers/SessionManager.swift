import Foundation
import Combine

// Session State
public enum SessionState {
    case authenticated
    case unauthenticated
    case expired
    case loading
}

// JWT Token Model
public struct JWTToken: Codable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresAt: Date
    public let tokenType: String
    
    public init(accessToken: String, refreshToken: String, expiresAt: Date, tokenType: String = "Bearer") {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
        self.tokenType = tokenType
    }
    
    public var isExpired: Bool {
        return Date() >= expiresAt
    }
    
    public var isExpiringSoon: Bool {
        let fiveMinutesFromNow = Date().addingTimeInterval(5 * 60) // 5 minutes
        return expiresAt <= fiveMinutesFromNow
    }
    
    public var authorizationHeader: String {
        return "\(tokenType) \(accessToken)"
    }
}

// User Session
public struct UserSession: Codable {
    public let user: User
    public let token: JWTToken
    public let lastLoginAt: Date
    public let deviceId: String
    
    public init(user: User, token: JWTToken, lastLoginAt: Date = Date(), deviceId: String = "") {
        self.user = user
        self.token = token
        self.lastLoginAt = lastLoginAt
        self.deviceId = deviceId
    }
}

// Session Manager
public class SessionManager: ObservableObject {
    public static let shared = SessionManager()
    
    // Published Properties
    @Published public private(set) var sessionState: SessionState = .unauthenticated
    @Published public private(set) var currentSession: UserSession?
    @Published public private(set) var isRefreshing = false
    
    // Private Properties
    private let userDefaults = UserDefaultsManager.shared
    private let apiService: APIServiceProtocol
    private var refreshTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    // Constants
    private enum Constants {
        static let sessionKey = "user_session"
        static let refreshThreshold: TimeInterval = 5 * 60 // 5 minutes
    }
    
    // Initialization
    public init(apiService: APIServiceProtocol = ServiceFactory.shared.createAPIService()) {
        self.apiService = apiService
        setupSession()
        startRefreshTimer()
    }
    
    //  Session Setup
    private func setupSession() {
        if let sessionData = userDefaults.getData(forKey: Constants.sessionKey),
           let session = try? JSONCoding.shared.decode(UserSession.self, from: sessionData) {
            
            if session.token.isExpired {
                // Token is expired, clear session
                clearSession()
            } else {
                // Valid session found
                currentSession = session
                sessionState = .authenticated
                
                // Setup auto-refresh if token is expiring soon
                if session.token.isExpiringSoon {
                    refreshToken()
                }
            }
        } else {
            sessionState = .unauthenticated
        }
    }
    
    // Authentication Methods
    public func login(email: String, password: String) -> AnyPublisher<UserSession, APIError> {
        sessionState = .loading
        
        return apiService.login(email: email, password: password)
            .map { response in
                // Create JWT token from response
                let token = JWTToken(
                    accessToken: response.token,
                    refreshToken: response.refreshToken,
                    expiresAt: Date().addingTimeInterval(3600), // 1 hour default
                    tokenType: "Bearer"
                )
                
                // Create user session
                let session = UserSession(
                    user: response.user,
                    token: token
                )
                
                return session
            }
            .handleEvents(receiveOutput: { [weak self] session in
                self?.saveSession(session)
            })
            .eraseToAnyPublisher()
    }
    
    public func register(email: String, password: String, name: String) -> AnyPublisher<UserSession, APIError> {
        sessionState = .loading
        
        return apiService.register(email: email, password: password, name: name)
            .map { response in
                // Create JWT token from response
                let token = JWTToken(
                    accessToken: response.token,
                    refreshToken: response.refreshToken,
                    expiresAt: Date().addingTimeInterval(3600), // 1 hour default
                    tokenType: "Bearer"
                )
                
                // Create user session
                let session = UserSession(
                    user: response.user,
                    token: token
                )
                
                return session
            }
            .handleEvents(receiveOutput: { [weak self] session in
                self?.saveSession(session)
            })
            .eraseToAnyPublisher()
    }
    
    public func logout() -> AnyPublisher<Void, APIError> {
        guard let session = currentSession else {
            clearSession()
            return Just(())
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        
        return apiService.logout()
            .map { _ in }
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.clearSession()
            })
            .eraseToAnyPublisher()
    }
    
    // Token Management
    public func refreshToken() {
        guard let session = currentSession, !isRefreshing else { return }
        
        isRefreshing = true
        
        // Call refresh token API
        apiService.refreshToken(session.token.refreshToken)
            .map { response in
                // Create new JWT token
                let newToken = JWTToken(
                    accessToken: response.token,
                    refreshToken: response.refreshToken,
                    expiresAt: Date().addingTimeInterval(3600), // 1 hour default
                    tokenType: "Bearer"
                )
                
                // Create updated session
                let updatedSession = UserSession(
                    user: session.user,
                    token: newToken,
                    lastLoginAt: session.lastLoginAt,
                    deviceId: session.deviceId
                )
                
                return updatedSession
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isRefreshing = false
                    if case .failure(let error) = completion {
                        print("Token refresh failed: \(error)")
                        self?.handleTokenRefreshFailure()
                    }
                },
                receiveValue: { [weak self] session in
                    self?.saveSession(session)
                }
            )
            .store(in: &cancellables)
    }
    
    public func getValidToken() -> String? {
        guard let session = currentSession else { return nil }
        
        if session.token.isExpired {
            // Token is expired, try to refresh
            refreshToken()
            return nil
        }
        
        if session.token.isExpiringSoon {
            // Token is expiring soon, refresh in background
            refreshToken()
        }
        
        return session.token.accessToken
    }
    
    public func getAuthorizationHeader() -> String? {
        guard let session = currentSession else { return nil }
        
        if session.token.isExpired {
            refreshToken()
            return nil
        }
        
        return session.token.authorizationHeader
    }
    
    // Session Management
    private func saveSession(_ session: UserSession) {
        do {
            let sessionData = try JSONCoding.shared.encode(session)
            userDefaults.saveData(sessionData, forKey: Constants.sessionKey)
            
            currentSession = session
            sessionState = .authenticated
            
            // Setup auto-refresh timer
            setupRefreshTimer(for: session.token)
            
        } catch {
            print("Failed to save session: \(error)")
            sessionState = .unauthenticated
        }
    }
    
    private func clearSession() {
        userDefaults.removeData(forKey: Constants.sessionKey)
        currentSession = nil
        sessionState = .unauthenticated
        stopRefreshTimer()
    }
    
    private func handleTokenRefreshFailure() {
        // Token refresh failed, clear session
        clearSession()
        sessionState = .expired
    }
    
    // Timer Management
    private func startRefreshTimer() {
        guard let session = currentSession else { return }
        setupRefreshTimer(for: session.token)
    }
    
    private func setupRefreshTimer(for token: JWTToken) {
        stopRefreshTimer()
        
        let timeUntilRefresh = token.expiresAt.timeIntervalSinceNow - Constants.refreshThreshold
        if timeUntilRefresh > 0 {
            refreshTimer = Timer.scheduledTimer(withTimeInterval: timeUntilRefresh, repeats: false) { [weak self] _ in
                self?.refreshToken()
            }
        }
    }
    
    private func stopRefreshTimer() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    // Session Information
    public var isAuthenticated: Bool {
        return sessionState == .authenticated && currentSession != nil
    }
    
    public var currentUser: User? {
        return currentSession?.user
    }
    
    public var currentToken: JWTToken? {
        return currentSession?.token
    }
    
    public var sessionDuration: TimeInterval? {
        guard let session = currentSession else { return nil }
        return Date().timeIntervalSince(session.lastLoginAt)
    }
    
    // Device Management
    public func updateDeviceId(_ deviceId: String) {
        guard var session = currentSession else { return }
        
        let updatedSession = UserSession(
            user: session.user,
            token: session.token,
            lastLoginAt: session.lastLoginAt,
            deviceId: deviceId
        )
        
        saveSession(updatedSession)
    }
    
    // Session Validation
    public func validateSession() -> Bool {
        guard let session = currentSession else {
            sessionState = .unauthenticated
            return false
        }
        
        if session.token.isExpired {
            sessionState = .expired
            return false
        }
        
        sessionState = .authenticated
        return true
    }
    
    // Force Refresh
    public func forceRefreshToken() {
        refreshToken()
    }
}



// Refresh Token Request
public struct RefreshTokenRequest: Codable {
    public let refreshToken: String
    
    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}

// Session Manager Extensions
extension SessionManager {
    
    // MARK: - Convenience Methods
    public func loginWithPhone(phone: String, password: String) -> AnyPublisher<UserSession, APIError> {
        return login(email: phone, password: password)
    }
    
    public func loginWithBiometrics() -> AnyPublisher<UserSession, APIError> {
        // Implement biometric authentication
        guard let session = currentSession else {
            return Fail(error: APIError.unauthorized)
                .eraseToAnyPublisher()
        }
        
        return Just(session)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
    
    //  Session Analytics
    public func getSessionAnalytics() -> [String: Any] {
        guard let session = currentSession else { return [:] }
        
        return [
            "user_id": session.user.id,
            "session_duration": sessionDuration ?? 0,
            "device_id": session.deviceId,
            "last_login": session.lastLoginAt,
            "token_expires_at": session.token.expiresAt,
            "is_token_expired": session.token.isExpired,
            "is_token_expiring_soon": session.token.isExpiringSoon
        ]
    }
    
    // Session Cleanup
    public func cleanupSession() {
        // Clear any temporary data
        userDefaults.removeData(forKey: "temp_session_data")
        userDefaults.removeData(forKey: "pending_requests")
    }
}

// Session Manager Observers
extension SessionManager {
    
    public func addSessionObserver(_ observer: @escaping (SessionState) -> Void) {
        $sessionState
            .sink(receiveValue: observer)
            .store(in: &cancellables)
    }
    
    public func addAuthenticationObserver(_ observer: @escaping (Bool) -> Void) {
        $sessionState
            .map { $0 == .authenticated }
            .sink(receiveValue: observer)
            .store(in: &cancellables)
    }
    
    public func addTokenRefreshObserver(_ observer: @escaping (Bool) -> Void) {
        $isRefreshing
            .sink(receiveValue: observer)
            .store(in: &cancellables)
    }
} 
