//
//  FoodieFinderApp.swift
//  FoodieFinder
//
//  Created by Swasti Sundar Pradhan on 24/05/25.
//

import SwiftUI

@main
struct FoodieFinderApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashScreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showSplash = false
                                }
                            }
                        }
                } else {
                    WelcomeCoordinator()
                }
            }
            .preferredColorScheme(.light) // Force light mode for onboarding
        }
    }
}
