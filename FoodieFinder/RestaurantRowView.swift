//
// RestaurantRowView.swift
// Individual restaurant row in the list
//

import SwiftUI

struct RestaurantRowView: View {
    let restaurant: Restaurant
    @ObservedObject var viewModel: RestaurantViewModel
    
    var body: some View {
        HStack {
            // Restaurant Image
            AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 80, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(restaurant.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleFavorite(restaurant: restaurant)
                    }) {
                        Image(systemName: viewModel.isFavorite(restaurant: restaurant) ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isFavorite(restaurant: restaurant) ? .red : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text(restaurant.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Text(restaurant.priceRange)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 4)
    }
}
