//
//  UIView+extension.swift
//  ARGearSample
//
//  Created by Jihye on 2020/03/19.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import Toast_Swift

extension UIView {
    func showToast(message: String, position: CGPoint) {
        var style = ToastStyle()
        style.messageFont = UIFont.systemFont(ofSize: 11)
        style.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        style.messageColor = UIColor.white.withAlphaComponent(0.75)
        style.cornerRadius = 16
        
        self.makeToast(message, duration: 1.5, point: position, title: nil, image: nil, style: style, completion: nil)
    }
}
