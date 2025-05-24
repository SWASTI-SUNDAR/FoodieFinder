import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    @State private var emailUpdates = false
    @State private var darkMode = false
    @State private var searchRadius = 10.0
    
    var body: some View {
        NavigationStack {
            List {
                Section("Preferences") {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(.orange)
                        Toggle("Push Notifications", isOn: $notificationsEnabled)
                    }
                    
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.orange)
                        Toggle("Location Services", isOn: $locationEnabled)
                    }
                    
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.orange)
                        Toggle("Email Updates", isOn: $emailUpdates)
                    }
                    
                    HStack {
                        Image(systemName: "moon")
                            .foregroundColor(.orange)
                        Toggle("Dark Mode", isOn: $darkMode)
                    }
                }
                
                Section("Search Settings") {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "map")
                                .foregroundColor(.orange)
                            Text("Search Radius")
                            Spacer()
                            Text("\(Int(searchRadius)) miles")
                                .foregroundColor(.secondary)
                        }
                        
                        Slider(value: $searchRadius, in: 1...50, step: 1)
                            .accentColor(.orange)
                    }
                }
                
                Section("About") {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.orange)
                        VStack(alignment: .leading) {
                            Text("FoodieFinder")
                                .font(.headline)
                            Text("Version 1.0.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.orange)
                        Text("Privacy Policy")
                    }
                    
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.orange)
                        Text("Terms of Service")
                    }
                }
            }
            .navigationTitle("Settings")
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
}
