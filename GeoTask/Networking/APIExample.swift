import Foundation
import Combine

// API Usage Examples
public class APIExample {
    
    // JSONCoding Examples
    public static func jsonCodingExamples() {
        print("=== JSONCoding Examples ===")
        
        // Example 1: Basic encoding/decoding
        let user = User(id: "123", name: "John Doe", email: "john@example.com")
        
        do {
            // Encode to JSON string
            let jsonString = try user.toJSONString()
            print("Encoded JSON: \(jsonString)")
            
            // Decode from JSON string
            let decodedUser = try User.fromJSONString(jsonString)
            print("Decoded User: \(decodedUser.name)")
            
            // Encode to dictionary
            let jsonDict = try user.toJSONDictionary()
            print("JSON Dictionary: \(jsonDict)")
            
            // Decode from dictionary
            let userFromDict = try User.fromJSONDictionary(jsonDict)
            print("User from Dict: \(userFromDict.name)")
            
        } catch {
            print("JSON Coding Error: \(error)")
        }
        
        // Example 2: Custom encoding strategies
        let customEncoder = JSONCoding.shared.createEncoder(
            keyEncodingStrategy: .useDefaultKeys,
            dateEncodingStrategy: .formatted(JSONCoding.shared.dateFormatter),
            outputFormatting: [.prettyPrinted]
        )
        
        let customDecoder = JSONCoding.shared.createDecoder(
            keyDecodingStrategy: .useDefaultKeys,
            dateDecodingStrategy: .formatted(JSONCoding.shared.dateFormatter)
        )
        
        print("Custom Encoder: \(customEncoder)")
        print("Custom Decoder: \(customDecoder)")
    }
    
    // MARK: - Interceptor Examples
    public static func interceptorExamples() {
        print("\n=== Interceptor Examples ===")
        
        // Example 1: Custom interceptor chain
        let customChain = InterceptorChain()
        
        // Add authentication interceptor
        customChain.addRequestInterceptor(AuthenticationInterceptor())
        
        // Add logging interceptor
        customChain.addRequestInterceptor(LoggingInterceptor())
        customChain.addResponseInterceptor(LoggingInterceptor())
        customChain.addErrorInterceptor(LoggingInterceptor())
        
        // Add rate limiting
        customChain.addRequestInterceptor(RateLimitingInterceptor(requestsPerMinute: 30))
        
        // Add caching
        customChain.addResponseInterceptor(CacheInterceptor())
        
        // Add retry logic
        customChain.addErrorInterceptor(RetryInterceptor(maxRetries: 3, retryDelay: 2.0))
        
        print("Custom Interceptor Chain created")
        
        // Example 2: Using default chain
        let defaultChain = InterceptorChain.defaultChain()
        print("Default Interceptor Chain created")
        
        // Example 3: Custom authentication interceptor
        let customAuthInterceptor = AuthenticationInterceptor()
        
        print("Custom Authentication Interceptor created")
    }
    
