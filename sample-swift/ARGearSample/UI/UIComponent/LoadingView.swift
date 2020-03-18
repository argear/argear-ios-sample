//
//  LoadingView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/04.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit

let ARGLoading = Loading.shared

class Loading {
    static let shared = Loading()
    
    let imageCount = 90
    
    let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
    let backgroundViewSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    let background43RatioViewSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width * 4)/3)
    let roundViewSize = CGSize(width: 120.0, height: 120.0)
    let animationImageSize = CGSize(width: 120.0, height: 120.0)
    let animationTime = 2.5

    let screenRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
    
    private var backgroundView: UIView = UIView()
    private var background43RatioView: UIView = UIView()
    private var roundView: UIView = UIView()
    private var loadingAnimationImageView: UIImageView = UIImageView()
    private var isReady: Bool = false
    
    private var safeAreaTopAnchor: CGFloat = 0
    
    init() {
        self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: backgroundViewSize.width, height: backgroundViewSize.height))
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView.backgroundColor = .clear
        self.backgroundView.isUserInteractionEnabled = true
        
        if #available(iOS 11.0, *) {
            if let topInset = rootView?.safeAreaInsets.top {
                safeAreaTopAnchor = topInset
            }
        }
        
        if screenRatio > 2.0 {
            safeAreaTopAnchor += 64.0
        }
        
        self.background43RatioView = UIView(frame: CGRect(x: 0, y: safeAreaTopAnchor, width: background43RatioViewSize.width, height: background43RatioViewSize.height))
        self.background43RatioView.backgroundColor = .clear
        self.backgroundView.addSubview(self.background43RatioView)
        
        self.roundView = UIView(frame: CGRect(x: background43RatioViewSize.width/2 - roundViewSize.width/2, y: background43RatioViewSize.height/2 - roundViewSize.height/2, width: roundViewSize.width, height: roundViewSize.height))
        self.roundView.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        self.roundView.layer.cornerRadius = roundViewSize.width/2
        self.roundView.layer.masksToBounds = true
        self.background43RatioView.addSubview(self.roundView)

        self.loadingAnimationImageView = UIImageView(frame: CGRect(x: background43RatioViewSize.width/2 - animationImageSize.width/2, y: background43RatioViewSize.height/2 - animationImageSize.height/2, width: animationImageSize.width, height: animationImageSize.height))
        self.loadingAnimationImageView.backgroundColor = .clear
        self.loadingAnimationImageView.layer.cornerRadius = animationImageSize.width/2
        self.loadingAnimationImageView.layer.masksToBounds = true
        self.background43RatioView.addSubview(self.loadingAnimationImageView)
    }
    
    func prepare() {
        if self.isReady {
            return
        }
     
        DispatchQueue.global(qos: .default).async {
            var images = Array<UIImage>()
            
            for i in 0..<self.imageCount {
                if let image = UIImage(named: String(format: "%04d", i)) {
                    images.append(image)
                }
            }
            
            DispatchQueue.main.async {
                self.loadingAnimationImageView.image = UIImage(named: "0001")
                self.loadingAnimationImageView.animationImages = images
                self.loadingAnimationImageView.animationDuration = self.animationTime
                self.loadingAnimationImageView.animationRepeatCount = 0
            }
            
            self.isReady = true
        }
    }
    
    func show() {
        DispatchQueue.main.async {
            self.rootView?.addSubview(self.backgroundView)
            self.loadingAnimationImageView.startAnimating()
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.backgroundView.removeFromSuperview()
            self.loadingAnimationImageView.stopAnimating()
            self.loadingAnimationImageView.image = UIImage(named: "0001")
        }
    }
}
