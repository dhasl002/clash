//
//  Troop.swift
//  ARPersistence
//
//  Created by DevinHaslam on 2/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import ARKit

class Troop {
    
    var health = 100.0
    var position: SCNVector3!
    var attackPower: Double!
    var attackSpeed: Double!
    let visualModelPath: String
    
    init(_ newPosition: SCNVector3, _ newAttackPower: Double, _ newAttackSpeed: Double, _ newVisualModelPath: String) {
        position = newPosition
        attackPower = newAttackPower
        attackSpeed = newAttackSpeed
        visualModelPath = newVisualModelPath
    }
}