    // MARK: - API Client Examples
    public static func apiClientExamples() {
        print("\n=== API Client Examples ===")
        
        // Example 1: Custom API client with interceptors
        let customChain = InterceptorChain()
        customChain.addRequestInterceptor(LoggingInterceptor())
        customChain.addResponseInterceptor(LoggingInterceptor())
        
        let customAPIClient = APIClient(
            baseURL: "https://api.example.com",
            interceptorChain: customChain
        )
        
        print("Custom API Client created with logging interceptors")
        
        // Example 2: Using shared client with default interceptors
        let sharedClient = APIClient.shared
        print("Shared API Client with default interceptors")
        
        // Example 3: Making requests
        var cancellables = Set<AnyCancellable>()
        
        // GET request
        sharedClient.get("/tasks", responseType: [GeoTask].self)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("GET request completed")
                    case .failure(let error):
                        print("GET request failed: \(error)")
                    }
                },
                receiveValue: { response in
                    print("Received \(response.data.count) tasks")
                }
            )
            .store(in: &cancellables)
        
        // POST request
        let loginRequest = LoginRequest(email: "user@example.com", password: "password")
        sharedClient.post("/auth/login", body: loginRequest, responseType: LoginResponse.self)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("POST request completed")
                    case .failure(let error):
                        print("POST request failed: \(error)")
                    }
                },
                receiveValue: { response in
                    print("Login successful for user: \(response.data.user.name)")
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Service Examples
    public static func serviceExamples() {
        print("\n=== Service Examples ===")
        
        let apiService = ServiceFactory.shared.createAPIService()
        var cancellables = Set<AnyCancellable>()
        
        // Example 1: Login flow
        apiService.login(email: "user@example.com", password: "password")
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Login completed")
                    case .failure(let error):
                        print("Login failed: \(error)")
                    }
                },
                receiveValue: { response in
                    print("Login successful: \(response.user.name)")
                }
            )
            .store(in: &cancellables)
        
        // Example 2: Get tasks
        apiService.getTasks()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Tasks request completed")
                    case .failure(let error):
                        print("Tasks request failed: \(error)")
                    }
                },
                receiveValue: { tasks in
                    print("Received \(tasks.count) tasks")
                }
            )
            .store(in: &cancellables)
        
        // Example 3: Create task
        let taskRequest = CreateTaskRequest(
            title: "New Task",
            description: "Task description",
            location: "New York",
            priority: "high"
        )
        
        apiService.createTask(taskRequest)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Task creation completed")
                    case .failure(let error):
                        print("Task creation failed: \(error)")
                    }
                },
                receiveValue: { task in
                    print("Task created: \(task.title)")
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Error Handling Examples
    public static func errorHandlingExamples() {
        print("\n=== Error Handling Examples ===")
        
        let apiService = ServiceFactory.shared.createAPIService()
        var cancellables = Set<AnyCancellable>()
        
        // Example 1: Handle specific errors
        apiService.login(email: "invalid@example.com", password: "wrong")
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Login completed")
                    case .failure(let error):
                        switch error {
                        case .unauthorized:
                            print("Invalid credentials")
                        case .networkError:
                            print("Network connection issue")
                        case .serverError(let code):
                            print("Server error with code: \(code)")
                        default:
                            print("Other error: \(error)")
                        }
                    }
                },
                receiveValue: { response in
                    print("Login successful")
                }
            )
            .store(in: &cancellables)
        
        // Example 2: Retry logic
        let apiClient = APIClient.shared
        let request = APIRequest(method: .GET, path: "/unstable-endpoint")
        
        apiClient.requestWithRetry(request, responseType: [GeoTask].self, retries: 3, delay: 1.0)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Request completed after retries")
                    case .failure(let error):
                        print("Request failed after all retries: \(error)")
                    }
                },
                receiveValue: { response in
                    print("Request successful after retries")
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Advanced Examples
    public static func advancedExamples() {
        print("\n=== Advanced Examples ===")
        
        // Example 1: Custom interceptor for analytics
        class AnalyticsInterceptor: RequestInterceptor, ResponseInterceptor {
            func interceptRequest(_ request: URLRequest) -> URLRequest {
                // Track request
                print("Analytics: Tracking request to \(request.url?.absoluteString ?? "")")
                return request
            }
            
            func interceptResponse(_ response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data) {
                // Track response
                print("Analytics: Tracking response with status \(response.statusCode)")
                return (response, data)
            }
            
            func interceptError(_ error: APIError) -> APIError {
                // Track error
                print("Analytics: Tracking error \(error)")
                return error
            }
        }
        
        // Example 2: Custom interceptor for offline support
        class OfflineInterceptor: RequestInterceptor, ResponseInterceptor {
            private let cache = URLCache.shared
            
            func interceptRequest(_ request: URLRequest) -> URLRequest {
                // Check if offline and return cached response
                if !isOnline() {
                    print("Offline: Using cached response")
                }
                return request
            }
            
            func interceptResponse(_ response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, Data) {
                // Cache successful responses
                if response.statusCode == 200 {
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    if let url = response.url {
                        let urlRequest = URLRequest(url: url)
                        cache.storeCachedResponse(cachedResponse, for: urlRequest)
                    }
                }
                return (response, data)
            }
            
            func interceptError(_ error: APIError) -> APIError {
                return error
            }
            
            private func isOnline() -> Bool {
                // Implement network reachability check
                return true
            }
        }
        
        // Example 3: Using custom interceptors
        let advancedChain = InterceptorChain()
        advancedChain.addRequestInterceptor(AnalyticsInterceptor())
        advancedChain.addRequestInterceptor(OfflineInterceptor())
        advancedChain.addResponseInterceptor(AnalyticsInterceptor())
        advancedChain.addResponseInterceptor(OfflineInterceptor())
        
        let advancedAPIClient = APIClient(
            baseURL: "https://api.example.com",
            interceptorChain: advancedChain
        )
        
        print("Advanced API Client created with custom interceptors")
    }
}

// MARK: - Usage Examples
public extension APIExample {
    static func runAllExamples() {
        jsonCodingExamples()
        interceptorExamples()
        apiClientExamples()
        serviceExamples()
        errorHandlingExamples()
        advancedExamples()
    }
} 
