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
    @State private var showImageGallery = false
    @State private var selectedImageIndex = 0
    @State private var showReservationView = false
    @State private var showShareSheet = false
    @State private var animateContent = false
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero Image Section
                    ZStack(alignment: .topTrailing) {
                        // Image Carousel
                        TabView(selection: $selectedImageIndex) {
                            ForEach(Array(restaurant.images.enumerated()), id: \.offset) { index, imageURL in
                                AsyncImage(url: URL(string: imageURL)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.gray.opacity(0.3),
                                                    Color.gray.opacity(0.1)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                                        )
                                }
                                .tag(index)
                            }
                        }
                        .frame(height: 350)
                        .tabViewStyle(PageTabViewStyle())
                        .onTapGesture {
                            showImageGallery = true
                        }
                        
                        // Gradient overlay
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.6),
                                Color.clear,
                                Color.clear,
                                Color.black.opacity(0.3)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 350)
                        
                        // Top Controls
                        HStack {
                            Button(action: { dismiss() }) {
                                ZStack {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 12) {
                                Button(action: { showShareSheet = true }) {
                                    ZStack {
                                        Circle()
                                            .fill(.ultraThinMaterial)
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                        viewModel.toggleFavorite(restaurant: restaurant)
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(.ultraThinMaterial)
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: viewModel.isFavorite(restaurant: restaurant) ? "heart.fill" : "heart")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(viewModel.isFavorite(restaurant: restaurant) ? .red : .white)
                                            .scaleEffect(viewModel.isFavorite(restaurant: restaurant) ? 1.2 : 1.0)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Rating Badge (Bottom Left)
                        VStack {
                            Spacer()
                            HStack {
                                HStack(spacing: 8) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.yellow)
                                    
                                    Text(String(format: "%.1f", restaurant.rating))
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("(\(restaurant.reviews.count) reviews)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule()
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }
                    
                    // Content Section
                    VStack(spacing: 24) {
                        // Restaurant Info Card
                        VStack(spacing: 20) {
                            // Header
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(restaurant.name)
                                            .font(.system(size: 28, weight: .bold))
                                            .foregroundColor(.primary)
                                        
                                        HStack(spacing: 12) {
                                            CuisineBadge(cuisine: restaurant.cuisine)
                                            PriceBadge(priceRange: restaurant.priceRange)
                                            
                                            if let distance = viewModel.distanceToRestaurant(restaurant) {
                                                DistanceBadge(distance: distance)
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                
                                // Status Row
                                HStack(spacing: 12) {
                                    StatusChip(
                                        text: restaurant.isOpen ? "Open Now" : "Closed",
                                        icon: restaurant.isOpen ? "checkmark.circle.fill" : "xmark.circle.fill",
                                        color: restaurant.isOpen ? .green : .red,
                                        isProminent: true
                                    )
                                    
                                    if restaurant.deliveryAvailable {
                                        StatusChip(text: "Delivery", icon: "bicycle", color: .blue)
                                    }
                                    
                                    if restaurant.takeoutAvailable {
                                        StatusChip(text: "Takeout", icon: "bag", color: .purple)
                                    }
                                }
                            }
                            
                            Divider()
                                .background(Color.gray.opacity(0.3))
                            
                            // Description
                            VStack(alignment: .leading, spacing: 12) {
                                Text("About")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Text(restaurant.description)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .lineSpacing(4)
                            }
                            
                            // Features
                            if !restaurant.features.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Features")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                        ForEach(restaurant.features, id: \.self) { feature in
                                            FeatureItem(feature: feature)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(24)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        
                        // Contact Info Card
                        ContactInfoCard(restaurant: restaurant)
                        
                        // Rating Breakdown Card
                        RatingBreakdownCard(ratingBreakdown: restaurant.ratingBreakdown)
                        
                        // Reviews Section
                        if !restaurant.reviews.isEmpty {
                            ReviewsCard(reviews: restaurant.reviews)
                        }
                        
                        // Action Buttons
                        ActionButtonsCard(restaurant: restaurant) {
                            showReservationView = true
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, -30)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
        .opacity(animateContent ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                animateContent = true
            }
        }
        .sheet(isPresented: $showImageGallery) {
            ImageGalleryView(images: restaurant.images, selectedIndex: selectedImageIndex)
        }
        .sheet(isPresented: $showReservationView) {
            ReservationView(restaurant: restaurant)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [restaurant.name, restaurant.address])
        }
    }
}

// MARK: - Supporting Views

struct CuisineBadge: View {
    let cuisine: String
    
    var body: some View {
        Text(cuisine)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.orange)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.orange.opacity(0.1))
                    .overlay(
                        Capsule()
                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

struct PriceBadge: View {
    let priceRange: String
    
    var body: some View {
        Text(priceRange)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.green)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.green.opacity(0.1))
                    .overlay(
                        Capsule()
                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

struct DistanceBadge: View {
    let distance: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "location.fill")
                .font(.system(size: 12, weight: .medium))
            Text(distance)
                .font(.system(size: 14, weight: .semibold))
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color(.systemGray6))
        )
    }
}

struct FeatureItem: View {
    let feature: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.orange)
            
            Text(feature)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.orange.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange.opacity(0.2), lineWidth: 0.5)
                )
        )
    }
}

