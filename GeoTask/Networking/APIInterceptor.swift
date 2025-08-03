import Foundation
import Combine

// Interceptor Protocol
public protocol APIInterceptor {
    func interceptRequest(_ request: URLRequest) -> URLRequest
    func interceptResponse(_ response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data)
    func interceptError(_ error: APIError) -> APIError
}

// Request Interceptor
public protocol RequestInterceptor: APIInterceptor {
    func interceptRequest(_ request: URLRequest) -> URLRequest
}

// Response Interceptor
public protocol ResponseInterceptor: APIInterceptor {
    func interceptResponse(_ response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data)
}

//  Error Interceptor
public protocol ErrorInterceptor: APIInterceptor {
    func interceptError(_ error: APIError) -> APIError
}

// Authentication Interceptor
public class AuthenticationInterceptor: RequestInterceptor {
    private let sessionManager: SessionManager
    
    public init(sessionManager: SessionManager = SessionManager.shared) {
        self.sessionManager = sessionManager
    }
    
    public func interceptRequest(_ request: URLRequest) -> URLRequest {
        var modifiedRequest = request
        
        if let authHeader = sessionManager.getAuthorizationHeader() {
            modifiedRequest.setValue(authHeader, forHTTPHeaderField: "Authorization")
        }
        
        return modifiedRequest
    }
    
    public func interceptResponse(_ response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data) {
        // Handle 401 responses by triggering token refresh
        if response.statusCode == 401 {
            sessionManager.forceRefreshToken()
        }
        
        return (response, data)
    }
    
    public func interceptError(_ error: APIError) -> APIError {
        // Handle authentication errors
        if case .unauthorized = error {
            sessionManager.forceRefreshToken()
        }
        
        return error
    }
}

// Logging Interceptor
public class LoggingInterceptor: RequestInterceptor, ResponseInterceptor, ErrorInterceptor {
    private let logger: APILogger
    
    public init(logger: APILogger = APILogger.shared) {
        self.logger = logger
    }
    
    public func interceptRequest(_ request: URLRequest) -> URLRequest {
        logger.logRequest(request)
        return request
    }
    
    public func interceptResponse(_ response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data) {
        logger.logResponse(response, data: data)
        return (response, data)
    }
    
    public func interceptError(_ error: APIError) -> APIError {
        logger.logError(error)
        return error
    }
}

// Retry Interceptor
public class RetryInterceptor: ErrorInterceptor {
    private let maxRetries: Int
    private let retryDelay: TimeInterval
    private let shouldRetry: (APIError) -> Bool
    
    public init(
        maxRetries: Int = 3,
        retryDelay: TimeInterval = 1.0,
        shouldRetry: @escaping (APIError) -> Bool = { error in
            switch error {
            case .networkError, .timeout, .serverError:
                return true
            default:
                return false
            }
        }
    ) {
        self.maxRetries = maxRetries
        self.retryDelay = retryDelay
        self.shouldRetry = shouldRetry
    }
    
    public func interceptRequest(_ request: URLRequest) -> URLRequest {
        return request
    }
    
    public func interceptResponse(_ response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data) {
        return (response, data)
    }
    
    public func interceptError(_ error: APIError) -> APIError {
        return error
    }
    
    public func shouldRetry(_ error: APIError) -> Bool {
        return shouldRetry(error)
    }
}

// Cache Interceptor
public class CacheInterceptor: ResponseInterceptor {
    private let cache: URLCache
    private let cachePolicy: URLRequest.CachePolicy
    
    public init(cache: URLCache = .shared, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) {
        self.cache = cache
        self.cachePolicy = cachePolicy
    }
    
    public func interceptRequest(_ request: URLRequest) -> URLRequest {
        var modifiedRequest = request
        modifiedRequest.cachePolicy = cachePolicy
        return modifiedRequest
    }
    
    public func interceptResponse(_ response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data) {
        // Cache the response if it's cacheable
        if let request = response.url {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedResponse, for: URLRequest(url: request))
        }
        
        return (response, data)
    }
    
    public func interceptError(_ error: APIError) -> APIError {
        return error
    }
}

