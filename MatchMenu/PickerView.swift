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
         Chelsea = "Chelsea",
         Liverpool = "Liverpool"
    
    var id: Self { self }
}

struct PickerView: View {
    
    // try set it to a default? then use @AppStorage to save it?
    @Binding var selectedTeam: Team
    
    var body: some View {
        HStack {
            Image(systemName: "soccerball.inverse")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Picker("Select a team",
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
