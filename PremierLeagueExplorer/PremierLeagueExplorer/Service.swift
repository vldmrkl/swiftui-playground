//
//  Service.swift
//  PremierLeagueExplorer
//
//  Created by Volodymyr Klymenko on 2019-08-20.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import Foundation

class Service {
    let API_KEY: String = {
        if  let path = Bundle.main.path(forResource: "ApiKeys", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let properties = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil) as? [String: String],
            let apiKey = properties["FOOTBALL_DATA_API_KEY"]
        {
            return(apiKey)
        }
        return ""
    }()

    func fetchTeams(handler: @escaping (Result<[Team], Error>) -> Void) {
        var teams: [Team] = []
        guard let url = URL(string: "https://api.football-data.org/v2/competitions/2021/teams")  else { return }
        var request = URLRequest(url: url)
        request.setValue(API_KEY, forHTTPHeaderField: "X-Auth-Token")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let responseData = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        if let teamsJson = json["teams"] as? [[String: Any]] {
                            for teamJson in teamsJson {

                                let teamId = teamJson["id"] as! Int
                                let shortName = teamJson["shortName"] as! String
                                let tla = teamJson["tla"] as! String
                                let crestUrl = teamJson["crestUrl"] as! String
                                let founded = teamJson["founded"] as? Int ?? 0
                                let clubColors = teamJson["clubColors"] as! String
                                let venue = teamJson["venue"] as! String

                                let newTeam = Team(id: teamId, name: teamJson["name"] as! String, shortName: shortName, tla: tla, crestUrl: crestUrl, founded: founded, clubColors: clubColors, venue: venue)

                                teams.append(newTeam)
                            }
                        }
                    }
                    teams.sort(by: <)
                    handler(.success(teams))
                } catch {
                    handler(.failure(error))
                }
            }
        }.resume()


    }
}
