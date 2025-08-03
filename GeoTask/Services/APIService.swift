import Foundation
import Combine

// MARK: - API Service Protocol
public protocol APIServiceProtocol {
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, APIError>
    func register(email: String, password: String, name: String) -> AnyPublisher<LoginResponse, APIError>
    func logout() -> AnyPublisher<EmptyResponse, APIError>
    func getProfile() -> AnyPublisher<User, APIError>
    func updateProfile(_ user: User) -> AnyPublisher<User, APIError>
    
    func getTasks() -> AnyPublisher<[GeoTask], APIError>
    func getTask(id: String) -> AnyPublisher<GeoTask, APIError>
    func createTask(_ task: CreateTaskRequest) -> AnyPublisher<GeoTask, APIError>
    func updateTask(id: String, _ task: CreateTaskRequest) -> AnyPublisher<GeoTask, APIError>
    func deleteTask(id: String) -> AnyPublisher<EmptyResponse, APIError>
    
    func getOrders() -> AnyPublisher<[Order], APIError>
    func getOrder(id: String) -> AnyPublisher<Order, APIError>
    func createOrder(_ order: CreateOrderRequest) -> AnyPublisher<Order, APIError>
    func cancelOrder(id: String) -> AnyPublisher<EmptyResponse, APIError>
    func acceptOrder(id: String) -> AnyPublisher<EmptyResponse, APIError>
    
    func getContractors() -> AnyPublisher<[Contractor], APIError>
    func getContractor(id: String) -> AnyPublisher<Contractor, APIError>
    func getContractorRequests() -> AnyPublisher<[ContractorRequest], APIError>
    func acceptContractor(id: String) -> AnyPublisher<EmptyResponse, APIError>
    
    func getLocations() -> AnyPublisher<[Location], APIError>
    func getLocation(id: String) -> AnyPublisher<Location, APIError>
    func getNearbyLocations(latitude: Double, longitude: Double, radius: Double) -> AnyPublisher<[Location], APIError>
    
    func refreshToken(_ refreshToken: String) -> AnyPublisher<LoginResponse, APIError>
}

//  API Service Implementation
public class APIService: APIServiceProtocol {
    private let apiClient: APIClient
    private var cancellables = Set<AnyCancellable>()
    
    public init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    // MARK: - Authentication Services
    public func login(email: String, password: String) -> AnyPublisher<LoginResponse, APIError> {
        let loginRequest = LoginRequest(email: email, password: password)
        return apiClient.post(APIEndpoints.login, body: loginRequest, responseType: LoginResponse.self)
            .map { $0.data }
            .handleEvents(receiveOutput: { response in
                self.apiClient.setAuthToken(response.token)
            })
            .eraseToAnyPublisher()
    }
    
    public func register(email: String, password: String, name: String) -> AnyPublisher<LoginResponse, APIError> {
        let registerRequest = RegisterRequest(email: email, password: password, name: name)
        return apiClient.post(APIEndpoints.register, body: registerRequest, responseType: LoginResponse.self)
            .map { $0.data }
            .handleEvents(receiveOutput: { response in
                self.apiClient.setAuthToken(response.token)
            })
            .eraseToAnyPublisher()
    }
    
    public func logout() -> AnyPublisher<EmptyResponse, APIError> {
        return apiClient.post(APIEndpoints.logout, body: EmptyResponse(), responseType: EmptyResponse.self)
            .map { $0.data }
            .handleEvents(receiveOutput: { _ in
                UserDefaultsManager.shared.clearAuthData()
            })
            .eraseToAnyPublisher()
    }
    
