//
//  MatchMenuApp.swift
//  MatchMenu
//
//  Created by Henry Fielding on 14/1/2024.
//

import SwiftUI

@main
struct MatchMenuApp: App {
    var body: some Scene {
        // Create a MenuBarExtra with the "hammer" system image
        MenuBarExtra("MatchMenu", systemImage: "sportscourt.fill") {
            // Define the content of the menu using AppMenu
            ContentView()
        }.menuBarExtraStyle(.window)
    }
}
