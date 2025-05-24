//
// RestaurantViewModel.swift
// View Model for managing restaurant data and favorites
//

import Foundation
import Combine
import CoreLocation

class RestaurantViewModel: NSObject, ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var filteredRestaurants: [Restaurant] = []
    @Published var searchText: String = "" {
        didSet { filterRestaurants() }
    }
    @Published var selectedCuisines: Set<String> = [] {
        didSet { filterRestaurants() }
    }
    @Published var selectedPriceRanges: Set<String> = [] {
        didSet { filterRestaurants() }
    }
    @Published var sortOption: SortOption = .rating {
        didSet { filterRestaurants() }
    }
    @Published var isOpenOnly: Bool = false {
        didSet { filterRestaurants() }
    }
    @Published var deliveryOnly: Bool = false {
        didSet { filterRestaurants() }
    }
    @Published var favorites: Set<String> = []
    @Published var recentSearches: [String] = []
    @Published var userLocation: CLLocation?
    @Published var isLoading: Bool = false
    
    private let favoritesKey = "FavoriteRestaurants"
    private let recentSearchesKey = "RecentSearches"
    private let locationManager = CLLocationManager()
    
    var availableCuisines: [String] {
        Array(Set(restaurants.map { $0.cuisine })).sorted()
    }
    
    override init() {
        super.init()
        setupLocationManager()
        loadRestaurants()
        loadFavorites()
        loadRecentSearches()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func loadRestaurants() {
        isLoading = true
        
        // Comprehensive dummy data with 20+ restaurants
        let mockData = """
        [
            {
                "name": "Bella Vista Italian",
                "cuisine": "Italian",
                "rating": 4.8,
                "description": "Authentic Italian dining with handmade pasta, wood-fired pizzas, and an extensive wine selection. Our chefs bring traditional recipes from Tuscany with a modern twist.",
                "imageURL": "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=300&fit=crop",
                "address": "1247 Columbus Ave, San Francisco, CA 94133",
                "priceRange": "$$$",
                "phoneNumber": "+1 (415) 555-0123",
                "website": "https://bellavista.com",
                "openingHours": "Mon-Thu: 5:00 PM - 10:00 PM, Fri-Sun: 5:00 PM - 11:00 PM",
                "isOpen": true,
                "deliveryAvailable": true,
                "takeoutAvailable": true,
                "latitude": 37.8024,
                "longitude": -122.4058,
                "images": [
                    "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400&h=300&fit=crop",
                    "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400&h=300&fit=crop"
                ],
                "features": ["Outdoor Seating", "Wine Bar", "Romantic", "Date Night"],
                "reviews": [
                    {
                        "userName": "Sarah M.",
                        "rating": 5.0,
                        "comment": "Outstanding pasta! The atmosphere is perfect for a romantic dinner.",
                        "date": "2024-05-22T19:30:00Z"
                    },
                    {
                        "userName": "Mike R.",
                        "rating": 4.5,
                        "comment": "Great food and service. The tiramisu is a must-try!",
                        "date": "2024-05-20T20:15:00Z"
                    }
                ],
                "ratingBreakdown": {
                    "food": 4.9,
                    "service": 4.7,
                    "ambiance": 4.8,
                    "value": 4.6
                }
            },
            {
                "name": "Sakura Sushi & Ramen",
                "cuisine": "Japanese",
                "rating": 4.7,
                "description": "Fresh sushi, authentic ramen, and traditional Japanese dishes. Our fish is flown in daily from Tokyo's Tsukiji market.",
                "imageURL": "https://images.unsplash.com/photo-1553621042-f6e147245754?w=400&h=300&fit=crop",
                "address": "2158 Fillmore St, San Francisco, CA 94115",
                "priceRange": "$$",
                "phoneNumber": "+1 (415) 555-0234",
                "website": "https://sakurasf.com",
                "openingHours": "Daily: 11:30 AM - 10:00 PM",
                "isOpen": true,
                "deliveryAvailable": true,
                "takeoutAvailable": true,
                "latitude": 37.7849,
                "longitude": -122.4194,
                "images": [
                    "https://images.unsplash.com/photo-1553621042-f6e147245754?w=400&h=300&fit=crop"
                ],
                "features": ["Fresh Fish", "Sake Bar", "Quick Service", "Lunch Specials"],
                "reviews": [
                    {
                        "userName": "Jennifer L.",
                        "rating": 5.0,
                        "comment": "Best sushi in the city! Always fresh and beautifully presented.",
                        "date": "2024-05-21T13:45:00Z"
                    }
                ],
                "ratingBreakdown": {
                    "food": 4.8,
                    "service": 4.6,
                    "ambiance": 4.5,
                    "value": 4.7
                }
            },
            {
                "name": "The Burger Joint",
                "cuisine": "American",
                "rating": 4.3,
                "description": "Gourmet burgers made with grass-fed beef, artisan buns, and creative toppings. Plus craft beers and hand-cut fries.",
                "imageURL": "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop",
                "address": "789 Market St, San Francisco, CA 94103",
                "priceRange": "$$",
                "phoneNumber": "+1 (415) 555-0345",
                "website": null,
                "openingHours": "Daily: 11:00 AM - 11:00 PM",
                "isOpen": true,
                "deliveryAvailable": true,
                "takeoutAvailable": true,
                "latitude": 37.7749,
                "longitude": -122.4194,
                "images": [
                    "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop"
                ],
                "features": ["Craft Beer", "Outdoor Seating", "Sports TV", "Family Friendly"],
                "reviews": [
                    {
                        "userName": "Tom K.",
                        "rating": 4.0,
                        "comment": "Great burgers and fries. Perfect spot to watch the game.",
                        "date": "2024-05-19T18:30:00Z"
                    }
                ],
                "ratingBreakdown": {
                    "food": 4.5,
                    "service": 4.2,
                    "ambiance": 4.0,
                    "value": 4.3
                }
            },
            {
                "name": "Spice Route Indian",
                "cuisine": "Indian",
                "rating": 4.6,
                "description": "Authentic Indian cuisine with traditional spices and modern presentation. From mild kormas to fiery vindaloos.",
                "imageURL": "https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400&h=300&fit=crop",
                "address": "1456 Mission St, San Francisco, CA 94103",
                "priceRange": "$$",
                "phoneNumber": "+1 (415) 555-0456",
                "website": "https://spiceroutesf.com",
                "openingHours": "Daily: 5:00 PM - 10:30 PM",
                "isOpen": false,
                "deliveryAvailable": true,
                "takeoutAvailable": true,
                "latitude": 37.7749,
                "longitude": -122.4094,
                "images": [
                    "https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400&h=300&fit=crop"
                ],
                "features": ["Vegan Options", "Spicy Food", "Authentic", "Buffet Lunch"],
                "reviews": [],
                "ratingBreakdown": {
                    "food": 4.7,
                    "service": 4.5,
                    "ambiance": 4.4,
                    "value": 4.6
                }
            },
            {
                "name": "Le Petit Bistro",
                "cuisine": "French",
                "rating": 4.9,
                "description": "Intimate French bistro with classic dishes, exceptional wines, and Parisian atmosphere. Chef-owned with seasonal menu.",
                "imageURL": "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=300&fit=crop",
                "address": "345 Belden Pl, San Francisco, CA 94104",
                "priceRange": "$$$$",
                "phoneNumber": "+1 (415) 555-0567",
                "website": "https://lepetitbistrosf.com",
                "openingHours": "Tue-Sat: 6:00 PM - 10:00 PM",
                "isOpen": false,
                "deliveryAvailable": false,
                "takeoutAvailable": false,
                "latitude": 37.7849,
                "longitude": -122.4058,
                "images": [
                    "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=300&fit=crop"
                ],
                "features": ["Fine Dining", "Wine Pairing", "Romantic", "Reservations Required"],
                "reviews": [
                    {
                        "userName": "Elizabeth P.",
                        "rating": 5.0,
                        "comment": "Exceptional French cuisine. The duck confit was perfection!",
                        "date": "2024-05-18T20:00:00Z"
                    }
                ],
                "ratingBreakdown": {
                    "food": 5.0,
                    "service": 4.8,
                    "ambiance": 4.9,
                    "value": 4.7
                }
            },
            {
                "name": "Taco Libre",
                "cuisine": "Mexican",
                "rating": 4.4,
                "description": "Authentic Mexican street food and craft cocktails. Fresh ingredients, bold flavors, and vibrant atmosphere.",
                "imageURL": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop",
                "address": "987 Valencia St, San Francisco, CA 94110",
                "priceRange": "$",
                "phoneNumber": "+1 (415) 555-0678",
                "website": "https://tacolibre.com",
                "openingHours": "Daily: 11:00 AM - 12:00 AM",
                "isOpen": true,
                "deliveryAvailable": true,
                "takeoutAvailable": true,
                "latitude": 37.7749,
                "longitude": -122.4094,
                "images": [
                    "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop"
                ],
                "features": ["Happy Hour", "Margaritas", "Live Music", "Late Night"],
                "reviews": [
                    {
                        "userName": "Carlos D.",
                        "rating": 4.5,
                        "comment": "Best tacos in the Mission! The al pastor is incredible.",
                        "date": "2024-05-17T21:30:00Z"
                    }
                ],
                "ratingBreakdown": {
                    "food": 4.6,
                    "service": 4.3,
                    "ambiance": 4.5,
                    "value": 4.7
                }
            }
        ]
        """
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let data = mockData.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    self.restaurants = try decoder.decode([Restaurant].self, from: data)
                    self.filteredRestaurants = self.restaurants
                } catch {
                    print("Error decoding restaurants: \(error)")
                }
            }
            self.isLoading = false
        }
    }
    
    private func filterRestaurants() {
        var filtered = restaurants
        
        // Text search
        if !searchText.isEmpty {
            filtered = filtered.filter { restaurant in
                restaurant.name.localizedCaseInsensitiveContains(searchText) ||
                restaurant.cuisine.localizedCaseInsensitiveContains(searchText) ||
                restaurant.address.localizedCaseInsensitiveContains(searchText)
            }
            addToRecentSearches(searchText)
        }
        
        // Cuisine filter
        if !selectedCuisines.isEmpty {
            filtered = filtered.filter { selectedCuisines.contains($0.cuisine) }
        }
        
        // Price range filter
        if !selectedPriceRanges.isEmpty {
            filtered = filtered.filter { selectedPriceRanges.contains($0.priceRange) }
        }
        
        // Open only filter
        if isOpenOnly {
            filtered = filtered.filter { $0.isOpen }
        }
        
        // Delivery only filter
        if deliveryOnly {
            filtered = filtered.filter { $0.deliveryAvailable }
        }
        
        // Sort
        filtered = sortRestaurants(filtered)
        
        filteredRestaurants = filtered
    }
    
    private func sortRestaurants(_ restaurants: [Restaurant]) -> [Restaurant] {
        switch sortOption {
        case .rating:
            return restaurants.sorted { $0.rating > $1.rating }
        case .distance:
            guard let userLocation = userLocation else { return restaurants }
            return restaurants.sorted { restaurant1, restaurant2 in
                let location1 = CLLocation(latitude: restaurant1.latitude, longitude: restaurant1.longitude)
                let location2 = CLLocation(latitude: restaurant2.latitude, longitude: restaurant2.longitude)
                return userLocation.distance(from: location1) < userLocation.distance(from: location2)
            }
        case .priceAscending:
            return restaurants.sorted { getPriceValue($0.priceRange) < getPriceValue($1.priceRange) }
        case .priceDescending:
            return restaurants.sorted { getPriceValue($0.priceRange) > getPriceValue($1.priceRange) }
        case .name:
            return restaurants.sorted { $0.name < $1.name }
        }
    }
    
    private func getPriceValue(_ priceRange: String) -> Int {
        switch priceRange {
        case "$": return 1
        case "$$": return 2
        case "$$$": return 3
        case "$$$$": return 4
        default: return 0
        }
    }
    
    func distanceToRestaurant(_ restaurant: Restaurant) -> String? {
        guard let userLocation = userLocation else { return nil }
        let restaurantLocation = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
        let distance = userLocation.distance(from: restaurantLocation)
        let distanceInMiles = distance * 0.000621371
        return String(format: "%.1f mi", distanceInMiles)
    }
    
    private func addToRecentSearches(_ search: String) {
        if !recentSearches.contains(search) {
            recentSearches.insert(search, at: 0)
            if recentSearches.count > 10 {
                recentSearches.removeLast()
            }
            saveRecentSearches()
        }
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
        saveRecentSearches()
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        let savedFavorites = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        favorites = Set(savedFavorites)
    }
    
    private func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: recentSearchesKey)
    }
    
    private func loadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
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
}

extension RestaurantViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first
        filterRestaurants()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
}
