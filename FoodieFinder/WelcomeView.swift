import SwiftUI

struct WelcomeView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    @State private var showMainApp = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    let onboardingPages = [
        OnboardingPage(
            id: 0,
            title: "Discover Amazing Restaurants",
            subtitle: "Find the perfect dining experience near you with our curated selection of restaurants",
            imageName: "magnifyingglass.circle.fill",
            primaryColor: .orange,
            secondaryColor: .red,
            features: ["Real-time search", "Location-based results", "Personalized recommendations"]
        ),
        OnboardingPage(
            id: 1,
            title: "Explore by Categories",
            subtitle: "Browse through diverse cuisines and discover new flavors from around the world",
            imageName: "square.grid.2x2",
            primaryColor: .purple,
            secondaryColor: .pink,
            features: ["Italian, Japanese, Mexican", "Featured restaurants", "Cuisine discovery"]
        ),
        OnboardingPage(
            id: 2,
            title: "Save Your Favorites",
            subtitle: "Keep track of restaurants you love and never forget a great dining experience",
            imageName: "heart.circle.fill",
            primaryColor: .red,
            secondaryColor: .orange,
            features: ["Personal collection", "Quick access", "Sync across devices"]
        ),
        OnboardingPage(
            id: 3,
            title: "Book with Ease",
            subtitle: "Make reservations instantly and manage all your bookings in one place",
            imageName: "calendar.circle.fill",
            primaryColor: .blue,
            secondaryColor: .teal,
            features: ["Instant booking", "Reservation management", "Status tracking"]
        )
    ]
    
    var body: some View {
        ZStack {
            // Dynamic Background
            LinearGradient(
                gradient: Gradient(colors: [
                    onboardingPages[currentPage].primaryColor.opacity(0.1),
                    onboardingPages[currentPage].secondaryColor.opacity(0.05),
                    Color(.systemBackground)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.8), value: currentPage)
            
            VStack(spacing: 0) {
                // Skip Button
                HStack {
                    Spacer()
                    
                    if currentPage < onboardingPages.count - 1 {
                        Button("Skip") {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentPage = onboardingPages.count - 1
                            }
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }
                }
                
                // Main Content
                TabView(selection: $currentPage) {
                    ForEach(onboardingPages, id: \.id) { page in
                        OnboardingPageView(page: page, isActive: currentPage == page.id)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                // Bottom Controls
                VStack(spacing: 32) {
                    // Custom Page Indicators
                    HStack(spacing: 8) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            PageIndicator(
                                isActive: currentPage == index,
                                color: onboardingPages[currentPage].primaryColor
                            )
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        if currentPage == onboardingPages.count - 1 {
                            // Get Started Button
                            Button(action: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    hasSeenOnboarding = true
                                    showMainApp = true
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                    
                                    Text("Get Started")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 28)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    onboardingPages[currentPage].primaryColor,
                                                    onboardingPages[currentPage].secondaryColor
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(
                                            color: onboardingPages[currentPage].primaryColor.opacity(0.4),
                                            radius: 15,
                                            x: 0,
                                            y: 8
                                        )
                                )
                            }
                            .scaleEffect(isAnimating ? 1.02 : 1.0)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                            .onAppear {
                                isAnimating = true
                            }
                        } else {
                            // Next Button
                            Button(action: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    currentPage += 1
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Text("Next")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 28)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    onboardingPages[currentPage].primaryColor,
                                                    onboardingPages[currentPage].secondaryColor
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(
                                            color: onboardingPages[currentPage].primaryColor.opacity(0.3),
                                            radius: 12,
                                            x: 0,
                                            y: 6
                                        )
                                )
                            }
                        }
                        
                        // Already have account (for last page)
                        if currentPage == onboardingPages.count - 1 {
                            Button("Already have an account? Sign In") {
                                // Handle sign in
                                hasSeenOnboarding = true
                                showMainApp = true
                            }
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 50)
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            ContentView()
        }
    }
}

// MARK: - Supporting Views

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    @State private var animateIcon = false
    @State private var animateFeatures = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 40)
            
            // Animated Icon Section
            ZStack {
                // Background Circles
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                page.primaryColor.opacity(0.1),
                                page.secondaryColor.opacity(0.05),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 50,
                            endRadius: 150
                        )
                    )
                    .frame(width: 300, height: 300)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateIcon)
                
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                page.primaryColor.opacity(0.15),
                                page.secondaryColor.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(animateIcon ? 0.9 : 1.0)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: animateIcon)
                
                // Main Icon
                Image(systemName: page.imageName)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(page.primaryColor)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: isActive)
            }
            .frame(height: 320)
            
            Spacer(minLength: 20)
            
            // Content Section
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text(page.title)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .opacity(isActive ? 1.0 : 0.0)
                        .offset(y: isActive ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: isActive)
                    
                    Text(page.subtitle)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 16)
                        .opacity(isActive ? 1.0 : 0.0)
                        .offset(y: isActive ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: isActive)
                }
                
                // Features List
                VStack(spacing: 12) {
                    ForEach(Array(page.features.enumerated()), id: \.offset) { index, feature in
                        FeatureRow(
                            feature: feature,
                            color: page.primaryColor,
                            isVisible: animateFeatures,
                            delay: Double(index) * 0.1
                        )
                    }
                }
                .opacity(isActive ? 1.0 : 0.0)
                .offset(y: isActive ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(0.6), value: isActive)
            }
            .padding(.horizontal, 32)
            
            Spacer(minLength: 40)
        }
        .onAppear {
            if isActive {
                animateIcon = true
                withAnimation(.easeOut(duration: 0.8).delay(0.8)) {
                    animateFeatures = true
                }
            }
        }
        .onChange(of: isActive) { newValue in
            if newValue {
                animateIcon = true
                withAnimation(.easeOut(duration: 0.8).delay(0.8)) {
                    animateFeatures = true
                }
            }
        }
    }
}

struct FeatureRow: View {
    let feature: String
    let color: Color
    let isVisible: Bool
    let delay: Double
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
            }
            
            Text(feature)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .opacity(isVisible ? 1.0 : 0.0)
        .offset(x: isVisible ? 0 : -30)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay), value: isVisible)
    }
}

struct PageIndicator: View {
    let isActive: Bool
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(isActive ? color : Color(.systemGray4))
            .frame(width: isActive ? 24 : 8, height: 8)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isActive)
    }
}

// MARK: - Data Models

struct OnboardingPage {
    let id: Int
    let title: String
    let subtitle: String
    let imageName: String
    let primaryColor: Color
    let secondaryColor: Color
    let features: [String]
}

// MARK: - Welcome Screen Coordinator

struct WelcomeCoordinator: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                ContentView()
            } else {
                WelcomeView()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
