//
//  Restaurant.swift
//  FoodieFinder
//
//  Created by Swasti Sundar Pradhan on 24/05/25.
//

import Foundation
import CoreLocation

struct Restaurant: Identifiable, Codable {
    let id = UUID()
    let name: String
    let cuisine: String
    let rating: Double
    let description: String
    let imageURL: String
    let address: String
    let priceRange: String
    
    // New properties
    let phoneNumber: String
    let website: String?
    let openingHours: String
    let isOpen: Bool
    let deliveryAvailable: Bool
    let takeoutAvailable: Bool
    let latitude: Double
    let longitude: Double
    let images: [String]
    let features: [String] // e.g., ["Outdoor Seating", "WiFi", "Parking"]
    let reviews: [Review]
    let ratingBreakdown: RatingBreakdown
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, cuisine, rating, description, imageURL, address, priceRange
        case phoneNumber, website, openingHours, isOpen, deliveryAvailable, takeoutAvailable
        case latitude, longitude, images, features, reviews, ratingBreakdown
    }
}

struct Review: Identifiable, Codable {
    let id = UUID()
    let userName: String
    let rating: Double
    let comment: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case userName, rating, comment, date
    }
}

struct RatingBreakdown: Codable {
    let food: Double
    let service: Double
    let ambiance: Double
    let value: Double
}

enum PriceRange: String, CaseIterable {
    case budget = "$"
    case moderate = "$$"
    case expensive = "$$$"
    case luxury = "$$$$"
}

enum SortOption: String, CaseIterable {
    case rating = "Rating"
    case distance = "Distance"
    case priceAscending = "Price (Low to High)"
    case priceDescending = "Price (High to Low)"
    case name = "Name"
}
