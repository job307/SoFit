//
//  ContentView.swift
//  SoFit
//
//  Created by Jonas Barth on 11.05.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(entity: Countdown.entity(), sortDescriptors: []) var countdown: FetchedResults<Countdown>
    
    @State var practice: [Workout] = []
    @State var selected = "Home"
    @State var prefsFromList: [[Double]] = []
    @State var lvlUp: Bool = false
    
    var body: some View {
        ZStack {
            
            //Show Home Page
            if self.selected == "Home" {
                HomeView(selected: $selected, practice: $practice)
            //Show Gym Page
            }else if self.selected == "Gym" {
                GymView(selected: $selected, practice: $practice)
            //Show Statistic Page
            }else if self.selected == "Stats" {
                StatsView(selected: $selected)
            //Show Rating Page
            }else if self.selected == "Rating" {
                PrefListView(selected: $selected, prefs: $prefsFromList)
            //Show Preferences Page
            } else if self.selected == "Prefs" {
                PrefsView(selected: $selected, countdown: self.countdown.count == 0 ? Int16(10) : self.countdown[0].countdown, prefs: $prefsFromList)
                // Countdown 1
            } else if self.selected == "Countdown1" {
                CountdownView(workout: self.practice[0], countdown: self.countdown.count == 0 ? Int16(10) : self.countdown[0].countdown, selected: $selected, nextOne: "Workout1")
                // Workout 1
            } else if self.selected == "Workout1" {
                WorkoutView(workout: self.practice[0],selected: $selected, nextOne: "Countdown2", lvlUp: $lvlUp)
                // Countdown 2
            } else if self.selected == "Countdown2" {
                CountdownView(workout: self.practice[1], countdown: self.countdown.count == 0 ? Int16(10) : self.countdown[0].countdown, selected: $selected, nextOne: "Workout2")
                // Workout 2
            } else if self.selected == "Workout2" {
                WorkoutView(workout: self.practice[1], selected: $selected, nextOne: "Countdown3", lvlUp: $lvlUp)
                // Countdown 3
            } else if self.selected == "Countdown3" {
                CountdownView(workout: self.practice[2], countdown: self.countdown.count == 0 ? Int16(10) : self.countdown[0].countdown, selected: $selected, nextOne: "Workout3")
                // Workout 3
            } else if self.selected == "Workout3" {
                WorkoutView(workout: self.practice[2], selected: $selected, nextOne: "Countdown4", lvlUp: $lvlUp)
                // Countdown 4
            } else if self.selected == "Countdown4" {
                CountdownView(workout: self.practice[3], countdown: self.countdown.count == 0 ? Int16(10) : self.countdown[0].countdown, selected: $selected, nextOne: "Workout4")
                // Workout 4
            } else if self.selected == "Workout4" {
                WorkoutView(workout: self.practice[3], selected: $selected, nextOne: "Countdown5", lvlUp: $lvlUp)
                // Countdown 5
            } else if self.selected == "Countdown5" {
                CountdownView(workout: self.practice[4], countdown: self.countdown.count == 0 ? Int16(10) : self.countdown[0].countdown, selected: $selected, nextOne: "Workout5")
                // Workout 5
            } else if self.selected == "Workout5" {
                WorkoutView(workout: self.practice[4], selected: $selected, nextOne: "Finish", lvlUp: $lvlUp)
                // Finish
            } else if self.selected == "Finish" {
                FinishedView(selected: $selected, practice: $practice, lvlUp: $lvlUp)
            }
        }
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
}
