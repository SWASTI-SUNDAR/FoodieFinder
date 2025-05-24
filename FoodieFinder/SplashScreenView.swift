import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    @State private var showWelcome = false
    
    var body: some View {
        ZStack {
            // Animated Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.orange.opacity(0.8),
                    Color.orange.opacity(0.6),
                    Color.red.opacity(0.4),
                    Color.orange.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating Particles
            ParticleEffectView()
            
            VStack(spacing: 32) {
                Spacer()
                
                // App Logo/Icon
                VStack(spacing: 20) {
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 50,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 200, height: 200)
                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                        
                        // Main logo circle
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                            .scaleEffect(logoScale)
                            .opacity(logoOpacity)
                        
                        // Food icon
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.system(size: 60, weight: .medium))
                            .foregroundColor(.orange)
                            .scaleEffect(logoScale)
                            .opacity(logoOpacity)
                    }
                    
                    // App Name
                    VStack(spacing: 8) {
                        Text("FoodieFinder")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(textOpacity)
                        
                        Text("Discover Your Next Great Meal")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .opacity(textOpacity)
                    }
                }
                
                Spacer()
                
                // Loading Indicator
                VStack(spacing: 16) {
                    LoadingDotsView()
                    
                    Text("Preparing your dining experience...")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(textOpacity)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startAnimations()
        }
        .fullScreenCover(isPresented: $showWelcome) {
            WelcomeCoordinator()
        }
    }
    
    private func startAnimations() {
        // Logo animation
        withAnimation(.spring(response: 1.0, dampingFraction: 0.6)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Text animation
        withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
            textOpacity = 1.0
        }
        
        // Start particle animation
        withAnimation(.easeInOut(duration: 1.0).delay(0.3)) {
            isAnimating = true
        }
        
        // Navigate to welcome screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showWelcome = true
            }
        }
    }
}

// MARK: - Supporting Views

struct ParticleEffectView: View {
    @State private var particles: [Particle] = []
    @State private var animateParticles = false
    
    var body: some View {
        ZStack {
            ForEach(particles.indices, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: particles[index].size, height: particles[index].size)
                    .position(particles[index].position)
                    .opacity(animateParticles ? 0.0 : 1.0)
                    .animation(
                        .linear(duration: particles[index].duration)
                        .repeatForever(autoreverses: false),
                        value: animateParticles
                    )
            }
        }
        .onAppear {
            generateParticles()
            animateParticles = true
        }
    }
    
    private func generateParticles() {
        particles = (0..<20).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 2...6),
                duration: Double.random(in: 3...8)
            )
        }
    }
}

struct LoadingDotsView: View {
    @State private var animationPhase = 0
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animationPhase == index ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: animationPhase
                    )
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
                animationPhase = (animationPhase + 1) % 3
            }
        }
    }
}

struct Particle {
    let position: CGPoint
    let size: CGFloat
    let duration: Double
}

#Preview {
    SplashScreenView()
}
