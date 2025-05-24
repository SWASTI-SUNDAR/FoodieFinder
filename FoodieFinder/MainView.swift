//
//  MainView.swift
//  FoodieFinder
//
//  Created by Swasti Sundar Pradhan on 24/05/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = RestaurantViewModel()
    @State private var showingFilters = false
    @State private var showingMap = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Enhanced Search Header
                VStack(spacing: 12) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search restaurants, cuisine, or location", text: $viewModel.searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: { viewModel.searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Quick Action Buttons
                    HStack(spacing: 12) {
                        Button(action: { showingFilters = true }) {
                            HStack(spacing: 4) {
                                Image(systemName: "slider.horizontal.3")
                                Text("Filters")
                            }
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        Button(action: { showingMap = true }) {
                            HStack(spacing: 4) {
                                Image(systemName: "map")
                                Text("Map")
                            }
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        Button(action: { viewModel.requestLocation() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "location.circle")
                                Text("Near Me")
                            }
                            .font(.subheadline)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        Menu {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Button(option.rawValue) {
                                    viewModel.sortOption = option
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.arrow.down")
                                Text("Sort")
                            }
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    
                    // Recent Searches
                    if !viewModel.recentSearches.isEmpty && viewModel.searchText.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                Text("Recent:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                ForEach(viewModel.recentSearches.prefix(5), id: \.self) { search in
                                    Button(search) {
                                        viewModel.searchText = search
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.orange.opacity(0.1))
                                    .foregroundColor(.orange)
                                    .cornerRadius(6)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                .background(Color(.systemBackground))
                
                // Content
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Finding restaurants...")
                        Spacer()
                    }
                } else if viewModel.filteredRestaurants.isEmpty {
                    EmptyStateView()
                } else {
                    // Restaurant List
                    List(viewModel.filteredRestaurants) { restaurant in
                        NavigationLink(destination: DetailView(restaurant: restaurant, viewModel: viewModel)) {
                            EnhancedRestaurantRowView(restaurant: restaurant, viewModel: viewModel)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        viewModel.loadRestaurants()
                    }
                }
            }
            .navigationTitle("FoodieFinder")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingFilters) {
                FilterView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingMap) {
                MapView(viewModel: viewModel)
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No restaurants found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Try adjusting your search or filters")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
