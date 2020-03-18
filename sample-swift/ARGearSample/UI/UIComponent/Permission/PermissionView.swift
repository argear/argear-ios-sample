//
//  PermissionView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/28.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit

class PermissionView: UIView {
    
    @IBOutlet weak var permissionAgreeView: UIView!
    @IBOutlet weak var permissionTitleLabel: UILabel!
    @IBOutlet weak var permissionAgreeMessageLabel: UILabel!
    
    @IBOutlet weak var permissionDeniedView: UIView!
    @IBOutlet weak var permissionDeniedTitleLabel: UILabel!
    @IBOutlet weak var permissionDeniedMessageLabel: UILabel!

    @IBOutlet weak var permissionAgreeOKButton: UIButton!
    @IBOutlet weak var permissionDeniedOKButton: UIButton!

    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var storageLabel: UILabel!
    @IBOutlet weak var microphoneLabel: UILabel!
    
    let permission = Permission()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.permissionTitleLabel.text = "application_permissions".localized()
        self.permissionAgreeMessageLabel.text = "permission_message".localized()

        self.permissionDeniedTitleLabel.text = "application_denied".localized()
        self.permissionDeniedMessageLabel.text = "denied_message".localized()

        self.cameraLabel.text = "camera".localized()
        self.storageLabel.text = "storage".localized()
        self.microphoneLabel.text = "microphone".localized()
        
        self.permissionAgreeOKButton.setTitle("allow".localized(), for: .normal)
        self.permissionDeniedOKButton.setTitle("allow".localized(), for: .normal)
    }
    
    @IBAction func permissionAgreeOKButtonAction(_ sender: UIButton) {
        permission.allAllow { permissionLevel in
            self.setPermissionLevel(permissionLevel)
        }
    }
    
    @IBAction func permissionDeniedOKButtonAction(_ sender: UIButton) {
        permission.openSettings()
    }
    
    func setPermissionLevel(_ level: PermissionLevel) {
        
        switch level {
        case .Granted:
            // hide PermissionView
            if let grantedHandler = permission.grantedHandler {
                grantedHandler()
            }
            DispatchQueue.main.async {
                self.removeFromSuperview()
            }
        case .Restricted:
            // show AccessDeniedView
            DispatchQueue.main.async {
                self.permissionAgreeView.isHidden = true
                self.permissionDeniedView.isHidden = false
            }
        case .None:
            // show AccessAgreeView
            DispatchQueue.main.async {
                self.permissionAgreeView.isHidden = false
                self.permissionDeniedView.isHidden = true
            }
        }
    }
}
