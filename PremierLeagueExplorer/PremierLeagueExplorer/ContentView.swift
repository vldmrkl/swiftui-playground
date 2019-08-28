//
//  ContentView.swift
//  PremierLeagueExplorer
//
//  Created by Volodymyr Klymenko on 2019-08-19.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var teamStore: TeamStore
    
    var body: some View {
        NavigationView {
            if (teamStore.teams.count > 0) {
                List {
                    ForEach(teamStore.teams) { team in
                        NavigationLink(destination: TeamView(team: team)) {
                            TeamRow(team: team)
                        }
                    }
                }.navigationBarTitle(Text("Teams"))
            } else {
                Text("Loading...")
            }
        }.onAppear(perform: teamStore.fetch)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
