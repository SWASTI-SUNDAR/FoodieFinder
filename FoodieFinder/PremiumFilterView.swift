import SwiftUI

struct PremiumFilterView: View {
    @ObservedObject var viewModel: RestaurantViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Find Your Perfect Restaurant")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Customize your search with these filters")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                    
                    // Cuisine Types
                    FilterSection(title: "Cuisine Types", icon: "fork.knife") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(viewModel.availableCuisines, id: \.self) { cuisine in
                                CuisineFilterButton(
                                    cuisine: cuisine,
                                    isSelected: viewModel.selectedCuisines.contains(cuisine)
                                ) {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        if viewModel.selectedCuisines.contains(cuisine) {
                                            viewModel.selectedCuisines.remove(cuisine)
                                        } else {
                                            viewModel.selectedCuisines.insert(cuisine)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Price Range
                    FilterSection(title: "Price Range", icon: "dollarsign.circle") {
                        VStack(spacing: 12) {
                            ForEach(PriceRange.allCases, id: \.self) { priceRange in
                                PriceRangeButton(
                                    priceRange: priceRange,
                                    isSelected: viewModel.selectedPriceRanges.contains(priceRange.rawValue)
                                ) {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        if viewModel.selectedPriceRanges.contains(priceRange.rawValue) {
                                            viewModel.selectedPriceRanges.remove(priceRange.rawValue)
                                        } else {
                                            viewModel.selectedPriceRanges.insert(priceRange.rawValue)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Quick Options
                    FilterSection(title: "Quick Options", icon: "slider.horizontal.3") {
                        VStack(spacing: 16) {
                            ToggleOption(
                                title: "Open Now",
                                subtitle: "Show only restaurants currently open",
                                icon: "clock.fill",
                                iconColor: .green,
                                isOn: $viewModel.isOpenOnly
                            )
                            
                            ToggleOption(
                                title: "Delivery Available",
                                subtitle: "Restaurants that deliver to your location",
                                icon: "bicycle",
                                iconColor: .blue,
                                isOn: $viewModel.deliveryOnly
                            )
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: { dismiss() }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Apply Filters")
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
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.selectedCuisines.removeAll()
                                viewModel.selectedPriceRanges.removeAll()
                                viewModel.isOpenOnly = false
                                viewModel.deliveryOnly = false
                            }
                        }) {
                            Text("Clear All Filters")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.red.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(20)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }
}

struct FilterSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.orange)
                
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct CuisineFilterButton: View {
    let cuisine: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isSelected ? .orange : .gray)
                
                Text(cuisine)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? .orange : .primary)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.orange.opacity(0.1) : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.orange.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
    }
}

struct PriceRangeButton: View {
    let priceRange: PriceRange
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isSelected ? .orange : .gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(priceRange.rawValue)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isSelected ? .orange : .primary)
                    
                    Text(getPriceDescription(priceRange))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.orange.opacity(0.1) : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.orange.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
    }
    
    private func getPriceDescription(_ priceRange: PriceRange) -> String {
        switch priceRange {
        case .budget: return "Under $15 per person"
        case .moderate: return "$15-30 per person"
        case .expensive: return "$30-60 per person"
        case .luxury: return "$60+ per person"
        }
    }
}

struct ToggleOption: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(.orange)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}
