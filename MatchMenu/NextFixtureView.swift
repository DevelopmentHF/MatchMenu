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
        Text("\(selectedTeam.rawValue.capitalized)")
    }
}

//#Preview {
//    NextFixtureView()
//}
