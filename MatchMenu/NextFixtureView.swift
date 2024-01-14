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
    
    var body: some View {
        VStack {
            Text("Matchday 21")
                .font(.headline)
            Text("16/01/2024")
                .font(.subheadline)
        }
        
        HStack {
            Text("Manchester United (H)")
            Divider()
            Text("Everton (A)")
        }
    }
}

#Preview {
    NextFixtureView(selectedTeam: .constant(.ManchesterUnited))
}
