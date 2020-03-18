//
//  ModeSelectView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/30.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class ModeSelectView: UIView {
    
    let kModeSelectViewFullEnableColor = UIColor.white
    let kModeSelectViewFullDisableColor = UIColor.white.withAlphaComponent(0.5)
    let kModeSelectViewEnablePinkColor = UIColor(red: 48.0/255.0, green: 99.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    let kModeSelectViewDisableGrayColor = UIColor(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    
    @objc dynamic var mode: ARGMediaMode = .photo
    
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var pictureButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var videoButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var modeButtonsViewWidth: NSLayoutConstraint!

    @IBOutlet weak var modeButtonsView: UIView!
    @IBOutlet weak var modeButtonsViewTrailing: NSLayoutConstraint!

    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!

    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var underlineViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let photoString = "photo".localized()
        let videoString = "video".localized()
        
        self.pictureButton.setTitle(photoString, for: .normal)
        self.videoButton.setTitle(videoString, for: .normal)
        
        let photoStringSize = photoString.size(withAttributes: [.font: UIFont(name: "NotoSansKR-Regular", size: 13.0)!])
        let videoStringSize = videoString.size(withAttributes: [.font: UIFont(name: "NotoSansKR-Regular", size: 13.0)!])
        
        let viewWidth = 1.5 * photoStringSize.width + 1.5 * videoStringSize.width + 18 * 2 + 5 * 2 + 4
        self.viewWidth.constant = viewWidth
        
        self.pictureButtonWidth.constant = photoStringSize.width + 2
        self.videoButtonWidth.constant = videoStringSize.width + 2

        let modeButtonsViewWidth = self.pictureButtonWidth.constant + 18.0 + self.videoButtonWidth.constant
        self.modeButtonsViewWidth.constant = modeButtonsViewWidth
        
        self.underlineViewWidth.constant = self.pictureButtonWidth.constant + 10
    }
    
    func setRatio(_ ratio: ARGMediaRatio) {
        
        var underlineViewColor = kModeSelectViewEnablePinkColor
        if ratio == ._16x9 {
            underlineViewColor = kModeSelectViewFullEnableColor
        }
        self.underlineView.backgroundColor = underlineViewColor
        
        self.changeModeColor()
    }
    
    @IBAction func pictureButtonAction(_ sender: UIButton) {
        if self.mode == .video {
            self.changePhotoMode()
        }
    }
    
    @IBAction func videoButtonAction(_ sender: UIButton) {
        if self.mode == .photo {
            self.changeVideoMode()
        }
    }
    
    @IBAction func handleSwipeFrom(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .left {
            if self.mode == .photo {
                self.changeVideoMode()
            }
        } else if swipe.direction == .right {
            if self.mode == .video {
                self.changePhotoMode()
            }
        }
    }
    
    // change to photo mode
    func changePhotoMode() {
        self.mode = .photo
        
        let trailing = (self.pictureButton.title(for: .normal)?.lowercased() == "photo") ? 4 : 2
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.modeButtonsViewTrailing.constant = CGFloat(trailing)
            self.underlineViewWidth.constant = self.pictureButtonWidth.constant + 10
            
            self.changeModeColor()
            
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    // change to video mode
    func changeVideoMode() {
        self.mode = .video
        
        let halfPhotoWidth = self.pictureButtonWidth.constant/2
        let halfVideoWidth = self.videoButtonWidth.constant/2
        
        let trailing = (self.pictureButton.title(for: .normal)?.lowercased() == "photo") ? 2 : 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.modeButtonsViewTrailing.constant = 2 + halfPhotoWidth + 18 + halfVideoWidth + CGFloat(trailing)
            self.underlineViewWidth.constant = self.videoButtonWidth.constant + 10
            
            self.changeModeColor()
            
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func changeModeColor() {

        var picureButtonTitleColor: UIColor = .clear
        var videoButtonTitleColor: UIColor = .clear

        if self.underlineView.backgroundColor == kModeSelectViewFullEnableColor {
            // full
            if self.mode == .photo {
                picureButtonTitleColor = kModeSelectViewFullEnableColor
                videoButtonTitleColor = kModeSelectViewFullDisableColor
            } else {
                picureButtonTitleColor = kModeSelectViewFullDisableColor
                videoButtonTitleColor = kModeSelectViewFullEnableColor
            }
        } else {
            // 4:3, 1:1
            if self.mode == .photo {
                picureButtonTitleColor = kModeSelectViewEnablePinkColor
                videoButtonTitleColor = kModeSelectViewDisableGrayColor
            } else {
                picureButtonTitleColor = kModeSelectViewDisableGrayColor
                videoButtonTitleColor = kModeSelectViewEnablePinkColor
            }
        }
        
        self.pictureButton.setTitleColor(picureButtonTitleColor, for: .normal)
        self.videoButton.setTitleColor(videoButtonTitleColor, for: .normal)
    }
}
