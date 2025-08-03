import Foundation
import Combine
import Network

// WebSocket Message Types
public enum WebSocketMessageType: String, Codable {
    case connect = "connect"
    case disconnect = "disconnect"
    case message = "message"
    case typing = "typing"
    case read = "read"
    case join = "join"
    case leave = "leave"
    case heartbeat = "heartbeat"
    case error = "error"
    case ack = "ack"
}

//  WebSocket Message
public struct WebSocketMessage<T: Codable>: Codable {
    public let id: String
    public let type: WebSocketMessageType
    public let data: T?
    public let timestamp: Date
    public let sender: String?
    public let room: String?
    
    public init(
        id: String = UUID().uuidString,
        type: WebSocketMessageType,
        data: T? = nil,
        timestamp: Date = Date(),
        sender: String? = nil,
        room: String? = nil
    ) {
        self.id = id
        self.type = type
        self.data = data
        self.timestamp = timestamp
        self.sender = sender
        self.room = room
    }
}

//  Chat Message
public struct ChatMessage: Codable {
    public let id: String
    public let text: String
    public let sender: String
    public let senderName: String
    public let senderAvatar: String?
    public let timestamp: Date
    public let room: String
    public let isRead: Bool
    public let messageType: MessageType
    
    public enum MessageType: String, Codable {
        case text
        case image
        case file
        case audio
        case video
        case location
        case system
    }
    
    public init(
        id: String = UUID().uuidString,
        text: String,
        sender: String,
        senderName: String,
        senderAvatar: String? = nil,
        timestamp: Date = Date(),
        room: String,
        isRead: Bool = false,
        messageType: MessageType = .text
    ) {
        self.id = id
        self.text = text
        self.sender = sender
        self.senderName = senderName
        self.senderAvatar = senderAvatar
        self.timestamp = timestamp
        self.room = room
        self.isRead = isRead
        self.messageType = messageType
    }
}

//  Typing Indicator
public struct TypingIndicator: Codable {
    public let userId: String
    public let userName: String
    public let room: String
    public let isTyping: Bool
    public let timestamp: Date
    
    public init(
        userId: String,
        userName: String,
        room: String,
        isTyping: Bool,
        timestamp: Date = Date()
    ) {
        self.userId = userId
        self.userName = userName
        self.room = room
        self.isTyping = isTyping
        self.timestamp = timestamp
    }
}

//  WebSocket Connection State
public enum WebSocketConnectionState {
    case disconnected
    case connecting
    case connected
    case reconnecting
    case failed(Error)
}

//  WebSocket Error
public enum WebSocketError: LocalizedError {
    case connectionFailed
    case connectionLost
    case messageSendFailed
    case messageReceiveFailed
    case invalidMessage
    case authenticationFailed
    case rateLimitExceeded
    case serverError(String)
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .connectionFailed:
            return "Failed to connect to WebSocket server"
        case .connectionLost:
            return "WebSocket connection was lost"
        case .messageSendFailed:
            return "Failed to send message"
        case .messageReceiveFailed:
            return "Failed to receive message"
        case .invalidMessage:
            return "Invalid message format"
        case .authenticationFailed:
            return "Authentication failed"
        case .rateLimitExceeded:
            return "Rate limit exceeded"
        case .serverError(let message):
            return "Server error: \(message)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// WebSocket Manager
public class WebSocketManager: ObservableObject {
    public static let shared = WebSocketManager()
    
    // Published Properties
    @Published public private(set) var connectionState: WebSocketConnectionState = .disconnected
    @Published public private(set) var isConnected: Bool = false
    @Published public private(set) var lastMessage: ChatMessage?
    @Published public private(set) var typingUsers: [TypingIndicator] = []
    
    // Private Properties
    private var webSocketTask: URLSessionWebSocketTask?
    private var session: URLSession
    private var heartbeatTimer: Timer?
    private var reconnectTimer: Timer?
    private var messageQueue: [WebSocketMessage<ChatMessage>] = []
    private var cancellables = Set<AnyCancellable>()
    
    // Configuration
    private var baseURL: String = ""
    private var authToken: String = ""
    private var reconnectAttempts: Int = 0
    private let maxReconnectAttempts: Int = 5
    private let reconnectDelay: TimeInterval = 2.0
    private let heartbeatInterval: TimeInterval = 30.0
    
