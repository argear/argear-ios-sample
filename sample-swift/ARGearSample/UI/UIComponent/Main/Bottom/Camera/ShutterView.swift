//
//  ShutterView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/30.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class ShutterView: UIView {
    
    // Full
    let kShutterViewFullBorderColor = UIColor.white.cgColor
    let kShutterViewFullFillColor = UIColor.white.withAlphaComponent(0.3).cgColor
    let kShutterViewFullInnerCircleColor = UIColor.white.cgColor
    // 4:3, 1:1
    let kShutterViewPinkBorderColor = UIColor(red: 48.0/255.0, green: 99.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
    let kShutterViewPinkFillColor = UIColor(red: 48.0/255.0, green: 99.0/255.0, blue: 230.0/255.0, alpha: 0.3).cgColor
    let kShutterViewPinkInnerCircleColor = UIColor(red: 48.0/255.0, green: 99.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
    
    var mode: ARGMediaMode = .photo
    
    var circleLayer: CAShapeLayer?
    var innerCircleLayer: CAShapeLayer?
    var progressLayer: CAShapeLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // base circle
        self.circleLayer = CAShapeLayer()
        if let circleLayer = self.circleLayer {
            circleLayer.path = UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: 61, height: 61)).cgPath
            circleLayer.lineWidth = 6
            circleLayer.strokeColor = kShutterViewPinkBorderColor
            circleLayer.fillColor = kShutterViewPinkFillColor
            circleLayer.shadowColor = UIColor(red: 97.0/255.0, green: 97.0/255.0, blue: 97.0/255.0, alpha: 0.16).cgColor
            circleLayer.shadowOpacity = 0.5
            circleLayer.shadowOffset = CGSize(width: 0.1, height: 0.1)
            circleLayer.masksToBounds = false

            self.layer.addSublayer(circleLayer)
        }
        
        let arcCenter = CGPoint(x: self.bounds.midY, y: self.bounds.midX)
        
        // inner circle
        self.innerCircleLayer = CAShapeLayer()
        if let innerCircleLayer = self.innerCircleLayer {
            let innerPath = UIBezierPath(arcCenter: arcCenter, radius: 6.75, startAngle: -.pi/2, endAngle: .pi + .pi/2, clockwise: true)
            innerCircleLayer.path = innerPath.cgPath
            innerCircleLayer.lineWidth = 13.5
            innerCircleLayer.strokeColor = UIColor.clear.cgColor
            innerCircleLayer.fillColor = UIColor.clear.cgColor
            
            self.layer.addSublayer(innerCircleLayer)
        }
        
        // progress circle
        self.progressLayer = CAShapeLayer()
        if let progressLayer = self.progressLayer {
            let progressPath = UIBezierPath(arcCenter: arcCenter, radius: 30.5, startAngle: -.pi/2, endAngle: .pi + .pi/4, clockwise: true)
            progressLayer.path = progressPath.cgPath
            progressLayer.lineWidth = 6
            progressLayer.strokeColor = UIColor(red: 255.0/255.0, green: 202.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
            progressLayer.fillColor = UIColor.clear.cgColor
        }
        
        self.setRatio(ARGMediaRatio(rawValue: self.tag) ?? ._4x3)
    }
    
    func setRatio(_ ratio: ARGMediaRatio) {
        
        guard let circleLayer = self.circleLayer, let innerCircleLayer = self.innerCircleLayer
            else { return }
        
        if ratio == ._16x9 {
            circleLayer.strokeColor = kShutterViewFullBorderColor
            circleLayer.fillColor = kShutterViewFullFillColor
            
            if mode == .video {
                innerCircleLayer.strokeColor = kShutterViewFullInnerCircleColor
            }
        } else {
            circleLayer.strokeColor = kShutterViewPinkBorderColor
            circleLayer.fillColor = kShutterViewPinkFillColor
            
            if mode == .video {
                innerCircleLayer.strokeColor = kShutterViewPinkInnerCircleColor
            }
        }
    }
    
    func setShutterMode(_ mode: ARGMediaMode) {
        switch mode {
        case .photo:
            self.setPhotoMode()
        case .video:
            self.setVideoMode()
        default:
            return
        }
    }
    
    func setPhotoMode() {
        self.mode = .photo
        
        if let innercircleLayer = self.innerCircleLayer {
            innercircleLayer.strokeColor = UIColor.clear.cgColor
        }
    }
    
    func setVideoMode() {
        self.mode = .video
        
        guard let circleLayer = self.circleLayer, let innerCircleLayer = self.innerCircleLayer
            else { return }
        
        innerCircleLayer.strokeColor = (circleLayer.strokeColor == kShutterViewFullBorderColor) ? kShutterViewFullInnerCircleColor : kShutterViewPinkInnerCircleColor
    }
}
