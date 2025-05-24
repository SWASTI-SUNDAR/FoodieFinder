import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: RestaurantViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Cuisine Type") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(viewModel.availableCuisines, id: \.self) { cuisine in
                            Button(action: {
                                if viewModel.selectedCuisines.contains(cuisine) {
                                    viewModel.selectedCuisines.remove(cuisine)
                                } else {
                                    viewModel.selectedCuisines.insert(cuisine)
                                }
                            }) {
                                HStack {
                                    Image(systemName: viewModel.selectedCuisines.contains(cuisine) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(viewModel.selectedCuisines.contains(cuisine) ? .orange : .gray)
                                    Text(cuisine)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                Section("Price Range") {
                    ForEach(PriceRange.allCases, id: \.self) { priceRange in
                        Button(action: {
                            if viewModel.selectedPriceRanges.contains(priceRange.rawValue) {
                                viewModel.selectedPriceRanges.remove(priceRange.rawValue)
                            } else {
                                viewModel.selectedPriceRanges.insert(priceRange.rawValue)
                            }
                        }) {
                            HStack {
                                Image(systemName: viewModel.selectedPriceRanges.contains(priceRange.rawValue) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(viewModel.selectedPriceRanges.contains(priceRange.rawValue) ? .orange : .gray)
                                Text(priceRange.rawValue)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(getPriceDescription(priceRange))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Section("Options") {
                    Toggle("Open Now", isOn: $viewModel.isOpenOnly)
                    Toggle("Delivery Available", isOn: $viewModel.deliveryOnly)
                }
                
                Section {
                    Button("Clear All Filters") {
                        viewModel.selectedCuisines.removeAll()
                        viewModel.selectedPriceRanges.removeAll()
                        viewModel.isOpenOnly = false
                        viewModel.deliveryOnly = false
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func getPriceDescription(_ priceRange: PriceRange) -> String {
        switch priceRange {
        case .budget: return "Under $15"
        case .moderate: return "$15-30"
        case .expensive: return "$30-60"
        case .luxury: return "$60+"
        }
    }
}
