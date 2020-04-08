//
//  BeautyView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/21.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class BeautyView: ARGBottomFunctionBaseView {
    
    let kBeautyViewCompareIconName = "icCompare"
    let kBeautyViewResetIconName = "icRefresh"
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var beautyCollectionView: BeautyCollectionView!
    
    private var observers = [NSKeyValueObservation]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let sliderThumb = UIImage(named: "bttnControl.png")
        self.slider.setThumbImage(sliderThumb, for: .normal)
        self.slider.setThumbImage(sliderThumb, for: .highlighted)

        self.beautyCollectionView.selectedIndexPath = IndexPath(row: 0, section: 0)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(compareButtonLongPressAction(_:)))
        self.compareButton.addGestureRecognizer(longPressGesture)
        
        self.addObservers()
    }
    
    deinit {
        self.removeObservers()
    }
    
    override func open() {
        super.open()

        var beautyIndex = 0
        if let selectedBeauty = self.beautyCollectionView.selectedIndexPath {
            beautyIndex = selectedBeauty.row
        }
        self.slider.value = BeautyManager.shared.getBeautyValue(type: ARGContentItemBeauty(rawValue: beautyIndex)!)
        
        BulgeManager.shared.off()
        ContentManager.shared.clearContent()
    }
    
    override func setRatio(_ ratio: ARGMediaRatio) {
        super.setRatio(ratio)
        
        self.setButtons(ratio: ratio)
        self.beautyCollectionView.setRatio(ratio)
    }
    
    func setButtons(ratio: ARGMediaRatio) {
        
        var compareButtonImageName = self.kBeautyViewCompareIconName
        var resetButtonImageName = self.kBeautyViewResetIconName
        
        var imageColorString = ""
        if ratio == ._16x9 {
            imageColorString = "White"
        } else {
            imageColorString = "Black"
        }
        compareButtonImageName.append(imageColorString)
        resetButtonImageName.append(imageColorString)

        self.compareButton.setImage(UIImage(named: compareButtonImageName), for: .normal)
        self.compareButton.setImage(UIImage(named: compareButtonImageName)?.withAlpha(BUTTON_HIGHLIGHTED_ALPHA), for: .highlighted)

        self.resetButton.setImage(UIImage(named: resetButtonImageName), for: .normal)
        self.resetButton.setImage(UIImage(named: resetButtonImageName)?.withAlpha(BUTTON_HIGHLIGHTED_ALPHA), for: .highlighted)
    }
    
    @objc
    func compareButtonLongPressAction(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            BeautyManager.shared.off()
        } else if gesture.state == .ended {
            BeautyManager.shared.on()
        }
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        BeautyManager.shared.setDefault()
        
        if let selectedIndexPath = beautyCollectionView.selectedIndexPath {
            let beautyValue = BeautyManager.shared.getBeautyValue(type: ARGContentItemBeauty(rawValue: selectedIndexPath.row) ?? .vline)
            
            slider.setValue(beautyValue, animated: false)
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        BeautyManager.shared.setBeauty(type: ARGContentItemBeauty(rawValue: sender.tag)!, value: sender.value)
    }
    
    func addObservers() {
        self.observers.append(
            self.beautyCollectionView.observe(\.selectedIndexPath, options: .new) { [weak self] _, change in
                guard let self = self else { return }

                if let indexPath = change.newValue as? IndexPath {
                    let beautyValue = BeautyManager.shared.getBeautyValue(type: ARGContentItemBeauty(rawValue: indexPath.row)!)
                    self.slider.tag = indexPath.row
                    self.slider.value = beautyValue
                }
            }
        )
    }
    
    func removeObservers() {
        self.observers.removeAll()
    }
}
