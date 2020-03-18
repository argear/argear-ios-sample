//
//  ARGPreferences.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/29.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import Foundation


class ARGPreferences {
    
    let kARGPreferencesShowLandmark = "kARGPreferencesShowLandmark"
    let kARGPreferencesVideoBitrate = "kARGPreferencesVideoBitrate"

    var showLandmark: Bool = false
    var videoBitrate: NSInteger = 0
    
    init() {
        self.showLandmark = self.loadBoolValue(kARGPreferencesShowLandmark)
        self.videoBitrate = self.loadIntegerValue(kARGPreferencesVideoBitrate)
    }

    // load
    func loadBoolValue(_ key: String) -> Bool {
        
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: key)
    }

    func loadIntegerValue(_ key: String) -> NSInteger {
        
        let userDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: key)
    }

    // store
    func storeBoolValue(_ value: Bool, key: String) {
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }

    func storeIntegerValue(_ value: NSInteger, key: String) {
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }

    func setShowLandmark(_ showLandmark: Bool) {
        
        self.showLandmark = showLandmark
        self.storeBoolValue(showLandmark, key: kARGPreferencesShowLandmark)
    }

    func setVideoBitrate(_ videoBitrate: NSInteger) {
        
        self.videoBitrate = videoBitrate
        self.storeIntegerValue(videoBitrate, key: kARGPreferencesVideoBitrate)
    }
}
