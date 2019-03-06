//
//  GoldMine.swift
//  ARPersistence
//
//  Created by DevinHaslam on 2/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import ARKit

class GoldMine: Building {
    
    var amountOfGoldPerSecond = 0.1
    var startingHealth = 100.0
    let visualModePath = Bundle.main.url(forResource: "barn", withExtension: "scn", subdirectory: "Assets.scnassets")
    
    init(_ newPosition: SCNVector3) {
        super.init(newPosition, startingHealth, visualModePath!)
    }
    
}
