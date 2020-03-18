//
//  NSString+extension.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/28.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func appendLanguageCode() -> String {
        
        var code = ""
        if #available(iOS 10.0, *) {
            code = Locale.current.languageCode?.lowercased() ?? ""
        } else {
            code = Locale.preferredLanguages[0].prefix(2).lowercased()
        }
        
        var resultString = self
        if code == "ko" {
            resultString.append(code)
        } else {
            resultString.append("en")
        }
        
        return resultString
    }
}
