//
//  ARGScene.swift
//  ARGearSample
//
//  Created by Jaecheol Kim on 2019/11/07.
//  Copyright © 2019 Seerslab. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

typealias ARGSceneRenderUpdateAtTimeHandler = (SCNSceneRenderer, TimeInterval) -> Void
typealias ARGSceneRenderDidRenderSceneHandler = (SCNSceneRenderer, SCNScene, TimeInterval) -> Void

typealias ARGSceneSessionDidUpdateFrameHandler = (ARSession, ARFrame) -> Void

class ARGScene: NSObject {
    
    var sceneRenderUpdateAtTimeHandler: ARGSceneRenderUpdateAtTimeHandler?
    var sceneRenderDidRenderSceneHandler: ARGSceneRenderDidRenderSceneHandler?
    
    var sceneSessionDidUpdateFrameHandler: ARGSceneSessionDidUpdateFrameHandler?
    
    lazy var sceneView = ARSCNView()
    
    var objectNodes: [SCNNode] = []
    
    init(viewContainer: UIView?){
        super.init()
        
        guard let scene = SCNScene(named: "Face.scnassets/face.scn")
            else {
                fatalError("Failed to load face scene!")
        }

        // setup preview
        if let viewContainer = viewContainer {
            sceneView.scene = scene
            sceneView.frame = viewContainer.bounds
            sceneView.delegate = self
            sceneView.session.delegate = self
            sceneView.showsStatistics = false
            sceneView.rendersContinuously = true
            sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            sceneView.backgroundColor = .clear
            sceneView.layer.transform = CATransform3DMakeScale(1, 1, 1)
            sceneView.isUserInteractionEnabled = true
            
            // tap gesture for object
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
            sceneView.addGestureRecognizer(tapGesture)
        }
        
        self.setupSession()
    }
    
    func setupSession() {
        
        let arkitFaceTrackingConfig = ARFaceTrackingConfiguration()
        sceneView.session.run(arkitFaceTrackingConfig, options: [.removeExistingAnchors, .resetTracking])
    }
    
    func toggleSession() {
        
        sceneView.delegate = nil
        sceneView.session.delegate = nil
        
        let arSession = sceneView.session
        let config = arSession.configuration

        var arkitConfig: ARConfiguration
        if config is ARFaceTrackingConfiguration {

            let worldConfiguration = ARWorldTrackingConfiguration()
            worldConfiguration.planeDetection = [.horizontal]

            arkitConfig = worldConfiguration
        } else {

            let faceConfiguration = ARFaceTrackingConfiguration()
            arkitConfig = faceConfiguration
            
            for node in objectNodes {
                node.removeFromParentNode()
            }
            objectNodes.removeAll()
        }
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        arSession.run(arkitConfig, options: [.removeExistingAnchors, .resetTracking])
    }

    func toggleScene(view: UIView?) {
        
        guard let viewContainer = view
            else { return }
        
        if sceneView.session.configuration is ARFaceTrackingConfiguration {
            viewContainer.addSubview(sceneView)
        } else {
            sceneView.removeFromSuperview()
        }
    }
    
    @objc
    func didTap(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: sceneView)
        
        // object (candle, chair, cup, lamp, painting, sticky note, vase)
        let nodes = self.createObjectNode(string: "candle")
        guard let objectNode = nodes.first else {
            return
        }
        objectNode.load()
        
        if #available(iOS 11.3, *) {

            let hits = sceneView.hitTest(touchLocation, types: [.existingPlaneUsingGeometry, .existingPlane])

            if let hit = hits.first {
                self.setNodePosition(node: objectNode, atHit: hit)
            }
        } else {
            // Fallback on earlier versions
            objectNode.position = SCNVector3Zero
        }
        
        sceneView.scene.rootNode.addChildNode(objectNode)
        self.objectNodes.append(objectNode)
    }
    
    private func setNodePosition(node: SCNNode, atHit hit: ARHitTestResult) {

        // object
        let position = SCNVector3Make(hit.worldTransform.columns.3.x, hit.worldTransform.columns.3.y, hit.worldTransform.columns.3.z)
        node.position = position
    }
    
    func createObjectNode(string: String) -> [SCNReferenceNode] {
        
        let modelsURL = Bundle.main.url(forResource: "Models.scnassets", withExtension: nil)!
        let fileEnumerator = FileManager().enumerator(at: modelsURL, includingPropertiesForKeys: [])!

        return fileEnumerator.compactMap { element in
            let url = element as! URL

            guard url.pathExtension == "scn" && !url.path.contains("lighting") else { return nil }
            
            if url.path.contains(string) {
                return SCNReferenceNode(url: url)
            } else {
                return nil
            }
        }
    }
}

extension ARGScene: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard let handler = sceneRenderUpdateAtTimeHandler
            else { return }
        
        handler(renderer, time)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard let handler = sceneRenderDidRenderSceneHandler
            else { return }
        
        handler(renderer, scene, time)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        guard let planeAnchor = anchor as? ARPlaneAnchor
            else { return }

        let plane = Plane(anchor: planeAnchor, in: sceneView)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            let plane = node.childNodes.first as? Plane
            else { return }
        
        // Update ARSCNPlaneGeometry to the anchor's new estimated shape.
        if #available(iOS 11.3, *) {
            if let planeGeometry = plane.meshNode.geometry as? ARSCNPlaneGeometry {
                planeGeometry.update(from: planeAnchor.geometry)
            }
        }

        // Update extent visualization to the anchor's new bounding rectangle.
        if let extentGeometry = plane.extentNode.geometry as? SCNPlane {
            extentGeometry.width = CGFloat(planeAnchor.extent.x)
            extentGeometry.height = CGFloat(planeAnchor.extent.z)
            plane.extentNode.simdPosition = planeAnchor.center
        }
    }
}

extension ARGScene: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        guard let handler = sceneSessionDidUpdateFrameHandler
            else { return }
        
        handler(session, frame)
    }
}
