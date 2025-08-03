import Foundation

// MARK: - JSON Coding Configuration
public class JSONCoding {
    public static let shared = JSONCoding()
    
    // MARK: - Encoder
    public lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")
        return encoder
    }()
    
    // MARK: - Decoder
    public lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")
        return decoder
    }()
    
    // MARK: - Custom Date Formatter
    public lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    // MARK: - ISO8601 Date Formatter
    public lazy var iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private init() {}
    
    // MARK: - Encoding Methods
    public func encode<T: Encodable>(_ value: T) throws -> Data {
        return try encoder.encode(value)
    }
    
    public func encodeToString<T: Encodable>(_ value: T) throws -> String {
        let data = try encode(value)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    public func encodeToJSON<T: Encodable>(_ value: T) throws -> [String: Any] {
        let data = try encode(value)
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw JSONCodingError.invalidJSON
        }
        return json
    }
    
    // MARK: - Decoding Methods
    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try decoder.decode(type, from: data)
    }
    
    public func decode<T: Decodable>(_ type: T.Type, from string: String) throws -> T {
        guard let data = string.data(using: .utf8) else {
            throw JSONCodingError.invalidString
        }
        return try decode(type, from: data)
    }
    
    public func decode<T: Decodable>(_ type: T.Type, from json: [String: Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        return try decode(type, from: data)
    }
    
    // MARK: - Custom Encoding Strategies
    public func createEncoder(
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase,
        dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601,
        outputFormatting: JSONEncoder.OutputFormatting = [.sortedKeys, .prettyPrinted]
    ) -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        encoder.dateEncodingStrategy = dateEncodingStrategy
        encoder.outputFormatting = outputFormatting
        return encoder
    }
    
    public func createDecoder(
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    ) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }
}

// MARK: - JSON Coding Error
public enum JSONCodingError: Error, LocalizedError {
    case invalidJSON
    case invalidString
    case encodingFailed
    case decodingFailed
    case invalidDateFormat
    
    public var errorDescription: String? {
        switch self {
        case .invalidJSON:
            return "Invalid JSON format"
        case .invalidString:
            return "Invalid string encoding"
        case .encodingFailed:
            return "Failed to encode object"
        case .decodingFailed:
            return "Failed to decode object"
        case .invalidDateFormat:
            return "Invalid date format"
        }
    }
}

// MARK: - JSON Extensions
public extension Encodable {
    func toJSON() throws -> Data {
        return try JSONCoding.shared.encode(self)
    }
    
    func toJSONString() throws -> String {
        return try JSONCoding.shared.encodeToString(self)
    }
    
    func toJSONDictionary() throws -> [String: Any] {
        return try JSONCoding.shared.encodeToJSON(self)
    }
}

public extension Decodable {
    static func fromJSON(_ data: Data) throws -> Self {
        return try JSONCoding.shared.decode(Self.self, from: data)
    }
    
    static func fromJSONString(_ string: String) throws -> Self {
        return try JSONCoding.shared.decode(Self.self, from: string)
    }
    
    static func fromJSONDictionary(_ json: [String: Any]) throws -> Self {
        return try JSONCoding.shared.decode(Self.self, from: json)
    }
} 