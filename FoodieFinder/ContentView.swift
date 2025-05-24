//
//  ContentView.swift
//  FoodieFinder
//
//  Created by Swasti Sundar Pradhan on 24/05/25.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}
import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "magnifyingglass.circle.fill" : "magnifyingglass")
                    Text("Search")
                }
                .tag(0)
            
            CategoriesView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "square.grid.2x2.fill" : "square.grid.2x2")
                    Text("Categories")
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "heart.fill" : "heart")
                    Text("Favorites")
                }
                .tag(2)
            
            ReservationsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "calendar.circle.fill" : "calendar")
                    Text("Bookings")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.orange)
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            UITabBar.appearance().standardAppearance = appearance
        }
    }
}
