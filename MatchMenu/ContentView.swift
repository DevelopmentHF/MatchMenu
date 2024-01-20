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
    
    @State private var isSpoilersOn: Bool = UserDefaults.standard.bool(forKey: "isSpoilersOnKey")
    
    
    
    init() {
        // Check if a value exists in UserDefaults
        if let savedValue = UserDefaults.standard.value(forKey: "isSpoilersOnKey") as? Bool {
            _isSpoilersOn = State(initialValue: savedValue)
        } else {
            // Set a default value if no value is found
            _isSpoilersOn = State(initialValue: true)
        }
    }
    
    var body: some View {
        VStack {
            MatchdayView(selectedTeam: $selectedTeam, matches: $matches, matchday: $matchday)
            Divider()
                .padding([.top, .bottom], 5)
            NextFixtureView(selectedTeam: $selectedTeam, matches: $matches, matchday: $matchday, isSpoilersOn: $isSpoilersOn)
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
                    isSpoilersOn = !isSpoilersOn
                    print(isSpoilersOn)
                }, label: {
                    if (isSpoilersOn) {
                        Image(systemName: "eye")
                    } else {
                        Image(systemName: "eye.slash")
                    }
                    
                }).buttonStyle(PlainButtonStyle())
                    .help("Hide spoilers")
                
            }
        }
        .padding()
        .onAppear() {
            // Load the saved value from UserDefaults when the view appears
            isSpoilersOn = UserDefaults.standard.bool(forKey: "isSpoilersOnKey")
        }
        .onChange(of: isSpoilersOn) { _, newValue in
            // Save the updated value to UserDefaults when it changes
            UserDefaults.standard.set(newValue, forKey: "isSpoilersOnKey")
        }
    }
}

