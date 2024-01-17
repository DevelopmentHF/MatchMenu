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
    
    @State var matchday: Int = 0 // 0 acts a default value
    
    var body: some View {
        VStack {
            MatchdayView(selectedTeam: $selectedTeam, matches: $matches, matchday: $matchday)
            Divider()
                .padding([.top, .bottom], 5)
            NextFixtureView(selectedTeam: $selectedTeam, matches: $matches, matchday: $matchday)
            Divider()
                .padding([.top, .bottom], 5)
            
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

