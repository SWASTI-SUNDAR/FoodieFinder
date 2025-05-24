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
    @State private var selectedQuickFilter: QuickFilter? = nil
    @State private var searchAnimation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.2)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Premium Header Section
                        VStack(spacing: 20) {
                            // Top Bar with Greeting
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Good")
                                            .font(.title2)
                                            .fontWeight(.medium)
                                        + Text(" \(getGreeting())")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.orange)
                                    }
                                    
                                    Text("Find amazing restaurants near you")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .fontWeight(.medium)
                                }
                                
                                Spacer()
                                
                                // Profile & Notification Buttons
                                HStack(spacing: 10) {
                                    Button(action: {}) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.orange.opacity(0.1))
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: "bell")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.orange)
                                            
                                            // Notification badge
                                            Circle()
                                                .fill(Color.red)
                                                .frame(width: 8, height: 8)
                                                .offset(x: 7, y: -7)
                                        }
                                    }
                                    
                                    Button(action: {}) {
                                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face")) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            Image(systemName: "person.circle.fill")
                                                .font(.system(size: 40))
                                                .foregroundColor(.orange)
                                        }
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                                        )
                                    }
                                }
                            }
                            
                            // Premium Search Bar
                            VStack(spacing: 14) {
                                HStack(spacing: 0) {
                                    HStack(spacing: 14) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.orange.opacity(0.1))
                                                .frame(width: 32, height: 32)
                                            
                                            Image(systemName: "magnifyingglass")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.orange)
                                        }
                                        
                                        TextField("Search restaurants, cuisines...", text: $viewModel.searchText)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.primary)
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                                    isSearchFocused = true
                                                    searchAnimation.toggle()
                                                }
                                            }
                                        
                                        if !viewModel.searchText.isEmpty {
                                            Button(action: {
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    viewModel.searchText = ""
                                                    isSearchFocused = false
                                                }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(.systemBackground))
                                            .shadow(
                                                color: isSearchFocused ? Color.orange.opacity(0.2) : Color.black.opacity(0.04),
                                                radius: isSearchFocused ? 10 : 6,
                                                x: 0,
                                                y: isSearchFocused ? 4 : 2
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(
                                                        isSearchFocused ? Color.orange.opacity(0.3) : Color.clear,
                                                        lineWidth: 1.5
                                                    )
                                            )
                                    )
                                    .scaleEffect(isSearchFocused ? 1.01 : 1.0)
                                }
                            }
                            
                            // Quick Filter Pills
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(QuickFilter.allCases, id: \.self) { filter in
                                        EnhancedQuickFilterPill(
                                            filter: filter,
                                            isSelected: selectedQuickFilter == filter,
                                            count: getFilterCount(filter),
                                            action: {
                                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                                    if selectedQuickFilter == filter {
                                                        selectedQuickFilter = nil
                                                        clearFilter(filter)
                                                    } else {
                                                        selectedQuickFilter = filter
                                                        applyFilter(filter)
                                                    }
                                                }
                                            }
                                        )
                                    }
                                    
                                    // Advanced Filters Button
                                    Button(action: { showingFilters = true }) {
                                        HStack(spacing: 6) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.orange.opacity(0.1))
                                                    .frame(width: 24, height: 24)
                                                
                                                Image(systemName: "slider.horizontal.3")
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundColor(.orange)
                                                
                                                if getActiveFiltersCount() > 0 {
                                                    Circle()
                                                        .fill(Color.red)
                                                        .frame(width: 10, height: 10)
                                                        .overlay(
                                                            Text("\(getActiveFiltersCount())")
                                                                .font(.system(size: 7, weight: .bold))
                                                                .foregroundColor(.white)
                                                        )
                                                        .offset(x: 8, y: -8)
                                                }
                                            }
                                            
                                            Text("Filters")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.orange)
                                        }
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background(
                                            Capsule()
                                                .fill(Color.orange.opacity(0.05))
                                                .overlay(
                                                    Capsule()
                                                        .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                                                )
                                        )
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            
                            // Recent Searches (Enhanced)
                            if !viewModel.recentSearches.isEmpty && viewModel.searchText.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        HStack(spacing: 6) {
                                            Image(systemName: "clock.arrow.circlepath")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.orange)
                                            
                                            Text("Recent Searches")
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(.primary)
                                        }
                                        
                                        Spacer()
                                        
                                        Button("Clear All") {
                                            withAnimation(.easeInOut(duration: 0.4)) {
                                                viewModel.clearRecentSearches()
                                            }
                                        }
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.orange)
                                    }
                                    .padding(.horizontal, 16)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(viewModel.recentSearches.prefix(8), id: \.self) { search in
                                                Button(search) {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        viewModel.searchText = search
                                                    }
                                                }
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(.secondary)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(
                                                    Capsule()
                                                        .fill(Color(.systemGray6))
                                                        .overlay(
                                                            Capsule()
                                                                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                                        )
                                                )
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 20)
                        .background(
                            Color(.systemBackground)
                                .ignoresSafeArea(edges: .top)
                        )
                        
                        // Content Section
                        if viewModel.isLoading {
                            PremiumLoadingView()
                                .frame(height: 400)
                        } else if viewModel.filteredRestaurants.isEmpty {
                            PremiumEmptyStateView()
                                .frame(height: 400)
                        } else {
                            // Results Header
                            VStack(spacing: 16) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("\(viewModel.filteredRestaurants.count) restaurants")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundColor(.primary)
                                        
                                        Text("Based on your preferences")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    // Sort & Map Buttons
                                    HStack(spacing: 10) {
                                        Menu {
                                            ForEach(SortOption.allCases, id: \.self) { option in
                                                Button(action: { viewModel.sortOption = option }) {
                                                    HStack {
                                                        Text(option.rawValue)
                                                        if viewModel.sortOption == option {
                                                            Image(systemName: "checkmark")
                                                                .foregroundColor(.orange)
                                                        }
                                                    }
                                                }
                                            }
                                        } label: {
                                            HStack(spacing: 5) {
                                                Image(systemName: "arrow.up.arrow.down")
                                                    .font(.system(size: 12, weight: .medium))
                                                Text("Sort")
                                                    .font(.system(size: 13, weight: .medium))
                                            }
                                            .foregroundColor(.orange)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 7)
                                            .background(
                                                Capsule()
                                                    .fill(Color.orange.opacity(0.1))
                                            )
                                        }
                                        
                                        Button(action: { showingMap = true }) {
                                            Image(systemName: "map")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.white)
                                                .frame(width: 32, height: 32)
                                                .background(
                                                    Circle()
                                                        .fill(
                                                            LinearGradient(
                                                                gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                            )
                                                        )
                                                        .shadow(color: .orange.opacity(0.3), radius: 4, x: 0, y: 2)
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                
                                // Restaurant Cards
                                LazyVStack(spacing: 16) {
                                    ForEach(Array(viewModel.filteredRestaurants.enumerated()), id: \.element.id) { index, restaurant in
                                        NavigationLink(destination: DetailView(restaurant: restaurant, viewModel: viewModel)) {
                                            PremiumRestaurantCard(
                                                restaurant: restaurant,
                                                viewModel: viewModel,
                                                index: index
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 100)
                            }
                        }
                    }
                }
                .refreshable {
                    await refreshRestaurants()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingFilters) {
                PremiumFilterView(viewModel: viewModel)
                    .presentationDetents([.height(600), .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showingMap) {
                MapView(viewModel: viewModel)
            }
            .onTapGesture {
                if isSearchFocused {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSearchFocused = false
                    }
                    hideKeyboard()
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Morning"
        case 12..<17: return "Afternoon"
        case 17..<22: return "Evening"
        default: return "Night"
        }
    }
    
    private func getFilterCount(_ filter: QuickFilter) -> Int {
        switch filter {
        case .nearMe: return viewModel.userLocation != nil ? viewModel.filteredRestaurants.count : 0
        case .openNow: return viewModel.restaurants.filter { $0.isOpen }.count
        case .delivery: return viewModel.restaurants.filter { $0.deliveryAvailable }.count
        case .topRated: return viewModel.restaurants.filter { $0.rating >= 4.5 }.count
        }
    }
    
    private func applyFilter(_ filter: QuickFilter) {
        switch filter {
        case .nearMe:
            viewModel.requestLocation()
            viewModel.sortOption = .distance
        case .openNow:
            viewModel.isOpenOnly = true
        case .delivery:
            viewModel.deliveryOnly = true
        case .topRated:
            viewModel.sortOption = .rating
        }
    }
    
    private func clearFilter(_ filter: QuickFilter) {
        switch filter {
        case .nearMe:
            viewModel.sortOption = .rating
        case .openNow:
            viewModel.isOpenOnly = false
        case .delivery:
            viewModel.deliveryOnly = false
        case .topRated:
            viewModel.sortOption = .rating
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

// MARK: - Quick Filter Types
enum QuickFilter: String, CaseIterable {
    case nearMe = "Near Me"
    case openNow = "Open Now"
    case delivery = "Delivery"
    case topRated = "Top Rated"
    
    var icon: String {
        switch self {
        case .nearMe: return "location.fill"
        case .openNow: return "clock.fill"
        case .delivery: return "bicycle"
        case .topRated: return "star.fill"
        }
    }
}

// MARK: - Enhanced Quick Filter Component
struct EnhancedQuickFilterPill: View {
    let filter: QuickFilter
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.white : Color.orange.opacity(0.1))
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: filter.icon)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isSelected ? .orange : .orange.opacity(0.8))
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(filter.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    if count > 0 {
                        Text("\(count)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(
                        isSelected ?
                        LinearGradient(
                            gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: isSelected ? Color.orange.opacity(0.25) : Color.black.opacity(0.04),
                        radius: isSelected ? 6 : 3,
                        x: 0,
                        y: isSelected ? 3 : 1
                    )
            )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
    }
}

// MARK: - Premium Components
struct QuickFilterPill: View {
    let filter: QuickFilter
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.white : Color.orange.opacity(0.1))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: filter.icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isSelected ? .orange : .orange.opacity(0.8))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(filter.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    if count > 0 {
                        Text("\(count)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(
                        isSelected ?
                        LinearGradient(
                            gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: isSelected ? Color.orange.opacity(0.3) : Color.black.opacity(0.05),
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
    }
}

struct PremiumLoadingView: View {
    @State private var animationPhase = 0.0
    @State private var pulseAnimation = false
    
    var body: some View {
        VStack(spacing: 32) {
            ZStack {
                // Outer ring
                Circle()
                    .stroke(Color.orange.opacity(0.1), lineWidth: 6)
                    .frame(width: 80, height: 80)
                
                // Animated ring
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.orange, .orange.opacity(0.3), .orange]),
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(animationPhase))
                    .animation(
                        Animation.linear(duration: 2)
                            .repeatForever(autoreverses: false),
                        value: animationPhase
                    )
                
                // Center pulse
                Circle()
                    .fill(Color.orange.opacity(0.3))
                    .frame(width: 20, height: 20)
                    .scaleEffect(pulseAnimation ? 1.5 : 1.0)
                    .opacity(pulseAnimation ? 0.3 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: pulseAnimation
                    )
            }
            
            VStack(spacing: 12) {
                Text("Discovering amazing restaurants")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Finding the perfect places just for you...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animationPhase = 360
            pulseAnimation = true
        }
    }
}

struct PremiumEmptyStateView: View {
    var body: some View {
        VStack(spacing: 32) {
            // Animated Icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.orange.opacity(0.1),
                                Color.orange.opacity(0.05),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                
                Image(systemName: "fork.knife.circle")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.orange)
            }
            
            VStack(spacing: 16) {
                Text("No restaurants found")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("We couldn't find any restaurants matching your criteria. Try adjusting your filters or search terms.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 32)
            }
            
            VStack(spacing: 16) {
                Text("Suggestions:")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    SuggestionRow(
                        icon: "location.fill",
                        text: "Enable location for nearby results",
                        iconColor: .blue
                    )
                    SuggestionRow(
                        icon: "slider.horizontal.3",
                        text: "Clear or adjust your filters",
                        iconColor: .orange
                    )
                    SuggestionRow(
                        icon: "magnifyingglass",
                        text: "Try different search terms",
                        iconColor: .green
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct SuggestionRow: View {
    let icon: String
    let text: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    MainView()
}
