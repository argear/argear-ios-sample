//
//  ARGBottomFunctionBaseView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/21.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

@IBDesignable
class ARGBottomFunctionBaseView: UIView {
    
    @IBInspectable var topGradientColor: UIColor = .clear
    @IBInspectable var bottomGradientColor: UIColor = .clear
    
    var gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set gradient
        gradient.frame = self.bounds
        gradient.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
    }
    
    func open() {
        self.isHidden = false
    }
    
    func close() {
        self.isHidden = true
    }
    
    func setRatio(_ ratio: ARGMediaRatio) {
        self.tag = ratio.rawValue
        
        if ratio == ARGMediaRatio._16x9 {
            self.layer.insertSublayer(gradient, at: 0)
            self.backgroundColor = .clear
        } else {
            gradient.removeFromSuperlayer()
            self.backgroundColor = .white
        }
    }
}
