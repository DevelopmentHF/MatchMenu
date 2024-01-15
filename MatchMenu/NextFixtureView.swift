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
    
    var body: some View {
        
        HStack {
            Button("<") {
                
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
                .frame(width: 24.57, height: 32.0)
            Text("Manchester United (H)")
            Divider()
            Image("Tottenham Hotspur")
                .resizable()
                .frame(width: 24.57, height: 32.0)
            Text("Tottenham Hotspur (A)")
        }
    }
}

#Preview {
    NextFixtureView(selectedTeam: .constant(.ManchesterUnited))
}