    // Constants
    private enum Constants {
        static let heartbeatMessage = "ping"
        static let heartbeatResponse = "pong"
    }
    
    // Initialization
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Connection Management
    public func connect(url: String, authToken: String) -> AnyPublisher<Bool, WebSocketError> {
        self.baseURL = url
        self.authToken = authToken
        connectionState = .connecting
        
        guard let url = URL(string: url) else {
            connectionState = .failed(WebSocketError.connectionFailed)
            return Fail(error: WebSocketError.connectionFailed)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()
      
        receiveMessage()
        startHeartbeat()
        
        // Send connect message
        let connectMessage = WebSocketMessage<String?>(
            type: .connect,
            data: nil,
            sender: nil,
            room: nil
        )
        
        return sendMessage(connectMessage)
            .map { _ in
                self.connectionState = .connected
                self.isConnected = true
                self.reconnectAttempts = 0
                return true
            }
            .catch { error in
                self.connectionState = .failed(error)
                return Fail<Bool, WebSocketError>(error: error)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    public func disconnect() {
        connectionState = .disconnected
        isConnected = false
        
        stopHeartbeat()
        stopReconnectTimer()
        
        let disconnectMessage = WebSocketMessage<String?>(
            type: .disconnect,
            data: nil,
            sender: nil,
            room: nil
        )
        
        sendMessage(disconnectMessage)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        
        webSocketTask?.cancel()
        webSocketTask = nil
    }
    
    // Message Sending
    public func sendChatMessage(_ message: ChatMessage) -> AnyPublisher<Bool, WebSocketError> {
        let wsMessage = WebSocketMessage(
            type: .message,
            data: message,
            sender: message.sender,
            room: message.room
        )
        
        return sendMessage(wsMessage)
    }
    
    public func sendTypingIndicator(_ indicator: TypingIndicator) -> AnyPublisher<Bool, WebSocketError> {
        let wsMessage = WebSocketMessage(
            type: .typing,
            data: indicator,
            sender: indicator.userId,
            room: indicator.room
        )
        
        return sendMessage(wsMessage)
    }
    
    public func joinRoom(_ room: String) -> AnyPublisher<Bool, WebSocketError> {
        let wsMessage = WebSocketMessage<String>(
            type: .join,
            data: room,
            sender: nil,
            room: room
        )
        
        return sendMessage(wsMessage)
    }
    
    public func leaveRoom(_ room: String) -> AnyPublisher<Bool, WebSocketError> {
        let wsMessage = WebSocketMessage<String>(
            type: .leave,
            data: room,
            sender: nil,
            room: room
        )
        
        return sendMessage(wsMessage)
    }
    
    //  Private Methods
    private func sendMessage<T: Codable>(_ message: WebSocketMessage<T>) -> AnyPublisher<Bool, WebSocketError> {
        guard let webSocketTask = webSocketTask else {
            return Fail(error: WebSocketError.connectionFailed)
                .eraseToAnyPublisher()
        }
        
        return Future<Bool, WebSocketError> { promise in
            do {
                let data = try JSONEncoder().encode(message)
                let wsMessage = URLSessionWebSocketTask.Message.data(data)
                
                webSocketTask.send(wsMessage) { error in
                    if let error = error {
                        promise(.failure(.messageSendFailed))
                    } else {
                        promise(.success(true))
                    }
                }
            } catch {
                promise(.failure(.invalidMessage))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func receiveMessage() {
        guard let webSocketTask = webSocketTask else { return }
        
        webSocketTask.receive { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self?.handleMessage(message)
                    self?.receiveMessage() // Continue receiving
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .data(let data):
            handleDataMessage(data)
        case .string(let string):
            handleStringMessage(string)
        @unknown default:
            break
        }
    }
    
    private func handleDataMessage(_ data: Data) {
        do {
            let message = try JSONDecoder().decode(WebSocketMessage<ChatMessage>.self, from: data)
            processMessage(message)
        } catch {
            print("Failed to decode message: \(error)")
        }
    }
    
    private func handleStringMessage(_ string: String) {
        if string == Constants.heartbeatResponse {
            // Handle heartbeat response
            return
        }
        
        // Try to decode as JSON
        guard let data = string.data(using: .utf8) else { return }
        handleDataMessage(data)
    }
    
    private func processMessage(_ message: WebSocketMessage<ChatMessage>) {
        switch message.type {
        case .message:
            if let chatMessage = message.data {
                lastMessage = chatMessage
                // Notify observers of new message
                NotificationCenter.default.post(
                    name: .newChatMessage,
                    object: chatMessage
                )
            }
        case .typing:
            if let typingData = message.data {
                updateTypingIndicator(TypingIndicator(
                    userId: typingData.sender,
                    userName: typingData.senderName,
                    room: typingData.room,
                    isTyping: true
                ))
            }
        case .read:
            // Handle read receipts
            break
        case .error:
            handleError(WebSocketError.serverError("Server error"))
        default:
            break
        }
    }
    
    private func updateTypingIndicator(_ indicator: TypingIndicator) {
        // Remove existing typing indicator for this user
        typingUsers.removeAll { $0.userId == indicator.userId }
        
        if indicator.isTyping {
            typingUsers.append(indicator)
        }
        
        // Auto-remove typing indicator after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.typingUsers.removeAll { $0.userId == indicator.userId }
        }
    }
    
    private func handleError(_ error: Error) {
        connectionState = .failed(WebSocketError.networkError(error))
        isConnected = false
        
        if reconnectAttempts < maxReconnectAttempts {
            scheduleReconnect()
        }
    }
    
    private func scheduleReconnect() {
        reconnectAttempts += 1
        connectionState = .reconnecting
        
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: reconnectDelay, repeats: false) { [weak self] _ in
            self?.attemptReconnect()
        }
    }
    
    private func attemptReconnect() {
        guard !baseURL.isEmpty && !authToken.isEmpty else { return }
        
        connect(url: baseURL, authToken: authToken)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Reconnect failed: \(error)")
                    }
                },
                receiveValue: { _ in
                    print("Reconnected successfully")
                }
            )
            .store(in: &cancellables)
    }
    
    private func startHeartbeat() {
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: heartbeatInterval, repeats: true) { [weak self] _ in
            self?.sendHeartbeat()
        }
    }
    
