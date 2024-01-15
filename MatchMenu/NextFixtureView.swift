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
    @Binding var matches: [String: Any]
    
    var body: some View {
        ScrollView {
            FixtureView(team1: "Manchester United", team2: "Manchester City")
            FixtureView(team1: "Liverpool", team2: "Everton")
            FixtureView(team1: "Chelsea", team2: "Arsenal")
            FixtureView(team1: "Tottenham Hotspur", team2: "West Ham United")
            FixtureView(team1: "Leicester City", team2: "Southampton")
            FixtureView(team1: "Aston Villa", team2: "Wolverhampton Wanderers")
            FixtureView(team1: "Leeds United", team2: "Crystal Palace")
            FixtureView(team1: "Newcastle United", team2: "Brighton & Hove Albion")
            FixtureView(team1: "Burnley", team2: "Fulham")
            FixtureView(team1: "West Bromwich Albion", team2: "Sheffield United")
        }
        Button("Calculate matchday") {
            calculateMatchday()
        }
    }
    
    func calculateMatchday() {
        let currentDate = Date()
        
        // DATE
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let formattedDate = dateFormatter.string(from: currentDate)
        print(formattedDate)
        
        // TIME ZONE
        let timeZone = TimeZone.current
        let offsetInSeconds = timeZone.secondsFromGMT(for: currentDate)
        let offsetInHours = offsetInSeconds / 3600
        print("Time Zone Offset: \(offsetInHours) hours")
        
        // TIMESTAMP
        let timestamp = currentDate.timeIntervalSince1970
        print("Unix Timestamp: \(timestamp)")
        
//           let responseArray = jsonDict["response"] as? [[String: Any]],
//           let firstFixture = responseArray.first,
//           let fixtureInfo = firstFixture["fixture"] as? [String: Any],
//           let refereeName = fixtureInfo["referee"] as? String {
//
//            print("Referee Name: \(refereeName)")
//        }
        
        // Matchday shenanigans
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // these are in UK time
        var matchdays: [[String: Any]] = []
        fillMatchdaysArray(arr: &matchdays)
        
        // convert current local time into a given Matchday `x` in UK time

        
        // go thru all matches in json which also fall into Matchday `x`
        
    }
    
    func fillMatchdaysArray(arr: inout [[String: Any]]) {
        // get array of fixtures to find out which matchday is when

        if let responseArray = matches["response"] as? [[String: Any]] {
            var matchdayInteger = 0
            for fixture in responseArray {
                print(fixture)
                var curInt = 0
                
                if let leagueInfo = fixture["league"] as? [String: Any],
                   let round = leagueInfo["round"] as? String {
                    print("Round: \(round)")

                    // Find the numeric characters at the end of the string
                    let numericCharacters = round.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)

                    // Convert the numeric characters to an integer
                    if let roundNumber = Int(numericCharacters) {
                        print("Last Numeric Characters of Round: \(numericCharacters)")
                        print("Round Number: \(roundNumber)")
                        curInt = roundNumber
                    }
                }
                if (matchdayInteger != curInt) {
                    print("mismatch")
                }
            }
        }
    }
}
