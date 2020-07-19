//
//  ExerciseView.swift
//  SoFit
//
//  Created by Jonas Barth on 02.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct WorkoutView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: TBL_Practice.entity(), sortDescriptors: []) var practices: FetchedResults<TBL_Practice>
    @FetchRequest(entity: FitnessLevel.entity(), sortDescriptors: []) var level: FetchedResults<FitnessLevel>
    
    @State private var activeImageIndex = 0
    @State private var fillCircle: CGFloat = 0
    @State private var count = 30
    @State private var pause = false
    @State private var fitnesslvl: FitnessClass = fitnessClassData[0]
    
    @Binding var maxCount: Int
    @Binding var selected: String
    @Binding var lvlUp: Bool
    
    private var workout: Workout
    private var nextOne: String
    private let clockTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var imageSwitchTimer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    
    init(workout: Workout, selected: Binding<String>, nextOne: String, lvlUp: Binding<Bool>) {
        self.nextOne = nextOne
        self._selected = selected
        self.workout = workout
        self._lvlUp = lvlUp
        self._maxCount = Binding.constant(Int(workout.clipDuration * workout.repetition * Double(workout.clips.count)))
        self._count = State(initialValue: Int(workout.clipDuration * workout.repetition * Double(workout.clips.count)))
        self.imageSwitchTimer = Timer.publish(every: workout.clipDuration, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        VStack {
            // Show Countdown
            ZStack {
                // Empty Circle in Background
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .padding(.top, 25)
                
                // Circle filling over time
                Circle()
                    .trim(from: 0, to: self.fillCircle)
                    .stroke(Color("font"), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.init(degrees: -90))
                    .padding(.top, 25)
                
                // Shown Countdown as a Number
                Text("\(self.count)")
                    .font(.system(size: 55))
                    .fontWeight(.bold)
                    .padding(.top, 25)
                
            }.onReceive(self.clockTimer) { _ in
                // If Pause selected ignore this
                if !self.pause {
                    
                    // Fill Circle per Secend
                    if self.count != 0 {
                        self.count -= 1
                        withAnimation(.default) {
                            self.fillCircle = 1 - (CGFloat(self.count) / CGFloat(self.maxCount))
                        }
                    // Countdown = 0
                    } else {
                        self.count = self.maxCount
                        withAnimation(.default) {
                            self.fillCircle = 0
                        }
                        
                        // Save workout history (DB)
                        let mdWorkout: Workout = workoutData[self.workout.id - 1]
                        var todaysWorkouts: [TBL_Practice] = []
                        var Prc: Double = 0
                        var userFitness: Double = self.fitnesslvl.percentage
                        
                        // Save all todays Workouts to Array
                        for i in 0..<self.practices.count {
                            if Calendar.current.isDateInToday(self.practices[i].timestamp!) {
                                todaysWorkouts.append(self.practices[i])
                            }
                        }
                        
                        // Sum Percentage of todays Workouts
                        for i in 0..<todaysWorkouts.count {
                            Prc += todaysWorkouts[i].actLvl
                        }
                        
                        // Needed when table is empty; else if there are no Workouts done today use "newScore" from latest entry; else use "userFitness" from latest entry
                        if self.practices.count != 0 {
                            userFitness = todaysWorkouts.count == 0 ? self.practices[self.practices.count - 1].newScore : self.practices[self.practices.count - 1].userFitness
                        }
                        
                        // Extracted Values needed to fill Practice Obj to save it in DB
                        let avgPrc = Prc / (Double(todaysWorkouts.count) == 0 ? 1 : Double(todaysWorkouts.count))
                        let newScore = self.fitnesslvl.percentage + avgPrc * self.fitnesslvl.progress
                        let newFitid = Int16(self.returnFitID(score: Int(newScore)))
                        
                        // If FitId changes, play dance moves on FinishedView to celebrate Level Up
                        if self.practices.count != 0{
                            if self.practices[self.practices.count - 1].newFitId < newFitid {
                                self.lvlUp = true
                            }
                        }
                        
                        if newFitid != self.level[0].level {
                            let lvl = FitnessLevel(context: self.moc)
                            lvl.level = newFitid
                            
                            try? self.moc.save()
                        }
                        
                        // Fill Practice Obj for DB
                        let currentWorkout = TBL_Practice(context: self.moc)
                        currentWorkout.actDur = self.workout.repetition * self.workout.clipDuration * Double(self.workout.clips.count)
                        currentWorkout.actLvl = self.workout.repetition / mdWorkout.repetition
                        currentWorkout.actReps = self.workout.repetition
                        currentWorkout.avgPrc = avgPrc
                        currentWorkout.defReps = (self.fitnesslvl.percentage * mdWorkout.level * 1.01).rounded(.up)
                        currentWorkout.newScore = newScore
                        currentWorkout.newFitId = newFitid
                        currentWorkout.timestamp = Calendar.current.date(byAdding: .day, value: 0, to: Date())
                        currentWorkout.userFitness = userFitness
                        currentWorkout.id = Int16(self.practices.count + 1)
                        currentWorkout.userID = 1
                        currentWorkout.workoutID = Int16(self.workout.id)
                        
                        try? self.moc.save()
                        
                        self.selected =  self.nextOne
                    }
                }
            }
            
            // Text changeing after 5 sec to Workout name
            Text(self.maxCount - self.count <= 5 ? "Go" : self.workout.name)
                .font(.system(size: self.maxCount - self.count <= 5 ? 40 : 30))
                .fontWeight(.heavy)
                .padding(.top, self.maxCount - self.count <= 5 ? 20 : 39)
                .foregroundColor(Color.black)
            
            Spacer()
            
            // Changeing Images after several sec to "animate" Workout
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
        }.onAppear {
            self.fitnesslvl = fitnessClassData[Int(self.level[0].level)]
        }
    }
    
    func returnFitID (score: Int) -> Int {
        var fitID = 0
        for i in 0..<fitnessClassData.count {
            if Double(score) >= fitnessClassData[i].percentage {
                fitID = fitnessClassData[i].id
            }
        }
        return fitID
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: workoutData[13], selected: Binding.constant("Countdown1"), nextOne: "Workout1", lvlUp: Binding.constant(false))
    }
}
