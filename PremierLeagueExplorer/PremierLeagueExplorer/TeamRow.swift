//
//  TeamRow.swift
//  PremierLeagueExplorer
//
//  Created by Volodymyr Klymenko on 2019-08-19.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import SwiftUI

struct TeamRow: View {
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
        HStack {
            Image(uiImage: teamLogo).resizable().aspectRatio(contentMode: .fit).frame(width: 40.0, height: 40.0) 
            Text(team.shortName)
        }
    }
}
