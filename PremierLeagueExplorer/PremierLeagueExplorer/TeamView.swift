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

    var body: some View {
        VStack(alignment: .trailing) {
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
            Spacer()
        }.onAppear(perform: {
            let service = Service()
            service.fetchPlayers(for: self.team.id) { [self] result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let players): self.squad = players
                        case .failure: self.squad = []
                    }
                }
            }
        })
    }
}
