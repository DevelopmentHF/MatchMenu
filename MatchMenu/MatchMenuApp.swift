//
//  MatchMenuApp.swift
//  MatchMenu
//
//  Created by Henry Fielding on 14/1/2024.
//

import SwiftUI

@main
struct MatchMenuApp: App {
    
    @State var matches: [String: Any] = [:]
    
    init() {
        readJSONFromFile()
    }
    
    var body: some Scene {
        // Create a MenuBarExtra with the "hammer" system image
        MenuBarExtra("MatchMenu", systemImage: "sportscourt.fill") {
            // Define the content of the menu using AppMenu
            ContentView(matches: $matches)
        }.menuBarExtraStyle(.window)
    }
    
    func readJSONFromFile() {
        // Get the file URL for the JSON file in your app bundle
        if let fileURL = Bundle.main.url(forResource: "PL_2023-24_Fixture", withExtension: "json") {
            do {
                // Read the JSON data from the file
                let data = try Data(contentsOf: fileURL)
                
                // Parse the JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Now 'json' is a dictionary containing your JSON data
                    matches = json

                } else {
                    print("Failed to parse JSON")
                }
            } catch {
                print("Error reading JSON file: \(error.localizedDescription)")
            }
        } else {
            print("JSON file not found in the app bundle")
        }
    }
}
