//
//  BeautyManager.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/10.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import Foundation
import ARGear

class BeautyManager {
    static let shared = BeautyManager()
    
    private var beautyValues: [Float] = Array(repeating: 0, count: ARGContentItemBeauty.num.rawValue)
    
    var argSession: ARGSession?
    var beautyRange200Array: [ARGContentItemBeauty] = [
        .chin,
        .eyeGap,
        .noseLength,
        .mouthSize,
        .eyeCorner,
        .lipSize
    ]
    
    init() {
        self.loadBeautyValue()
    }
    
    public func start() {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        contents.setBulge(.NONE)
        contents.setDefaultBeauty()
    }
    
    public func setDefault() {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        contents.setDefaultBeauty()
    }
    
    public func off() {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        self.loadBeautyValue()
        
        contents.setBeautyOn(false)
    }
    
    public func on() {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        let beautyValuePointer: UnsafeMutablePointer<Float> = UnsafeMutablePointer(&self.beautyValues)
        
        contents.setBeautyValues(beautyValuePointer)
    }
    
    public func setBeauty(type: ARGContentItemBeauty, value: Float) {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        let value = self.convertSliderValueToBeautyValue(type: type, value: value)
        
        contents.setBeauty(type, value: value)
    }
    
    public func getBeautyValue(type: ARGContentItemBeauty) -> Float {
        guard let session = self.argSession, let contents = session.contents
            else { return 0 }
        
        let value = contents.getBeautyValue(type)
        
        return self.convertBeautyValueToSliderValue(type: type, value: value)
    }
    
    // load current ARGear's beauty values
    private func loadBeautyValue() {
        guard let session = self.argSession, let contents = session.contents
            else { return }

        for i in 0..<ARGContentItemBeauty.num.rawValue {
            self.beautyValues[i] = contents.getBeautyValue(ARGContentItemBeauty(rawValue: i)!)
        }
    }
    
    // 0 ~ 1 -> 0 ~ 100 or -100 ~ 100
    private func convertSliderValueToBeautyValue(type: ARGContentItemBeauty, value: Float) -> Float {
        var beautyValue = value
        if value < 0 {
            beautyValue = 0.0;
        }
        
        if value > 1 {
            beautyValue = 1.0;
        }
        
        if beautyRange200Array.contains(type) {
            beautyValue = (value * 200.0) - 100.0
        } else {
            beautyValue = value * 100.0
        }
        
        return beautyValue
    }
    
    // 0 ~ 100 or -100 ~ 100 -> 0 ~ 1
    private func convertBeautyValueToSliderValue(type: ARGContentItemBeauty, value: Float) -> Float {
        var beautyValue = value
        if beautyRange200Array.contains(type) {
            beautyValue = (value + 100.0) / 200.0
        } else {
            beautyValue = value / 100.0
        }
        
        return beautyValue
    }
}
