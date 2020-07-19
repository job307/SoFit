//
//  FitnessClass.swift
//  SoFit
//
//  Created by Jonas Barth on 02.06.20.
//  Copyright © 2020 Jonas Barth. All rights reserved.
//

import SwiftUI

struct FitnessClass: Codable, Identifiable {
    
    enum Level: String, Codable, CaseIterable, Hashable {
        case CoachPotato = "Couch Potato"
        case Rookie = "Rookie"
        case HobbyAthlet = "Hobby Athlet"
        case EliteAthlet = "Elite Athlet"
        case NavySeal = "Navy Seal"
        case Machine = "Machine"
    }
    
    var id: Int
    var name: Level
    var percentage: Double
    var progress: Double
}
