//
//  PlayerList.swift
//  PremierLeagueExplorer
//
//  Created by Volodymyr Klymenko on 2019-08-28.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import SwiftUI

struct PlayerList: View {
    var title: String
    var players: [Player]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline).bold()
            ForEach(players) { player in
                Text(player.name).font(.body)
            }
        }.padding(.leading, 30)
    }
}
