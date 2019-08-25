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

    var body: some View {
        HStack {
            Text(team.shortName)
        }
    }
}
