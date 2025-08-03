import SwiftUI
import Combine

public enum BannerType {
    case success
    case error
    case warning
    case info
    case accept
    case cancel
    case confirm
    case request
    case order
    case contractor
    
    var iconName: String {
        switch self {
        case .success:
            return "checkmark"
        case .error:
            return "xmark"
        case .warning:
            return "exclamationmark.triangle"
        case .info:
            return "info.circle"
        case .accept:
            return "person.crop.circle"
        case .cancel:
            return "exclamationmark.circle.fill"
        case .confirm:
            return "questionmark.circle"
        case .request:
            return "person.crop.circle"
        case .order:
            return "bag"
        case .contractor:
            return "person.2"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .success:
            return AppColors.shared.alertGreen
        case .error:
            return AppColors.shared.alertRed
        case .warning:
            return AppColors.shared.alertYellow
        case .info:
            return AppColors.shared.black
        case .accept:
            return AppColors.shared.whiteShades90
        case .cancel:
            return AppColors.shared.alertRed
        case .confirm:
            return AppColors.shared.black
        case .request:
            return AppColors.shared.whiteShades90
        case .order:
            return AppColors.shared.black
        case .contractor:
            return AppColors.shared.alertGreen
        }
    }
    
    var iconColor: Color {
        switch self {
        case .accept, .request:
            return AppColors.shared.black
        case .cancel:
            return AppColors.shared.white
        default:
            return AppColors.shared.white
        }
    }
}

public struct ReusableBanner: View {
    let type: BannerType
    let title: String
    let message: String
    let buttonTitle: String
    let onButtonTap: () -> Void
    let onDismiss: (() -> Void)?
    
    @State private var isPresented = false
    
    public init(
        type: BannerType = .success,
        title: String,
        message: String,
        buttonTitle: String = "Continue",
        onButtonTap: @escaping () -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onButtonTap = onButtonTap
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissBanner()
                }
            
            VStack(spacing: 24) {
                IconView(type: type)
                
                VStack(spacing: 12) {
                    BoldText(title)
                        .font(AppFonts.shared.titleLarge)
                        .foregroundColor(AppColors.shared.black)
                        .multilineTextAlignment(.center)
                    
                    MediumText(message)
                        .font(AppFonts.shared.bodyMedium)
                        .foregroundColor(AppColors.shared.whiteShades90)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                
                ReusableButton(
                    title: buttonTitle,
                    backgroundColor: AppColors.shared.black,
                    textColor: AppColors.shared.white
                ) {
                    onButtonTap()
                    dismissBanner()
                }
            }
            .padding(24)
            .background(AppColors.shared.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 32)
            .scaleEffect(isPresented ? 1.0 : 0.8)
            .opacity(isPresented ? 1.0 : 0.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isPresented)
        }
        .onAppear {
            isPresented = true
        }
    }
    
    private func dismissBanner() {
        isPresented = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss?()
        }
    }
}

private struct IconView: View {
    let type: BannerType
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(type.backgroundColor)
                .frame(width: 60, height: 60)
            
            Image(systemName: type.iconName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(type.iconColor)
        }
    }
}

public struct SuccessBanner: View {
    let title: String
    let message: String
    let buttonTitle: String
    let onButtonTap: () -> Void
    let onDismiss: (() -> Void)?
    
    public init(
        title: String,
        message: String,
        buttonTitle: String = "Continue",
        onButtonTap: @escaping () -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onButtonTap = onButtonTap
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ReusableBanner(
            type: .success,
            title: title,
            message: message,
            buttonTitle: buttonTitle,
            onButtonTap: onButtonTap,
            onDismiss: onDismiss
        )
    }
}

public struct ErrorBanner: View {
    let title: String
    let message: String
    let buttonTitle: String
    let onButtonTap: () -> Void
    let onDismiss: (() -> Void)?
    
    public init(
        title: String,
        message: String,
        buttonTitle: String = "Try Again",
        onButtonTap: @escaping () -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onButtonTap = onButtonTap
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ReusableBanner(
            type: .error,
            title: title,
            message: message,
            buttonTitle: buttonTitle,
            onButtonTap: onButtonTap,
            onDismiss: onDismiss
        )
    }
}

public struct WarningBanner: View {
    let title: String
    let message: String
    let buttonTitle: String
    let onButtonTap: () -> Void
    let onDismiss: (() -> Void)?
    
    public init(
        title: String,
        message: String,
        buttonTitle: String = "OK",
        onButtonTap: @escaping () -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onButtonTap = onButtonTap
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ReusableBanner(
            type: .warning,
            title: title,
            message: message,
            buttonTitle: buttonTitle,
            onButtonTap: onButtonTap,
            onDismiss: onDismiss
        )
    }
}

public struct InfoBanner: View {
    let title: String
    let message: String
    let buttonTitle: String
    let onButtonTap: () -> Void
    let onDismiss: (() -> Void)?
    
