//
//  BulgeManager.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/10.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import Foundation
import ARGear

class BulgeManager {
    static let shared = BulgeManager()
    
    var argSession: ARGSession?
    
    init() {
    }
    
    public func on() {
    }
    
    public func off() {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        contents.setBulge(.NONE)
    }
    
    public func setFunMode(_ mode: ARGContentItemBulge) {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        contents.setBulge(mode)
    }
}
