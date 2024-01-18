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
    @Binding var matchday: Int
    @State var fixtures: [[String: String]] = []
    
    var body: some View {
        VStack {
            ForEach(fixtures, id: \.self) { fixture in
                FixtureView(team1: fixture["home"] ?? "", team2: fixture["away"] ?? "", date: fixture["date"] ?? "", status: fixture["status"] ?? "", homeScore: fixture["homeScore"] ?? "", awayScore: fixture["awayScore"] ?? "")
            }
        }
        .onChange(of: matchday) { _, _ in
            fixtures = findFixtures(matchdayNumber: matchday)
        }
        .onAppear() {
            fetchData {
                    calculateMatchday()
                    fixtures = findFixtures(matchdayNumber: matchday)
                    print(fixtures)
            }
        }
        .onDisappear() {
            // with our timer, if the window is open, call the API once every minute(?tbd)
            // change the timer to be like every hour if the app is open but window hidden
        }
    }
    
    private func findFixtures(matchdayNumber: Int) -> [[String: String]] {
        // init a list to store relevant fixtures
        var fixtures: [[String: String]] = []
        
        // check which fixtures have this `matchdayNumber`
        if let responseArr = matches["response"] as? [[String: Any]] {
            for fixture in responseArr {
                if let teamsInfo = fixture["teams"] as? [String: Any],
                let awayInfo = teamsInfo["away"] as? [String: Any],
                let homeInfo = teamsInfo["home"] as? [String: Any],
                let awayTeam = awayInfo["name"] as? String,
                let homeTeam = homeInfo["name"] as? String,
                let leagueInfo = fixture["league"] as? [String: Any],
                let round = leagueInfo["round"] as? String,
                let fixtureInfo = fixture["fixture"] as? [String: Any],
                let fixtureDate = fixtureInfo["date"] as? String,
                let statusInfo = fixtureInfo["status"] as? [String: Any],
                let status = statusInfo["short"] as? String,
                let scoreInfo = fixture["score"] as? [String: Any],
                let fulltimeInfo = scoreInfo["fulltime"] as? [String: Any],
                let homeScore = fulltimeInfo["home"] as? String,
                let awayScore = fulltimeInfo["away"] as? String {
                    // extract round number of current game
                    let roundNum = extractRoundNumber(roundStr: round)
                    
                    if (roundNum == matchday) {
                        fixtures.append(["home": homeTeam, "away": awayTeam, "date": fixtureDate, "status": status,
                                         "homeScore": homeScore, "awayScore": awayScore])
                    }
                }
            }
        }
        
        // sort fixtures before returning
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        /* borrowed from chatgpt */
        // Convert the date strings to Date objects
        let fixturesWithDates: [(Date, [String: String])] = fixtures.compactMap { fixture in
            guard let dateString = fixture["date"],
                  let date = dateFormatter.date(from: dateString) else {
                return nil
            }
            return (date, fixture)
        }

        // Sort the array based on the Date objects
        let sortedFixtures = fixturesWithDates.sorted { $0.0 < $1.0 }   // refers to the first and second parameter

        // Extract the sorted fixtures without the Date objects
        let resultArray: [[String: String]] = sortedFixtures.map { $0.1 }

        print(resultArray)
        
        return resultArray
    }
    
    
    
    private func extractRoundNumber(roundStr: String) -> Int {
        // Find the numeric characters at the end of the string by removing all characters
        // not in the char set 0-9
        let numericCharacters = roundStr.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)

        // Convert the numeric characters to an integer
        if let roundNumber = Int(numericCharacters) {
            return roundNumber
        }
        
        return -1
    }
    
    private func calculateMatchday() {
        
        // get date in local time
        let currentDate = Date()
        
        // date formatting shenanigans
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // convert local date to utc date
        let formattedDate = dateFormatter.string(from: currentDate)
        print(formattedDate)


        // find out when each matchday begins
        var matchdays: [[String: Any]] = []
        fillMatchdaysArray(arr: &matchdays)
        //print(matchdays)
        
        // convert current local time into a given Matchday `x` in UK time
        matchday = findOutCurrentMatchday(arr: matchdays, currentUTCDate: formattedDate)

        // go thru all matches in json which also fall into Matchday `x`
        
    }
    
    private func findOutCurrentMatchday(arr: [[String: Any]], currentUTCDate: String) -> Int {
        // set up date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // convert current utc date (machine time) back into a date object so we can compare
        let formattedCurrentUTCDate = dateFormatter.date(from: currentUTCDate)!
        
        var matchdayNumber = 1
        for matchdayStartingDict in arr {

            // do the same conversion as above but for each of the starting matchday dates
            if let matchdayDateStr = matchdayStartingDict[String(matchdayNumber)] as? String {
                if let unwrappedDate = dateFormatter.date(from: matchdayDateStr) {
                    
                    if (formattedCurrentUTCDate <= unwrappedDate) {
                        print("current matchday = \(matchdayNumber)")
                        return matchdayNumber
                    }
                }

            }
            
            matchdayNumber += 1
        }
        return 0;
    }
    
    /* Taken from RapidAPI sample query */
    private func fetchData(completion: @escaping () -> Void) {
        let headers = [
            "X-RapidAPI-Key": "6b815b7a96mshb5a3eead469d603p1ea2d6jsnbb3356f397f4",
            "X-RapidAPI-Host": "api-football-v1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api-football-v1.p.rapidapi.com/v3/fixtures?league=39&season=2023")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse)
                    
                    if let responseData = data {
                        do {
                            // Assuming the data is in JSON format, you can use JSONSerialization to parse it
                            let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                            
                            // convert the json into a variable other views can access
                            if let jsonDict = json as? [String: Any] {
                                matches = jsonDict
                                //print(matches)
                            } else {
                                print("failed to convert serialised json into a variable")
                            }
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                        completion()
                    }
        })

        dataTask.resume()
    }
    
    private func fillMatchdaysArray(arr: inout [[String: Any]]) {
        // get array of fixtures to find out which matchday is when

        if let responseArray = matches["response"] as? [[String: Any]] {
            var matchdayInteger = 0
            
            // convert this to a date we can compare with system date
            let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            for fixture in responseArray {
                //print(fixture)
                var curInt = 0
                
                if let leagueInfo = fixture["league"] as? [String: Any],
                   let round = leagueInfo["round"] as? String {
                    
                    // checking for postponements, we don't want this to impact our matchday starting time
                    if let fixtureInfo = fixture["fixture"] as? [String: Any],
                       let statusInfo = fixtureInfo["status"] as? [String: Any],
                       let shortStatus = statusInfo["short"] as? String {
                        if shortStatus == "TBD" {
                            continue
                        }
                    }
            
                    curInt = extractRoundNumber(roundStr: round)
                }
                
                // check if we are in a new matchday period
                // TODO: Bruh the first matchday in the API call isnt necessarily the first one scheduled.
                // TODO: thus, change to find the minimum date for a given matchday. good enough for now to create
                // a ui but *needs* to be fixed
                if (matchdayInteger != curInt) {
                    // we have progressed from matchday X, to matchday X+1
                    // let endDateOfMatchday = finddateinjson
                    // new matchday
                    matchdayInteger = curInt
                    
                    if let fixtureInfo = fixture["fixture"] as? [String: Any],
                       let fixtureDate = fixtureInfo["date"] as? String {
                        //print("fixture date = \(fixtureDate)")
                        
                        dateFormatter.dateFormat = dateFormat

                        if let date = dateFormatter.date(from: fixtureDate) {
                            let newFormat = "dd MMMM yyyy"
                            dateFormatter.dateFormat = newFormat
                            let formattedDate = dateFormatter.string(from: date)
                            //print("Formatted Date: \(formattedDate)")
                            
                            arr.append([String(matchdayInteger): formattedDate])
                        } else {
                            print("Failed to convert string to date.")
                        }
                        
                    }
                }
            }
        }
    }
}
