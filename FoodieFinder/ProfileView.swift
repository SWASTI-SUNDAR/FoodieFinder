import SwiftUI

struct ProfileView: View {
    @State private var user = User(
        name: "John Doe",
        email: "john.doe@example.com",
        joinDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
        favoriteRestaurants: 12,
        totalReviews: 24
    )
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.orange)
                        
                        VStack(spacing: 4) {
                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Stats Section
                    HStack(spacing: 16) {
                        StatCard(title: "Favorites", value: "\(user.favoriteRestaurants)", icon: "heart.fill", color: .red)
                        StatCard(title: "Reviews", value: "\(user.totalReviews)", icon: "star.fill", color: .yellow)
                        StatCard(title: "Member Since", value: user.joinDate.formatted(.dateTime.year()), icon: "calendar", color: .blue)
                    }
                    
                    // Menu Options
                    VStack(spacing: 0) {
                        MenuRow(icon: "heart", title: "My Favorites", action: {})
                        Divider().padding(.leading, 50)
                        MenuRow(icon: "star", title: "My Reviews", action: {})
                        Divider().padding(.leading, 50)
                        MenuRow(icon: "clock", title: "Recent Orders", action: {})
                        Divider().padding(.leading, 50)
                        MenuRow(icon: "creditcard", title: "Payment Methods", action: {})
                        Divider().padding(.leading, 50)
                        MenuRow(icon: "bell", title: "Notifications", action: {})
                        Divider().padding(.leading, 50)
                        MenuRow(icon: "questionmark.circle", title: "Help & Support", action: {})
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    
                    // Settings Section
                    VStack(spacing: 0) {
                        MenuRow(icon: "gear", title: "Settings", action: { showingSettings = true })
                        Divider().padding(.leading, 50)
                        MenuRow(icon: "info.circle", title: "About", action: {})
                        Divider().padding(.leading, 50)
                        MenuRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign Out", action: {}, isDestructive: true)
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

struct User {
    let name: String
    let email: String
    let joinDate: Date
    let favoriteRestaurants: Int
    let totalReviews: Int
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct MenuRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    var isDestructive: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isDestructive ? .red : .orange)
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(isDestructive ? .red : .primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
