//
//  TeamView.swift
//  PremierLeagueExplorer
//
//  Created by Volodymyr Klymenko on 2019-08-27.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import SwiftUI

struct TeamView: View {
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
        VStack {
            HStack(alignment: .top) {
                Image(uiImage: teamLogo).resizable().aspectRatio(contentMode: .fit).frame(width: 120.0, height: 120.0)
                VStack(alignment: .leading) {
                    Text(team.shortName).font(.title).bold()
                    Text("Founded in " + String(team.founded)).font(.caption)
                    Text("Stadium: \(team.venue)").font(.caption)
                    Text("Colors: \(team.clubColors)").font(.caption)
                }.padding(.top, 10).padding(.leading, 15)

            }
            Spacer()
        }
    }
}
