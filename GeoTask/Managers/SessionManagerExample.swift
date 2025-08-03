import Foundation
import Combine
import SwiftUI

// Session Manager Usage Examples
public class SessionManagerExample {
    
    //  Basic Authentication Flow
    public static func basicAuthenticationFlow() {
        print("=== Basic Authentication Flow ===")
        
        let sessionManager = SessionManager.shared
        var cancellables = Set<AnyCancellable>()
        
        // Login
        sessionManager.login(email: "user@example.com", password: "password")
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Login completed successfully")
                    case .failure(let error):
                        print("Login failed: \(error)")
                    }
                },
                receiveValue: { session in
                    print("User logged in: \(session.user.name)")
                    print("Session duration: \(sessionManager.sessionDuration ?? 0) seconds")
                }
            )
            .store(in: &cancellables)
        
        // Register
        sessionManager.register(email: "newuser@example.com", password: "password", name: "New User")
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Registration completed successfully")
                    case .failure(let error):
                        print("Registration failed: \(error)")
                    }
                },
                receiveValue: { session in
                    print("User registered: \(session.user.name)")
                }
            )
            .store(in: &cancellables)
        
        // Logout
        sessionManager.logout()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Logout completed successfully")
                    case .failure(let error):
                        print("Logout failed: \(error)")
                    }
                },
                receiveValue: { _ in
                    print("User logged out")
                }
            )
            .store(in: &cancellables)
    }
    
    //  Token Management Examples
    public static func tokenManagementExamples() {
        print("\n=== Token Management Examples ===")
        
        let sessionManager = SessionManager.shared
        
        // Get valid token
        if let token = sessionManager.getValidToken() {
            print("Valid token: \(token)")
        } else {
            print("No valid token available")
        }
        
        // Get authorization header
        if let authHeader = sessionManager.getAuthorizationHeader() {
            print("Authorization header: \(authHeader)")
        } else {
            print("No authorization header available")
        }
        
        // Force refresh token
        sessionManager.forceRefreshToken()
        print("Token refresh triggered")
        
        // Check token status
        if let currentToken = sessionManager.currentToken {
            print("Token expires at: \(currentToken.expiresAt)")
            print("Token is expired: \(currentToken.isExpired)")
            print("Token is expiring soon: \(currentToken.isExpiringSoon)")
        }
    }
    
    //  Session State Monitoring
    public static func sessionStateMonitoring() {
        print("\n=== Session State Monitoring ===")
        
        let sessionManager = SessionManager.shared
        var cancellables = Set<AnyCancellable>()
        
        // Monitor session state
        sessionManager.addSessionObserver { state in
            switch state {
            case .authenticated:
                print("Session state: Authenticated")
            case .unauthenticated:
                print("Session state: Unauthenticated")
            case .expired:
                print("Session state: Expired")
            case .loading:
                print("Session state: Loading")
            }
        }
        
        // Monitor authentication status
        sessionManager.addAuthenticationObserver { isAuthenticated in
            print("Authentication status: \(isAuthenticated ? "Authenticated" : "Not Authenticated")")
        }
        
        // Monitor token refresh status
        sessionManager.addTokenRefreshObserver { isRefreshing in
            print("Token refresh status: \(isRefreshing ? "Refreshing" : "Not Refreshing")")
        }
    }
    
    // Session Analytics
    public static func sessionAnalyticsExamples() {
        print("\n=== Session Analytics Examples ===")
        
        let sessionManager = SessionManager.shared
        
        // Get session analytics
        let analytics = sessionManager.getSessionAnalytics()
        print("Session Analytics: \(analytics)")
        
        // Check session duration
        if let duration = sessionManager.sessionDuration {
            print("Session duration: \(duration) seconds")
        }
        
        // Get current user
        if let user = sessionManager.currentUser {
            print("Current user: \(user.name) (\(user.email))")
        }
        
        // Validate session
        let isValid = sessionManager.validateSession()
        print("Session is valid: \(isValid)")
    }
    
    //  Device Management
    public static func deviceManagementExamples() {
        print("\n=== Device Management Examples ===")
        
        let sessionManager = SessionManager.shared
        
        // Update device ID
        let newDeviceId = "new_device_123"
        sessionManager.updateDeviceId(newDeviceId)
        print("Device ID updated to: \(newDeviceId)")
        
        // Get current device ID
        if let session = sessionManager.currentSession {
            print("Current device ID: \(session.deviceId)")
        }
    }
    
    //  Advanced Session Management
    public static func advancedSessionManagement() {
        print("\n=== Advanced Session Management ===")
        
        let sessionManager = SessionManager.shared
        
        // Cleanup session
        sessionManager.cleanupSession()
        print("Session cleanup completed")
        
        // Check if authenticated
        let isAuthenticated = sessionManager.isAuthenticated
        print("Is authenticated: \(isAuthenticated)")
        
        // Get session information
        if let session = sessionManager.currentSession {
            print("Session info:")
            print("  User: \(session.user.name)")
            print("  Last login: \(session.lastLoginAt)")
            print("  Device: \(session.deviceId)")
            print("  Token expires: \(session.token.expiresAt)")
        }
    }
}

