//
//  TeamStore.swift
//  PremierLeagueExplorer
//
//  Created by Volodymyr Klymenko on 2019-08-21.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import Foundation

class TeamStore: ObservableObject {
    @Published private(set) var teams: [Team] = []
    private let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func fetch() {
        service.fetchTeams() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let teams): self?.teams = teams
                    case .failure: self?.teams = []
                }
            }
        }
    }
}

