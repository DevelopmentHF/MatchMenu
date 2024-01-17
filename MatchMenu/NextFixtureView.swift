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
        Button("Debug") {
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
        print(matchdays)
        // convert current local time into a given Matchday `x` in UK time

        
        // go thru all matches in json which also fall into Matchday `x`
        
    }
    
    func fillMatchdaysArray(arr: inout [[String: Any]]) {
        // get array of fixtures to find out which matchday is when

        if let responseArray = matches["response"] as? [[String: Any]] {
            var matchdayInteger = 0
            
            // convert this to a date we can compare with system date
            let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            for fixture in responseArray {
                print(fixture)
                var curInt = 0
                
                if let leagueInfo = fixture["league"] as? [String: Any],
                   let round = leagueInfo["round"] as? String {
                    print("Round: \(round)")

                    // Find the numeric characters at the end of the string by removing all characters
                    // not in the char set 0-9
                    let numericCharacters = round.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)

                    // Convert the numeric characters to an integer
                    if let roundNumber = Int(numericCharacters) {
                        print("Last Numeric Characters of Round: \(numericCharacters)")
                        print("Round Number: \(roundNumber)")
                        curInt = roundNumber
                    }
                }
                
                // check if we are in a new matchday period
                if (matchdayInteger != curInt) {
                    // we have progressed from matchday X, to matchday X+1
                    // let endDateOfMatchday = finddateinjson
                    // new matchday
                    matchdayInteger = curInt
                    
                    if let fixtureInfo = fixture["fixture"] as? [String: Any],
                       let fixtureDate = fixtureInfo["date"] as? String {
                        print("fixture date = \(fixtureDate)")
                        
                        dateFormatter.dateFormat = dateFormat

                        if let date = dateFormatter.date(from: fixtureDate) {
                            let newFormat = "dd MMMM yyyy"
                            dateFormatter.dateFormat = newFormat
                            let formattedDate = dateFormatter.string(from: date)
                            print("Formatted Date: \(formattedDate)")
                            
                            arr.append([String(matchdayInteger): formattedDate])
                        } else {
                            print("Failed to convert string to date.")
                        }
                        
                    }
                    
                    
                    
                    // thus, this must be the first fixture of the new matchday,
                    // which means we can use its date as a lower bound, or 'start'
                    // let startDateOfMatchday =finddateinjson
                    
                    // then add that as dictioanry to matchdays array
                    
                }
            }
        }
    }
}
