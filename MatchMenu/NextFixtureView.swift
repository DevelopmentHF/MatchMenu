//
//  NextFixtureView.swift
//  MatchMenu
//
//  Created by Henry Fielding on 14/1/2024.
//

import Foundation
import SwiftUI

struct NextFixtureView: View {
    @Binding var selectedTeam: Team
    var currentMatchDay: Date = Date()
    @Binding var matches: [String: Any]
    
    var body: some View {
        
        VStack {
            HStack {
                Button("<") {
                    if let matchDetails = matches["matches"] as? [[String: Any]] {   // optional type casting
                        print(matchDetails[0])
                    } else {
                        print("key doesn't exist :( or casting failed")
                    }
                }
                
                VStack {
                    Text("Matchday 21")
                        .font(.headline)
                    Text("15/01/2024")
                        .font(.subheadline)
                }
                
                Button(">") {
                    
                }
            }
            HStack {
                Image("Manchester United")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24.57, height: 32.0)
                Text("Manchester United (H)")
                Divider()
                    .frame(height: 50)
                Image("Tottenham Hotspur")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24.57, height: 32.0)
                Text("Tottenham Hotspur (A)")
            }
            .frame(minWidth: 250)
        }.padding()
    }
}
