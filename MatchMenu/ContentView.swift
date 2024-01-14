//
//  ContentView.swift
//  MatchMenu
//
//  Created by Henry Fielding on 14/1/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTeam: Team = .ManchesterUnited
    
    var body: some View {
        VStack {
            PickerView(selectedTeam: $selectedTeam)
            Divider()
            NextFixtureView(selectedTeam: $selectedTeam)
        }
        .padding()
    }
}

//#Preview {
//    ContentView()
//}

