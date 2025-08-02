import SwiftUI

public struct ReusableTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let textContentType: UITextContentType?
    let isSecure: Bool
    let cornerRadius: CGFloat
    @FocusState private var isFocused: Bool
    
    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        isSecure: Bool = false,
        cornerRadius: CGFloat = 12
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.isSecure = isSecure
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(AppFonts.shared.bodyMedium)
                .fontWeight(.medium)
                .foregroundColor(AppColors.shared.black)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(AppFonts.shared.bodyMedium)
            .foregroundColor(AppColors.shared.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(text.isEmpty ? AppColors.shared.whiteShades98 : AppColors.shared.whiteShades90)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isFocused ? AppColors.shared.black : Color.clear, lineWidth: isFocused ? 2 : 0)
            )
            .cornerRadius(cornerRadius)
            .shadow(color: isFocused ? AppColors.shared.black.opacity(0.2) : .black.opacity(0.05), radius: isFocused ? 4 : 2, x: 0, y: isFocused ? 2 : 1)
            .keyboardType(keyboardType)
            .textContentType(textContentType)
            .focused($isFocused)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
        }
    }
}

public struct ReusableTextArea: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let cornerRadius: CGFloat
    @FocusState private var isFocused: Bool
    
    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        minHeight: CGFloat = 80,
        maxHeight: CGFloat = 200,
        cornerRadius: CGFloat = 12
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(AppFonts.shared.bodyMedium)
                .fontWeight(.medium)
                .foregroundColor(AppColors.shared.black)
            
            TextEditor(text: $text)
                .font(AppFonts.shared.bodyMedium)
                .foregroundColor(AppColors.shared.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(text.isEmpty ? AppColors.shared.whiteShades98 : AppColors.shared.whiteShades90)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(isFocused ? AppColors.shared.black : Color.clear, lineWidth: isFocused ? 2 : 0)
                )
                .cornerRadius(cornerRadius)
                .shadow(color: isFocused ? AppColors.shared.black.opacity(0.2) : .black.opacity(0.05), radius: isFocused ? 4 : 2, x: 0, y: isFocused ? 2 : 1)
                .frame(minHeight: minHeight, maxHeight: maxHeight)
                .focused($isFocused)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
                .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
                .overlay(
                    Group {
                        if text.isEmpty {
                            VStack {
                                HStack {
                                    Text(placeholder)
                                        .font(AppFonts.shared.bodyMedium)
                                        .foregroundColor(AppColors.shared.whiteShades90)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 18)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                )
        }
    }
}

public struct ReusableSearchField: View {
    let placeholder: String
    @Binding var text: String
    let onSearch: () -> Void
    @FocusState private var isFocused: Bool
    
    public init(
        placeholder: String = "Search...",
        text: Binding<String>,
        onSearch: @escaping () -> Void
    ) {
        self.placeholder = placeholder
        self._text = text
        self.onSearch = onSearch
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isFocused ? AppColors.shared.black : AppColors.shared.whiteShades90)
            
            TextField(placeholder, text: $text)
                .font(AppFonts.shared.bodyMedium)
                .foregroundColor(AppColors.shared.black)
                .focused($isFocused)
                .onSubmit {
                    onSearch()
                }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.shared.whiteShades90)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(text.isEmpty ? AppColors.shared.whiteShades98 : AppColors.shared.whiteShades90)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? AppColors.shared.black : Color.clear, lineWidth: isFocused ? 2 : 0)
        )
        .cornerRadius(12)
        .shadow(color: isFocused ? AppColors.shared.black.opacity(0.2) : .black.opacity(0.05), radius: isFocused ? 4 : 2, x: 0, y: isFocused ? 2 : 1)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
    }
}

public struct ReusableFormSection: View {
    let title: String
    let content: AnyView
    
    public init<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = AnyView(content())
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFonts.shared.titleMedium)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.shared.black)
            
            content
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            ReusableFormSection(title: "Personal Information") {
                VStack(spacing: 16) {
                    ReusableTextField(
                        label: "Name",
                        placeholder: "Enter your name",
                        text: .constant("")
                    )
                    
                    ReusableTextField(
                        label: "City",
                        placeholder: "Please indicate your city",
                        text: .constant("")
                    )
                    
                    ReusableTextField(
                        label: "Email",
                        placeholder: "Enter your email",
                        text: .constant(""),
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress
                    )
                    
                    ReusableTextField(
                        label: "Password",
                        placeholder: "Enter your password",
                        text: .constant(""),
                        textContentType: .password,
                        isSecure: true
                    )
                }
            }
            
            ReusableFormSection(title: "Additional Information") {
                VStack(spacing: 16) {
                    ReusableTextArea(
                        label: "Description",
                        placeholder: "Enter your description here...",
                        text: .constant("")
                    )
                    
                    ReusableSearchField(
                        placeholder: "Search locations...",
                        text: .constant("")
                    ) {
                        print("Search performed")
                    }
                }
            }
        }
        .padding()
    }
    .background(AppColors.shared.white)
} 