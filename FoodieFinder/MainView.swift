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
    @State private var isSearchFocused = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Header with Search and Quick Actions
                    VStack(spacing: 20) {
                        // Welcome Section
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Discover")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("Great restaurants near you")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Profile Button
                            Button(action: {}) {
                                Image(systemName: "person.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        // Enhanced Search Bar
                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 18, weight: .medium))
                                    
                                    TextField("Search restaurants, cuisine, or location", text: $viewModel.searchText)
                                        .font(.system(size: 16))
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                isSearchFocused = true
                                            }
                                        }
                                    
                                    if !viewModel.searchText.isEmpty {
                                        Button(action: { 
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                viewModel.searchText = ""
                                                isSearchFocused = false
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 16))
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemGray6))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(isSearchFocused ? Color.orange : Color.clear, lineWidth: 2)
                                        )
                                )
                                .shadow(color: .black.opacity(isSearchFocused ? 0.1 : 0.05), radius: isSearchFocused ? 8 : 4, x: 0, y: 2)
                                .scaleEffect(isSearchFocused ? 1.02 : 1.0)
                            }
                            
                            // Quick Action Pills
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    // Location Button
                                    QuickActionButton(
                                        icon: "location.fill",
                                        title: "Near Me",
                                        isPrimary: true,
                                        action: { viewModel.requestLocation() }
                                    )
                                    
                                    // Filter Button
                                    QuickActionButton(
                                        icon: "slider.horizontal.3",
                                        title: "Filters",
                                        badge: getActiveFiltersCount(),
                                        action: { showingFilters = true }
                                    )
                                    
                                    // Map Button
                                    QuickActionButton(
                                        icon: "map",
                                        title: "Map View",
                                        action: { showingMap = true }
                                    )
                                    
                                    // Sort Button
                                    Menu {
                                        ForEach(SortOption.allCases, id: \.self) { option in
                                            Button(action: { viewModel.sortOption = option }) {
                                                HStack {
                                                    Text(option.rawValue)
                                                    if viewModel.sortOption == option {
                                                        Image(systemName: "checkmark")
                                                    }
                                                }
                                            }
                                        }
                                    } label: {
                                        QuickActionButton(
                                            icon: "arrow.up.arrow.down",
                                            title: "Sort",
                                            subtitle: viewModel.sortOption.rawValue,
                                            action: {}
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Recent Searches with better design
                        if !viewModel.recentSearches.isEmpty && viewModel.searchText.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Recent Searches")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                    
                                    Button("Clear") {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            viewModel.clearRecentSearches()
                                        }
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                                }
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(viewModel.recentSearches.prefix(6), id: \.self) { search in
                                            Button(search) {
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    viewModel.searchText = search
                                                }
                                            }
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                Capsule()
                                                    .fill(Color.orange.opacity(0.1))
                                                    .overlay(
                                                        Capsule()
                                                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                                    )
                                            )
                                            .foregroundColor(.orange)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(.systemBackground),
                                Color(.systemBackground).opacity(0.95)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // Content Area
                    if viewModel.isLoading {
                        LoadingView()
                    } else if viewModel.filteredRestaurants.isEmpty {
                        EnhancedEmptyStateView()
                    } else {
                        // Results Header
                        HStack {
                            Text("\(viewModel.filteredRestaurants.count) restaurants found")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            if !viewModel.selectedCuisines.isEmpty || !viewModel.selectedPriceRanges.isEmpty {
                                Button("Clear Filters") {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        viewModel.selectedCuisines.removeAll()
                                        viewModel.selectedPriceRanges.removeAll()
                                        viewModel.isOpenOnly = false
                                        viewModel.deliveryOnly = false
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.orange)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // Restaurant List
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.filteredRestaurants) { restaurant in
                                    NavigationLink(destination: DetailView(restaurant: restaurant, viewModel: viewModel)) {
                                        EnhancedRestaurantRowView(restaurant: restaurant, viewModel: viewModel)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 100)
                        }
                        .refreshable {
                            await refreshRestaurants()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingFilters) {
                FilterView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showingMap) {
                MapView(viewModel: viewModel)
            }
            .onTapGesture {
                if isSearchFocused {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSearchFocused = false
                    }
                    hideKeyboard()
                }
            }
        }
    }
    
    private func getActiveFiltersCount() -> Int {
        var count = 0
        count += viewModel.selectedCuisines.count
        count += viewModel.selectedPriceRanges.count
        if viewModel.isOpenOnly { count += 1 }
        if viewModel.deliveryOnly { count += 1 }
        return count
    }
    
    private func refreshRestaurants() async {
        viewModel.loadRestaurants()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    var isPrimary: Bool = false
    var badge: Int? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                ZStack {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isPrimary ? .white : .primary)
                    
                    if let badge = badge, badge > 0 {
                        Text("\(badge)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 12, y: -12)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(isPrimary ? .white : .primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(isPrimary ? .white.opacity(0.8) : .secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isPrimary ? 
                        LinearGradient(gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .shadow(color: .black.opacity(isPrimary ? 0.2 : 0.1), radius: isPrimary ? 6 : 3, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .stroke(Color.orange.opacity(0.2), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [.orange, .orange.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            }
            
            VStack(spacing: 8) {
                Text("Finding great restaurants")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Please wait while we discover the best places for you")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            isAnimating = true
        }
    }
}

struct EnhancedEmptyStateView: View {
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.orange.opacity(0.1), Color.orange.opacity(0.05)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.orange)
            }
            
            VStack(spacing: 12) {
                Text("No restaurants found")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Try adjusting your search criteria or filters to discover more restaurants")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 12) {
                Text("Suggestions:")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 8) {
                    SuggestionRow(icon: "location", text: "Enable location services for nearby results")
                    SuggestionRow(icon: "slider.horizontal.3", text: "Remove some filters")
                    SuggestionRow(icon: "magnifyingglass", text: "Try different search terms")
                }
            }
            .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct SuggestionRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.orange)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

#Preview {
    MainView()
}
