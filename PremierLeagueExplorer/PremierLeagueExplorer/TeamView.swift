//
//  TeamView.swift
//  PremierLeagueExplorer
//
//  Created by Volodymyr Klymenko on 2019-08-27.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import SwiftUI

struct TeamView: View {
    @State var squad: [Player] = []
    @State var sortedSquad: [String: [Player]] = ["goalkeepers": [],
                                                  "defenders": [],
                                                  "midfielders": [],
                                                  "forwards": []]

    var team: Team
    var teamLogo: UIImage {
        get {
            if let url = URL(string: team.crestUrl), let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    return image
                }
            }
            return UIImage()
        }
    }

    struct PlayerList: View {
        var title: String
        var players: [Player]

        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.subheadline).bold()
                ForEach(players) { player in
                    Text(player.name).font(.body)
                }
            }.padding(.leading, 30)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image(uiImage: teamLogo).resizable().aspectRatio(contentMode: .fit).frame(width: 120.0, height: 120.0).padding(.leading, 20)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(team.name).font(.title).bold().lineLimit(nil)
                        Text("Founded in " + String(team.founded)).font(.caption).lineLimit(1)
                        Text("Stadium: \(team.venue)").font(.caption).lineLimit(2)
                        Text("Colors: \(team.clubColors)").font(.caption).lineLimit(1)
                    }.padding(.trailing, 10).frame(width: 220)

                }

                if(sortedSquad["goalkeepers"]!.count > 0) {
                    PlayerList(title: "Goalkeepers", players: sortedSquad["goalkeepers"]!)
                }

                if(sortedSquad["defenders"]!.count > 0) {
                    PlayerList(title: "Defenders", players: sortedSquad["defenders"]!)
                }

                if(sortedSquad["midfielders"]!.count > 0) {
                    PlayerList(title: "Midfielders", players: sortedSquad["midfielders"]!)
                }
                if(sortedSquad["forwards"]!.count > 0) {
                    PlayerList(title: "Forwards", players: sortedSquad["forwards"]!)
                }
            }.onAppear(perform: {
                let service = Service()
                service.fetchPlayers(for: self.team.id) { [self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let players): self.squad = players
                        case .failure: self.squad = []
                        }
                        self.sortSquad()
                    }
                }
            })
        }
    }

    func sortSquad() {
        for player in self.squad {
            switch player.position {
            case "Midfielder":
                sortedSquad["midfielders"]?.append(player)
                break
            case "Attacker":
                sortedSquad["forwards"]?.append(player)
                break
            case "Defender":
                sortedSquad["defenders"]?.append(player)
                break
            case "Goalkeeper":
                sortedSquad["goalkeepers"]?.append(player)
                break
            default:
                break
            }
        }
    }
}