    public init(
        title: String,
        message: String,
        buttonTitle: String = "Got it",
        onButtonTap: @escaping () -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onButtonTap = onButtonTap
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ReusableBanner(
            type: .info,
            title: title,
            message: message,
            buttonTitle: buttonTitle,
            onButtonTap: onButtonTap,
            onDismiss: onDismiss
        )
    }
}

public struct AcceptRequestBanner: View {
    let title: String
    let message: String
    let buttonTitle: String
    let onButtonTap: () -> Void
    let onDismiss: (() -> Void)?
    
    public init(
        title: String = "Accept request",
        message: String,
        buttonTitle: String = "Accept",
        onButtonTap: @escaping () -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onButtonTap = onButtonTap
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ReusableBanner(
            type: .accept,
            title: title,
            message: message,
            buttonTitle: buttonTitle,
            onButtonTap: onButtonTap,
            onDismiss: onDismiss
        )
    }
}

public struct CancelOrderBanner: View {
    let title: String
    let message: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    let onDismiss: (() -> Void)?
    
    public init(
        title: String = "Cancel the order?",
        message: String = "Are you sure you want to cancel your order?",
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissBanner()
                }
            
            VStack(spacing: 24) {
                IconView(type: .cancel)
                
                VStack(spacing: 12) {
                    BoldText(title)
                        .font(AppFonts.shared.titleLarge)
                        .foregroundColor(AppColors.shared.black)
                        .multilineTextAlignment(.center)
                    
                    MediumText(message)
                        .font(AppFonts.shared.bodyMedium)
                        .foregroundColor(AppColors.shared.whiteShades90)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                
                VStack(spacing: 12) {
                    ReusableButton(
                        title: "Yes",
                        backgroundColor: AppColors.shared.black,
                        textColor: AppColors.shared.white
                    ) {
                        onConfirm()
                        dismissBanner()
                    }
                    
                    ReusableOutlinedButton(
                        title: "No",
                        textColor: AppColors.shared.black,
                        borderColor: AppColors.shared.black
                    ) {
                        onCancel()
                        dismissBanner()
                    }
                }
            }
            .padding(24)
            .background(AppColors.shared.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 32)
        }
    }
    
    private func dismissBanner() {
        onDismiss?()
    }
}

public struct OrderCancelledBanner: View {
    let title: String
    let message: String
    let buttonTitle: String
    let onButtonTap: () -> Void
    let onDismiss: (() -> Void)?
    
    public init(
        title: String = "Order cancelled",
        message: String = "Your order has been successfully canceled. You can create a new order to find a suitable contractor and fulfill your needs.",
        buttonTitle: String = "Continue",
        onButtonTap: @escaping () -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onButtonTap = onButtonTap
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ReusableBanner(
            type: .order,
            title: title,
            message: message,
            buttonTitle: buttonTitle,
            onButtonTap: onButtonTap,
            onDismiss: onDismiss
        )
    }
}

public struct ContractorRequestBanner: View {
    let title: String
    let message: String
    let buttonTitle: String
    let onButtonTap: () -> Void
    let onDismiss: (() -> Void)?
    
    public init(
        title: String = "Contractor request",
        message: String,
        buttonTitle: String = "Accept",
        onButtonTap: @escaping () -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onButtonTap = onButtonTap
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ReusableBanner(
            type: .contractor,
            title: title,
            message: message,
            buttonTitle: buttonTitle,
            onButtonTap: onButtonTap,
            onDismiss: onDismiss
        )
    }
}

// MARK: - Banner Presenter
@MainActor
public class BannerPresenter: ObservableObject {
    @Published var isShowingBanner = false
    @Published var bannerType: BannerType = .success
    @Published var bannerTitle = ""
    @Published var bannerMessage = ""
    @Published var bannerButtonTitle = ""
    @Published var onBannerButtonTap: (() -> Void)?
    @Published var onBannerDismiss: (() -> Void)?
    
    public static let shared = BannerPresenter()
    
    private init() {}
    
    public func showSuccess(
        title: String,
        message: String,
        buttonTitle: String = "Continue",
        onButtonTap: @escaping () -> Void = {},
        onDismiss: (() -> Void)? = nil
    ) {
        bannerType = .success
        bannerTitle = title
        bannerMessage = message
        bannerButtonTitle = buttonTitle
        onBannerButtonTap = onButtonTap
        onBannerDismiss = onDismiss
        isShowingBanner = true
    }
    
    public func showError(
        title: String,
        message: String,
        buttonTitle: String = "Try Again",
        onButtonTap: @escaping () -> Void = {},
        onDismiss: (() -> Void)? = nil
    ) {
        bannerType = .error
        bannerTitle = title
        bannerMessage = message
        bannerButtonTitle = buttonTitle
        onBannerButtonTap = onButtonTap
        onBannerDismiss = onDismiss
        isShowingBanner = true
    }
    
    public func showWarning(
        title: String,
        message: String,
        buttonTitle: String = "OK",
        onButtonTap: @escaping () -> Void = {},
        onDismiss: (() -> Void)? = nil
    ) {
        bannerType = .warning
        bannerTitle = title
        bannerMessage = message
        bannerButtonTitle = buttonTitle
        onBannerButtonTap = onButtonTap
        onBannerDismiss = onDismiss
        isShowingBanner = true
    }
    