    public func getProfile() -> AnyPublisher<User, APIError> {
        return apiClient.get(APIEndpoints.profile, responseType: User.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func updateProfile(_ user: User) -> AnyPublisher<User, APIError> {
        return apiClient.put(APIEndpoints.updateProfile, body: user, responseType: User.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func refreshToken(_ refreshToken: String) -> AnyPublisher<LoginResponse, APIError> {
        let refreshRequest = RefreshTokenRequest(refreshToken: refreshToken)
        return apiClient.post("/auth/refresh", body: refreshRequest, responseType: LoginResponse.self)
            .map { $0.data }
            .handleEvents(receiveOutput: { response in
                self.apiClient.setAuthToken(response.token)
            })
            .eraseToAnyPublisher()
    }
    
    //  Task Services
    public func getTasks() -> AnyPublisher<[GeoTask], APIError> {
        return apiClient.get(APIEndpoints.tasks, responseType: [GeoTask].self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func getTask(id: String) -> AnyPublisher<GeoTask, APIError> {
        let path = APIEndpoints.task.replacingOccurrences(of: "{id}", with: id)
        return apiClient.get(path, responseType: GeoTask.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func createTask(_ task: CreateTaskRequest) -> AnyPublisher<GeoTask, APIError> {
        return apiClient.post(APIEndpoints.createTask, body: task, responseType: GeoTask.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func updateTask(id: String, _ task: CreateTaskRequest) -> AnyPublisher<GeoTask, APIError> {
        let path = APIEndpoints.updateTask.replacingOccurrences(of: "{id}", with: id)
        return apiClient.put(path, body: task, responseType: GeoTask.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func deleteTask(id: String) -> AnyPublisher<EmptyResponse, APIError> {
        let path = APIEndpoints.deleteTask.replacingOccurrences(of: "{id}", with: id)
        return apiClient.delete(path, responseType: EmptyResponse.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    //  Order Services
    public func getOrders() -> AnyPublisher<[Order], APIError> {
        return apiClient.get(APIEndpoints.orders, responseType: [Order].self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func getOrder(id: String) -> AnyPublisher<Order, APIError> {
        let path = APIEndpoints.order.replacingOccurrences(of: "{id}", with: id)
        return apiClient.get(path, responseType: Order.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func createOrder(_ order: CreateOrderRequest) -> AnyPublisher<Order, APIError> {
        return apiClient.post(APIEndpoints.createOrder, body: order, responseType: Order.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func cancelOrder(id: String) -> AnyPublisher<EmptyResponse, APIError> {
        let path = APIEndpoints.cancelOrder.replacingOccurrences(of: "{id}", with: id)
        return apiClient.post(path, body: EmptyResponse(), responseType: EmptyResponse.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func acceptOrder(id: String) -> AnyPublisher<EmptyResponse, APIError> {
        let path = APIEndpoints.acceptOrder.replacingOccurrences(of: "{id}", with: id)
        return apiClient.post(path, body: EmptyResponse(), responseType: EmptyResponse.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    // - Contractor Services
    public func getContractors() -> AnyPublisher<[Contractor], APIError> {
        return apiClient.get(APIEndpoints.contractors, responseType: [Contractor].self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func getContractor(id: String) -> AnyPublisher<Contractor, APIError> {
        let path = APIEndpoints.contractor.replacingOccurrences(of: "{id}", with: id)
        return apiClient.get(path, responseType: Contractor.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func getContractorRequests() -> AnyPublisher<[ContractorRequest], APIError> {
        return apiClient.get(APIEndpoints.contractorRequests, responseType: [ContractorRequest].self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func acceptContractor(id: String) -> AnyPublisher<EmptyResponse, APIError> {
        let path = APIEndpoints.acceptContractor.replacingOccurrences(of: "{id}", with: id)
        return apiClient.post(path, body: EmptyResponse(), responseType: EmptyResponse.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    //  Location Services
    public func getLocations() -> AnyPublisher<[Location], APIError> {
        return apiClient.get(APIEndpoints.locations, responseType: [Location].self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func getLocation(id: String) -> AnyPublisher<Location, APIError> {
        let path = APIEndpoints.location.replacingOccurrences(of: "{id}", with: id)
        return apiClient.get(path, responseType: Location.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    public func getNearbyLocations(latitude: Double, longitude: Double, radius: Double) -> AnyPublisher<[Location], APIError> {
        let queryParameters: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude,
            "radius": radius
        ]
        return apiClient.get(APIEndpoints.nearbyLocations, queryParameters: queryParameters, responseType: [Location].self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

//  Additional Request/Response Models
public struct RegisterRequest: Codable {
    public let email: String
    public let password: String
    public let name: String
    
    public init(email: String, password: String, name: String) {
        self.email = email
        self.password = password
        self.name = name
    }
}

public struct Order: Codable {
    public let id: String
    public let title: String
    public let description: String
    public let status: String
    public let contractorId: String?
    public let customerId: String
    public let location: String
    public let price: Double?
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, title: String, description: String, status: String, contractorId: String?, customerId: String, location: String, price: Double?, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.status = status
        self.contractorId = contractorId
        self.customerId = customerId
        self.location = location
        self.price = price
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct CreateOrderRequest: Codable {
    public let title: String
    public let description: String
    public let location: String
    public let price: Double?
    
    public init(title: String, description: String, location: String, price: Double? = nil) {
        self.title = title
        self.description = description
        self.location = location
        self.price = price
    }
}

public struct Contractor: Codable {
    public let id: String
    public let name: String
    public let email: String
    public let phone: String?
    public let specialization: String
    public let rating: Double
    public let completedOrders: Int
    public let profileImage: String?
    public let isAvailable: Bool
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, name: String, email: String, phone: String?, specialization: String, rating: Double, completedOrders: Int, profileImage: String?, isAvailable: Bool, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.specialization = specialization
        self.rating = rating
        self.completedOrders = completedOrders
        self.profileImage = profileImage
        self.isAvailable = isAvailable
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct ContractorRequest: Codable {
    public let id: String
    public let contractorId: String
    public let orderId: String
    public let status: String
    public let message: String?
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, contractorId: String, orderId: String, status: String, message: String?, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.contractorId = contractorId
        self.orderId = orderId
        self.status = status
        self.message = message
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct Location: Codable {
    public let id: String
    public let name: String
    public let address: String
    public let latitude: Double
    public let longitude: Double
    public let type: String
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, name: String, address: String, latitude: Double, longitude: Double, type: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// Service Factory
public class ServiceFactory {
    public static let shared = ServiceFactory()
    
    private init() {}
    
    public func createAPIService() -> APIServiceProtocol {
        return APIService()
    }
} 
