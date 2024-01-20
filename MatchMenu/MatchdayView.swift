//
//  PickerView.swift
//  MatchMenu
//
//  Created by Henry Fielding on 14/1/2024.
//

import Foundation
import SwiftUI

enum Team: String, CaseIterable, Identifiable {
    case ManchesterUnited = "Manchester United",
         Chelsea = "Chelsea FC",
         Liverpool = "Liverpool FC",
         Bournemouth = "AFC Bournemouth",
         Arsenal = "Arsenal FC",
         AstonVilla = "Aston Villa",
          Brentford = "Brentford FC",
          Brighton = "Brighton & Hove Albion",
          Burnley = "Burnley FC",
          CrystalPalace = "Crystal Palace FC",
          Everton = "Everton FC",
          Fulham = "Fulham FC",
          Luton = "Luton Town FC",
          ManchesterCity = "Manchester City",
          NewcastleUnited = "Newcastle United",
          NottinghamForest = "Nottingham Forest",
          SheffieldUtd = "Sheffield United",
          TottenhamHotspur = "Tottenham Hotspur",
          WestHam = "West Ham United",
          Wolves = "Wolverhampton Wanderers"
    
    
    var id: Self { self }
    
    init?(id: String) {
        self = Team(rawValue: id) ?? .ManchesterUnited
    }
}

struct MatchdayView: View {
    
    // try set it to a default? then use @AppStorage to save it?
    @Binding var selectedTeam: Team
    @Binding var matches: [String: Any]
    @Binding var matchday: Int
    
    var body: some View {
        
        HStack {
            Button() {
                if (matchday > 1) {
                    matchday -= 1
                }
            } label: {
                Image(systemName: "arrow.left")
            }
            .keyboardShortcut(.leftArrow)
            .buttonStyle(PlainButtonStyle())
            .help("View previous matchday")
            
            Spacer()
            
            Text("Matchday \(matchday)")
                .font(.headline)
            
            
            Spacer()
            
            Button() {
                if (matchday < 38) {
                    matchday += 1
                }
            } label : {
                Image(systemName: "arrow.right")
            }
            .keyboardShortcut(.rightArrow)
            .buttonStyle(PlainButtonStyle())
            .help("View next matchday")
        }
        
        
        if (matches.isEmpty) {
            ProgressView()
                  .progressViewStyle(CircularProgressViewStyle(tint: .blue))
        }
    }
}
