//
//  ViewController.swift
//  ARGearSample
//
//  Created by Jaecheol Kim on 2019/10/28.
//  Copyright © 2019 Seerslab. All rights reserved.
//

import UIKit
import CoreMedia
import SceneKit
import AVFoundation
import ARGearRenderer
import ARKit

public final class MainViewController: UIViewController {
    
    // MARK: - ARGearSDK properties
    private var argConfig: ARGConfig?
    private var argSession: ARGSession?
    private var currentFaceFrame: ARGFrame?
    private var nextFaceFrame: ARGFrame?
    
    // MARK: - ARKit properties
    private var currentARKitFrame: ARFrame?
    
    // MARK: - Camera & Scene properties
    private let serialQueue = DispatchQueue(label: "serialQueue")
    
    private var arScene: ARGScene!
    private var arMedia: ARGMedia!
    
    @IBOutlet weak var sceneBaseView: UIView!
    private lazy var cameraPreviewCALayer = CALayer()
    
    // MARK: - Functions UI
    @IBOutlet weak var beautyCancelLabel: UILabel!
    @IBOutlet weak var filterCancelLabel: UILabel!
    @IBOutlet weak var contentCancelLabel: UILabel!
    @IBOutlet weak var bulgeCancelLabel: UILabel!
    
    // MARK: - viewDidLoad
    override public func viewDidLoad() {
      super.viewDidLoad()
        
        setupARGearConfig()
        setupScene()
    }
    // MARK: - viewWillAppear
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        runARGSession()
        
