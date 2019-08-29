//
//  Service.swift
//  PremierLeagueExplorer
//
//  Created by Volodymyr Klymenko on 2019-08-20.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import Foundation

let teamLogoURLs = [
    "Arsenal": "https://www.stickpng.com/assets/images/580b57fcd9996e24bc43c4df.png",
    "Aston Villa": "https://upload.wikimedia.org/wikipedia/en/thumb/f/f9/Aston_Villa_FC_crest_%282016%29.svg/1200px-Aston_Villa_FC_crest_%282016%29.svg.png",
    "Bournemouth": "https://upload.wikimedia.org/wikipedia/ro/thumb/b/bf/AFC_Bournemouth.svg/1200px-AFC_Bournemouth.svg.png",
    "Brighton Hove": "https://upload.wikimedia.org/wikipedia/en/thumb/f/fd/Brighton_%26_Hove_Albion_logo.svg/1200px-Brighton_%26_Hove_Albion_logo.svg.png",
    "Burnley": "https://upload.wikimedia.org/wikipedia/sco/0/02/Burnley_FC_badge.png",
    "Chelsea": "https://www.stickpng.com/assets/images/580b57fcd9996e24bc43c4e1.png",
    "Crystal Palace": "https://upload.wikimedia.org/wikipedia/hif/c/c1/Crystal_Palace_FC_logo.png",
    "Everton": "https://www.stickpng.com/assets/images/580b57fcd9996e24bc43c4e3.png",
    "Leicester City": "https://upload.wikimedia.org/wikipedia/en/6/63/Leicester02.png",
    "Liverpool": "https://upload.wikimedia.org/wikipedia/hif/b/bd/Liverpool_FC.png",
    "Man City": "https://pluspng.com/img-png/manchester-city-fc-png-manchester-city-fc-png-1024.png",
    "Man United": "https://www.stickpng.com/assets/images/580b57fcd9996e24bc43c4e7.png",
    "Newcastle": "https://upload.wikimedia.org/wikipedia/hif/2/25/Newcastle_United_Logo.png",
    "Norwich": "https://www.stickpng.com/assets/images/580b57fcd9996e24bc43c4e9.png",
    "Sheffield Utd": "https://upload.wikimedia.org/wikipedia/en/thumb/9/9c/Sheffield_United_FC_logo.svg/1200px-Sheffield_United_FC_logo.svg.png",
    "Southampton": "https://www.stickpng.com/assets/images/580b57fcd9996e24bc43c4ea.png",
    "Tottenham": "https://upload.wikimedia.org/wikipedia/hif/6/6d/Tottenham_Hotspur.png",
    "Watford": "https://www.stickpng.com/assets/images/580b57fcd9996e24bc43c4ef.png",
    "West Ham": "https://upload.wikimedia.org/wikipedia/en/thumb/c/c2/West_Ham_United_FC_logo.svg/1200px-West_Ham_United_FC_logo.svg.png",
    "Wolverhampton": "https://upload.wikimedia.org/wikipedia/en/thumb/f/fc/Wolverhampton_Wanderers.svg/1200px-Wolverhampton_Wanderers.svg.png",
]

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
                                let teamName = teamJson["name"] as! String
                                let shortName = teamJson["shortName"] as! String
                                let tla = teamJson["tla"] as! String
                                let crestUrl = teamLogoURLs[shortName]!
                                let founded = teamJson["founded"] as? Int ?? 0
                                let clubColors = teamJson["clubColors"] as! String
                                let venue = teamJson["venue"] as! String

                                let newTeam = Team(id: teamId, name: teamName, shortName: shortName, tla: tla, crestUrl: crestUrl, founded: founded, clubColors: clubColors, venue: venue)

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

    func fetchPlayers(for teamId: Int, handler: @escaping (Result<[Player], Error>) -> Void) {
        var players: [Player] = []
        guard let url = URL(string: "https://api.football-data.org/v2/teams/\(teamId)")  else { return }
        var request = URLRequest(url: url)
        request.setValue(API_KEY, forHTTPHeaderField: "X-Auth-Token")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let responseData = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        let squad = json["squad"] as! [[String: Any]]
                        for player in squad {
                            if let role = player["role"] as? String,
                                role == "PLAYER" {
                                let playerId = player["id"] as! Int
                                let playerName = player["name"] as! String
                                let playerPosition = player["position"] as! String
                                let dob = player["dateOfBirth"] as? String ?? "N/A"
                                let country = player["countryOfBirth"] as! String
                                let nationality = player["nationality"] as! String
                                let shirtNumber = player["shirtNumber"] as? Int ?? 0

                                let newPlayer = Player(id: playerId, name: playerName, position: playerPosition, dateOfBirth: dob, countryOfBirth: country, nationality: nationality, shirtNumber: shirtNumber, role: role)
                                players.append(newPlayer)
                            }
                        }
                    }
                    handler(.success(players))
                } catch {
                    handler(.failure(error))
                }
            }
        }.resume()
    }
}
