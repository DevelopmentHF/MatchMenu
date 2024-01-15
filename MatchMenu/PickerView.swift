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
         AFCBournemouth = "AFC Bournemouth",
         ArsenalFC = "Arsenal FC",
         AstonVilla = "Aston Villa",
          BrentfordFC = "Brentford FC",
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
        HStack {
            Picker("",
                   selection: $selectedTeam) {
                ForEach(Team.allCases) { team in
                    Text(team.rawValue)}
            }
        }
        .onChange(of: selectedTeam) { oldValue, newValue in
            saveSelectedTeam(selectedTeam: newValue)
            readJSONFromFile()
        }
        .onAppear() {
            readJSONFromFile()
            loadSelectedTeam()
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
    
    func readJSONFromFile() {
        // Get the file URL for the JSON file in your app bundle
        if let fileURL = Bundle.main.url(forResource: "\(selectedTeam)", withExtension: "json") {
            do {
                // Read the JSON data from the file
                let data = try Data(contentsOf: fileURL)
                
                // Parse the JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Now 'json' is a dictionary containing your JSON data
                    matches = json

                } else {
                    print("Failed to parse JSON")
                }
            } catch {
                print("Error reading JSON file: \(error.localizedDescription)")
            }
        } else {
            print("JSON file not found in the app bundle")
        }
    }
}



//#Preview {
//    PickerView(selectedTeam: )
//}
