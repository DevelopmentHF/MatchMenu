//
//  ContentView.swift
//  MatchMenu
//
//  Created by Henry Fielding on 14/1/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTeam: Team = .ManchesterUnited
    
    @State var matches: [String: Any] = [:]
    
    var body: some View {
        VStack {
            PickerView(selectedTeam: $selectedTeam, matches: $matches)
            Divider()
            NextFixtureView(selectedTeam: $selectedTeam, matches: $matches)
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
        .padding()
    }
}

