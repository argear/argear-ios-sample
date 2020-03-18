//
//  PreviewBottomFunctionView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/06.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

protocol PreviewBottomFunctionDelegate: class {
    func backButtonAction()
    func saveButtonAction()
    func checkButtonAction()
    func shareButtonAction()
}

class PreviewBottomFunctionView: UIView {
    
    let kPreviewBottomFunctionBackButtonName = "icBack"
    let kPreviewBottomFunctionSaveButtonName = "btnDownload"
    let kPreviewBottomFunctionCheckButtonName = "btnCheck"
    let kPreviewBottomFunctionShareButtonName = "icShare"
    
    weak var delegate: PreviewBottomFunctionDelegate?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    public func setRatio(_ ratio: ARGMediaRatio) {
        var backButtonImageName = kPreviewBottomFunctionBackButtonName
        var saveButtonImageName = kPreviewBottomFunctionSaveButtonName
        var checkButtonImageName = kPreviewBottomFunctionCheckButtonName
        var shareButtonImageName = kPreviewBottomFunctionShareButtonName
        
        var imageSaveCheckColorString = ""
        var imageBackColorString = ""
        if ratio == ._16x9 {
            imageSaveCheckColorString = "White"
            imageBackColorString = "White"
        } else {
            imageSaveCheckColorString = "Pink"
            imageBackColorString = "Black"
        }
        backButtonImageName.append(imageBackColorString)
        saveButtonImageName.append(imageSaveCheckColorString)
        checkButtonImageName.append(imageSaveCheckColorString)
        shareButtonImageName.append(imageBackColorString)
        
        self.backButton.setImage(UIImage(named: backButtonImageName), for: .normal)
        self.saveButton.setImage(UIImage(named: saveButtonImageName), for: .normal)
        self.checkButton.setImage(UIImage(named: checkButtonImageName), for: .normal)
        self.shareButton.setImage(UIImage(named: shareButtonImageName), for: .normal)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }
        
        delegate.backButtonAction()
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }
        
        delegate.saveButtonAction()
    }
    
    @IBAction func checkButtonAction(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }
        
        delegate.checkButtonAction()
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }
        
        delegate.shareButtonAction()
    }
    
    func showCheckButton() {
        self.saveButton.isHidden = true
        self.checkButton.isHidden = false
    }
}
