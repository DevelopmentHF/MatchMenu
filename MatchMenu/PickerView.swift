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
          LutonTown = "Luton Town FC",
          ManchesterCity = "Manchester City",
          NewcastleUnited = "Newcastle United",
          NottinghamForest = "Nottingham Forest",
          SheffieldUnited = "Sheffield United",
          TottenhamHotspur = "Tottenham Hotspur",
          WestHamUnited = "West Ham United",
          WolverhamptonWanderers = "Wolverhampton Wanderers"
    
    
    var id: Self { self }
    
    init?(id: String) {
        self = Team(rawValue: id) ?? .ManchesterUnited
    }
}

struct PickerView: View {
    
    // try set it to a default? then use @AppStorage to save it?
    @Binding var selectedTeam: Team
    @Binding var matches: [String: Any]
    
    var body: some View {
//        HStack {
//            Picker("",
//                   selection: $selectedTeam) {
//                ForEach(Team.allCases) { team in
//                    Text(team.rawValue)}
//            }
//        }
        Text("Matchday 21")
            .font(.headline)
        .onChange(of: selectedTeam) { oldValue, newValue in
            saveSelectedTeam(selectedTeam: newValue)
        }
        .onAppear() {
            loadSelectedTeam()
             fetchData() // reinsert this when you need the API -> dont want to waste calls
        }
    }
    
    func saveSelectedTeam(selectedTeam: Team) {
        UserDefaults.standard.set(selectedTeam.id.rawValue, forKey: "last-chosen-team")
    }
    
    func loadSelectedTeam() {
        if let teamId = UserDefaults.standard.string(forKey: "last-chosen-team"),
           let team = Team(id: teamId) {
            selectedTeam = team
        } else {
            selectedTeam = .ManchesterUnited
        }
    }
    
    func fetchData() {
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
                            
                            // test accessing some of the json data -> its in a slightly wack format
//                            if let jsonDict = json as? [String: Any],
//                                   let responseArray = jsonDict["response"] as? [[String: Any]],
//                                   let firstFixture = responseArray.first,
//                                   let fixtureInfo = firstFixture["fixture"] as? [String: Any],
//                                   let refereeName = fixtureInfo["referee"] as? String {
//                                   
//                                    print("Referee Name: \(refereeName)")
//                                }
                            
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



//#Preview {
//    PickerView(selectedTeam: )
//}
