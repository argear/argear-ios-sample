//
//  ContentManager.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/10.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import Foundation
import ARGear

typealias ContentCompletion = () -> Void

class ContentManager {
    static let shared = ContentManager()
    
    var argSession: ARGSession?
    var selectedContentId: String?
    
    public func setContent(_ content: Item, successBlock: @escaping ContentCompletion, failBlock: @escaping ContentCompletion) {
        guard let session = self.argSession, let contents = session.contents, let uuid = content.uuid
            else {
                failBlock()
                return
        }
        
        if RealmManager.shared.getIsDownloaded(item: content) {
            self.selectedContentId = uuid
            contents.setItemWith(.sticker, withItemFilePath: nil, withItemID: uuid) { (success, msg) in
                if (success) {
                    successBlock()
                } else {
                    failBlock()
                }
            }
        } else {
            ARGLoading.show()
            NetworkManager.shared.downloadItem(content) { (result: Result<URL, DownloadError>) in

                switch result {
                case .success(let targetPath):
                    DispatchQueue.main.async {
                        RealmManager.shared.setIsDownloaded(item: content, isDownloaded: true)
                    }
                    self.selectedContentId = uuid
                    contents.setItemWith(.sticker, withItemFilePath: targetPath.absoluteString, withItemID: uuid) { (success, msg) in
                        ARGLoading.hide()
                        if (success) {
                            successBlock()
                        } else {
                            failBlock()
                        }
                    }
                    break;
                case .failure(.network):
                    ARGLoading.hide()
                    failBlock()
                    break
                case .failure(.auth):
                    ARGLoading.hide()
                    failBlock()
                    break
                case .failure(.content):
                    ARGLoading.hide()
                    failBlock()
                    break
                }
                
            }
        }
    }
    
    public func clearContent() {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        contents.clear(.sticker)
        
        self.selectedContentId = nil
    }
}
