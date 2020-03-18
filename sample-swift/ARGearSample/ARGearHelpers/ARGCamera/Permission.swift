//
//  Permission.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/21.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import Photos

enum PermissionLevel : Int {
    case None       = 0
    case Granted    = 1
    case Restricted = 2
}

typealias PermissionCheckComplete = () -> Void
typealias PermissionCheckHandler = (PermissionLevel) -> Void

class Permission: NSObject {
    
    var grantedHandler: PermissionCheckComplete?
    
    func allowCamera(_ permissionCheckComplete: @escaping PermissionCheckComplete) {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraStatus == .denied {
            permissionCheckComplete()
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                permissionCheckComplete()
            }
        }
    }
    
    func allowLibrary(_ permissionCheckComplete: @escaping PermissionCheckComplete) {
        let libraryStatus = PHPhotoLibrary.authorizationStatus()
        if libraryStatus == .denied {
            permissionCheckComplete()
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                permissionCheckComplete()
            }
        }
    }
    
    func allowMic(_ permissionCheckComplete: @escaping PermissionCheckComplete) {
        let micStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if micStatus == .denied {
            permissionCheckComplete()
        } else {
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                permissionCheckComplete()
            }
        }
    }
    
    func allAllow(_ permissionCheckHandler: @escaping PermissionCheckHandler) {
        self.allowCamera {
            self.allowLibrary {
                self.allowMic {
                    permissionCheckHandler(self.getPermissionLevel())
                }
            }
        }
    }
    
    func getPermissionLevel() -> PermissionLevel {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let micStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        let libraryStatus = PHPhotoLibrary.authorizationStatus()
        
        let cameraDetermined = (cameraStatus == .notDetermined) ? true : false
        let micDetermined = (micStatus == .notDetermined) ? true : false
        let libraryDetermined = (libraryStatus == .notDetermined) ? true : false
        
        let cameraAuthorized = (cameraStatus == .authorized) ? true : false
        let micAuthorized = (micStatus == .authorized) ? true : false
        let libraryAuthorized = (libraryStatus == .authorized) ? true : false
        
        if cameraDetermined || micDetermined || libraryDetermined {
            return .None
        }
        
        if cameraAuthorized && micAuthorized && libraryAuthorized {
            return .Granted
        }
        
        return .Restricted
    }
    
    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
            else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(settingsURL)
        }
    }
}
