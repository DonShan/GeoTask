import SwiftUI

public struct LoginScreen: View {
    @State private var phoneNumber = "+7 223 23 456 77"
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 24) {
                    BoldText("Log In")
                        .font(AppFonts.shared.titleLarge)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 8) {
                        MediumText("Enter your phone number")
                            .font(AppFonts.shared.bodyMedium)
                            .foregroundColor(AppColors.shared.whiteShades90)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        PhoneNumberField(
                            phoneNumber: $phoneNumber
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                Spacer()
                
                VStack(spacing: 24) {
                    LegalText()
                    
                    ReusableButton(
                        title: "Log In",
                        backgroundColor: AppColors.shared.black,
                        textColor: AppColors.shared.white
                    ) {
                        print("Login tapped")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 60)
            }
        }
        .background(AppColors.shared.white)
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0)
        }
    }
}

private struct PhoneNumberField: View {
    @Binding var phoneNumber: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("", text: $phoneNumber)
                .font(AppFonts.shared.titleLarge)
                .fontWeight(.medium)
                .foregroundColor(AppColors.shared.black)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .focused($isFocused)
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .background(AppColors.shared.whiteShades98)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? AppColors.shared.black : AppColors.shared.whiteShades90, lineWidth: isFocused ? 2 : 1)
                )
                .cornerRadius(12)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

private struct LegalText: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                MediumText("By using the application you agree to the ")
                    .font(AppFonts.shared.bodySmall)
                    .foregroundColor(AppColors.shared.whiteShades90)
                
                Spacer()
            }
            
            HStack {
                Button("Privacy Policy") {
                    print("Privacy Policy tapped")
                }
                .font(AppFonts.shared.bodySmall)
                .fontWeight(.medium)
                .foregroundColor(AppColors.shared.black)
                .underline()
                
                MediumText(" and ")
                    .font(AppFonts.shared.bodySmall)
                    .foregroundColor(AppColors.shared.whiteShades90)
                
                Button("Terms of Use") {
                    print("Terms of Use tapped")
                }
                .font(AppFonts.shared.bodySmall)
                .fontWeight(.medium)
                .foregroundColor(AppColors.shared.black)
                .underline()
                
                Spacer()
            }
        }
    }
}

public struct LoginScreenWithAlternative: View {
    @State private var phoneNumber = "+7 223 23 456 77"
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 24) {
                    HStack {
                        BoldText("Log In")
                            .font(AppFonts.shared.titleLarge)
                        
                        Spacer()
                        
                        Button("Login without an account") {
                            print("Login without account tapped")
                        }
                        .font(AppFonts.shared.bodyMedium)
                        .fontWeight(.medium)
                        .foregroundColor(AppColors.shared.black)
                        .underline()
                    }
                    
                    VStack(spacing: 8) {
                        MediumText("Enter your phone number")
                            .font(AppFonts.shared.bodyMedium)
                            .foregroundColor(AppColors.shared.whiteShades90)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        PhoneNumberField(
                            phoneNumber: $phoneNumber
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                Spacer()
                
                VStack(spacing: 24) {
                    LegalText()
                    
                    ReusableButton(
                        title: "Log In",
                        backgroundColor: AppColors.shared.black,
                        textColor: AppColors.shared.white
                    ) {
                        print("Login tapped")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 60)
            }
        }
        .background(AppColors.shared.white)
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0)
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        LoginScreen()
        
        Divider()
        
        LoginScreenWithAlternative()
    }
    .background(AppColors.shared.whiteShades97)
} 