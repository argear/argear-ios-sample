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
    
    public func setContent(_ content: Item, success: @escaping ContentCompletion, fail: @escaping ContentCompletion) {
        guard let session = self.argSession, let contents = session.contents, let uuid = content.uuid
            else {
                fail()
                return
        }
        
        if RealmManager.shared.getIsDownloaded(item: content) {
            self.selectedContentId = uuid
            contents.setItemWith(.sticker, withItemFilePath: nil, withItemID: uuid)
            success()
            return
        }
        
        ARGLoading.show()
        NetworkManager.shared.downloadItem(content) { (result: Result<URL, DownloadError>) in

            switch result {
            case .success(let targetPath):
                DispatchQueue.main.async {
                    RealmManager.shared.setIsDownloaded(item: content, isDownloaded: true)
                }
                self.selectedContentId = uuid
                contents.setItemWith(.sticker, withItemFilePath: targetPath.absoluteString, withItemID: uuid)
                success()
            case .failure(.network):
                fail()
                break
            case .failure(.auth):
                fail()
                break
            case .failure(.content):
                fail()
                break
            }
            ARGLoading.hide()
        }
    }
    
    public func clearContent() {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        contents.clear(.sticker)
        
        self.selectedContentId = nil
    }
}
