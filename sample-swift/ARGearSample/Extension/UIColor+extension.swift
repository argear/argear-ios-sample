//
//  UIColor+extension.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/29.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit

extension UIColor {
    
    func getImage() -> UIImage {
        
        let imageRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(imageRect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(imageRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
