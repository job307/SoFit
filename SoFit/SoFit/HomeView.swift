//
//  HomeView.swift
//  SoFit
//
//  Created by Jonas Barth on 24.05.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: TBL_WO_Pref.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TBL_WO_Pref.pref, ascending: false)]) var prefs: FetchedResults<TBL_WO_Pref>
    @FetchRequest(entity: Countdown.entity(), sortDescriptors: []) var countdown: FetchedResults<Countdown>
    @FetchRequest(entity: FitnessLevel.entity(), sortDescriptors: []) var level: FetchedResults<FitnessLevel>
    
    @Binding var selected: String
    @Binding var practice: [Workout]
    
    @State var image: Image?
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    image?.resizable()
                        .frame(width: 350, height: 500)
                }.navigationBarTitle(Text("Home").foregroundColor(Color("font")), displayMode: .inline).onAppear {
                    let number = Int.random(in: 1..<15)
                    self.image = Image("qte\(number)")
                }
                    
                // Button to PrefsView
                .navigationBarItems(trailing: Button(action: {
                    
                    // Ask for permission to send notifications
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("Notifications allowed!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    // Fill DB if empty
                    if self.prefs.count == 0 {
                        for i in 1...workoutData.count {
                            let initialiseDB = TBL_WO_Pref(context: self.moc)
                            initialiseDB.pref = 1
                            initialiseDB.workoutID = Int16(i)
                            
                            try? self.moc.save()
                        }
                    }
                    self.selected = "Prefs"
                }) {
                    Image(systemName: "person").resizable()
                        .frame(width: 25, height: 25, alignment: .leading)
                        .foregroundColor(Color("font"))
                })
            }
            
            CustomTabView(practice: $practice, selected: $selected).offset(x: 0, y: 15)
        }.onAppear {
            
            // Set Countdown to 10 if there is none
            if self.countdown.count == 0 {
                let cd = Countdown(context: self.moc)
                cd.countdown = Int16(10)
                
                try? self.moc.save()
            }
            
            // Set FitnessLevel to Couch Potato if there is none
            if self.level.count == 0 {
                let lvl = FitnessLevel(context: self.moc)
                lvl.level = Int16(0)
                
                try? self.moc.save()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selected: Binding.constant("Home"), practice: Binding.constant([]))
    }
}
