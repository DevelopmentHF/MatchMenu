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
         AFCBournemouth = "AFC Bournemouth",
         ArsenalFC = "Arsenal FC",
         AstonVilla = "Aston Villa",
          BrentfordFC = "Brentford FC",
          Brighton = "Brighton & Hove Albion",
          Burnley = "Burnley FC",
          CrystalPalace = "Crystal Palace FC",
          Everton = "Everton FC",
          Fulham = "Fulham FC",
          LutonTown = "Luton Town FC",
          ManchesterCity = "Manchester City",
          NewcastleUnited = "Newcastle United",
          NottinghamForest = "Nottingham Forest",
          SheffieldUnited = "Sheffield United",
          TottenhamHotspur = "Tottenham Hotspur",
          WestHamUnited = "West Ham United",
          WolverhamptonWanderers = "Wolverhampton Wanderers"
    
    
    var id: Self { self }
}

struct PickerView: View {
    
    // try set it to a default? then use @AppStorage to save it?
    @Binding var selectedTeam: Team
    
    var body: some View {
        HStack {
//            Image(systemName: "soccerball.inverse")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
            Picker("",
                   selection: $selectedTeam) {
                ForEach(Team.allCases) { team in
                    Text(team.rawValue.capitalized)}
            }
        }
    }
}

//#Preview {
//    PickerView(selectedTeam: )
//}
