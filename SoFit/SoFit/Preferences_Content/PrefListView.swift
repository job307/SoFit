//
//  PrefListView.swift
//  SoFit
//
//  Created by Jonas Barth on 27.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct PrefListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: TBL_WO_Pref.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TBL_WO_Pref.workoutID, ascending: true)]) var prefsDB: FetchedResults<TBL_WO_Pref>
    
    @Binding var selected: String
    @Binding var prefs: [[Double]]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    Text("Rating Workouts effects it's chances to be selested for Practices")
                        .padding(.top, 15)
                        .padding(.bottom, 10)
                        .foregroundColor(Color.gray)
                        .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05926262842)))
                    VStack {
                        
                        ForEach(workoutData, id: \.id) { workout in
                            PrefRowView(workout: workout, prefs: self.$prefs)
                        }
                    }
                }
            }.navigationBarTitle(Text("Rating"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    if let index = self.prefs.firstIndex(of: []) {
                        self.prefs.remove(at: index)
                    }
                    
                    // Update DB with Preferences set by user
                    for j in 0..<self.prefsDB.count {
                        for i in 0..<self.prefs.count {
                            if self.prefsDB[j].workoutID == Int16(self.prefs[i][0]) {
                                
                                // Delete old Pref
                                self.moc.delete(self.prefsDB[j])
                                
                                // Add new Pref
                                let initialiseDB = TBL_WO_Pref(context: self.moc)
                                initialiseDB.pref = self.prefs[i][1]
                                initialiseDB.workoutID = Int16(self.prefs[i][0])
                                
                                try? self.moc.save()
                            }
                        }
                    }
                    
                    self.selected = "Prefs"
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Preferences")
                    }
                }))
        }
    }
    
    func savePrefs(prefs: [[Double]]) {
        
    }
}

struct PrefListView_Previews: PreviewProvider {
    static var previews: some View {
        PrefListView(selected: Binding.constant("Rating"), prefs: Binding.constant([[1.0, 0.9], [2.0, 1.1], [4.0, 1.1], [8.0, 0.9], [9.0, 1.1]]))
    }
}
