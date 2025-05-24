import SwiftUI

struct CategoryRestaurantsView: View {
    let category: CuisineCategory
    @ObservedObject var viewModel: RestaurantViewModel
    
    var filteredRestaurants: [Restaurant] {
        viewModel.restaurants.filter { $0.cuisine == category.name }
    }
    
    var body: some View {
        List(filteredRestaurants) { restaurant in
            NavigationLink(destination: DetailView(restaurant: restaurant, viewModel: viewModel)) {
                EnhancedRestaurantRowView(restaurant: restaurant, viewModel: viewModel)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(PlainListStyle())
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.large)
    }
}