    public func showInfo(
        title: String,
        message: String,
        buttonTitle: String = "Got it",
        onButtonTap: @escaping () -> Void = {},
        onDismiss: (() -> Void)? = nil
    ) {
        bannerType = .info
        bannerTitle = title
        bannerMessage = message
        bannerButtonTitle = buttonTitle
        onBannerButtonTap = onButtonTap
        onBannerDismiss = onDismiss
        isShowingBanner = true
    }
    
    public func showAcceptRequest(
        title: String = "Accept request",
        message: String,
        buttonTitle: String = "Accept",
        onButtonTap: @escaping () -> Void = {},
        onDismiss: (() -> Void)? = nil
    ) {
        bannerType = .accept
        bannerTitle = title
        bannerMessage = message
        bannerButtonTitle = buttonTitle
        onBannerButtonTap = onButtonTap
        onBannerDismiss = onDismiss
        isShowingBanner = true
    }
    
    public func showCancelOrder(
        title: String = "Cancel the order?",
        message: String = "Are you sure you want to cancel your order?",
        onConfirm: @escaping () -> Void = {},
        onCancel: @escaping () -> Void = {},
        onDismiss: (() -> Void)? = nil
    ) {
        bannerType = .cancel
        bannerTitle = title
        bannerMessage = message
        bannerButtonTitle = "Yes"
        onBannerButtonTap = onConfirm
        onBannerDismiss = onDismiss
        isShowingBanner = true
    }
    
    public func showOrderCancelled(
        title: String = "Order cancelled",
        message: String = "Your order has been successfully canceled. You can create a new order to find a suitable contractor and fulfill your needs.",
        buttonTitle: String = "Continue",
        onButtonTap: @escaping () -> Void = {},
        onDismiss: (() -> Void)? = nil
    ) {
        bannerType = .order
        bannerTitle = title
        bannerMessage = message
        bannerButtonTitle = buttonTitle
        onBannerButtonTap = onButtonTap
        onBannerDismiss = onDismiss
        isShowingBanner = true
    }
    
    public func showContractorRequest(
        title: String = "Contractor request",
        message: String,
        buttonTitle: String = "Accept",
        onButtonTap: @escaping () -> Void = {},
        onDismiss: (() -> Void)? = nil
    ) {
        bannerType = .contractor
        bannerTitle = title
        bannerMessage = message
        bannerButtonTitle = buttonTitle
        onBannerButtonTap = onButtonTap
        onBannerDismiss = onDismiss
        isShowingBanner = true
    }
    
    public func dismiss() {
        isShowingBanner = false
    }
}

// MARK: - Banner View Modifier
public struct BannerModifier: ViewModifier {
    @ObservedObject var presenter: BannerPresenter
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if presenter.isShowingBanner {
                ReusableBanner(
                    type: presenter.bannerType,
                    title: presenter.bannerTitle,
                    message: presenter.bannerMessage,
                    buttonTitle: presenter.bannerButtonTitle,
                    onButtonTap: {
                        presenter.onBannerButtonTap?()
                    },
                    onDismiss: {
                        presenter.dismiss()
                        presenter.onBannerDismiss?()
                    }
                )
            }
        }
    }
}

public extension View {
    func bannerPresenter(_ presenter: BannerPresenter) -> some View {
        modifier(BannerModifier(presenter: presenter))
    }
}

#Preview {
    VStack(spacing: 20) {
        SuccessBanner(
            title: "Review sent",
            message: "Congratulations! Your review has been successfully sent to the artist. Thank you for your gratitude and valuable comments.",
            buttonTitle: "Continue"
        ) {
            print("Continue tapped")
        }
        
        ErrorBanner(
            title: "Error occurred",
            message: "Something went wrong. Please try again later.",
            buttonTitle: "Try Again"
        ) {
            print("Try again tapped")
        }
        
        WarningBanner(
            title: "Warning",
            message: "This action cannot be undone. Are you sure you want to proceed?",
            buttonTitle: "Proceed"
        ) {
            print("Proceed tapped")
        }
        
        InfoBanner(
            title: "Information",
            message: "This is an informational message for the user.",
            buttonTitle: "Got it"
        ) {
            print("Got it tapped")
        }
        
        AcceptRequestBanner(
            message: "The contractor has sent you a request to complete the order. Please check the completed work to ensure all requirements are met.",
            buttonTitle: "Accept"
        ) {
            print("Accept tapped")
        }
        
        CancelOrderBanner(
            onConfirm: {
                print("Order cancelled")
            },
            onCancel: {
                print("Cancellation cancelled")
            }
        )
        
        OrderCancelledBanner(
            onButtonTap: {
                print("Continue after cancellation")
            }
        )
        
        ContractorRequestBanner(
            message: "A contractor is requesting to work on your project. Please review their profile and accept if suitable.",
            buttonTitle: "Accept"
        ) {
            print("Contractor accepted")
        }
    }
    .padding()
    .background(AppColors.shared.whiteShades97)
} 