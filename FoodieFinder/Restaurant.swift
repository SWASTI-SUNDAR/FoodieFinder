//
//  Restaurant.swift
//  FoodieFinder
//
//  Created by Swasti Sundar Pradhan on 24/05/25.
//

import Foundation

struct Restaurant: Identifiable, Codable {
    let id = UUID()
    let name: String
    let cuisine: String
    let rating: Double
    let description: String
    let imageURL: String
    let address: String
    let priceRange: String
    
    enum CodingKeys: String, CodingKey {
        case name, cuisine, rating, description, imageURL, address, priceRange
    }
}
