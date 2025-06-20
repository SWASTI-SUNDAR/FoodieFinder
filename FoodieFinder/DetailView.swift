//
//  DetailView.swift
//  FoodieFinder
//
//  Created by Swasti Sundar Pradhan on 24/05/25.
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
                    VStack(spacing: 16) {
                        // Restaurant Info Card
                        VStack(spacing: 0) {
                            // Header Section
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(restaurant.name)
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    // Badges Row
                                    HStack(spacing: 8) {
                                        CuisineBadge(cuisine: restaurant.cuisine)
                                        PriceBadge(priceRange: restaurant.priceRange)
                                        
                                        if let distance = viewModel.distanceToRestaurant(restaurant) {
                                            DistanceBadge(distance: distance)
                                        }
                                    }
                                }
                                
                                // Status Row - Enhanced layout
                                VStack(spacing: 12) {
                                    HStack(spacing: 0) {
                                        // Primary Status - Open/Closed
                                        HStack(spacing: 8) {
                                            Circle()
                                                .fill(restaurant.isOpen ? .green : .red)
                                                .frame(width: 10, height: 10)
                                            
                                            Text(restaurant.isOpen ? "Open Now" : "Closed")
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundColor(restaurant.isOpen ? .green : .red)
                                            
                                            if restaurant.isOpen {
                                                Text("• Closes at 10 PM")
                                                    .font(.system(size: 13, weight: .medium))
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill((restaurant.isOpen ? Color.green : Color.red).opacity(0.1))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke((restaurant.isOpen ? Color.green : Color.red).opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                        
                                        Spacer()
                                    }
                                    
                                    // Services Row - Redesigned
                                    if restaurant.deliveryAvailable || restaurant.takeoutAvailable {
                                        HStack(spacing: 12) {
                                            Text("Available Services:")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.secondary)
                                            
                                            Spacer()
                                            
                                            HStack(spacing: 16) {
                                                if restaurant.deliveryAvailable {
                                                    ServiceIcon(
                                                        icon: "bicycle",
                                                        text: "Delivery",
                                                        color: .blue
                                                    )
                                                }
                                                
                                                if restaurant.takeoutAvailable {
                                                    ServiceIcon(
                                                        icon: "bag",
                                                        text: "Takeout",
                                                        color: .purple
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 16)
                            
                            Divider()
                                .padding(.horizontal, 20)
                            
                            // Description Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("About")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(restaurant.description)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .lineSpacing(4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            
                            // Features Section
                            if !restaurant.features.isEmpty {
                                Divider()
                                    .padding(.horizontal, 20)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Features")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                                        ForEach(restaurant.features, id: \.self) { feature in
                                            EnhancedFeatureItem(feature: feature)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                            }
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
                        
                        // Contact Info Card
                        EnhancedContactInfoCard(restaurant: restaurant)
                        
                        // Rating Breakdown Card
                        EnhancedRatingBreakdownCard(ratingBreakdown: restaurant.ratingBreakdown)
                        
                        // Reviews Section
                        if !restaurant.reviews.isEmpty {
                            EnhancedReviewsCard(reviews: restaurant.reviews)
                        }
                        
                        // Action Buttons
                        EnhancedActionButtonsCard(restaurant: restaurant) {
                            showReservationView = true
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, -20)
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

// MARK: - Enhanced Supporting Views

struct CuisineBadge: View {
    let cuisine: String
    
    var body: some View {
        Text(cuisine)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.orange)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.orange.opacity(0.12))
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
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.green)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.green.opacity(0.12))
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
                .font(.system(size: 10, weight: .medium))
            Text(distance)
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color(.systemGray6))
        )
    }
}

struct EnhancedStatusChip: View {
    let text: String
    let icon: String
    let color: Color
    var isProminent: Bool = false
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(isProminent ? .white : color)
            
            Text(text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isProminent ? .white : color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(isProminent ? color : color.opacity(0.12))
                .overlay(
                    Capsule()
                        .stroke(isProminent ? Color.clear : color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: isProminent ? color.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
    }
}

struct EnhancedFeatureItem: View {
    let feature: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.orange)
            
            Text(feature)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.orange.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange.opacity(0.15), lineWidth: 0.5)
                )
        )
    }
}

struct EnhancedContactInfoCard: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Contact Information")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.orange)
            }
            
            VStack(spacing: 16) {
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
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

struct ContactRow: View {
    let icon: String
    let title: String
    let content: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Text(content)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
}

struct EnhancedRatingBreakdownCard: View {
    let ratingBreakdown: RatingBreakdown
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Rating Breakdown")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.orange)
            }
            
            VStack(spacing: 14) {
                RatingRow(category: "Food", rating: ratingBreakdown.food)
                RatingRow(category: "Service", rating: ratingBreakdown.service)
                RatingRow(category: "Ambiance", rating: ratingBreakdown.ambiance)
                RatingRow(category: "Value", rating: ratingBreakdown.value)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

struct RatingRow: View {
    let category: String
    let rating: Double
    
    var body: some View {
        HStack(spacing: 14) {
            Text(category)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .frame(width: 70, alignment: .leading)
            
            // Rating bar
            HStack(spacing: 10) {
                RatingBar(rating: rating)
                
                Text(String(format: "%.1f", rating))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(width: 32, alignment: .trailing)
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
                    .frame(height: 6)
                    .cornerRadius(3)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.orange, .yellow]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * (rating / 5.0), height: 6)
                    .cornerRadius(3)
            }
        }
        .frame(height: 6)
    }
}

struct EnhancedReviewsCard: View {
    let reviews: [Review]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Recent Reviews")
                    .font(.system(size: 18, weight: .bold))
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
                    EnhancedReviewRow(review: review)
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

struct EnhancedReviewRow: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(review.userName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 3) {
                    ForEach(0..<5) { index in
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
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
                .lineLimit(3)
        }
        .padding(14)
        .background(Color(.systemGray6).opacity(0.6))
        .cornerRadius(10)
    }
}

struct EnhancedActionButtonsCard: View {
    let restaurant: Restaurant
    let onReservation: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Primary Action
            Button(action: onReservation) {
                HStack(spacing: 10) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Make a Reservation")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14)
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
            HStack(spacing: 10) {
                EnhancedActionButton(
                    icon: "phone.fill",
                    title: "Call",
                    color: .blue
                ) {
                    // Call restaurant
                }
                
                EnhancedActionButton(
                    icon: "map.fill",
                    title: "Directions",
                    color: .green
                ) {
                    // Open maps
                }
                
                EnhancedActionButton(
                    icon: "safari.fill",
                    title: "Website",
                    color: .purple
                ) {
                    // Open website
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

struct EnhancedActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
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

// Add new ServiceIcon component
struct ServiceIcon: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
            
            Text(text)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(color)
        }
    }
}
