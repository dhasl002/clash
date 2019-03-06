//
//  BuilderHut.swift
//  ARPersistence
//
//  Created by DevinHaslam on 2/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import ARKit

class BuilderHut: Building {
    
    var working = false
    var timeToFinishWork = 0.0
    var startingHealth = 100.0
    let visualModelPath = Bundle.main.url(forResource: "barn", withExtension: "scn", subdirectory: "Assets.scnassets")
    
    init(_ newPosition: SCNVector3) {
        super.init(newPosition, startingHealth, visualModelPath!)
    }
    
    func startWorking() {
        working = true
    }
    
    func stopWorking() {
        working = false
    }
}
