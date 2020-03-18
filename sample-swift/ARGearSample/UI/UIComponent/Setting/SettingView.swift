//
//  SettingView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/28.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit

protocol SettingDelegate: class {
    func autoSaveSwitchAction(_ sender: UISwitch)
    func faceLandmarkSwitchAction(_ sender: UISwitch)
    func bitrateSegmentedControlAction(_ sender: UISegmentedControl)
}

class SettingView: UIView {
    
    weak var delegate: SettingDelegate?
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var touchView: UIView!
    @IBOutlet weak var radiusView: UIView!

    @IBOutlet weak var menuViewLeading: NSLayoutConstraint!   // 243

    @IBOutlet weak var autoSaveSwitch: UISwitch!
    @IBOutlet weak var autoSaveLabel: UILabel!
    
    @IBOutlet weak var faceLandmarkSwitch: UISwitch!
    
    @IBOutlet weak var bitrateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControlThumb: UIView!
    @IBOutlet weak var segmentedControlThumbTitleLabel: UILabel!
    @IBOutlet weak var segmentedControlThumbLeading: NSLayoutConstraint!
    
    @IBOutlet weak var appInfoLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    let menuLeading: CGFloat = -243
    let kSettingSegmentedControlBackgroundColor: UIColor = UIColor(red: 41.0/255.0, green: 52.0/255.0, blue: 80.0/255.0, alpha: 1.0)

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.autoSaveLabel.text = "auto_save".localized()
        
        let segmentedControlBackView = UIView(frame: CGRect(x: 0, y: 0, width: 85, height: 31))
        segmentedControlBackView.backgroundColor = kSettingSegmentedControlBackgroundColor
        segmentedControlBackView.layer.cornerRadius = 15.5
        
        let clearImage = UIColor.clear.getImage()
        bitrateSegmentedControl.setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        bitrateSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)
        bitrateSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .selected)
        bitrateSegmentedControl.setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        bitrateSegmentedControl.addSubview(segmentedControlBackView)
        bitrateSegmentedControl.addSubview(segmentedControlThumb)

        appInfoLabel.text = "application_info".localized()
        
        if let infoDictionary = Bundle.main.infoDictionary, let versionString = infoDictionary["CFBundleShortVersionString"] as? String {
            appVersionLabel.text = "v\(versionString)"
        }
    }
    
    func setPreferences(autoSave: Bool, showLandmark: Bool, videoBitrate: Int) {
        
        autoSaveSwitch.isOn = autoSave
        faceLandmarkSwitch.isOn = showLandmark
        bitrateSegmentedControl.selectedSegmentIndex = videoBitrate
        
        self.animateBitrateSegmentedControl(selectedIndex: videoBitrate)
    }

    @IBAction func handleTapFrom(_ tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            self.close()
        }
    }
    
    @IBAction func autoSaveSwitchAction(_ sender: UISwitch) {
        guard let delegate = self.delegate else { return }
        
        delegate.autoSaveSwitchAction(sender)
    }
    
    @IBAction func faceLandmarkSwitchAction(_ sender: UISwitch) {
        guard let delegate = self.delegate else { return }

        delegate.faceLandmarkSwitchAction(sender)
    }
    
    @IBAction func bitrateSegmentedControlAction(_ sender: UISegmentedControl) {
        guard let delegate = self.delegate else { return }
        
        delegate.bitrateSegmentedControlAction(sender)

        self.animateBitrateSegmentedControl(selectedIndex: sender.selectedSegmentIndex)
    }
    
    func open() {
        self.isHidden = false
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.radiusView.alpha = 1.0
            self.menuViewLeading.constant = 0
            
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func close() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.radiusView.alpha = 0
            self.menuViewLeading.constant = self.menuLeading
            
            self.layoutIfNeeded()
        }) { finished in
            self.isHidden = true
        }
    }
    
    func animateBitrateSegmentedControl(selectedIndex: Int) {

        let xPosition = CGFloat(2 + 27 * selectedIndex)
        let segmentTitles = ["4M bps",
                             "2M bps",
                             "1M bps"
        ]
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.segmentedControlThumbLeading.constant = xPosition
            self.segmentedControlThumbTitleLabel.text = segmentTitles[selectedIndex]
            
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
