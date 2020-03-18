//
//  UIImage+extension.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/04.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit

let BUTTON_HIGHLIGHTED_ALPHA: CGFloat = 0.5

extension UIImage {
    
    func withAlpha(_ alpha: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)

        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -area.size.height)

        context?.setBlendMode(.multiply)
        context?.setAlpha(alpha)
        context?.draw(self.cgImage!, in: area)

        let alphaImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        return alphaImage!;
    }
}
