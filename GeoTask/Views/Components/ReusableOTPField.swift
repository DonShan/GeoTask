import SwiftUI

public struct ReusableOTPField: View {
    @Binding var otpCode: String
    let numberOfDigits: Int
    let onComplete: (String) -> Void
    let validationState: OTPValidationState
    @FocusState private var isFocused: Bool
    
    public init(
        otpCode: Binding<String>,
        numberOfDigits: Int = 6,
        validationState: OTPValidationState = .none,
        onComplete: @escaping (String) -> Void = { _ in }
    ) {
        self._otpCode = otpCode
        self.numberOfDigits = numberOfDigits
        self.validationState = validationState
        self.onComplete = onComplete
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                ForEach(0..<numberOfDigits, id: \.self) { index in
                    OTPDigitField(
                        digit: digitAt(index: index),
                        isActive: isFocused && index == otpCode.count,
                        isFilled: index < otpCode.count,
                        showCursor: isFocused && index == otpCode.count,
                        validationState: validationState
                    )
                }
            }
            
            if case .error(let message) = validationState {
                Text(message)
                    .font(AppFonts.shared.bodyMedium)
                    .foregroundColor(AppColors.shared.alertRed)
                    .multilineTextAlignment(.center)
            }
        }
        .overlay(
            TextField("", text: $otpCode)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0)
                .onChange(of: otpCode) { newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered.count <= numberOfDigits {
                        otpCode = filtered
                        if filtered.count == numberOfDigits {
                            onComplete(filtered)
                        }
                    }
                }
        )
    }
    
    private func digitAt(index: Int) -> String {
        if index < otpCode.count {
            return String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: index)])
        }
        return ""
    }
}

public enum OTPValidationState {
    case none
    case success
    case error(String)
}

private struct OTPDigitField: View {
    let digit: String
    let isActive: Bool
    let isFilled: Bool
    let showCursor: Bool
    let validationState: OTPValidationState
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.shared.white)
                .frame(width: 48, height: 56)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
            
            if isFilled {
                HStack(spacing: 0) {
                    Text(digit)
                        .font(AppFonts.shared.titleLarge)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.shared.black)
                    
                    if showCursor {
                        Rectangle()
                            .fill(AppColors.shared.black)
                            .frame(width: 2, height: 24)
                            .padding(.leading, 2)
                    }
                }
            } else {
                Rectangle()
                    .fill(AppColors.shared.whiteShades90)
                    .frame(width: 16, height: 2)
            }
        }
    }
    
    private var borderColor: Color {
        switch validationState {
        case .success:
            return AppColors.shared.alertGreen
        case .error:
            return AppColors.shared.alertRed
        case .none:
            if isActive {
                return AppColors.shared.black
            } else if isFilled {
                return AppColors.shared.whiteShades90
            } else {
                return AppColors.shared.whiteShades90
            }
        }
    }
    
    private var borderWidth: CGFloat {
        switch validationState {
        case .success, .error:
            return 2
        case .none:
            return isActive ? 2 : 1
        }
    }
    
    private var shadowColor: Color {
        switch validationState {
        case .success:
            return AppColors.shared.alertGreen.opacity(0.2)
        case .error:
            return AppColors.shared.alertRed.opacity(0.2)
        case .none:
            return isActive ? AppColors.shared.black.opacity(0.1) : .black.opacity(0.05)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch validationState {
        case .success, .error:
            return 3
        case .none:
            return isActive ? 2 : 1
        }
    }
    
    private var shadowY: CGFloat {
        switch validationState {
        case .success, .error:
            return 1.5
        case .none:
            return isActive ? 1 : 0.5
        }
    }
}

public struct ReusableOTPFieldWithTitle: View {
    let title: String
    let subtitle: String?
    @Binding var otpCode: String
    let numberOfDigits: Int
    let validationState: OTPValidationState
    let onComplete: (String) -> Void
    
    public init(
        title: String,
        subtitle: String? = nil,
        otpCode: Binding<String>,
        numberOfDigits: Int = 6,
        validationState: OTPValidationState = .none,
        onComplete: @escaping (String) -> Void = { _ in }
    ) {
        self.title = title
        self.subtitle = subtitle
        self._otpCode = otpCode
        self.numberOfDigits = numberOfDigits
        self.validationState = validationState
        self.onComplete = onComplete
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(AppFonts.shared.titleLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.shared.black)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppFonts.shared.bodyMedium)
                        .foregroundColor(AppColors.shared.whiteShades90)
                }
            }
            
            ReusableOTPField(
                otpCode: $otpCode,
                numberOfDigits: numberOfDigits,
                validationState: validationState,
                onComplete: onComplete
            )
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        ReusableOTPFieldWithTitle(
            title: "Enter verification code",
            subtitle: "We've sent a code to your email",
            otpCode: .constant("337779"),
            validationState: .success
        ) { code in
            print("OTP completed: \(code)")
        }
        
        ReusableOTPFieldWithTitle(
            title: "SMS Code",
            otpCode: .constant("113246"),
            validationState: .error("Wrong code")
        ) { code in
            print("OTP completed: \(code)")
        }
        
        ReusableOTPField(
            otpCode: .constant(""),
            numberOfDigits: 4
        ) { code in
            print("4-digit OTP completed: \(code)")
        }
    }
    .padding()
    .background(AppColors.shared.white)
}
