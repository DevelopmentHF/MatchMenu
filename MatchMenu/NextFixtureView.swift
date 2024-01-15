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
        let matchdays = [
                ["start": dateFormatter.date(from: "11 August 2023") ?? Date(),
                 "end": dateFormatter.date(from: "14 August 2023") ?? Date()],
                ["start": dateFormatter.date(from: "18 August 2023") ?? Date(),
                 "end": dateFormatter.date(from: "03 October 2023") ?? Date()],
                ["start": dateFormatter.date(from: "25 August 2023") ?? Date(),
                 "end": dateFormatter.date(from: "27 October 2023") ?? Date()],
                ["start": dateFormatter.date(from: "01 September 2023") ?? Date(),
                 "end": dateFormatter.date(from: "03 September 2023") ?? Date()],
                ["start": dateFormatter.date(from: "16 September 2023") ?? Date(),
                 "end": dateFormatter.date(from: "18 September 2023") ?? Date()],
                ["start": dateFormatter.date(from: "23 September 2023") ?? Date(),
                 "end": dateFormatter.date(from: "24 September 2023") ?? Date()],
                ["start": dateFormatter.date(from: "30 September 2023") ?? Date(),
                 "end": dateFormatter.date(from: "02 October 2023") ?? Date()],
                ["start": dateFormatter.date(from: "07 October 2023") ?? Date(),
                 "end": dateFormatter.date(from: "08 October 2023") ?? Date()],
                ["start": dateFormatter.date(from: "21 October 2023") ?? Date(),
                 "end": dateFormatter.date(from: "23 October 2023") ?? Date()],
                ["start": dateFormatter.date(from: "27 October 2023") ?? Date(),
                 "end": dateFormatter.date(from: "29 October 2023") ?? Date()],
                ["start": dateFormatter.date(from: "04 November 2023") ?? Date(),
                 "end": dateFormatter.date(from: "06 November 2023") ?? Date()],
                ["start": dateFormatter.date(from: "11 November 2023") ?? Date(),
                 "end": dateFormatter.date(from: "12 November 2023") ?? Date()],
                ["start": dateFormatter.date(from: "25 November 2023") ?? Date(),
                 "end": dateFormatter.date(from: "27 November 2023") ?? Date()],
                ["start": dateFormatter.date(from: "02 December 2023") ?? Date(),
                 "end": dateFormatter.date(from: "03 December 2023") ?? Date()],
                ["start": dateFormatter.date(from: "05 December 2023") ?? Date(),
                 "end": dateFormatter.date(from: "07 December 2023") ?? Date()],
                ["start": dateFormatter.date(from: "09 December 2023") ?? Date(),
                 "end": dateFormatter.date(from: "10 December 2023") ?? Date()],
                ["start": dateFormatter.date(from: "15 December 2023") ?? Date(),
                 "end": dateFormatter.date(from: "18 May 2024") ?? Date()],
                ["start": dateFormatter.date(from: "21 December 2023") ?? Date(),
                 "end": dateFormatter.date(from: "20 February 2024") ?? Date()],
                ["start": dateFormatter.date(from: "26 December 2023") ?? Date(),
                 "end": dateFormatter.date(from: "28 December 2023") ?? Date()],
                ["start": dateFormatter.date(from: "30 December 2023") ?? Date(),
                 "end": dateFormatter.date(from: "02 January 2024") ?? Date()],
                ["start": dateFormatter.date(from: "12 January 2024") ?? Date(),
                 "end": dateFormatter.date(from: "22 January 2024") ?? Date()],
                ["start": dateFormatter.date(from: "30 January 2024") ?? Date(),
                 "end": dateFormatter.date(from: "01 February 2024") ?? Date()],
                ["start": dateFormatter.date(from: "03 February 2024") ?? Date(),
                 "end": dateFormatter.date(from: "05 February 2024") ?? Date()],
                ["start": dateFormatter.date(from: "10 February 2024") ?? Date(),
                 "end": dateFormatter.date(from: "12 February 2024") ?? Date()],
                ["start": dateFormatter.date(from: "17 February 2024") ?? Date(),
                 "end": dateFormatter.date(from: "19 February 2024") ?? Date()],
                ["start": dateFormatter.date(from: "23 February 2024") ?? Date(),
                 "end": dateFormatter.date(from: "26 February 2024") ?? Date()],
                ["start": dateFormatter.date(from: "02 March 2024") ?? Date(),
                 "end": dateFormatter.date(from: "02 March 2024") ?? Date()], // Assuming it's a single-day matchday
                ["start": dateFormatter.date(from: "09 March 2024") ?? Date(),
                 "end": dateFormatter.date(from: "09 March 2024") ?? Date()], // Assuming it's a single-day matchday
                ["start": dateFormatter.date(from: "16 March 2024") ?? Date(),
                 "end": dateFormatter.date(from: "16 March 2024") ?? Date()], // Assuming it's a single-day matchday
                ["start": dateFormatter.date(from: "30 March 2024") ?? Date(),
                 "end": dateFormatter.date(from: "30 March 2024") ?? Date()], // Assuming it's a single-day matchday
                ["start": dateFormatter.date(from: "02 April 2024") ?? Date(),
                 "end": dateFormatter.date(from: "03 April 2024") ?? Date()],
                ["start": dateFormatter.date(from: "06 April 2024") ?? Date(),
                 "end": dateFormatter.date(from: "06 April 2024") ?? Date()], // Assuming it's a single-day matchday
                ["start": dateFormatter.date(from: "13 April 2024") ?? Date(),
                 "end": dateFormatter.date(from: "13 April 2024") ?? Date()], // Assuming it's a single-day matchday
                ["start": dateFormatter.date(from: "20 April 2024") ?? Date(),
                 "end": dateFormatter.date(from: "20 April 2024") ?? Date()], // Assuming it's a single-day matchday
                ["start": dateFormatter.date(from: "27 April 2024") ?? Date(),
                 "end": dateFormatter.date(from: "27 April 2024") ?? Date()], // Assuming it's a single-day matchday
                ["start": dateFormatter.date(from: "04 May 2024") ?? Date(),
                 "end": dateFormatter.date(from: "04 May 2024") ?? Date()], // Assuming it's a single-day matchday
                ["start": dateFormatter.date(from: "11 May 2024") ?? Date(),
                 "end": dateFormatter.date(from: "11 May 2024") ?? Date()], // Assuming it's a single-day matchday
                ["start": dateFormatter.date(from: "19 May 2024") ?? Date(),
                 "end": dateFormatter.date(from: "19 May 2024") ?? Date()] // Assuming it's a single-day matchday
        ]
        
        // convert current local time into a given Matchday `x` in UK time
        print(matchdays[0])
        
        // go thru all matches in json which also fall into Matchday `x`
        
    }
}
