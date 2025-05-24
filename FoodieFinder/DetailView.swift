//
//  DetailView.swift
//  FoodieFinder
//
//  Created by Swasti Sundar Pradhan on 24/05/25.


//
// DetailView.swift
// Restaurant detail screen
//

import SwiftUI

struct DetailView: View {
    let restaurant: Restaurant
    @ObservedObject var viewModel: RestaurantViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                                .font(.title)
                        )
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Restaurant Name and Rating
                    HStack {
                        VStack(alignment: .leading) {
                            Text(restaurant.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(restaurant.cuisine)
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", restaurant.rating))
                                    .fontWeight(.semibold)
                            }
                            
                            Text(restaurant.priceRange)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                    }
                    
                    Divider()
                    
                    // Address
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.red)
                        Text(restaurant.address)
                            .font(.subheadline)
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(restaurant.description)
                            .font(.body)
                            .lineLimit(nil)
                    }
                    
                    // Add to Favorites Button
                    Button(action: {
                        viewModel.toggleFavorite(restaurant: restaurant)
                    }) {
                        HStack {
                            Image(systemName: viewModel.isFavorite(restaurant: restaurant) ? "heart.fill" : "heart")
                            Text(viewModel.isFavorite(restaurant: restaurant) ? "Remove from Favorites" : "Add to Favorites")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isFavorite(restaurant: restaurant) ? Color.red : Color.orange)
                        .cornerRadius(12)
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}
