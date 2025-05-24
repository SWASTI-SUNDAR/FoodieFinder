import SwiftUI

struct CategoriesView: View {
    @StateObject private var viewModel = RestaurantViewModel()
    
    let cuisineCategories = [
        CuisineCategory(name: "Italian", icon: "🍝", color: .red, count: 3),
        CuisineCategory(name: "Japanese", icon: "🍣", color: .pink, count: 2),
        CuisineCategory(name: "American", icon: "🍔", color: .blue, count: 4),
        CuisineCategory(name: "Mexican", icon: "🌮", color: .orange, count: 3),
        CuisineCategory(name: "French", icon: "🥐", color: .purple, count: 2),
        CuisineCategory(name: "Indian", icon: "🍛", color: .yellow, count: 2),
        CuisineCategory(name: "Chinese", icon: "🥡", color: .green, count: 3),
        CuisineCategory(name: "Thai", icon: "🍜", color: .teal, count: 2)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Explore Cuisines")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Discover restaurants by your favorite cuisine type")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Popular Categories Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        ForEach(cuisineCategories, id: \.name) { category in
                            NavigationLink(destination: CategoryRestaurantsView(category: category, viewModel: viewModel)) {
                                CategoryCard(category: category)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // Featured Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Featured This Week")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Button("See All") {
                                // Navigate to featured restaurants
                            }
                            .font(.subheadline)
                            .foregroundColor(.orange)
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.restaurants.prefix(5)) { restaurant in
                                    NavigationLink(destination: DetailView(restaurant: restaurant, viewModel: viewModel)) {
                                        FeaturedRestaurantCard(restaurant: restaurant, viewModel: viewModel)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CuisineCategory {
    let name: String
    let icon: String
    let color: Color
    let count: Int
}

struct CategoryCard: View {
    let category: CuisineCategory
    
    var body: some View {
        VStack(spacing: 12) {
            Text(category.icon)
                .font(.system(size: 40))
            
            VStack(spacing: 4) {
                Text(category.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("\(category.count) restaurants")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [category.color.opacity(0.1), category.color.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(category.color.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

struct FeaturedRestaurantCard: View {
    let restaurant: Restaurant
    @ObservedObject var viewModel: RestaurantViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 200, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(restaurant.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", restaurant.rating))
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(restaurant.priceRange)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 200)
    }
}