        NetworkManager.shared.argSession = argSession
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopARGSession()
    }

    
    // MARK: - ARGearSDK setupConfig
    private func setupARGearConfig() {
        do {
            let config = ARGConfig(
                apiURL: API_HOST,
                apiKey: API_KEY,
                secretKey: API_SECRET_KEY,
                authKey: API_AUTH_KEY
            )
            argSession = try ARGSession(argConfig: config)
            argSession?.delegate = self
            argSession?.inferenceDebugOption = .optionDebugFaceLandmark2D
        } catch let error as NSError {
            NSLog("Failed to initialize ARGear Session with error: %@", error.description)
        } catch let exception as NSException {
            NSLog("Exception to initialize ARGear Session with error: %@", exception.description)
        }
    }

    // MARK: - setupScene
    private func setupScene() {
        arScene = ARGScene(viewContainer: self.sceneBaseView)

        arScene.sceneRenderUpdateAtTimeHandler = { [weak self] renderer, time in
            guard let _ = self else { return }
        }

        arScene.sceneRenderDidRenderSceneHandler = { [weak self] renderer, scene, time in
            guard let self = self else { return }
            
            guard let _ = self.arScene.sceneView.session.configuration as? ARWorldTrackingConfiguration else {
                return
            }
            
            self.drawARCameraPreview()
        }
        
        arScene.sceneSessionDidUpdateFrameHandler = { [weak self] session, frame in
            guard let self = self else { return }
            self.sessionDidUpdateFrame(session, didUpdate: frame)
        }

        cameraPreviewCALayer.contentsGravity = .resizeAspectFill
        cameraPreviewCALayer.frame = CGRect(x: 0, y: 0, width: arScene.sceneView.frame.size.height, height: arScene.sceneView.frame.size.width)
        cameraPreviewCALayer.contentsScale = UIScreen.main.scale
        view.layer.insertSublayer(cameraPreviewCALayer, at: 0)
    }
    
    // MARK: - run ARGSession
    private func runARGSession() {

        argSession?.run()
    }
    
    private func stopARGSession() {
        argSession?.pause()
    }
    
    // MARK: ARGScene ARKit Session
    private func sessionDidUpdateFrame(_ session: ARSession, didUpdate frame: ARFrame) {
        
        self.currentARKitFrame = frame
        
        let viewportSize = arScene.sceneView.bounds.size
        var updateFaceAnchor: ARFaceAnchor? = nil
        var isFace = false
        if let faceAnchor = frame.anchors.first as? ARFaceAnchor {
            if faceAnchor.isTracked {
                updateFaceAnchor = faceAnchor
                isFace = true
            }
        } else {
            if let _ = frame.anchors.first as? ARPlaneAnchor {
                
            }
        }
        
        // convert handler (required)
        let handler: ARGSessionProjectPointHandler = { (transform: simd_float3, orientation: UIInterfaceOrientation, viewport: CGSize) in
            
            return frame.camera.projectPoint(transform, orientation: orientation, viewportSize: viewport)
        }
        
        if isFace {
            if let faceAnchor = updateFaceAnchor {
                self.argSession?.applyAdditionalFaceInfo(withPixelbuffer: frame.capturedImage, transform: faceAnchor.transform, vertices: faceAnchor.geometry.vertices, viewportSize: viewportSize, convert: handler)
            } else {
                self.argSession?.feedPixelbuffer(frame.capturedImage)
            }
        } else {
            self.argSession?.feedPixelbuffer(frame.capturedImage)
        }
    }

    // MARK: - ARGearSDK Handling
    private func drawARCameraPreview() {
        
        guard let config = self.arScene.sceneView.session.configuration else  {
            return
        }
        
        DispatchQueue.main.async {
        
            var pixelBuffer: CVPixelBuffer?
            var flipTransform = CGAffineTransform(scaleX: 1, y: 1)
            if config == ARFaceTrackingConfiguration() {
                if let frame = self.argSession?.frame, let buffer = frame.renderedPixelBuffer {
                    pixelBuffer = buffer
                }
                flipTransform = CGAffineTransform(scaleX: -1, y: 1)
            } else {
                if let frame = self.currentARKitFrame {
                    pixelBuffer = frame.capturedImage
                }
            }

            CATransaction.flush()
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
            self.cameraPreviewCALayer.contents = pixelBuffer
            let angleTransform = CGAffineTransform(rotationAngle: .pi/2)
            let transform = angleTransform.concatenating(flipTransform)
            self.cameraPreviewCALayer.setAffineTransform(transform)
            self.cameraPreviewCALayer.frame = CGRect(x: 0, y: 0, width: self.cameraPreviewCALayer.frame.size.width, height: self.cameraPreviewCALayer.frame.size.height)
            CATransaction.commit()
        }
    }

    // MARK: - button Actions
    @IBAction func landmarkSwitchAction(_ sender: UISwitch) {
        
        guard let session = argSession else {
            return
        }
        
        let option: ARGInferenceDebugOption = sender.isOn ? .optionDebugFaceLandmark2D : .optionDebugNON
        session.inferenceDebugOption = option
    }
    
    @IBAction func toggleButtonAction(_ sender: Any) {
        
        guard let session = argSession else {
            return
        }
        
        let arkitConfiguration = arScene.sceneView.session.configuration
        
        session.pause()
        
        arScene.toggleScene(view: self.sceneBaseView)
        arScene.toggleSession()

        if arkitConfiguration is ARWorldTrackingConfiguration {
            session.run()
        }
    }
    
    @IBAction func beautyButtonAction(_ sender: UIButton) {
        
        guard let session = argSession, let contents = session.contents else {
            return
        }
        
        if sender.isSelected {
            contents.setBeautyOn(false)
        } else {
            contents.setBulge(.NONE)
            contents.setDefaultBeauty()
            
            // set beauty one value
    //        contents.setBeauty(.faceSlim, value: 0.7)
            
            // set all beauties
            let beautyValue: [Float] = [
                10.0,
                90.0,
                55.0,
                -50.0,
                5.0,
                -10.0,
                0.0,
                35.0,
                30.0,
                -35.0,
                0.0,
                0.0,
                0.0,
                50.0,
                0.0,
                0.0
            ]

            let beautyValuePointer = UnsafeMutablePointer<Float>.allocate(capacity: beautyValue.count)
            beautyValuePointer.assign(from: beautyValue, count: beautyValue.count)
            contents.setBeautyValues(beautyValuePointer)
            beautyValuePointer.deallocate()
        }
        sender.isSelected = !sender.isSelected
        beautyCancelLabel.isHidden = !sender.isSelected
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        
        guard let session = argSession, let contents = session.contents else {
            return
        }
        
        if sender.isSelected {
            contents.clear(.filter)
        } else {
            
            // filter download (first)
            NetworkManager.shared.downloadItem(url:"https://privatecontent.argear.io/contents/data/87942be0-f470-11e9-93ab-175806ecc470.zip", title:"azalea", type: "filter")
        }
        sender.isSelected = !sender.isSelected
        filterCancelLabel.isHidden = !sender.isSelected
    }
    
    @IBAction func contentButtonAction(_ sender: UIButton) {
        
        guard let session = argSession, let contents = session.contents else {
            return
        }
        
        if sender.isSelected {
            contents.clear(.sticker)
        } else {
            
            // content download (first)
            NetworkManager.shared.downloadItem(url:"https://privatecontent.argear.io/contents/data/8371db00-599b-11e8-be0b-a11704a45e60.zip", title:"Crayon_flowerxo", type: "sticker/effects")
        }
        sender.isSelected = !sender.isSelected
        contentCancelLabel.isHidden = !sender.isSelected
    }
    
    @IBAction func bulgeButtonAction(_ sender: UIButton) {
        
        guard let session = argSession, let contents = session.contents else {
            return
        }
        
        if sender.isSelected {
            contents.setBulge(.NONE)
        } else {
            contents.setBulge(.FUN5)
        }
        sender.isSelected = !sender.isSelected
        bulgeCancelLabel.isHidden = !sender.isSelected
    }
}

// MARK: - ARGearSDK ARGSession delegate
extension MainViewController : ARGSessionDelegate {

    public func didUpdate(_ arFrame: ARGFrame) {
        
        self.drawARCameraPreview()
    }
}

