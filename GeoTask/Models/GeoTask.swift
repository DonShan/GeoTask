import Foundation
import CoreLocation

public struct GeoTask: Identifiable, Hashable, Codable {
    public let id: UUID
    public var title: String
    public var description: String
    public var isCompleted: Bool
    public var priority: GeoTaskPriority
    public var dueDate: Date?
    public var location: GeoTaskLocation?
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        isCompleted: Bool = false,
        priority: GeoTaskPriority = .medium,
        dueDate: Date? = nil,
        location: GeoTaskLocation? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.priority = priority
        self.dueDate = dueDate
        self.location = location
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public enum GeoTaskPriority: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case urgent = "urgent"
    
    public var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .urgent: return "Urgent"
        }
    }
    
    public var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "blue"
        case .high: return "orange"
        case .urgent: return "red"
        }
    }
}

public struct GeoTaskLocation: Hashable, Codable {
    public let latitude: Double
    public let longitude: Double
    public let address: String?
    public let name: String?
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public init(latitude: Double, longitude: Double, address: String? = nil, name: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.name = name
    }
    
    public init(coordinate: CLLocationCoordinate2D, address: String? = nil, name: String? = nil) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.address = address
        self.name = name
    }
} 