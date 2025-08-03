import Foundation

// API Endpoints
public struct APIEndpoints {
    // User endpoints
    public static let login = "/auth/login"
    public static let register = "/auth/register"
    public static let logout = "/auth/logout"
    public static let profile = "/user/profile"
    public static let updateProfile = "/user/profile"
    
    // Task endpoints
    public static let tasks = "/tasks"
    public static let task = "/tasks/{id}"
    public static let createTask = "/tasks"
    public static let updateTask = "/tasks/{id}"
    public static let deleteTask = "/tasks/{id}"
    
    // Order endpoints
    public static let orders = "/orders"
    public static let order = "/orders/{id}"
    public static let createOrder = "/orders"
    public static let cancelOrder = "/orders/{id}/cancel"
    public static let acceptOrder = "/orders/{id}/accept"
    
    // Contractor endpoints
    public static let contractors = "/contractors"
    public static let contractor = "/contractors/{id}"
    public static let contractorRequests = "/contractors/requests"
    public static let acceptContractor = "/contractors/{id}/accept"
    
    // Location endpoints
    public static let locations = "/locations"
    public static let location = "/locations/{id}"
    public static let nearbyLocations = "/locations/nearby"
} 