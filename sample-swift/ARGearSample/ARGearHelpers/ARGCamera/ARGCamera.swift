//
//  ARGCamera1.swift
//  ARGearSample
//
//  Created by Jaecheol Kim on 2019/11/11.
//  Copyright © 2019 Seerslab. All rights reserved.
//

import Foundation
import AVFoundation
import CoreImage
import ARGear

class ARGCamera:NSObject, ARGCameraProtocol {
    
    private var captureSession: AVCaptureSession?
    private let dataOutputQueue = DispatchQueue.global(qos: .userInteractive)
    
    var sessionPreset: AVCaptureSession.Preset = .photo
    @objc dynamic var ratio: ARGMediaRatio = ._4x3

    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let metadataOutput = AVCaptureMetadataOutput()
    
    var cameraDevice: AVCaptureDevice?
    var cameraConnection: AVCaptureConnection?
    
    var metadataObjectsHandler: MetadataObjectsHandler?
    var sampleBufferHandler: SampleBufferHandler?
    
    var currentCamera: CameraDeviceWithPosition = .front
    
    func initCamera(with camera: CameraDeviceWithPosition) {
        
        if self.captureSession != nil {
            return
        }
        
        self.captureSession = AVCaptureSession()
        guard let captureSession = self.captureSession
            else { return }
        
        captureSession.beginConfiguration()
        
        captureSession.sessionPreset = self.sessionPreset
        
        setupCameraDevice(with:camera)
        
        // setup outputs
        do {
            // video output
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
            guard captureSession.canAddOutput(videoDataOutput) else { fatalError() }
            captureSession.addOutput(videoDataOutput)
            cameraConnection = videoDataOutput.connection(with: .video)

            // metadata output
            metadataOutput.setMetadataObjectsDelegate(self, queue: dataOutputQueue)
            guard captureSession.canAddOutput(metadataOutput) else { fatalError() }
            captureSession.addOutput(metadataOutput)
            if metadataOutput.availableMetadataObjectTypes.contains(.face) {
                metadataOutput.metadataObjectTypes = [.face]
            }
        }

        setupCameraConnections(with:camera)

        captureSession.commitConfiguration()
    }
    
    func startCamera() {

        self.initCamera(with: currentCamera)
        self.captureSession?.startRunning()
    }
    
    func stopCamera() {
        guard let captureSession = self.captureSession
            else { return }

        if !captureSession.isRunning {
            return
        }
        captureSession.stopRunning()
        self.captureSession = nil
    }
    
    func toggleCamera(_ completion: @escaping () -> Void) {
        
        self.currentCamera = self.currentCamera == .back ? .front : .back
        
        self.stopCamera()
        self.startCamera()
        
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func changeCameraRatio(_ completion: @escaping () -> Void) {
        // 4:3 -> 1:1 -> Full
        
        switch self.ratio {
        case ._4x3:
            self.ratio = ._1x1
        case ._1x1:
            self.ratio = ._16x9
        case ._16x9:
            self.ratio = ._4x3
        default:
            break
        }
        
        self.stopCamera()
        self.startCamera()
        
        DispatchQueue.main.async {
            completion()
        }
    }
    
    private func getVideoPermission(permissionHandler: @escaping (Bool) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
          permissionHandler(true)
        case .notDetermined:
          AVCaptureDevice.requestAccess(for: .video, completionHandler: permissionHandler)
        default:
          permissionHandler(false)
        }
    }

    private func setupCameraDevice(with cameraPosition: CameraDeviceWithPosition) {

        cameraDevice = cameraPosition.captureDevice()
        
        guard let captureSession = self.captureSession
            else { return }

        captureSession.inputs.forEach { captureInput in
            captureSession.removeInput(captureInput)
        }
        
        let videoDeviceInput = try! AVCaptureDeviceInput(device: cameraDevice!)
        guard captureSession.canAddInput(videoDeviceInput) else { fatalError() }
        captureSession.addInput(videoDeviceInput)
    }
    
    private func setupCameraConnections(with cameraPosition: CameraDeviceWithPosition) {
        cameraConnection = videoDataOutput.connection(with: .video)!
        switch cameraPosition {
        case .front:
            cameraConnection!.isVideoMirrored = false
        default:
            break
        }
    }
}


// MARK: - Camera delegate
extension ARGCamera: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard
            let sampleBufferHandler = sampleBufferHandler,
            connection == cameraConnection
            else { return }
        
        sampleBufferHandler(output, sampleBuffer, connection)
    }
}

extension ARGCamera: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObjectsHandler = metadataObjectsHandler
            else { return }
        
        metadataObjectsHandler(metadataObjects, connection)
    }
}
