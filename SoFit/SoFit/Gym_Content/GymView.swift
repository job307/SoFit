//
//  GymView.swift
//  SoFit
//
//  Created by Jonas Barth on 02.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct GymView: View {
    @Binding var selected: String
    @Binding var practice: [Workout]
    
    var body: some View {
        VStack{
            NavigationView {
                VStack {
                    Text("Today's Workout")
                    .foregroundColor(Color("font"))
                        .font(.system(size: 34))
                        .fontWeight(.heavy)
                        .padding(.top, 24)
                    
                    // Show the five Workouts in custom WorkoutRowView
                    VStack(spacing: -100) {
                        ForEach((0..<self.practice.count), id: \.self) { i in
                            WorkoutRowView(practice: self.$practice, workout: self.practice[i], finished: false)
                        }
                    }.offset(y: -55)
                // NavigationView parameters like Back Button
                }.navigationBarTitle(Text("Gym").foregroundColor(Color("font")), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {self.selected = "Home"}) {
                    Image(systemName: "arrowshape.turn.up.left").resizable()
                        .frame(width: 25, height: 25, alignment: .leading)
                        .foregroundColor(Color("font"))
                })
            }
            
            Button(action: {
                // Start Practice with first Workout
                self.selected = "Countdown1"
            }) {
                BottomButton(systemname: "play.circle")
            }
        }
        
    }
}

struct GymView_Previews: PreviewProvider {
    static var previews: some View {
        GymView(selected: Binding.constant("Gym"), practice: Binding.constant([workoutData[0], workoutData[1], workoutData[2], workoutData[3], workoutData[4]]))
    }
}

struct BottomButton: View {
    var systemname: String
    
    var body: some View {
        ZStack {
            
            // Special Button Form. Used during WorkoutView and CountdownView aswell
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .frame(width: 100, height: 60)
                .foregroundColor(Color(UIColor.systemGray6))
            
            Image(systemName: self.systemname).foregroundColor(Color("font")).font(.system(size: 45))
        }
    }
}
