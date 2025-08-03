import SwiftUI

public struct OnboardingStep {
    let title: String
    let description: String
    let imageName: String
    
    public init(title: String, description: String, imageName: String) {
        self.title = title
        self.description = description
        self.imageName = imageName
    }
}

public struct OnboardingScreen: View {
    let steps: [OnboardingStep]
    @Binding var currentStep: Int
    let onNext: () -> Void
    let onSkip: () -> Void
    let onBegin: () -> Void
    
    public init(
        steps: [OnboardingStep],
        currentStep: Binding<Int>,
        onNext: @escaping () -> Void,
        onSkip: @escaping () -> Void,
        onBegin: @escaping () -> Void
    ) {
        self.steps = steps
        self._currentStep = currentStep
        self.onNext = onNext
        self.onSkip = onSkip
        self.onBegin = onBegin
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentStep) {
                ForEach(0..<steps.count, id: \.self) { index in
                    OnboardingStepView(
                        step: steps[index],
                        isLastStep: index == steps.count - 1,
                        onNext: onNext,
                        onSkip: onSkip,
                        onBegin: onBegin
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            OnboardingPaginationView(
                totalSteps: steps.count,
                currentStep: currentStep
            )
        }
        .background(AppColors.shared.white)
    }
}

private struct OnboardingStepView: View {
    let step: OnboardingStep
    let isLastStep: Bool
    let onNext: () -> Void
    let onSkip: () -> Void
    let onBegin: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: step.imageName)
                    .font(.system(size: 120, weight: .light))
                    .foregroundColor(AppColors.shared.alertGreen)
                
                VStack(spacing: 16) {
                    BoldText(step.title)
                        .multilineTextAlignment(.center)
                    
                    SubtitleText(step.description)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                if isLastStep {
                    ReusableButton(
                        title: "Begin",
                        backgroundColor: AppColors.shared.alertGreen,
                        textColor: AppColors.shared.white
                    ) {
                        onBegin()
                    }
                } else {
                    ReusableButton(
                        title: "Next",
                        backgroundColor: AppColors.shared.black,
                        textColor: AppColors.shared.white
                    ) {
                        onNext()
                    }
                }
                
                ReusableOutlinedButton(
                    title: "Skip",
                    textColor: AppColors.shared.black,
                    borderColor: AppColors.shared.whiteShades90
                ) {
                    onSkip()
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
    }
}

private struct OnboardingPaginationView: View {
    let totalSteps: Int
    let currentStep: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Circle()
                    .fill(index == currentStep ? AppColors.shared.alertGreen : AppColors.shared.whiteShades90)
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
        .padding(.bottom, 32)
    }
}

public struct OnboardingScreenWithData: View {
    @State private var currentStep = 0
    
    public init() {}
    
    public var body: some View {
        OnboardingScreen(
            steps: defaultOnboardingSteps,
            currentStep: $currentStep,
            onNext: {
                withAnimation {
                    currentStep = min(currentStep + 1, defaultOnboardingSteps.count - 1)
                }
            },
            onSkip: {
                print("Onboarding skipped")
            },
            onBegin: {
                print("Onboarding completed")
            }
        )
    }
    
    private var defaultOnboardingSteps: [OnboardingStep] {
        [
            OnboardingStep(
                title: "Hassle-free construction in a couple of clicks",
                description: "Simply place an order with a description of the task, budget and deadlines - and performers will respond to help turn your ideas into reality",
                imageName: "list.bullet.clipboard"
            ),
            OnboardingStep(
                title: "A jack of all trades in your pocket",
                description: "Do you need professionals for construction or renovation work?. In our application you can easily find performers who will turn your ideas into reality",
                imageName: "magnifyingglass"
            ),
            OnboardingStep(
                title: "Create an artist profile and complete orders",
                description: "In our application you can easily find profitable orders for construction and repair work",
                imageName: "person.crop.circle.badge.plus"
            ),
            OnboardingStep(
                title: "Stable income from orders from the application",
                description: "Are you an experienced builder or renovator?. Show off your skills and earn more on interesting projects",
                imageName: "dollarsign.circle"
            )
        ]
    }
}

#Preview {
    OnboardingScreenWithData()
} 