import Foundation
import Combine


// MARK: - HTTP Methods
public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

// Request Configuration
public struct APIRequest {
    let method: HTTPMethod
    let path: String
    let queryParameters: [String: Any]?
    let body: Data?
    let headers: [String: String]
    
    public init(
        method: HTTPMethod,
        path: String,
        queryParameters: [String: Any]? = nil,
        body: Data? = nil,
        headers: [String: String] = [:]
    ) {
        self.method = method
        self.path = path
        self.queryParameters = queryParameters
        self.body = body
        self.headers = headers
    }
}

// API Response
public struct APIResponse<T: Codable> {
    public let data: T
    public let statusCode: Int
    public let headers: [String: String]
    
    public init(data: T, statusCode: Int, headers: [String: String]) {
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
    }
}

// API Client
public class APIClient {
    public static let shared = APIClient()
    
    private let baseURL: String
    private let session: URLSession
    private let interceptorChain: InterceptorChain
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        baseURL: String = "https://api.geotask.com",
        session: URLSession = .shared,
        interceptorChain: InterceptorChain = InterceptorChain.defaultChain()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.interceptorChain = interceptorChain
    }
    
    // - Generic Request Method
    public func request<T: Codable>(_ request: APIRequest, responseType: T.Type) -> AnyPublisher<APIResponse<T>, APIError> {
        guard let url = buildURL(from: request) else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        // Add headers
        request.headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add default headers
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Apply request interceptors
        let interceptedRequest = interceptorChain.interceptRequest(urlRequest)
        
        return session.dataTaskPublisher(for: interceptedRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                // Apply response interceptors
                let (interceptedResponse, interceptedData) = self.interceptorChain.interceptResponse(httpResponse, data: data)
                
                // Handle HTTP status codes
                switch interceptedResponse.statusCode {
                case 200...299:
                    return (interceptedData, interceptedResponse)
                case 401:
                    throw APIError.unauthorized
                case 403:
                    throw APIError.forbidden
                case 404:
                    throw APIError.notFound
                case 500...599:
                    throw APIError.serverError(interceptedResponse.statusCode, "Server error")
                default:
                    throw APIError.unknown
                }
            }
            .mapError { error in
                let apiError: APIError
                if let apiErrorType = error as? APIError {
                    apiError = apiErrorType
                } else {
                    apiError = APIError.networkError(error)
                }
                
                // Apply error interceptors
                return self.interceptorChain.interceptError(apiError)
            }
            .flatMap { (data: Data, response: HTTPURLResponse) in
                Just(data)
                    .decode(type: T.self, decoder: JSONCoding.shared.decoder)
                    .mapError { error in
                        APIError.decodingError(error)
                    }
                    .map { decodedData in
                        APIResponse(
                            data: decodedData,
                            statusCode: response.statusCode,
                            headers: response.allHeaderFields as? [String: String] ?? [:]
                        )
                    }
            }
            .eraseToAnyPublisher()
    }
    
    // Convenience Methods
    public func get<T: Codable>(
        _ path: String,
        queryParameters: [String: Any]? = nil,
        headers: [String: String] = [:],
        responseType: T.Type
    ) -> AnyPublisher<APIResponse<T>, APIError> {
        let request = APIRequest(
            method: .GET,
            path: path,
            queryParameters: queryParameters,
            headers: headers
        )
        return self.request(request, responseType: responseType)
    }
    
    public func post<T: Codable, U: Codable>(
        _ path: String,
        body: U,
        headers: [String: String] = [:],
        responseType: T.Type
    ) -> AnyPublisher<APIResponse<T>, APIError> {
        do {
            let bodyData = try JSONCoding.shared.encode(body)
            let request = APIRequest(
                method: .POST,
                path: path,
                body: bodyData,
                headers: headers
            )
            return self.request(request, responseType: responseType)
        } catch {
            return Fail(error: APIError.decodingError(error))
                .eraseToAnyPublisher()
        }
    }
    
    public func put<T: Codable, U: Codable>(
        _ path: String,
        body: U,
        headers: [String: String] = [:],
        responseType: T.Type
    ) -> AnyPublisher<APIResponse<T>, APIError> {
        do {
            let bodyData = try JSONCoding.shared.encode(body)
            let request = APIRequest(
                method: .PUT,
                path: path,
                body: bodyData,
                headers: headers
            )
            return self.request(request, responseType: responseType)
        } catch {
            return Fail(error: APIError.decodingError(error))
                .eraseToAnyPublisher()
        }
    }
    
    public func patch<T: Codable, U: Codable>(
        _ path: String,
        body: U,
        headers: [String: String] = [:],
        responseType: T.Type
    ) -> AnyPublisher<APIResponse<T>, APIError> {
        do {
            let bodyData = try JSONCoding.shared.encode(body)
            let request = APIRequest(
                method: .PATCH,
                path: path,
                body: bodyData,
                headers: headers
            )
            return self.request(request, responseType: responseType)
        } catch {
            return Fail(error: APIError.decodingError(error))
                .eraseToAnyPublisher()
        }
    }
    
    public func delete<T: Codable>(
        _ path: String,
        headers: [String: String] = [:],
        responseType: T.Type
    ) -> AnyPublisher<APIResponse<T>, APIError> {
        let request = APIRequest(
            method: .DELETE,
            path: path,
            headers: headers
        )
        return self.request(request, responseType: responseType)
    }
    
    // URL Building
    private func buildURL(from request: APIRequest) -> URL? {
        guard var urlComponents = URLComponents(string: baseURL + request.path) else {
            return nil
        }
        
        // Add query parameters
        if let queryParameters = request.queryParameters {
            urlComponents.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        return urlComponents.url
    }
}

