import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: RestaurantViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var selectedRestaurant: Restaurant?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $region, annotationItems: viewModel.filteredRestaurants) { restaurant in
                    MapAnnotation(coordinate: restaurant.coordinate) {
                        Button(action: {
                            selectedRestaurant = restaurant
                        }) {
                            VStack {
                                Image(systemName: "fork.knife.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .background(Color.orange)
                                    .clipShape(Circle())
                                
                                Text(restaurant.priceRange)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(Color.orange)
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                .onAppear {
                    if let userLocation = viewModel.userLocation {
                        region.center = userLocation.coordinate
                    } else if let firstRestaurant = viewModel.filteredRestaurants.first {
                        region.center = firstRestaurant.coordinate
                    }
                }
                
                // Restaurant card overlay
                if let selectedRestaurant = selectedRestaurant {
                    VStack {
                        Spacer()
                        RestaurantMapCard(restaurant: selectedRestaurant, viewModel: viewModel) {
                            self.selectedRestaurant = nil
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Restaurant Map")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if let userLocation = viewModel.userLocation {
                            region.center = userLocation.coordinate
                        }
                    }) {
                        Image(systemName: "location.circle")
                    }
                }
            }
        }
    }
}

struct RestaurantMapCard: View {
    let restaurant: Restaurant
    @ObservedObject var viewModel: RestaurantViewModel
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle().fill(Color.gray.opacity(0.3))
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.headline)
                Text(restaurant.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", restaurant.rating))
                        .font(.caption)
                    Text(restaurant.priceRange)
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
