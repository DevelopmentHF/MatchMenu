//
//  NextFixtureView.swift
//  MatchMenu
//
//  Created by Henry Fielding on 14/1/2024.
//

import Foundation
import Keys
import SwiftUI

struct NextFixtureView: View {
    
    @Binding var selectedTeam: Team
    @Binding var matches: [String: Any]
    @Binding var matchday: Int
    @State var fixtures: [[String: String]] = []
    @Binding var isSpoilersOn: Bool
    
    @State var autoRefreshTimer: Timer?
    @State var timerDuration = 3600.0   // update in background once per hr
    
    @State private var isWindowOpen = false
    
    
    
    var body: some View {
        VStack {
            ForEach(fixtures, id: \.self) { fixture in
                FixtureView(team1: fixture["home"] ?? "", team2: fixture["away"] ?? "", date: fixture["date"] ?? "", status: fixture["status"] ?? "", homeScore: fixture["homeScore"] ?? "", awayScore: fixture["awayScore"] ?? "", isSpoilersOn: $isSpoilersOn)
            }
        }
        .onChange(of: matchday) { _, _ in
            fixtures = findFixtures(matchdayNumber: matchday)
        }
        .onAppear() {
            fetchData {
                startTimer()
                calculateMatchday()
                fixtures = findFixtures(matchdayNumber: matchday)
            }
            // https://stackoverflow.com/a/77294334/19459511
            NotificationCenter.default.addObserver(
                forName: NSWindow.didChangeOcclusionStateNotification, object: nil, queue: nil)
            { notification in
                //print("Visible: \((notification.object as! NSWindow).isVisible)")
                isWindowOpen = (notification.object as! NSWindow).isVisible
            }
        }
        .onChange(of: isWindowOpen) { _, _ in
            // update once per hour if the window isnt showing, or once per minute if it is.
            if (isWindowOpen) {
                timerDuration = 60.0
                startTimer()
            } else {
                timerDuration = 3600.0
                startTimer()
            }
        }
    }
    
    func startTimer() {
        autoRefreshTimer?.invalidate()
        autoRefreshTimer = nil
        
        autoRefreshTimer = Timer.scheduledTimer(withTimeInterval: timerDuration, repeats: true) { _ in
            fetchData {}
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
                let scoreInfo = fixture["goals"] as? [String: Any] {
                    
                    if let homeScore = scoreInfo["home"] as? Int,
                       let awayScore = scoreInfo["away"] as? Int {
                        // extract round number of current game
                        let roundNum = extractRoundNumber(roundStr: round)
                        
                        if (roundNum == matchday) {
                            fixtures.append(["home": homeTeam, "away": awayTeam, "date": fixtureDate, "status": status,
                                             "homeScore": String(homeScore), "awayScore": String(awayScore)])
                        }
                    } else {
                        // extract round number of current game
                        let roundNum = extractRoundNumber(roundStr: round)
                        
                        if (roundNum == matchday) {
                            fixtures.append(["home": homeTeam, "away": awayTeam, "date": fixtureDate, "status": status,
                                             "homeScore": String(-1), "awayScore": String(-1)])
                        }
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
        var matchdays: [[String: Any]] = [["1": "31 December 2050"]]
        fillMatchdaysArray(arr: &matchdays)
        print(matchdays)
        
        // convert current local time into a given Matchday `x` in UK time
        matchday = findOutCurrentMatchday(arr: matchdays, currentUTCDate: formattedDate)

        if let test = Bundle.main.infoDictionary?["Variable"] as? String {
            print("test = \(test)")
        }
        
        if let configtest = Bundle.main.infoDictionary?["Configtest"] as? String {
            print("configtest = \(configtest)")
        }
        
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
            print(matchdayNumber)
            // do the same conversion as above but for each of the starting matchday dates
            if let matchdayDateStr = matchdayStartingDict[String(matchdayNumber)] as? String {
                if let unwrappedDate = dateFormatter.date(from: matchdayDateStr) {
                    
                    if (formattedCurrentUTCDate < unwrappedDate) {
                        print("\(formattedCurrentUTCDate) is less than \(unwrappedDate)")
                        print("current matchday = \(matchdayNumber)")
                        
                        if (matchdayNumber > 1) {
                            return matchdayNumber - 1
                        }
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
        
        let keys = MatchMenuKeys()
        let API_KEY = keys.rapidApiKey
        
        let headers = [
            "X-RapidAPI-Key": API_KEY,
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
           
            // convert this to a date we can compare with system date
            let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            for fixture in responseArray {
                
                // finds the round number of the current iterated fixture
                var matchdayOfCurrentFixture = 0
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
            
                    matchdayOfCurrentFixture = extractRoundNumber(roundStr: round)
                }
                
                var newDate: String = ""
                
                if let fixtureInfo = fixture["fixture"] as? [String: Any],
                   let fixtureDate = fixtureInfo["date"] as? String {
                    
                    dateFormatter.dateFormat = dateFormat

                    if let date = dateFormatter.date(from: fixtureDate) {
                        let newFormat = "dd MMMM yyyy"
                        dateFormatter.dateFormat = newFormat
                        newDate = dateFormatter.string(from: date)
                        
                    } else {
                        print("Failed to convert string to date.")
                    }
                    
                }
                
                
                // now, for this matchday, check if it's currently stored starting date is bigger than the
                // the new one we've just calculated
                if (arr.indices.contains(matchdayOfCurrentFixture - 1)) {
                    if let existingDate = arr[matchdayOfCurrentFixture - 1][String(matchdayOfCurrentFixture)] {
                        // key exists in dict
                        
                        // convert from strings back to date objects for comparison
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMMM yyyy"

                        if let existingDateObj = dateFormatter.date(from: existingDate as! String),
                           let newDateObj = dateFormatter.date(from: newDate) {
                            // Compare the two dates
                            if (newDateObj < existingDateObj) {
                                // new minimum
                                arr[matchdayOfCurrentFixture - 1][String(matchdayOfCurrentFixture)] = newDate
                            }
                        }
                        
                        
                    } else {
                        // new entry in dict -> must be a new minimum
                        arr.append([String(matchdayOfCurrentFixture): newDate])
                    }
                } else {
                    arr.append([String(matchdayOfCurrentFixture): newDate])
                }
            }
        }
    }
}
