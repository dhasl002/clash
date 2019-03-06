//
//  ElixerMine.swift
//  ARPersistence
//
//  Created by DevinHaslam on 2/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import ARKit

class ElixerMine: Building {
    
    var amountOfElixerPerSecond = 0.1
    var startingHealth = 100.0
    let visualModelPath = Bundle.main.url(forResource: "barn", withExtension: "scn", subdirectory: "Assets.scnassets")
    
    init(_ newPosition: SCNVector3) {
        super.init(newPosition, startingHealth, visualModelPath!) 
    }
}