struct ContactInfoCard: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Contact Information")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                ContactRow(
                    icon: "location.fill",
                    title: "Address",
                    content: restaurant.address,
                    iconColor: .red
                )
                
                ContactRow(
                    icon: "phone.fill",
                    title: "Phone",
                    content: restaurant.phoneNumber,
                    iconColor: .blue
                )
                
                if let website = restaurant.website {
                    ContactRow(
                        icon: "globe",
                        title: "Website",
                        content: website,
                        iconColor: .orange
                    )
                }
                
                ContactRow(
                    icon: "clock.fill",
                    title: "Hours",
                    content: restaurant.openingHours,
                    iconColor: .green
                )
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ContactRow: View {
    let icon: String
    let title: String
    let content: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Text(content)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}

struct RatingBreakdownCard: View {
    let ratingBreakdown: RatingBreakdown
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Rating Breakdown")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                RatingRow(category: "Food", rating: ratingBreakdown.food)
                RatingRow(category: "Service", rating: ratingBreakdown.service)
                RatingRow(category: "Ambiance", rating: ratingBreakdown.ambiance)
                RatingRow(category: "Value", rating: ratingBreakdown.value)
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct RatingRow: View {
    let category: String
    let rating: Double
    
    var body: some View {
        HStack(spacing: 16) {
            Text(category)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .frame(width: 80, alignment: .leading)
            
            // Rating bar
            HStack(spacing: 8) {
                RatingBar(rating: rating)
                
                Text(String(format: "%.1f", rating))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(width: 30, alignment: .trailing)
            }
        }
    }
}

struct RatingBar: View {
    let rating: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.orange, .yellow]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * (rating / 5.0), height: 8)
                    .cornerRadius(4)
            }
        }
        .frame(height: 8)
    }
}

struct ReviewsCard: View {
    let reviews: [Review]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent Reviews")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("See All") {
                    // Navigate to all reviews
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.orange)
            }
            
            VStack(spacing: 12) {
                ForEach(reviews.prefix(2)) { review in
                    ReviewRow(review: review)
                }
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ReviewRow: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.userName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Double(index) < review.rating ? .yellow : .gray.opacity(0.3))
                    }
                }
                
                Text(review.date.formatted(.dateTime.month().day()))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Text(review.comment)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ActionButtonsCard: View {
    let restaurant: Restaurant
    let onReservation: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Primary Action
            Button(action: onReservation) {
                HStack(spacing: 12) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Make a Reservation")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
                )
            }
            
            // Secondary Actions
            HStack(spacing: 12) {
                ActionButton(
                    icon: "phone.fill",
                    title: "Call",
                    color: .blue
                ) {
                    // Call restaurant
                }
                
                ActionButton(
                    icon: "map.fill",
                    title: "Directions",
                    color: .green
                ) {
                    // Open maps
                }
                
                ActionButton(
                    icon: "safari.fill",
                    title: "Website",
                    color: .purple
                ) {
                    // Open website
                }
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Supporting Components

struct ImageGalleryView: View {
    let images: [String]
    let selectedIndex: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            TabView(selection: .constant(selectedIndex)) {
                ForEach(Array(images.enumerated()), id: \.offset) { index, imageURL in
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
            VStack {
                HStack {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .padding()
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}

struct ReservationView: View {
    let restaurant: Restaurant
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Reservation form would go here")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Reserve Table")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
