import SwiftUI

struct ProfileView: View {
    @State private var user = User(
        name: "John Doe",
        email: "john.doe@example.com",
        profileImage: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&h=300&fit=crop&crop=face",
        joinDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
        favoriteRestaurants: 12,
        totalReviews: 24,
        points: 2450,
        level: "Foodie Expert"
    )
    
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    @State private var showingFavorites = false
    @State private var showingReviews = false
    @State private var showingAchievements = false
    @State private var selectedTab = 0
    @State private var animateStats = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.orange.opacity(0.1),
                        Color(.systemBackground)
                    ]),
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Hero Profile Section
                        VStack(spacing: 24) {
                            // Profile Image & Info
                            VStack(spacing: 20) {
                                ZStack {
                                    // Profile Image
                                    AsyncImage(url: URL(string: user.profileImage ?? "")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [.orange.opacity(0.8), .orange]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                            
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 50, weight: .medium))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.orange.opacity(0.6), .orange.opacity(0.2)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 4
                                            )
                                    )
                                    .shadow(color: .orange.opacity(0.3), radius: 20, x: 0, y: 8)
                                    
                                    // Edit Button
                                    Button(action: { showingEditProfile = true }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.orange)
                                                .frame(width: 36, height: 36)
                                                .shadow(color: .orange.opacity(0.4), radius: 6, x: 0, y: 3)
                                            
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .offset(x: 40, y: 40)
                                }
                                
                                VStack(spacing: 8) {
                                    Text(user.name)
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary)
                                    
                                    Text(user.email)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.secondary)
                                    
                                    // Level Badge
                                    HStack(spacing: 8) {
                                        Image(systemName: "star.circle.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.yellow)
                                        
                                        Text(user.level)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.orange)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(Color.orange.opacity(0.1))
                                            .overlay(
                                                Capsule()
                                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                            
                            // Enhanced Stats Section
                            VStack(spacing: 20) {
                                // Points Display
                                VStack(spacing: 8) {
                                    Text("Your Points")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.secondary)
                                    
                                    Text("\(user.points)")
                                        .font(.system(size: 36, weight: .bold, design: .rounded))
                                        .foregroundColor(.orange)
                                        .scaleEffect(animateStats ? 1.1 : 1.0)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateStats)
                                    
                                    Text("550 points to next level")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .padding(24)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.orange.opacity(0.05),
                                                    Color.orange.opacity(0.1)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                                        )
                                )
                                .shadow(color: .orange.opacity(0.1), radius: 10, x: 0, y: 5)
                                
                                // Quick Stats Row
                                HStack(spacing: 16) {
                                    ModernStatCard(
                                        title: "Favorites",
                                        value: "\(user.favoriteRestaurants)",
                                        icon: "heart.fill",
                                        color: .red,
                                        action: { showingFavorites = true }
                                    )
                                    
                                    ModernStatCard(
                                        title: "Reviews",
                                        value: "\(user.totalReviews)",
                                        icon: "star.fill",
                                        color: .yellow,
                                        action: { showingReviews = true }
                                    )
                                    
                                    ModernStatCard(
                                        title: "Achievements",
                                        value: "8",
                                        icon: "trophy.fill",
                                        color: .purple,
                                        action: { showingAchievements = true }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 32)
                        
                        // Content Sections
                        VStack(spacing: 20) {
                            // Quick Actions Section
                            ModernSectionCard(title: "Quick Actions", icon: "bolt.fill") {
                                VStack(spacing: 12) {
                                    QuickActionRow(
                                        icon: "bookmark.fill",
                                        title: "Saved Restaurants",
                                        subtitle: "View your saved places",
                                        color: .blue,
                                        action: { showingFavorites = true }
                                    )
                                    
                                    Divider()
                                        .padding(.horizontal, 16)
                                    
                                    QuickActionRow(
                                        icon: "clock.arrow.circlepath",
                                        title: "Recent Orders",
                                        subtitle: "See your order history",
                                        color: .green,
                                        action: {}
                                    )
                                    
                                    Divider()
                                        .padding(.horizontal, 16)
                                    
                                    QuickActionRow(
                                        icon: "gift.fill",
                                        title: "Rewards & Offers",
                                        subtitle: "Claim your rewards",
                                        color: .orange,
                                        action: {}
                                    )
                                }
                            }
                            
                            // Account Settings Section
                            ModernSectionCard(title: "Account", icon: "person.circle.fill") {
                                VStack(spacing: 12) {
                                    SettingsRow(
                                        icon: "pencil.circle.fill",
                                        title: "Edit Profile",
                                        subtitle: "Update your information",
                                        color: .blue,
                                        action: { showingEditProfile = true }
                                    )
                                    
                                    Divider()
                                        .padding(.horizontal, 16)
                                    
                                    SettingsRow(
                                        icon: "creditcard.fill",
                                        title: "Payment Methods",
                                        subtitle: "Manage your cards",
                                        color: .green,
                                        action: {}
                                    )
                                    
                                    Divider()
                                        .padding(.horizontal, 16)
                                    
                                    SettingsRow(
                                        icon: "bell.fill",
                                        title: "Notifications",
                                        subtitle: "Customize alerts",
                                        color: .orange,
                                        action: {}
                                    )
                                }
                            }
                            
                            // App Settings Section
                            ModernSectionCard(title: "App Settings", icon: "gear") {
                                VStack(spacing: 12) {
                                    SettingsRow(
                                        icon: "moon.fill",
                                        title: "Dark Mode",
                                        subtitle: "Appearance settings",
                                        color: .indigo,
                                        action: { showingSettings = true }
                                    )
                                    
                                    Divider()
                                        .padding(.horizontal, 16)
                                    
                                    SettingsRow(
                                        icon: "location.fill",
                                        title: "Location Services",
                                        subtitle: "Manage location access",
                                        color: .red,
                                        action: {}
                                    )
                                    
                                    Divider()
                                        .padding(.horizontal, 16)
                                    
                                    SettingsRow(
                                        icon: "shield.fill",
                                        title: "Privacy Settings",
                                        subtitle: "Control your data",
                                        color: .purple,
                                        action: {}
                                    )
                                }
                            }
                            
                            // Support Section
                            ModernSectionCard(title: "Support", icon: "questionmark.circle.fill") {
                                VStack(spacing: 12) {
                                    SettingsRow(
                                        icon: "message.fill",
                                        title: "Help Center",
                                        subtitle: "Get help and support",
                                        color: .blue,
                                        action: {}
                                    )
                                    
                                    Divider()
                                        .padding(.horizontal, 16)
                                    
                                    SettingsRow(
                                        icon: "star.bubble.fill",
                                        title: "Rate the App",
                                        subtitle: "Share your feedback",
                                        color: .yellow,
                                        action: {}
                                    )
                                    
                                    Divider()
                                        .padding(.horizontal, 16)
                                    
                                    SettingsRow(
                                        icon: "info.circle.fill",
                                        title: "About FoodieFinder",
                                        subtitle: "App version and info",
                                        color: .gray,
                                        action: {}
                                    )
                                }
                            }
                            
                            // Sign Out Section
                            Button(action: {}) {
                                HStack(spacing: 12) {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.red)
                                    
                                    Text("Sign Out")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.red)
                                    
                                    Spacer()
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.red.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.red.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8)) {
                    animateStats = true
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            EnhancedSettingsView()
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(user: $user)
        }
        .sheet(isPresented: $showingFavorites) {
            ProfileFavoritesView()
        }
        .sheet(isPresented: $showingReviews) {
            ProfileReviewsView()
        }
        .sheet(isPresented: $showingAchievements) {
            ProfileAchievementsView()
        }
    }
}

// MARK: - Enhanced User Model
struct User {
    let name: String
    let email: String
    let profileImage: String?
    let joinDate: Date
    let favoriteRestaurants: Int
    let totalReviews: Int
    let points: Int
    let level: String
}

// MARK: - Modern Components

struct ModernStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(value)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text(title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ModernSectionCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            // Section Header
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.orange)
                }
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            // Content
            content
                .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
        )
        .padding(.horizontal, 20)
    }
}

struct QuickActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Modal Views

struct EnhancedSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings page would go here")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EditProfileView: View {
    @Binding var user: User
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Edit profile functionality would go here")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct ProfileFavoritesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Favorites list would go here")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("My Favorites")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ProfileReviewsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Reviews list would go here")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("My Reviews")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ProfileAchievementsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Achievements would go here")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
