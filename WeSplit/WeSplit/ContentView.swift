//
//  ContentView.swift
//  WeSplit
//
//  Created by Volodymyr Klymenko on 2019-10-12.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 0
    let tipPercentages = [0, 10, 15, 20, 25]

    var totalAmount: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0

        let tip = tipSelection * orderAmount / 100
        return orderAmount + tip
    }

    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople) ?? 1
        return totalAmount / peopleCount
    }

    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)

                    TextField("Number of people", text: $numberOfPeople)
                    .keyboardType(.decimalPad)
                }

                Section(header: Text("How much tip would you like to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }

                Section(header: Text("Total amount")) {
                    Text("$\(totalAmount, specifier: "%.2f")")
                }
            }.navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
