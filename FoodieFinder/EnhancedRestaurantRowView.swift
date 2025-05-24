import SwiftUI

struct EnhancedRestaurantRowView: View {
    let restaurant: Restaurant
    @ObservedObject var viewModel: RestaurantViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main Content
            HStack(alignment: .top, spacing: 16) {
                // Restaurant Image
                AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.title2)
                        )
                }
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 8) {
                    // Header with name and favorite
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(restaurant.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .foregroundColor(.primary)
                            
                            Text(restaurant.cuisine)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                viewModel.toggleFavorite(restaurant: restaurant)
                            }
                        }) {
                            Image(systemName: viewModel.isFavorite(restaurant: restaurant) ? "heart.fill" : "heart")
                                .foregroundColor(viewModel.isFavorite(restaurant: restaurant) ? .red : .gray)
                                .font(.title2)
                                .scaleEffect(viewModel.isFavorite(restaurant: restaurant) ? 1.1 : 1.0)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Rating, price, and distance
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.subheadline)
                            Text(String(format: "%.1f", restaurant.rating))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("(\(restaurant.reviews.count))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(restaurant.priceRange)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(6)
                        
                        if let distance = viewModel.distanceToRestaurant(restaurant) {
                            HStack(spacing: 4) {
                                Image(systemName: "location.fill")
                                    .font(.caption)
                                Text(distance)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.orange)
                        }
                    }
                    
                    // Status indicators
                    HStack(spacing: 8) {
                        StatusBadge(
                            text: restaurant.isOpen ? "Open" : "Closed",
                            color: restaurant.isOpen ? .green : .red,
                            icon: restaurant.isOpen ? "checkmark.circle.fill" : "xmark.circle.fill"
                        )
                        
                        if restaurant.deliveryAvailable {
                            StatusBadge(text: "Delivery", color: .blue, icon: "bicycle")
                        }
                        
                        if restaurant.takeoutAvailable {
                            StatusBadge(text: "Takeout", color: .purple, icon: "bag")
                        }
                    }
                }
            }
            .padding(20)
            
            // Features tags
            if !restaurant.features.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(restaurant.features.prefix(4), id: \.self) { feature in
                            Text(feature)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.orange.opacity(0.15), Color.orange.opacity(0.05)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.orange)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.orange.opacity(0.2), lineWidth: 0.5)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

struct StatusBadge: View {
    let text: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.15))
        .foregroundColor(color)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color.opacity(0.3), lineWidth: 0.5)
        )
    }
}
