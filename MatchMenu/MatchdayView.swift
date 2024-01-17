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
         Chelsea = "Chelsea FC",
         Liverpool = "Liverpool FC",
         Bournemouth = "AFC Bournemouth",
         Arsenal = "Arsenal FC",
         AstonVilla = "Aston Villa",
          Brentford = "Brentford FC",
          Brighton = "Brighton & Hove Albion",
          Burnley = "Burnley FC",
          CrystalPalace = "Crystal Palace FC",
          Everton = "Everton FC",
          Fulham = "Fulham FC",
          Luton = "Luton Town FC",
          ManchesterCity = "Manchester City",
          NewcastleUnited = "Newcastle United",
          NottinghamForest = "Nottingham Forest",
          SheffieldUtd = "Sheffield United",
          TottenhamHotspur = "Tottenham Hotspur",
          WestHam = "West Ham United",
          Wolves = "Wolverhampton Wanderers"
    
    
    var id: Self { self }
    
    init?(id: String) {
        self = Team(rawValue: id) ?? .ManchesterUnited
    }
}

struct MatchdayView: View {
    
    // try set it to a default? then use @AppStorage to save it?
    @Binding var selectedTeam: Team
    @Binding var matches: [String: Any]
    @Binding var matchday: Int
    
    var body: some View {
        
        HStack {
            Button("<") {
                matchday -= 1
            }
            
            Text("Matchday \(matchday)") // placeholder
                .font(.headline)
                .onAppear() {
                     fetchData() // reinsert this when you need the API -> dont want to waste calls
                }
            
            Button(">") {
                matchday += 1
            }
        }
        
        
        if (matches.isEmpty) {
            ProgressView()
                  .progressViewStyle(CircularProgressViewStyle(tint: .blue))
        }
    }
    
    /* Taken from RapidAPI sample query */
    private func fetchData() {
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
        })

        dataTask.resume()
    }
}
