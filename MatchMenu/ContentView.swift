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
            
            HStack {
                Button() {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Image(systemName: "power")
                }
                .keyboardShortcut("q")
                .buttonStyle(PlainButtonStyle())
                .help("Quit")
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "eye")
                }).buttonStyle(PlainButtonStyle())
                    .help("Hide spoilers")
                
            }
            
            
        }
        .padding()
    }
}

