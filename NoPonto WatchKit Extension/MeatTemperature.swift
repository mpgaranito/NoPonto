//
//  MeatTemperature.swift
//  NoPonto WatchKit Extension
//
//  Created by Usuário Convidado on 31/08/19.
//  Copyright © 2019 GARANITO ME. All rights reserved.
//

import Foundation

enum MeatTemperature: Int {
    case rare = 0, mediumRare, medium, wellDone
    
    var stringValue: String {
        let temperatures = ["Cru", "Mal passado", "Ao ponto", "Bem passado"]
        return temperatures[self.rawValue]
    }
    
    var timeModifier: Double {
        let modifiers = [0.5, 0.75, 1.0, 1.5]
        return modifiers[self.rawValue]
    }
    
    func cookTimeForKg(_ kg: Double) -> TimeInterval {
        let baseTime: TimeInterval = 1.3 * 60
        let baseWeight = 0.5
        let weightModifier: Double = kg/baseWeight
        let tempModifier = self.timeModifier
        return baseTime * weightModifier * tempModifier
    }
}