    private func stopHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
    
    private func stopReconnectTimer() {
        reconnectTimer?.invalidate()
        reconnectTimer = nil
    }
    
    private func sendHeartbeat() {
        let heartbeatMessage = WebSocketMessage<String>(
            type: .heartbeat,
            data: Constants.heartbeatMessage,
            sender: nil,
            room: nil
        )
        
        sendMessage(heartbeatMessage)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
}

// Notification Names
public extension Notification.Name {
    static let newChatMessage = Notification.Name("newChatMessage")
    static let typingIndicator = Notification.Name("typingIndicator")
    static let connectionStateChanged = Notification.Name("connectionStateChanged")
}

// WebSocket Manager Extensions
extension WebSocketManager {
    
    //  Chat Room Management
    public func createChatRoom(_ roomId: String) -> AnyPublisher<Bool, WebSocketError> {
        return joinRoom(roomId)
    }
    
    public func sendTextMessage(_ text: String, to room: String, sender: String, senderName: String) -> AnyPublisher<Bool, WebSocketError> {
        let message = ChatMessage(
            text: text,
            sender: sender,
            senderName: senderName,
            room: room
        )
        
        return sendChatMessage(message)
    }
    
    public func sendSystemMessage(_ text: String, to room: String) -> AnyPublisher<Bool, WebSocketError> {
        let message = ChatMessage(
            text: text,
            sender: "system",
            senderName: "System",
            room: room,
            messageType: .system
        )
        
        return sendChatMessage(message)
    }
    
    // Analytics
    public func getConnectionAnalytics() -> [String: Any] {
        return [
            "is_connected": isConnected,
            "connection_state": String(describing: connectionState),
            "reconnect_attempts": reconnectAttempts,
            "typing_users_count": typingUsers.count,
            "last_message_timestamp": lastMessage?.timestamp.timeIntervalSince1970 ?? 0
        ]
    }
    
    // Message Queue Management
    public func flushMessageQueue() {
        for message in messageQueue {
            sendMessage(message)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { _ in }
                )
                .store(in: &cancellables)
        }
        messageQueue.removeAll()
    }
} 
