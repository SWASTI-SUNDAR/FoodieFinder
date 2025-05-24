//
//  MainView.swift
//  FoodieFinder
//
//  Created by Swasti Sundar Pradhan on 24/05/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = RestaurantViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search restaurants or cuisine", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Restaurant List
                List(viewModel.filteredRestaurants) { restaurant in
                    NavigationLink(destination: DetailView(restaurant: restaurant, viewModel: viewModel)) {
                        RestaurantRowView(restaurant: restaurant, viewModel: viewModel)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("FoodieFinder")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
