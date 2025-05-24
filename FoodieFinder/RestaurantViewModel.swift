

//
// RestaurantViewModel.swift
// View Model for managing restaurant data and favorites
//

import Foundation
import Combine

class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var filteredRestaurants: [Restaurant] = []
    @Published var searchText: String = "" {
        didSet {
            filterRestaurants()
        }
    }
    @Published var favorites: Set<String> = []
    
    private let favoritesKey = "FavoriteRestaurants"
    
    init() {
        loadRestaurants()
        loadFavorites()
    }
    
    private func loadRestaurants() {
        // Mock restaurant data
        let mockData = """
        [
            {
                "name": "Pasta Paradise",
                "cuisine": "Italian",
                "rating": 4.5,
                "description": "Authentic Italian pasta made fresh daily with imported ingredients. Experience the taste of Italy in every bite with our traditional recipes passed down through generations.",
                "imageURL": "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=300&h=200&fit=crop",
                "address": "123 Little Italy St, New York, NY",
                "priceRange": "$$"
            },
            {
                "name": "Sushi Zen",
                "cuisine": "Japanese",
                "rating": 4.8,
                "description": "Premium sushi and sashimi prepared by master chefs. Fresh fish flown in daily from Japan. An authentic Japanese dining experience.",
                "imageURL": "https://images.unsplash.com/photo-1553621042-f6e147245754?w=300&h=200&fit=crop",
                "address": "456 Sakura Ave, Los Angeles, CA",
                "priceRange": "$$$"
            },
            {
                "name": "Burger Haven",
                "cuisine": "American",
                "rating": 4.2,
                "description": "Gourmet burgers made with locally sourced beef and fresh ingredients. The perfect spot for a casual meal with friends and family.",
                "imageURL": "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=200&fit=crop",
                "address": "789 Main Street, Chicago, IL",
                "priceRange": "$"
            },
            {
                "name": "Spice Garden",
                "cuisine": "Indian",
                "rating": 4.6,
                "description": "Aromatic Indian cuisine with traditional spices and flavors. From mild to extra spicy, we cater to all palates with our extensive menu.",
                "imageURL": "https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300&h=200&fit=crop",
                "address": "321 Curry Lane, Houston, TX",
                "priceRange": "$$"
            },
            {
                "name": "Taco Fiesta",
                "cuisine": "Mexican",
                "rating": 4.3,
                "description": "Authentic Mexican street food and traditional dishes. Fresh ingredients, bold flavors, and a vibrant atmosphere make every meal a celebration.",
                "imageURL": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=200&fit=crop",
                "address": "654 Fiesta Blvd, San Antonio, TX",
                "priceRange": "$"
            },
            {
                "name": "Mediterranean Breeze",
                "cuisine": "Mediterranean",
                "rating": 4.7,
                "description": "Fresh Mediterranean cuisine featuring grilled meats, fresh vegetables, and authentic Mediterranean flavors. Healthy and delicious dining.",
                "imageURL": "https://images.unsplash.com/photo-1544510808-5617291605d3?w=300&h=200&fit=crop",
                "address": "987 Olive Street, Miami, FL",
                "priceRange": "$$"
            },
            {
                "name": "Dragon Palace",
                "cuisine": "Chinese",
                "rating": 4.4,
                "description": "Traditional Chinese cuisine with a modern twist. From dim sum to Peking duck, experience the rich flavors of Chinese culinary tradition.",
                "imageURL": "https://images.unsplash.com/photo-1563379091339-03246963d51a?w=300&h=200&fit=crop",
                "address": "147 Dragon Way, San Francisco, CA",
                "priceRange": "$$"
            },
            {
                "name": "French Bistro",
                "cuisine": "French",
                "rating": 4.9,
                "description": "Elegant French dining with classic dishes and exceptional wine pairings. Experience the sophistication of French cuisine in an intimate setting.",
                "imageURL": "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=300&h=200&fit=crop",
                "address": "258 Paris Lane, Seattle, WA",
                "priceRange": "$$$"
            }
        ]
        """
        
        if let data = mockData.data(using: .utf8) {
            do {
                self.restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                self.filteredRestaurants = self.restaurants
            } catch {
                print("Error decoding restaurants: \(error)")
            }
        }
    }
    
    private func filterRestaurants() {
        if searchText.isEmpty {
            filteredRestaurants = restaurants
        } else {
            filteredRestaurants = restaurants.filter { restaurant in
                restaurant.name.localizedCaseInsensitiveContains(searchText) ||
                restaurant.cuisine.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func toggleFavorite(restaurant: Restaurant) {
        if favorites.contains(restaurant.name) {
            favorites.remove(restaurant.name)
        } else {
            favorites.insert(restaurant.name)
        }
        saveFavorites()
    }
    
    func isFavorite(restaurant: Restaurant) -> Bool {
        return favorites.contains(restaurant.name)
    }
    
    func getFavoriteRestaurants() -> [Restaurant] {
        return restaurants.filter { favorites.contains($0.name) }
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        let savedFavorites = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        favorites = Set(savedFavorites)
    }
}