//  Authentication Support
extension APIClient {
    public func setAuthToken(_ token: String) {
        // Store token for future requests
        UserDefaultsManager.shared.saveAuthToken(token)
    }
    
    public func getAuthToken() -> String? {
        return UserDefaultsManager.shared.getAuthToken()
    }
    
    public func addAuthHeader(_ headers: [String: String]) -> [String: String] {
        var updatedHeaders = headers
        if let token = getAuthToken() {
            updatedHeaders["Authorization"] = "Bearer \(token)"
        }
        return updatedHeaders
    }
    
    public func authenticatedRequest<T: Codable>(
        _ request: APIRequest,
        responseType: T.Type
    ) -> AnyPublisher<APIResponse<T>, APIError> {
        let updatedRequest = APIRequest(
            method: request.method,
            path: request.path,
            queryParameters: request.queryParameters,
            body: request.body,
            headers: addAuthHeader(request.headers)
        )
        return self.request(updatedRequest, responseType: responseType)
    }
}

// Retry Logic
extension APIClient {
    public func requestWithRetry<T: Codable>(
        _ request: APIRequest,
        responseType: T.Type,
        retries: Int = 3,
        delay: TimeInterval = 1.0
    ) -> AnyPublisher<APIResponse<T>, APIError> {
        return self.request(request, responseType: responseType)
            .catch { error -> AnyPublisher<APIResponse<T>, APIError> in
                if retries > 0 && self.shouldRetry(error) {
                    return Just(())
                        .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                        .flatMap { _ in
                            self.requestWithRetry(request, responseType: responseType, retries: retries - 1, delay: delay * 2)
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func shouldRetry(_ error: APIError) -> Bool {
        switch error {
        case .networkError, .timeout, .noInternetConnection, .serverError:
            return true
        default:
            return false
        }
    }
}

// Request Cancellation
extension APIClient {
    public func cancelAllRequests() {
        cancellables.removeAll()
    }
}

//  Response Models
public struct EmptyResponse: Codable {}

public struct ErrorResponse: Codable {
    public let message: String
    public let code: String?
    public let details: [String: String]?
    
    public init(message: String, code: String? = nil, details: [String: String]? = nil) {
        self.message = message
        self.code = code
        self.details = details
    }
}

//  Usage Examples
extension APIClient {
    public func login(email: String, password: String) -> AnyPublisher<APIResponse<LoginResponse>, APIError> {
        let loginRequest = LoginRequest(email: email, password: password)
        return post(APIEndpoints.login, body: loginRequest, responseType: LoginResponse.self)
    }
    
    public func getTasks() -> AnyPublisher<APIResponse<[Task]>, APIError> {
        return get(APIEndpoints.tasks, responseType: [Task].self)
    }
    
    public func createTask(_ task: CreateTaskRequest) -> AnyPublisher<APIResponse<Task>, APIError> {
        return post(APIEndpoints.createTask, body: task, responseType: Task.self)
    }
    
    public func cancelOrder(id: String) -> AnyPublisher<APIResponse<EmptyResponse>, APIError> {
        let path = APIEndpoints.cancelOrder.replacingOccurrences(of: "{id}", with: id)
        return post(path, body: EmptyResponse(), responseType: EmptyResponse.self)
    }
}

//  Request/Response Models (Examples)
public struct LoginRequest: Codable {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct LoginResponse: Codable {
    public let token: String
    public let refreshToken: String
    public let user: User
    
    public init(token: String, refreshToken: String, user: User) {
        self.token = token
        self.refreshToken = refreshToken
        self.user = user
    }
}

public struct CreateTaskRequest: Codable {
    public let title: String
    public let description: String
    public let location: String
    public let priority: String
    
    public init(title: String, description: String, location: String, priority: String) {
        self.title = title
        self.description = description
        self.location = location
        self.priority = priority
    }
}

public struct Task: Codable {
    public let id: String
    public let title: String
    public let description: String
    public let status: String
    public let priority: String
    public let location: String
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, title: String, description: String, status: String, priority: String, location: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.status = status
        self.priority = priority
        self.location = location
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
} 
