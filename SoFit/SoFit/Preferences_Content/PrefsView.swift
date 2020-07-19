//
//  PreferencesView.swift
//  SoFit
//
//  Created by Jonas Barth on 18.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct PrefsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: TBL_Practice.entity(), sortDescriptors: []) var practices: FetchedResults<TBL_Practice>
    @FetchRequest(entity: TBL_WO_Pref.entity(), sortDescriptors: []) var prefs: FetchedResults<TBL_WO_Pref>
    @FetchRequest(entity: Countdown.entity(), sortDescriptors: []) var countdown: FetchedResults<Countdown>
    @FetchRequest(entity: FitnessLevel.entity(), sortDescriptors: []) var level: FetchedResults<FitnessLevel>
    
    @State private var reminderDate = Date()
    @State private var reminderIntervall = 0
    @State private var trigger: UNNotificationTrigger? = nil
    @State private var fitnessLevel = 0
    @State private var count = 30
    
    @Binding var selected: String
    @Binding var prefsForList: [[Double]]
    
    private let minDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
    private let maxDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())
    
    init(selected: Binding<String>, countdown: Int16, prefs: Binding<[[Double]]>) {
        self._selected = selected
        self._count = State(initialValue: Int(countdown))
        self._prefsForList = prefs
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("SCHEDULING")) {
                    DatePicker(selection: $reminderDate, in: self.minDate!...self.maxDate!) {
                        LabelView(text: "Reminder", imagename: "alarm")
                    }
                    
                    Picker(selection: $reminderIntervall, label: LabelView(text: "Recurring", imagename: "repeat")) {
                        Text("Never").tag(0)
                        Text("Daily").tag(1)
                        Text("Weekly").tag(2)
                    }
                    
                    
                    Button(action: {
                        let content = UNMutableNotificationContent()
                        
                        // Customize notification
                        content.title = "Wanna Workout?🏋️‍♂️"
                        content.body = "It's time for some training."
                        content.sound = UNNotificationSound.default
                        content.launchImageName = "AppIcon"
                        
                        // Intervall = weekly
                        if self.reminderIntervall == 2 {
                            
                            // Convert Date to DateComponents
                            let triggerDate = Calendar.current.dateComponents([.weekday,.hour,.minute], from: self.reminderDate)
                            
                            // Create weekly-repeating trigger
                            self.trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
                            
                            // Intervall = daily
                        } else if self.reminderIntervall == 1 {
                            let triggerDate = Calendar.current.dateComponents([.hour,.minute], from: self.reminderDate)
                            
                            // Create daily-repeating trigger
                            self.trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
                            
                            // Intervall = 0
                        } else {
                            let triggerDate = Calendar.current.dateComponents([.weekday,.hour,.minute], from: self.reminderDate)
                            
                            // Create non-repeating trigger
                            self.trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                        }
                        
                        // Choose a random identifier
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: self.trigger)
                        
                        // Add notification request
                        UNUserNotificationCenter.current().add(request)
                    }) {
                        HStack {
                            Spacer()
                            Text("Save Reminder")
                            Spacer()
                        }
                    }
                    
                    Button(action: {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }) {
                        HStack {
                            Spacer()
                            Text("Delete All Reminder")
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("OPTIONS")) {
                    
                    // User selects his Fitness Level
                    Picker(selection: $fitnessLevel, label:LabelView(text: "Fitness Level", imagename: "waveform.path.ecg")) {
                        Text("Couch Potato").tag(0)
                        Text("Rookie").tag(1)
                        Text("Hobby Athlet").tag(2)
                        Text("Elite Athlet").tag(3)
                        Text("Navy Seal").tag(4)
                        Text("Machine").tag(5)
                    }.disabled(true)
                    
                    Stepper(value: $count, in: 0...180) {
                        LabelView(text: "Countdown", imagename: "timer")
                        Text("\(self.count)").padding(.leading, 10)
                    }
                    
                    // Like or Dislike specific Workouts
                    Button(action: {
                        
                        // Fill PrefArray, so Preferences stay the same as in DB
                        var prefArray: [[Double]] = []
                        for i in 0..<self.prefs.count {
                            prefArray.append([Double(self.prefs[i].workoutID), self.prefs[i].pref])
                        }
                        self.prefsForList = prefArray
                        
                        // Move to View to rate Workouts
                        self.selected = "Rating"
                    }) {
                        HStack {
                            LabelView(text: "Rate Workouts", imagename: "star")
                                .foregroundColor(Color.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.gray)
                                .opacity(0.65)
                        }
                    }
                    
                    Button(action: {
                        //Reset Database values
                        for i in 1...workoutData.count {
                            let initialiseDB = TBL_WO_Pref(context: self.moc)
                            initialiseDB.pref = 1
                            initialiseDB.workoutID = Int16(i)
                            
                            try? self.moc.save()
                        }
                        for i in 0..<self.practices.count {
                            self.moc.delete(self.practices[i])
                        }
                        self.moc.delete(self.countdown[0])
                        let cd = Countdown(context: self.moc)
                        cd.countdown = Int16(10)
                        try? self.moc.save()
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("Reset").foregroundColor(Color.red)
                            Spacer()
                        }
                    }
                }
            }.navigationBarTitle(Text("Preferences").foregroundColor(Color("font")), displayMode: .inline)
                
                // Back to HomeView Button
                .navigationBarItems(leading: Button(action: {
                    self.moc.delete(self.countdown[0])
                    let cd = Countdown(context: self.moc)
                    cd.countdown = Int16(self.count)
                    
                    self.moc.delete(self.level[0])
                    let lvl = FitnessLevel(context: self.moc)
                    lvl.level = Int16(self.fitnessLevel)
                    
                    try? self.moc.save()
                    
                    self.selected = "Home"
                }) {
                    Image(systemName: "arrowshape.turn.up.left").resizable()
                        .frame(width: 25, height: 25, alignment: .leading)
                        .foregroundColor(Color("font"))
                })
        }.onAppear {
            self.fitnessLevel = Int(self.level[0].level)
        }
    }
}

struct PrefsView_Previews: PreviewProvider {
    static var previews: some View {
        PrefsView(selected: Binding.constant("Prefs"), countdown: Int16(10), prefs: Binding.constant([]))
    }
}

struct LabelView: View {
    var text: String
    var imagename: String
    
    var body: some View {
        HStack {
            Image(systemName: imagename)
            Text(text)
        }
    }
}
