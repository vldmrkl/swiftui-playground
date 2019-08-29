//
//  Player.swift
//  PremierLeagueExplorer
//
//  Created by Volodymyr Klymenko on 2019-08-27.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import Foundation

struct Player: Identifiable {
    var id: Int
    var name: String
    var position: String
    var dateOfBirth: String
    var countryOfBirth: String
    var nationality: String
    var shirtNumber: Int
    var role: String
}
