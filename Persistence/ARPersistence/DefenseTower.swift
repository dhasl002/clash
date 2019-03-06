//
//  DefenseTower.swift
//  ARPersistence
//
//  Created by DevinHaslam on 2/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import ARKit

class DefenseTower: Building {
    
    var rateOfFire: Double!
    var damage: Double!
    
    init(_ newPosition: SCNVector3, _ newHealth: Double, _ newRateOfFire: Double, _ newDamage: Double, _ visualModelURL: URL) {
        super.init(newPosition, newHealth, visualModelURL)
        rateOfFire = newRateOfFire
        damage = newDamage
    }
}
