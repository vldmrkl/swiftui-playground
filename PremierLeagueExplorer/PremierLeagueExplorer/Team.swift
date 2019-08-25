//
//  Team.swift
//  PremierLeagueExplorer
//
//  Created by Volodymyr Klymenko on 2019-08-19.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import Foundation

struct Team: Decodable, Identifiable, Comparable {
    var id: Int
    var name: String
    var shortName: String
    var tla: String
    var crestUrl: String
    var founded: Int
    var clubColors: String
    var venue: String
}

func < (lhs: Team, rhs: Team) -> Bool {
    return lhs.shortName < rhs.shortName
}
