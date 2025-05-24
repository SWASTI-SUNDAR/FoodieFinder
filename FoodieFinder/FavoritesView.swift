//
//  FavoritesView.swift
//  FoodieFinder
//
//  Created by Swasti Sundar Pradhan on 24/05/25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = RestaurantViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.getFavoriteRestaurants().isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Favorites Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Start exploring restaurants and add them to your favorites!")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.getFavoriteRestaurants()) { restaurant in
                        NavigationLink(destination: DetailView(restaurant: restaurant, viewModel: viewModel)) {
                            RestaurantRowView(restaurant: restaurant, viewModel: viewModel)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
