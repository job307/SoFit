//
//  CustomTabView.swift
//  SoFit
//
//  Created by Jonas Barth on 08.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct CustomTabView : View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: TBL_Practice.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TBL_Practice.timestamp, ascending: false)]) var practices: FetchedResults<TBL_Practice>
    @FetchRequest(entity: TBL_WO_Pref.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TBL_WO_Pref.workoutID, ascending: true)]) var prefs: FetchedResults<TBL_WO_Pref>
    
    @State var workouts: [Workout] = []
    
    @Binding var practice: [Workout]
    @Binding var selected : String
    var tabs = ["Gym","Stats"]
    
    var body : some View{
        HStack {
            ForEach(tabs, id: \.self) { i in
                VStack(spacing: 10) {
                    
                    //When pressed, selected changes to tabs name and ContentView shows different Page
                    Button(action: {
                        
                        // Fill DB if empty
                        if self.prefs.count == 0 {
                            for i in 1...workoutData.count {
                                let initialiseDB = TBL_WO_Pref(context: self.moc)
                                initialiseDB.pref = 1
                                initialiseDB.workoutID = Int16(i)
                                
                                try? self.moc.save()
                            }
                        }

                        // Random practice based on User Preference and History
                        if i == "Gym" {
                            var possiblePractice: [Double] = []
                            var totals: [[Double]] = []
                            var workoutIndex = 0
                            var deleteTotal = 0
                            let historyRates = self.getHistory()
                            
                            for j in 0..<workoutData.count {
                                let rand = 0.75 + Double((Double.random(in: 0..<50)/100))
                                let history = self.practices.count < 20 ? 1.0 : historyRates[j][1]
                                let pref = self.prefs[j].pref
                                totals.append([Double(j), rand * history * pref])
                                possiblePractice.append(rand * history * pref)
                            }
                            possiblePractice.sort(by: >)
                            
                            for k in 0...4 {
                                for j in 0..<totals.count {
                                    if possiblePractice[k] == totals[j][1] {
                                        workoutIndex = Int(totals[j][0])
                                        deleteTotal = j
                                    }
                                    if j == totals.count-1 {
                                        self.workouts.append(workoutData[workoutIndex])
                                        totals.remove(at: deleteTotal)
                                    }
                                }
                            }
                            self.practice = self.workouts
                        }
                        self.selected = i
                    }) {
                        VStack {
                            Image(systemName: i == "Gym" ? "heart.circle" : "speedometer")
                                .foregroundColor(Color("font"))
                                .font(.system(size: 30))
                            Text(i).foregroundColor(Color("font"))
                        }.offset(y: -10)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 80, alignment: .bottom)
            }
        .padding(.horizontal)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(30)
    }
    
    func getHistory() -> [[Double]] {
        var workoutHistory: [Int] = []
        var histRates: [Double] = [0.75]
        var workoutHistRates: [[Double]] = []
        for i in 0..<self.practices.count {
            workoutHistory.append(Int(self.practices[i].workoutID))
        }
        for i in 1...workoutData.count {
            workoutHistory.append(i)
            histRates.append(histRates[i - 1] + (0.5 / Double(workoutData.count)))
        }
        workoutHistory = workoutHistory.uniques
        for i in 0..<workoutHistory.count {
            workoutHistRates.append([Double(workoutHistory[i]), histRates[i]])
        }
        workoutHistRates = workoutHistRates.sorted(by: {$0[0] < $1[0] })

        return workoutHistRates
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(practice: Binding.constant([]), selected: Binding.constant("Gym"))

        
    }
}

extension Array where Element: Hashable {
    var uniques: Array {
        var arrHist = Array()
        var reqWo = Set<Element>()
        for elemHist in self {
            if !reqWo.contains(elemHist) {
                arrHist.append(elemHist)
                reqWo.insert(elemHist)
            }
        }
        return arrHist
    }
}
