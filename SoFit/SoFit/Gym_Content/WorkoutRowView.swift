//
//  ExerciseCountView.swift
//  SoFit
//
//  Created by Jonas Barth on 14.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct WorkoutRowView: View {
    @Binding var practice: [Workout]
    @State var workout: Workout
    var finished: Bool
    
    var body: some View {
        ZStack {
            
            // Rows background shape
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .shadow(color: Color("font").opacity(0.5), radius: 3, x: 3, y: 2)
                .frame(width: UIScreen.main.bounds.width - 32, height: 75, alignment: .center)
            
            GeometryReader { geo in
                HStack(alignment: .center) {
                    Text("\(self.workout.name)").font(.system(size: 21))
                        .frame(width: geo.size.width*0.57, alignment: .leading)
                        .foregroundColor(Color("font"))
                        .padding(.leading)
                    
                    GeometryReader { g in
                        HStack {
                            
                            // Reduce workouts repetition
                            Button(action: {
                                if !self.finished {
                                    var index = -1
                                    if index < 0 {
                                        for i in 0..<self.practice.count {
                                            if self.practice[i].name == self.workout.name {
                                                index = i
                                            }
                                        }
                                    }
                                    self.workout.repetition -= 1
                                    self.practice[index].repetition -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .resizable()
                                    .frame(width: g.size.width*0.2, height: g.size.width*0.2)
                                    .foregroundColor(self.finished ? Color.white : Color("font"))
                            }
                            
                            // Actual workouts repetition
                            Text("\(Int(self.workout.repetition))")
                                .frame(width: g.size.width*0.3)
                                .foregroundColor(Color("font"))
                                .font(.system(size: 21))
                            
                            // Increase workouts repetition
                            Button(action: {
                                if !self.finished {
                                    var index = -1
                                    if index < 0 {
                                        for i in 0..<self.practice.count {
                                            if self.practice[i].name == self.workout.name {
                                                index = i
                                            }
                                        }
                                    }
                                    self.workout.repetition += 1
                                    self.practice[index].repetition += 1
                                }
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: g.size.width*0.2, height: g.size.width*0.2)
                                    .foregroundColor(self.finished ? Color.white : Color("font"))
                            }
                        }.padding(.trailing)
                    }
                }.fixedSize(horizontal: false, vertical: true)
            }
        }.padding([.leading, .trailing])
    }
}

struct WorkoutRowView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRowView(practice: Binding.constant([workoutData[0], workoutData[1], workoutData[2], workoutData[3], workoutData[4]]), workout: workoutData[13], finished: false)
    }
}
