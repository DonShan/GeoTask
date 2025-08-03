import Foundation

// API Error
public enum APIError: LocalizedError {
    case invalidURL
    case invalidRequest
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case encodingError(Error)
    case serverError(Int, String)
    case clientError(Int, String)
    case unauthorized
    case forbidden
    case notFound
    case rateLimitExceeded
    case timeout
    case noInternetConnection
    case cancelled
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidRequest:
            return "Invalid request"
        case .invalidResponse:
            return "Invalid response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Encoding error: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        case .clientError(let code, let message):
            return "Client error (\(code)): \(message)"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .rateLimitExceeded:
            return "Rate limit exceeded"
        case .timeout:
            return "Request timeout"
        case .noInternetConnection:
            return "No internet connection"
        case .cancelled:
            return "Request cancelled"
        case .unknown:
            return "Unknown error occurred"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is not valid"
        case .invalidRequest:
            return "The request format is invalid"
        case .invalidResponse:
            return "The server response is invalid"
        case .networkError:
            return "A network error occurred"
        case .decodingError:
            return "Failed to decode the response"
        case .encodingError:
            return "Failed to encode the request"
        case .serverError:
            return "The server encountered an error"
        case .clientError:
            return "The request was invalid"
        case .unauthorized:
            return "Authentication required"
        case .forbidden:
            return "Access denied"
        case .notFound:
            return "The requested resource was not found"
        case .rateLimitExceeded:
            return "Too many requests"
        case .timeout:
            return "The request took too long"
        case .noInternetConnection:
            return "No internet connection available"
        case .cancelled:
            return "The request was cancelled"
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Check the URL format"
        case .invalidRequest:
            return "Verify the request parameters"
        case .invalidResponse:
            return "Check the server response format"
        case .networkError:
            return "Check your internet connection and try again"
        case .decodingError:
            return "The response format may have changed"
        case .encodingError:
            return "Check the request data format"
        case .serverError:
            return "Try again later or contact support"
        case .clientError:
            return "Check your request parameters"
        case .unauthorized:
            return "Please log in again"
        case .forbidden:
            return "You don't have permission to access this resource"
        case .notFound:
            return "The requested resource may have been moved or deleted"
        case .rateLimitExceeded:
            return "Please wait before making another request"
        case .timeout:
            return "Try again with a better connection"
        case .noInternetConnection:
            return "Connect to the internet and try again"
        case .cancelled:
            return "The request was cancelled by the user or system"
        case .unknown:
            return "Please try again or contact support"
        }
    }
    
    public var isRetryable: Bool {
        switch self {
        case .networkError, .timeout, .noInternetConnection, .serverError:
            return true
        case .invalidURL, .invalidRequest, .invalidResponse, .decodingError, .encodingError, .clientError, .unauthorized, .forbidden, .notFound, .rateLimitExceeded, .cancelled, .unknown:
            return false
        }
    }
    
    public var shouldRefreshToken: Bool {
        switch self {
        case .unauthorized:
            return true
        default:
            return false
        }
    }
}

// HTTP Status Code Extensions
extension APIError {
    public static func fromHTTPStatusCode(_ statusCode: Int, message: String? = nil) -> APIError {
        switch statusCode {
        case 400:
            return .clientError(statusCode, message ?? "Bad Request")
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 429:
            return .rateLimitExceeded
        case 500...599:
            return .serverError(statusCode, message ?? "Server Error")
        default:
            return .unknown
        }
    }
    
    public var statusCode: Int? {
        switch self {
        case .serverError(let code, _):
            return code
        case .clientError(let code, _):
            return code
        default:
            return nil
        }
    }
} 