// Rate Limiting Interceptor
public class RateLimitingInterceptor: RequestInterceptor {
    private let requestsPerMinute: Int
    private var requestCount = 0
    private var lastResetTime = Date()
    private let queue = DispatchQueue(label: "rate.limiting.interceptor")
    
    public init(requestsPerMinute: Int = 60) {
        self.requestsPerMinute = requestsPerMinute
    }
    
    public func interceptRequest(_ request: URLRequest) -> URLRequest {
        return queue.sync {
            let now = Date()
            
            // Reset counter if a minute has passed
            if now.timeIntervalSince(lastResetTime) >= 60 {
                requestCount = 0
                lastResetTime = now
            }
            
            // Check if we're within rate limit
            if requestCount >= requestsPerMinute {
                // Could throw an error or delay the request
                return request
            }
            
            requestCount += 1
            return request
        }
    }
    
    public func interceptResponse(_ response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data) {
        return (response, data)
    }
    
    public func interceptError(_ error: APIError) -> APIError {
        return error
    }
}

// API Logger
public class APILogger {
    public static let shared = APILogger()
    
    private init() {}
    
    public func logRequest(_ request: URLRequest) {
        #if DEBUG
        print("🌐 API Request:")
        print("   URL: \(request.url?.absoluteString ?? "Unknown")")
        print("   Method: \(request.httpMethod ?? "Unknown")")
        print("   Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody {
            print("   Body: \(String(data: body, encoding: .utf8) ?? "Unknown")")
        }
        print("")
        #endif
    }
    
    public func logResponse(_ response: HTTPURLResponse, data: Data) {
        #if DEBUG
        print("📥 API Response:")
        print("   Status Code: \(response.statusCode)")
        print("   Headers: \(response.allHeaderFields)")
        print("   Data: \(String(data: data, encoding: .utf8) ?? "Unknown")")
        print("")
        #endif
    }
    
    public func logError(_ error: APIError) {
        #if DEBUG
        print("❌ API Error:")
        print("   Error: \(error.localizedDescription)")
        print("")
        #endif
    }
}

// Interceptor Chain
public class InterceptorChain {
    private var requestInterceptors: [RequestInterceptor] = []
    private var responseInterceptors: [ResponseInterceptor] = []
    private var errorInterceptors: [ErrorInterceptor] = []
    
    public init() {}
    
    public func addRequestInterceptor(_ interceptor: RequestInterceptor) {
        requestInterceptors.append(interceptor)
    }
    
    public func addResponseInterceptor(_ interceptor: ResponseInterceptor) {
        responseInterceptors.append(interceptor)
    }
    
    public func addErrorInterceptor(_ interceptor: ErrorInterceptor) {
        errorInterceptors.append(interceptor)
    }
    
    public func interceptRequest(_ request: URLRequest) -> URLRequest {
        var modifiedRequest = request
        
        for interceptor in requestInterceptors {
            modifiedRequest = interceptor.interceptRequest(modifiedRequest)
        }
        
        return modifiedRequest
    }
    
    public func interceptResponse(_ response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data) {
        var modifiedResponse = response
        var modifiedData = data
        
        for interceptor in responseInterceptors {
            let result = interceptor.interceptResponse(modifiedResponse, data: modifiedData)
            modifiedResponse = result.0
            modifiedData = result.1
        }
        
        return (modifiedResponse, modifiedData)
    }
    
    public func interceptError(_ error: APIError) -> APIError {
        var modifiedError = error
        
        for interceptor in errorInterceptors {
            modifiedError = interceptor.interceptError(modifiedError)
        }
        
        return modifiedError
    }
}

// Default Interceptor Chain
public extension InterceptorChain {
    static func defaultChain() -> InterceptorChain {
        let chain = InterceptorChain()
        
        // Add default interceptors
        chain.addRequestInterceptor(AuthenticationInterceptor())
        
        chain.addRequestInterceptor(LoggingInterceptor())
        chain.addResponseInterceptor(LoggingInterceptor())
        chain.addErrorInterceptor(LoggingInterceptor())
        
        chain.addRequestInterceptor(RateLimitingInterceptor(requestsPerMinute: 60))
        chain.addResponseInterceptor(CacheInterceptor())
        
        return chain
    }
} 
