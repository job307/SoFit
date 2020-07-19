//
//  CountdownView.swift
//  SoFit
//
//  Created by Jonas Barth on 28.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct CountdownView: View {
    @State private var activeImageIndex = 0
    @State var fillCircle: CGFloat = 0
    @State var count = 30
    @State var pause: Bool = false
    @State var maxCount: Int
    
    @Binding var selected: String
    
    var workout: Workout
    var nextOne: String
    let clockTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var imageSwitchTimer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    
    init(workout: Workout, countdown: Int16, selected: Binding<String>, nextOne: String) {
        self.nextOne = nextOne
        self._selected = selected
        self.workout = workout
        self._maxCount = State(initialValue: Int(countdown))
        self._count = State(initialValue: Int(countdown))
        self.imageSwitchTimer = Timer.publish(every: workout.clipDuration, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        VStack {
            // Show Countdown
            ZStack {
                // Circle in background
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .padding(.top, 25)
                
                // Circle filling up over time
                Circle()
                    .trim(from: 0, to: self.fillCircle)
                    .stroke(Color("lightFont"), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.init(degrees: -90))
                    .padding(.top, 25)
                
                // Countdown as number
                Text("\(self.count)")
                    .font(.system(size: 55))
                    .fontWeight(.bold)
                    .padding(.top, 25)
                
            }.onReceive(self.clockTimer) { _ in
                // Ignore if pause = true
                if !self.pause {
                    // Fill Circle
                    if self.count != 0 {
                        self.count -= 1
                        withAnimation(.default) {
                            self.fillCircle = 1 - (CGFloat(self.count) / CGFloat(self.maxCount))
                        }
                    // Countdown = 0
                    }else {
                        self.count = self.maxCount
                        withAnimation(.default) {
                            self.fillCircle = 0
                        }
                        // Next CountdownView
                        self.selected =  self.nextOne
                    }
                }
            }
            // Changes after 5 sec to Workout name
            Text(self.maxCount - self.count <= 5 ? "Get Ready" : self.workout.name)
                .font(.system(size: self.maxCount - self.count <= 5 ? 40 : 30))
                .fontWeight(.heavy)
                .padding(.top, self.maxCount - self.count <= 5 ? 20 : 39)
                .foregroundColor(Color.black)
            
            Spacer()
            // Animates Image
            Image(self.workout.clips[activeImageIndex])
                .onReceive(imageSwitchTimer, perform: { _ in
                    self.activeImageIndex = (self.activeImageIndex + 1) % self.workout.clips.count
                })
                
            Spacer()
            HStack {
                // Back to Gym Button
                Button(action: {
                    self.selected = "Gym"
                }) {
                    BottomButton(systemname: "xmark.circle")
                }
                
                // Pause / Play Button
                Button(action: {
                    self.pause.toggle()
                }) {
                    BottomButton(systemname: self.pause ? "play.circle" : "pause.circle")
                }
                
                // Skip Button
                Button(action: {
                    self.selected =  self.nextOne
                }) {
                    BottomButton(systemname: "forward")
                }
            }
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(workout: workoutData[0], countdown: Int16(30), selected: Binding.constant("Countdown1"), nextOne: "Countdown2")
    }
}
