//
//  FinishedView.swift
//  SoFit
//
//  Created by Jonas Barth on 28.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct FinishedView: View {
    @Binding var selected: String
    @Binding var practice: [Workout]
    @Binding var levelup: Bool
    
    @State var activeImageIndex: Int = 0
    
    private let imageSwitchTimer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    private let lvlUpFinished = Timer.publish(every: 16, on: .main, in: .common).autoconnect()
    
    init(selected: Binding<String>, practice: Binding<[Workout]>, lvlUp: Binding<Bool>) {
        self._selected = selected
        self._practice = practice
        self._levelup = lvlUp
    }
    
    var body: some View {
        ZStack {
            if levelup {
                VStack {
                    Text("Level Up")
                        .foregroundColor(Color("font"))
                        .font(.system(size: 34))
                        .fontWeight(.heavy)
                        .padding(.top, 24)
                    
                    Image("level_up_\(activeImageIndex + 1)")
                        .onReceive(imageSwitchTimer, perform: { _ in
                            self.activeImageIndex = (self.activeImageIndex + 1) % 31
                        })
                        .onReceive(lvlUpFinished, perform: { _ in
                            self.levelup = false
                        })
                }
            } else {
                NavigationView {
                    VStack {
                        Text("Completed")
                            .foregroundColor(Color("font"))
                            .font(.system(size: 34))
                            .fontWeight(.heavy)
                            .padding(.top, 24)
                        
                        VStack(spacing: -160) {
                            ForEach((0..<self.practice.count), id: \.self) { i in
                                WorkoutRowView(practice: self.$practice, workout: self.practice[i], finished: true)
                            }
                        }.offset(y: -80)
                        
                    }
                    .navigationBarTitle(Text("Finished").foregroundColor(Color("font")), displayMode: .inline)
                    .navigationBarItems(leading: Button(action: {self.selected = "Home"}) {
                        Image(systemName: "arrowshape.turn.up.left").resizable()
                            .frame(width: 25, height: 25, alignment: .leading)
                            .foregroundColor(Color("font"))
                    })
                }
            }
        }
    }
}

struct FinishedView_Previews: PreviewProvider {
    static var previews: some View {
        FinishedView(selected: Binding.constant("Finish"), practice: Binding.constant([workoutData[0], workoutData[1], workoutData[2], workoutData[3], workoutData[4]]), lvlUp: Binding.constant(true))
    }
}
