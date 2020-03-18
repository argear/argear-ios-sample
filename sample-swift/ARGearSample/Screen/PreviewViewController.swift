//
//  PreviewViewController.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/06.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import AVFoundation
import ARGear

class PreviewViewController: UIViewController {
    
    let screenRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
    let topInsetViewHeightConstant: Float = 64.0
    let videoPathKey = "filePath"
    
    @IBOutlet weak var topInsetView: UIView!
    @IBOutlet weak var topInsetViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var ratio43ImageView: UIImageView!
    @IBOutlet weak var ratio11ImageView: UIImageView!
    
    @IBOutlet weak var previewBottomFunctionView: PreviewBottomFunctionView!
    
    var player: AVPlayer?
    
    var previewImage: UIImage?
    var videoInfo: Dictionary<String, Any>?
    
    var media: ARGMedia?
    var ratio: ARGMediaRatio = ._4x3
    var mode: ARGMediaMode = .photo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.previewBottomFunctionView.delegate = self
        
        if self.ratio == ._16x9 && !self.isPreviewContentOrientationIsPortrait() {
            self.previewBottomFunctionView.setRatio(._4x3)
        } else {
            self.previewBottomFunctionView.setRatio(self.ratio)
        }
        
        switch mode {
        case .photo:
            self.photoPreview()
        case .video:
            self.videoPreview()
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        guard let player = self.player
            else { return }

        player.pause()
    }
    
    func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func photoPreview() {
        
        self.fullImageView.image = nil
        self.ratio43ImageView.image = nil
        self.ratio11ImageView.image = nil
        
        switch self.ratio {
        case ._16x9:
            self.fullImageView.contentMode = self.isPreviewContentOrientationIsPortrait() ?
                .scaleAspectFill : .scaleAspectFit
            self.fullImageView.image = self.previewImage
        case ._4x3:
            self.topInsetViewHeight.constant = (screenRatio > 2.0) ? CGFloat(self.topInsetViewHeightConstant) : 0
            self.ratio43ImageView.image = self.previewImage
        case ._1x1:
            self.ratio11ImageView.image = self.previewImage
        default:
            break
        }
    }
    
    func videoPreview() {
        
        guard let videoInfo = self.videoInfo, let videoPath = videoInfo[self.videoPathKey] as? URL
            else { return }
        
        var previewView: UIImageView? = nil
        switch self.ratio {
        case ._16x9:
            previewView = self.fullImageView
        case ._4x3:
            self.topInsetViewHeight.constant = (screenRatio > 2.0) ? CGFloat(self.topInsetViewHeightConstant) : 0
            previewView = self.ratio43ImageView
        case ._1x1:
            previewView = self.ratio11ImageView
        default:
            break
        }
        
        var videoGravity: AVLayerVideoGravity = .resizeAspect
        // Full & Landscape
        if self.ratio == ._16x9 && self.isPreviewContentOrientationIsPortrait() {
            videoGravity = .resizeAspectFill
        }
        
        var topInset: Float = 0
        if #available(iOS 11.0, *) {
            if let keyWindow = UIApplication.shared.keyWindow {
                topInset = Float(keyWindow.safeAreaInsets.top)
            }
        }
        
        topInset += (screenRatio > 2.0) ? self.topInsetViewHeightConstant : 44.0
        if self.ratio == ._16x9 {
            topInset = 0
        }
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: videoPath)
        self.player = AVPlayer(playerItem: playerItem)
        
        guard let player = self.player, let preview = previewView
            else { return }
        
        let avPlayerLayer: AVPlayerLayer = AVPlayerLayer(player: self.player)
        avPlayerLayer.frame = UIScreen.main.bounds
        avPlayerLayer.bounds = CGRect(x: 0, y: -(preview.frame.origin.y) - CGFloat(topInset), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        avPlayerLayer.videoGravity = videoGravity
        preview.layer.addSublayer(avPlayerLayer)
        
        player.actionAtItemEnd = .none
        player.play()
    }
    
    private func photoSave() {
        guard let media = self.media
            else { return }

        media.saveImage(toAlbum: self.previewImage!, success: { [weak self] in
            guard let self = self else { return }

            self.previewBottomFunctionView.showCheckButton()
        }, error: nil)
    }
    
    private func videoSave() {
        guard let media = self.media, let videoInfo = self.videoInfo, let videoPath = videoInfo[self.videoPathKey] as? URL
            else { return }
        
        media.saveVideo(toAlbum: videoPath, success: { [weak self] in
            guard let self = self else { return }

            self.previewBottomFunctionView.showCheckButton()
        }, error: nil)
    }
    
    private func isPreviewContentOrientationIsPortrait() -> Bool {
        guard let media = self.media
            else {
                return false
        }
        return media.getRecordingOrientation() == .portrait
    }
}

extension PreviewViewController: PreviewBottomFunctionDelegate {
    func shareButtonAction() {
    }
    
    func backButtonAction() {
        self.backToMain()
    }
    
    func saveButtonAction() {
        switch self.mode {
        case .photo:
            self.photoSave()
        case .video:
            self.videoSave()
        default:
            break
        }
    }
    
    func checkButtonAction() {
        self.backToMain()
    }
}

extension PreviewViewController {
    @objc
    private func playerItemDidReachEnd(_ notification: NSNotification) {
        guard let player = self.player
            else { return }
        
        player.seek(to: CMTime.zero)
        player.play()
    }
}
