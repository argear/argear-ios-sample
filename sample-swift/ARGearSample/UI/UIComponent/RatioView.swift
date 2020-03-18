//
//  RatioView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/30.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

let kRatioViewTopBottomAlign169 = -44
let kRatioViewTopBottomAlign43 = 0
let kRatioViewTopBottomAlign11 = 64

let kRatioViewBottomViewTopAlign169 = 260
let kRatioViewBottomViewTopAlign43 = 0
let kRatioViewBottomViewTopAlign11 = -(UIScreen.main.bounds.size.width * 4/3 - UIScreen.main.bounds.size.width) + 64

typealias RatioViewCompletion = () -> Void

class RatioView: UIView {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var topViewBottomAlign: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTopAlign: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setRatio(ARGMediaRatio(rawValue: self.tag) ?? ._4x3)
    }
    
    func setRatio(_ ratio: ARGMediaRatio) {
        
        let screenRatio = UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width
        switch ratio {
        case ._16x9:
            var topViewBottomAlignConstant = 0
            if screenRatio > 2.0 {
                topViewBottomAlignConstant = kRatioViewTopBottomAlign169
            }
            self.animate({
                self.topViewBottomAlign.constant = CGFloat(topViewBottomAlignConstant)
                self.bottomViewTopAlign.constant = CGFloat(kRatioViewBottomViewTopAlign169)
            }) {
                self.bottomView.isHidden = true
            }
        case ._4x3:
            var topViewBottomAlignConstant = kRatioViewTopBottomAlign43
            var bottomViewTopAlignConstant = kRatioViewBottomViewTopAlign43
            if screenRatio > 2.0 {
                topViewBottomAlignConstant = kRatioViewTopBottomAlign11
                bottomViewTopAlignConstant = kRatioViewBottomViewTopAlign43 + 64
            }
            
            self.bottomView.isHidden = false
            self.animate({
                self.topViewBottomAlign.constant = CGFloat(topViewBottomAlignConstant)
                self.bottomViewTopAlign.constant = CGFloat(bottomViewTopAlignConstant)
            }, completion: nil)
        case ._1x1:
            self.bottomView.isHidden = false
            self.animate({
                self.topViewBottomAlign.constant = CGFloat(kRatioViewTopBottomAlign11)
                self.bottomViewTopAlign.constant = kRatioViewBottomViewTopAlign11
            }, completion: nil)
        default:
            break
        }
    }
    
    func blur(_ blur: Bool) {
        self.blurView.isHidden = !blur
    }
    
    private func animate(_ animate: @escaping RatioViewCompletion, completion: RatioViewCompletion?) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                animate()
                self.layoutIfNeeded()
            }) { complete in
                completion?()
                self.blur(false)
            }
        }
    }
}
