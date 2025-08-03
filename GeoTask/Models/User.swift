import Foundation

public struct User: Codable {
    public let id: String
    public let name: String
    public let email: String
    public let phone: String?
    public let profileImage: String?
    
    public init(id: String, name: String, email: String, phone: String? = nil, profileImage: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.profileImage = profileImage
    }
} 