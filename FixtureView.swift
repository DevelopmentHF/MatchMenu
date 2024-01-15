//
//  FixtureView.swift
//  MatchMenu
//
//  Created by Henry Fielding on 15/1/2024.
//

import Foundation
import SwiftUI


struct FixtureView: View {
    
    @State var team1: String
    @State var team2: String

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Spacer()
//            Text("\(team1)")
            Image("Manchester United")
                .resizable()
                .frame(width: 24.57, height: 32.0)
            Spacer()
            Text("15-Jan 16:00")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
//            Text("\(team2)")
            Image("Manchester City")
                .resizable()
                .frame(width: 24.57, height: 32.0)
            Spacer()
        }
    }
}
