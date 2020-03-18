//
//  MainTopFunctionView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/29.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

protocol MainTopFunctionDelegate: class {
    func settingButtonAction()
    func ratioButtonAction()
    func toggleButtonAction()
}

class MainTopFunctionView: UIView {
    
    let kMainTopFunctionSettingButtonName = "icSetting"
    let kMainTopFunctionToggleButtonName = "icRotate"

    let kMainTopFunctionRatio11ButtonName = "ic11Black"
    let kMainTopFunctionRatio43ButtonName = "ic43"
    let kMainTopFunctionRatioFullButtonName = "icFullWhite"
    
    weak var delegate: MainTopFunctionDelegate?

    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var ratioButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setRatio(ARGMediaRatio(rawValue: self.tag) ?? ._4x3)
    }
    
    func setRatio(_ ratio: ARGMediaRatio) {
        
        let screenRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        
        var settingButtonImageName = self.kMainTopFunctionSettingButtonName
        var toggleButtonImageName = self.kMainTopFunctionToggleButtonName
        var ratioButtonImageName = ""

        switch ratio {
        case ._16x9:
            settingButtonImageName.append("White")
            toggleButtonImageName.append("White")
            ratioButtonImageName.append(self.kMainTopFunctionRatioFullButtonName)
        case ._4x3:
            if screenRatio > 2.0 {
                settingButtonImageName.append("Black")
                toggleButtonImageName.append("Black")
                ratioButtonImageName.append(self.kMainTopFunctionRatio43ButtonName)
                ratioButtonImageName.append("Black")
            } else {
                settingButtonImageName.append("White")
                toggleButtonImageName.append("White")
                ratioButtonImageName.append(self.kMainTopFunctionRatio43ButtonName)
                ratioButtonImageName.append("White")
            }
        case ._1x1:
            settingButtonImageName.append("Black")
            toggleButtonImageName.append("Black")
            ratioButtonImageName.append(self.kMainTopFunctionRatio11ButtonName)
        default:
            break
        }
        
        self.settingButton.setImage(UIImage(named: settingButtonImageName), for: .normal)
        self.settingButton.setImage(UIImage(named: settingButtonImageName)?.withAlpha(BUTTON_HIGHLIGHTED_ALPHA), for: .highlighted)
        
        self.ratioButton.setImage(UIImage(named: ratioButtonImageName), for: .normal)
        self.ratioButton.setImage(UIImage(named: ratioButtonImageName)?.withAlpha(BUTTON_HIGHLIGHTED_ALPHA), for: .highlighted)

        self.toggleButton.setImage(UIImage(named: toggleButtonImageName), for: .normal)
        self.toggleButton.setImage(UIImage(named: toggleButtonImageName)?.withAlpha(BUTTON_HIGHLIGHTED_ALPHA), for: .highlighted)
    }
    
    @IBAction func settingButtonAction(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }
        
        delegate.settingButtonAction()
    }
    
    @IBAction func ratioButtonAction(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }

        delegate.ratioButtonAction()
    }
    
    @IBAction func toggleButtonAction(_ sender: UIButton) {
        self.disableButtons()

        guard let delegate = self.delegate
            else {
                self.enableButtons()
                return
        }

        delegate.toggleButtonAction()
    }
    
    func enableButtons() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.settingButton.isUserInteractionEnabled = true
            self.ratioButton.isUserInteractionEnabled = true
            self.toggleButton.isUserInteractionEnabled = true
        }
    }
    
    func disableButtons() {
        self.settingButton.isUserInteractionEnabled = false
        self.ratioButton.isUserInteractionEnabled = false
        self.toggleButton.isUserInteractionEnabled = false
    }
}
