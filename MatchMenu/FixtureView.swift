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
    @State var date: String
    @State var status: String
    @State var homeScore: String
    @State var awayScore: String
    @Binding var isSpoilersOn: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Spacer()

            Image(team1)
                .resizable()
                .frame(width: 24.57, height: 32.0)
            Spacer()
            
            HStack {
                if (status == "FT" || status == "1H" || status == "2H") {
                    
                    if (!isSpoilersOn) {
                        Image(systemName: "eye.slash.circle.fill")
      
                        if (status != "FT") {
                            Text("Live - " + status)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .frame(minWidth: 100)
                        } else {
                            Text(status)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 100) // this is so the columns still align when there a diff length strings.
                        }
                        
                        
                        Image(systemName: "eye.slash.circle.fill")
                    } else {
                        Text(homeScore)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        if (status != "FT") {
                            Text("Live - " + status)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .frame(minWidth: 100)
                        } else {
                            Text(status)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 100) // this is so the columns still align when there a diff length strings.
                        }
                        
                        Text(awayScore)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
     
                } else {
                    Text(UtcToLocalTime(utcDate: date))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(minWidth: 100)   // this is so the columns still align when there a diff length strings.
                }
            }.frame(minWidth: 150)
            
            
            Spacer()

            Image(team2)
                .resizable()
                .frame(width: 24.57, height: 32.0)
            Spacer()
        }
    }
    
    private func UtcToLocalTime(utcDate: String) -> String {
            
        // define input conditions of the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // convert
        if let formattedDate = dateFormatter.date(from: utcDate) {
            // define output condtions of the date
            let localDateFormatter = DateFormatter()
            localDateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
            localDateFormatter.timeZone = TimeZone.current

            return localDateFormatter.string(from: formattedDate)
        }

        return "Oops! We can't display match information right now."
    }
}
