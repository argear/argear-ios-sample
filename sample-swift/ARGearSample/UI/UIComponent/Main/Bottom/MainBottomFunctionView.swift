//
//  MainBottomFunctionView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/30.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

enum MainBottomButtonType : Int {
    case Beauty = 0
    case Filter = 1
    case Content = 2
    case Bulge = 3
}

protocol MainBottomFunctionDelegate: class {
    func photoButtonAction(_ button: UIButton)
    func videoButtonAction(_ button: UIButton)
}

class MainBottomFunctionView: UIView {
    
    let kMainBottomFunctionBeautyButtonName = "icBeauty"
    let kMainBottomFunctionFilterButtonName = "icFilter"
    let kMainBottomFunctionContentButtonName = "icSticker"
    let kMainBottomFunctionBulgeButtonName = "icBulge"

    let kMainBottomFunctionRecordTimeLabelRatioFullColor = UIColor.white
    let kMainBottomFunctionRecordTimeLabelColor = UIColor(red: 97.0/255.0, green: 97.0/255.0, blue: 97.0/255.0, alpha: 1.0)
    let kMainBottomFunctionRecordTimeLabelShadowColor = UIColor(red: 97.0/255.0, green: 97.0/255.0, blue: 97.0/255.0, alpha: 1.0)

    weak var delegate: MainBottomFunctionDelegate?

    @IBOutlet weak var touchCancelView: UIView!

    @IBOutlet weak var beautyButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var contentButton: UIButton!
    @IBOutlet weak var bulgeButton: UIButton!

    @IBOutlet weak var modeSelectView: ModeSelectView!

    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var shutterView: ShutterView!
    
    @IBOutlet weak var beautyView: BeautyView!
    @IBOutlet weak var filterView: FilterView!
    @IBOutlet weak var contentView: ContentView!
    @IBOutlet weak var bulgeView: BulgeView!
    
    @IBOutlet weak var recordTimeLabel: UILabel!
    
    private var argObservers = [NSKeyValueObservation]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setRatio(ARGMediaRatio(rawValue: self.tag) ?? ._4x3)
        
        self.addObservers()
    }
    
    deinit {
        self.removeObservers()
    }
    
    func addObservers() {
        self.argObservers.append(
            // mode change observer
            self.modeSelectView.observe(\.mode, options: [.new]) { [weak self] obj, _ in
                guard let self = self else { return }

                self.shutterView.setShutterMode(obj.mode)
            }
        )
    }
    
    func removeObservers() {
        self.argObservers.removeAll()
    }
    
    func setRatio(_ ratio: ARGMediaRatio) {
        
        self.setButtonsImage(ratio: ratio)
        self.setRecordTimeLabelColor(ratio: ratio)
        
        self.modeSelectView.setRatio(ratio)
        self.shutterView.setRatio(ratio)
        
        self.beautyView.setRatio(ratio)
        self.filterView.setRatio(ratio)
        self.contentView.setRatio(ratio)
        self.bulgeView.setRatio(ratio)
    }
    
    func setButtonsImage(ratio: ARGMediaRatio) {
        
        var beautyButtonImageName = self.kMainBottomFunctionBeautyButtonName
        var filterButtonImageName = self.kMainBottomFunctionFilterButtonName
        var contentButtonImageName = self.kMainBottomFunctionContentButtonName
        var bulgeButtonImageName = self.kMainBottomFunctionBulgeButtonName
        
        var imageColorString = ""
        if ratio == ._16x9 {
            imageColorString = "White"
        } else {
            imageColorString = "Black"
        }
        beautyButtonImageName.append(imageColorString)
        filterButtonImageName.append(imageColorString)
        contentButtonImageName.append(imageColorString)
        bulgeButtonImageName.append(imageColorString)

        beautyButtonImageName.append("_".appendLanguageCode())
        filterButtonImageName.append("_".appendLanguageCode())
        contentButtonImageName.append("_".appendLanguageCode())
        bulgeButtonImageName.append("_".appendLanguageCode())
        
        self.beautyButton.setImage(UIImage(named: beautyButtonImageName), for: .normal)
        self.beautyButton.setImage(UIImage(named: beautyButtonImageName)?.withAlpha(BUTTON_HIGHLIGHTED_ALPHA), for: .highlighted)

        self.filterButton.setImage(UIImage(named: filterButtonImageName), for: .normal)
        self.filterButton.setImage(UIImage(named: filterButtonImageName)?.withAlpha(BUTTON_HIGHLIGHTED_ALPHA), for: .highlighted)

        self.contentButton.setImage(UIImage(named: contentButtonImageName), for: .normal)
        self.contentButton.setImage(UIImage(named: contentButtonImageName)?.withAlpha(BUTTON_HIGHLIGHTED_ALPHA), for: .highlighted)

        self.bulgeButton.setImage(UIImage(named: bulgeButtonImageName), for: .normal)
        self.bulgeButton.setImage(UIImage(named: bulgeButtonImageName)?.withAlpha(BUTTON_HIGHLIGHTED_ALPHA), for: .highlighted)
    }
    
    func setRecordTimeLabelColor(ratio: ARGMediaRatio) {
        
        var textColor: UIColor = .clear
        var shadowColor: UIColor = .clear
        
        if ratio == ._16x9 {
            textColor = self.kMainBottomFunctionRecordTimeLabelRatioFullColor
            shadowColor = self.kMainBottomFunctionRecordTimeLabelShadowColor
        } else {
            textColor = self.kMainBottomFunctionRecordTimeLabelColor
        }

        self.recordTimeLabel.textColor = textColor
        
        self.recordTimeLabel.layer.shadowOffset = CGSize.zero
        self.recordTimeLabel.layer.shadowRadius = 1.0
        self.recordTimeLabel.layer.shadowOpacity = 0.5
        self.recordTimeLabel.layer.masksToBounds = false
        self.recordTimeLabel.layer.shouldRasterize = true
        self.recordTimeLabel.layer.shadowColor = shadowColor.cgColor
    }


    @IBAction func handleTapFrom(_ tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            self.closeBottomFunctions()
        }
    }
    
    @IBAction func bottomButtonAction(_ sender: UIButton) {
        
        self.openBottomFunctions()
        
        let buttonType = MainBottomButtonType(rawValue: sender.tag)
        
        switch buttonType {
        case .Beauty:
            self.beautyView.open()
        case .Filter:
            self.filterView.open()
        case .Content:
            self.contentView.open()
        case .Bulge:
            self.bulgeView.open()
        default:
            break
        }
    }
    
    @IBAction func shutterButtonAction(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }
        
        let mode = self.modeSelectView.mode
        switch mode {
        case .photo:
            delegate.photoButtonAction(sender)
        case .video:
            self.recordTimeLabel.isHidden = sender.tag.boolValue
            self.setModeSelectViewDisable(sender.tag.boolValue)
            delegate.videoButtonAction(sender)
        default:
            break
        }
    }
    
    private func setModeSelectViewDisable(_ disable: Bool) {
        self.modeSelectView.isUserInteractionEnabled = disable
    }

    func openBottomFunctions() {
        self.touchCancelView.isHidden = false
        
        self.isHidden = true
    }
    
    func closeBottomFunctions() {
        self.touchCancelView.isHidden = true
        
        self.beautyView.close()
        self.filterView.close()
        self.contentView.close()
        self.bulgeView.close()
        
        self.isHidden = false
    }
    
    func setRecordTime(_ time: Float) {
        let min: Int = Int(time / 60)
        let sec: Int = Int(time) - min * 60
        
        self.recordTimeLabel.text = String(format: "%02d:%02d", min, sec)
    }
}
