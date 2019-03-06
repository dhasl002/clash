//
//  Landscape.swift
//  ARPersistence
//
//  Created by DevinHaslam on 2/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

class Landscape {
    var currentBuildings = [Building]()
    var currentPlanes = [Plane]()
    
    init(_ newPlanes: [Plane]) {
        currentPlanes = newPlanes
    }
}
