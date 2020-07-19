//
//  Workout.swift
//  SoFit
//
//  Created by Jonas Barth on 02.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct Workout: Codable, Identifiable {
        
    enum Motion: String, CaseIterable, Codable, Hashable {
        case Cardio = "cardio"
        case Strength = "strength"
    }
    
    var id: Int
    var name: String
    var clips: [String]
    var clipDuration: Double
    var level: Double
    var duration: Double
    var repetition: Double
    var bodypart: Bodypart
    var motion: Motion
}

enum Bodypart: String, CaseIterable, Codable, Hashable {
    case Chest = "chest"
    case Back = "back"
    case Abs = "abs"
    case Glutes = "glutes"
    case Quads = "quads"
}
