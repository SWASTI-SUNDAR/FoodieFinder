import SwiftUI

struct PremiumRestaurantCard: View {
    let restaurant: Restaurant
    @ObservedObject var viewModel: RestaurantViewModel
    let index: Int
    
    @State private var imageLoaded = false
    @State private var cardAnimation = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Image Section with Overlay
            ZStack(alignment: .topTrailing) {
                // Restaurant Image
                AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                imageLoaded = true
                            }
                        }
                } placeholder: {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.gray.opacity(0.3),
                                    Color.gray.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(.gray)
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                    .scaleEffect(0.8)
                            }
                        )
                }
                .frame(height: 220)
                .clipped()
                
                // Gradient Overlay
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.clear,
                        Color.black.opacity(0.1),
                        Color.black.opacity(0.3)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 220)
                
                // Top Right Controls
                VStack(spacing: 12) {
                    // Favorite Button
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            viewModel.toggleFavorite(restaurant: restaurant)
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: viewModel.isFavorite(restaurant: restaurant) ? "heart.fill" : "heart")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(viewModel.isFavorite(restaurant: restaurant) ? .red : .white)
                                .scaleEffect(viewModel.isFavorite(restaurant: restaurant) ? 1.2 : 1.0)
                        }
                    }
                    
                    // Share Button
                    Button(action: {}) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(16)
                
                // Bottom Left Rating Badge
                VStack {
                    Spacer()
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.yellow)
                            
                            Text(String(format: "%.1f", restaurant.rating))
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("(\(restaurant.reviews.count))")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                                )
                        )
                        
                        Spacer()
                    }
                    .padding(16)
                }
            }
            
            // Content Section
            VStack(spacing: 16) {
                // Header Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(restaurant.name)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            
                            HStack(spacing: 8) {
                                Text(restaurant.cuisine)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.orange)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.orange.opacity(0.1))
                                    )
                                
                                Text(restaurant.priceRange)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.green.opacity(0.1))
                                    )
                                
                                if let distance = viewModel.distanceToRestaurant(restaurant) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "location.fill")
                                            .font(.system(size: 12, weight: .medium))
                                        Text(distance)
                                            .font(.system(size: 13, weight: .semibold))
                                    }
                                    .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    // Description
                    Text(restaurant.description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                // Enhanced Status & Services Row
                VStack(spacing: 12) {
                    // Status Row with better layout
                    HStack(spacing: 0) {
                        // Open/Closed Status - Most Important
                        HStack(spacing: 6) {
                            Circle()
                                .fill(restaurant.isOpen ? .green : .red)
                                .frame(width: 8, height: 8)
                            
                            Text(restaurant.isOpen ? "Open" : "Closed")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(restaurant.isOpen ? .green : .red)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill((restaurant.isOpen ? Color.green : Color.red).opacity(0.1))
                        )
                        
                        Spacer()
                        
                        // Services Icons Row - Compact
                        HStack(spacing: 16) {
                            if restaurant.deliveryAvailable {
                                VStack(spacing: 4) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.blue.opacity(0.1))
                                            .frame(width: 28, height: 28)
                                        
                                        Image(systemName: "bicycle")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Text("Delivery")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            if restaurant.takeoutAvailable {
                                VStack(spacing: 4) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.purple.opacity(0.1))
                                            .frame(width: 28, height: 28)
                                        
                                        Image(systemName: "bag")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.purple)
                                    }
                                    
                                    Text("Takeout")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(.purple)
                                }
                            }
                            
                            // Quick Action Button
                            Button(action: {}) {
                                VStack(spacing: 4) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.orange.opacity(0.1))
                                            .frame(width: 28, height: 28)
                                        
                                        Image(systemName: "phone.fill")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.orange)
                                    }
                                    
                                    Text("Call")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                    }
                    
                    // Features Tags - Horizontal Scrollable
                    if !restaurant.features.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Features")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("\(restaurant.features.count) features")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.orange)
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(restaurant.features.prefix(5), id: \.self) { feature in
                                        CompactFeatureTag(feature: feature)
                                    }
                                    
                                    if restaurant.features.count > 5 {
                                        Text("+\(restaurant.features.count - 5)")
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundColor(.orange)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 6)
                                            .background(
                                                Capsule()
                                                    .fill(Color.orange.opacity(0.1))
                                                    .overlay(
                                                        Capsule()
                                                            .stroke(Color.orange.opacity(0.3), lineWidth: 0.5)
                                                    )
                                            )
                                    }
                                }
                                .padding(.horizontal, 2)
                            }
                        }
                    }
                    
                    // Bottom Action Row
                    HStack {
                        // View Menu Button
                        Button(action: {}) {
                            HStack(spacing: 6) {
                                Image(systemName: "list.bullet")
                                    .font(.system(size: 12, weight: .semibold))
                                Text("View Menu")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(.orange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.orange.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 0.5)
                                    )
                            )
                        }
                        
                        Spacer()
                        
                        // Reserve Button
                        Button(action: {}) {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.system(size: 12, weight: .semibold))
                                Text("Reserve")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .orange.opacity(0.3), radius: 4, x: 0, y: 2)
                            )
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 12,
                    x: 0,
                    y: 6
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .scaleEffect(cardAnimation ? 1.0 : 0.95)
        .opacity(cardAnimation ? 1.0 : 0.0)
        .onAppear {
            withAnimation(
                .spring(response: 0.6, dampingFraction: 0.8)
                .delay(Double(index) * 0.1)
            ) {
                cardAnimation = true
            }
        }
    }
}

// MARK: - New Compact Components

struct CompactFeatureTag: View {
    let feature: String
    
    var body: some View {
        Text(feature)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color(.systemGray6))
                    .overlay(
                        Capsule()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                    )
            )
    }
}

struct StatusChip: View {
    let text: String
    let icon: String
    let color: Color
    var isProminent: Bool = false
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            
            Text(text)
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundColor(isProminent ? .white : color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(isProminent ? color : color.opacity(0.1))
                .overlay(
                    Capsule()
                        .stroke(color.opacity(isProminent ? 0 : 0.3), lineWidth: 0.5)
                )
        )
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
