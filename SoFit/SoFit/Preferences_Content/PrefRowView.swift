//
//  PrefRowView.swift
//  SoFit
//
//  Created by Jonas Barth on 27.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct PrefRowView: View {
    @Binding var prefs: [[Double]]
    @State var rating: Double = 1
    var workout: Workout
    
    init(workout: Workout, prefs: Binding<[[Double]]>) {
        self.workout = workout
        self._prefs = prefs
        self._rating = State(initialValue:
            self.prefs.first(where: { $0[0] == Double(workout.id) })?[1] ?? 1)
    }
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Color.gray).offset(x: 0, y: 2).opacity(0.2)
            Rectangle().foregroundColor(Color.white).offset(x: -380, y: 2)
            Rectangle().foregroundColor(Color.white)
            HStack(alignment: .center) {
                Text("\(self.workout.name)")
                    .padding(.leading, 30)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        
                        // Delete old Value if existing
                        if let index = self.prefs.firstIndex(of: [Double(self.workout.id), self.rating]) {
                            self.prefs.remove(at: index)
                        }
                        self.rating = 0.9
                        
                        // Append new Value
                        self.prefs.append([Double(self.workout.id), self.rating])
                    }) {
                        Text("☹️")
                            .font(.system(size: 25))
                            .opacity(self.rating == 0.9 ? 1 : 0.4)
                    }
                    
                    Button(action: {
                        
                        // Delete old Value if existing
                        if let index = self.prefs.firstIndex(of: [Double(self.workout.id), self.rating]) {
                            self.prefs.remove(at: index)
                        }
                        self.rating = 1
                        
                        // Append new Value
                        self.prefs.append([Double(self.workout.id), self.rating])
                    }) {
                        Text("😐")
                            .font(.system(size: 25))
                            .opacity(self.rating == 1 ? 1 : 0.4)
                    }
                    
                    Button(action: {
                        
                        // Delete old Value if existing
                        if let index = self.prefs.firstIndex(of: [Double(self.workout.id), self.rating]) {
                            self.prefs.remove(at: index)
                        }
                        self.rating = 1.1
                        
                        // Append new Value
                        self.prefs.append([Double(self.workout.id), self.rating])
                    }) {
                        Text("🤩")
                            .font(.system(size: 25))
                            .opacity(self.rating == 1.1 ? 1 : 0.4)
                    }.padding(.trailing, 35)
                }
            }
        }.frame(width: UIScreen.main.bounds.width, height: 45)
    }
}

struct PrefRowView_Previews: PreviewProvider {
    static var previews: some View {
        PrefRowView(workout: workoutData[13], prefs: Binding.constant([[14.0, 1.1]]))
    }
}
