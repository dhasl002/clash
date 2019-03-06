//
//  Building.swift
//  ARPersistence
//
//  Created by DevinHaslam on 2/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import ARKit
import Foundation

class Building {
    var position: SCNVector3!
    var currentHealth: Double!
    var visualModelURL: URL!
    var level = 0
    
    init(_ newPosition: SCNVector3, _ newHealth: Double, _ newVisualModelPath: URL) {
        position = newPosition
        currentHealth = newHealth
        visualModelURL = newVisualModelPath
    }
    
    private func setLevel(_ newLevel: Int) {
        level = newLevel
    }
}
