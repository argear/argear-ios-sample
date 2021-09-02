//
//  ARGCameraProtocol.swift
//  ARGearSample
//
//  Created by Jaecheol Kim on 2019/11/11.
//  Copyright © 2019 Seerslab. All rights reserved.
//

import Foundation
import AVFoundation
import CoreImage
import ARGear

public typealias SampleBufferHandler = (AVCaptureOutput, CMSampleBuffer, AVCaptureConnection) -> Void
public typealias MetadataObjectsHandler = ([AVMetadataObject], AVCaptureConnection) -> Void
public typealias DataBufferHandler = (CMSampleBuffer, NSArray?) -> Void

public enum CameraDeviceWithPosition {
    case front
    case back

    func captureDevice() -> AVCaptureDevice {
        
        var devices: [AVCaptureDevice]
        
        if #available(iOS 10.0, *) {
            
            switch self {
            case .front:
                let deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInWideAngleCamera]
                devices = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: .front).devices
                
            case .back:
                var deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInWideAngleCamera, .builtInTelephotoCamera]
                deviceTypes.append({ () -> AVCaptureDevice.DeviceType in
                    if #available(iOS 10.2, *) {
                        return .builtInDualCamera
                    } else {
                        return .builtInDuoCamera
                    }
                }())
                devices = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: .back).devices
            }
            guard let device = devices.first
                else {
                    return AVCaptureDevice.default(for: .video)!
            }
            return device
        } else {
            
            devices = AVCaptureDevice.devices(for: .video)
            var captureDevice = AVCaptureDevice.default(for: .video)!
            for device in devices {
                var position: AVCaptureDevice.Position
                switch self {
                case .front:
                    position = .front
                case .back:
                    position = .back
                }
                
                if device.position == position {
                    captureDevice = device
                    break
                }
            }
            return captureDevice
        }
    }
}

public extension CVPixelBuffer {
    func transformedImage(targetSize: CGSize, rotationAngle: CGFloat) -> CIImage? {
        let image = CIImage(cvPixelBuffer: self, options: [:])
        let scaleFactor = Float(targetSize.width) / Float(image.extent.width)
        let resizedImage = image.transformed(by: CGAffineTransform(rotationAngle: rotationAngle)).applyingFilter("CIBicubicScaleTransform", parameters: ["inputScale": scaleFactor])
        
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(resizedImage, forKey: "inputImage")
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        filter?.setValue(1.0, forKey: "inputIntensity")
        let grayImage = filter?.outputImage

        return grayImage
    }
}

public protocol ARGCameraProtocol {
    
    var cameraDevice: AVCaptureDevice? { get set }
    var cameraConnection: AVCaptureConnection? { get set }
    
    var sampleBufferHandler: SampleBufferHandler? { get set }
    
    
    func initCamera(with cameraPosition: CameraDeviceWithPosition)
    
    func startCamera()
    func stopCamera()
  
    func toggleCamera(_ completion: @escaping () -> Void)
    func changeCameraRatio(_ completion: @escaping () -> Void)
}