//  SwiftUI Integration Examples
public struct SessionManagerSwiftUIExamples {
    
    //  Login View Model
    public class LoginViewModel: ObservableObject {
        @Published var email = ""
        @Published var password = ""
        @Published var isLoading = false
        @Published var errorMessage: String?
        
        private let sessionManager = SessionManager.shared
        private var cancellables = Set<AnyCancellable>()
        
        public init() {
            // Monitor session state
            sessionManager.addSessionObserver { [weak self] state in
                DispatchQueue.main.async {
                    switch state {
                    case .authenticated:
                        self?.isLoading = false
                        self?.errorMessage = nil
                    case .loading:
                        self?.isLoading = true
                    case .expired:
                        self?.errorMessage = "Session expired. Please login again."
                    case .unauthenticated:
                        self?.isLoading = false
                    }
                }
            }
        }
        
        public func login() {
            isLoading = true
            errorMessage = nil
            
            sessionManager.login(email: email, password: password)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        if case .failure(let error) = completion {
                            self?.errorMessage = error.localizedDescription
                        }
                    },
                    receiveValue: { session in
                        print("Login successful: \(session.user.name)")
                    }
                )
                .store(in: &cancellables)
        }
        
        public func logout() {
            sessionManager.logout()
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            print("Logout error: \(error)")
                        }
                    },
                    receiveValue: { _ in
                        print("Logout successful")
                    }
                )
                .store(in: &cancellables)
        }
    }
    
    //  Session Status View
    public struct SessionStatusView: View {
        @StateObject private var sessionManager = SessionManager.shared
        
        public var body: some View {
            VStack(spacing: 16) {
                Text("Session Status")
                    .font(AppFonts.shared.titleLarge)
                
                switch sessionManager.sessionState {
                case .authenticated:
                    VStack {
                        Text("✅ Authenticated")
                            .foregroundColor(AppColors.shared.alertGreen)
                        
                        if let user = sessionManager.currentUser {
                            Text("User: \(user.name)")
                                .font(AppFonts.shared.bodyMedium)
                        }
                        
                        if let duration = sessionManager.sessionDuration {
                            Text("Session Duration: \(Int(duration))s")
                                .font(AppFonts.shared.bodySmall)
                        }
                    }
                    
                case .unauthenticated:
                    Text(" Not Authenticated")
                        .foregroundColor(AppColors.shared.alertRed)
                    
                case .expired:
                    Text("Session Expired")
                        .foregroundColor(AppColors.shared.alertYellow)
                    
                case .loading:
                    Text("Loading...")
                        .foregroundColor(AppColors.shared.black)
                }
                
                if sessionManager.isRefreshing {
                    Text("Refreshing Token...")
                        .font(AppFonts.shared.bodySmall)
                        .foregroundColor(AppColors.shared.alertYellow)
                }
            }
            .padding()
        }
    }
    
    // Authentication Required View
    public struct AuthenticationRequiredView<Content: View>: View {
        @StateObject private var sessionManager = SessionManager.shared
        let content: Content
        
        public init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        public var body: some View {
            Group {
                if sessionManager.isAuthenticated {
                    content
                } else {
                    LoginView()
                }
            }
        }
    }
    
    //  Login View
    public struct LoginView: View {
        @StateObject private var viewModel = LoginViewModel()
        
        public var body: some View {
            VStack(spacing: 24) {
                Text("Login")
                    .font(AppFonts.shared.titleLarge)
                
                VStack(spacing: 16) {
                    ReusableTextField(
                        label: "Email",
                        placeholder: "Enter your email",
                        text: $viewModel.email,
                        keyboardType: .emailAddress
                    )
                    
                    ReusableTextField(
                        label: "Password",
                        placeholder: "Enter your password",
                        text: $viewModel.password,
                        isSecure: true
                    )
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(AppFonts.shared.bodySmall)
                        .foregroundColor(AppColors.shared.alertRed)
                }
                
                ReusableButton(
                    title: "Login",
                    backgroundColor: AppColors.shared.black,
                    textColor: AppColors.shared.white
                ) {
                    viewModel.login()
                }
                .disabled(viewModel.isLoading)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .padding()
        }
    }
}

//  Usage Examples
public extension SessionManagerExample {
    static func runAllExamples() {
        basicAuthenticationFlow()
        tokenManagementExamples()
        sessionStateMonitoring()
        sessionAnalyticsExamples()
        deviceManagementExamples()
        advancedSessionManagement()
    }
} 
