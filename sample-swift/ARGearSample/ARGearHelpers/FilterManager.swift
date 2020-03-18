//
//  FilterManager.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/10.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import Foundation
import ARGear

typealias FilterCompletion = () -> Void

class FilterManager {
    static let shared = FilterManager()
    
    var argSession: ARGSession?
    
    public func setFilter(_ filter: Item, success: @escaping FilterCompletion, fail: @escaping FilterCompletion) {
        guard let session = self.argSession, let contents = session.contents, let uuid = filter.uuid
            else {
                fail()
                return
        }
        
        if RealmManager.shared.getIsDownloaded(item: filter) {
            contents.setItemWith(.filter, withItemFilePath: nil, withItemID: uuid)
            success()
            return
        }
        
        ARGLoading.show()
        NetworkManager.shared.downloadItem(filter) { (result: Result<URL, DownloadError>) in

            switch result {
            case .success(let targetPath):
                DispatchQueue.main.async {
                    RealmManager.shared.setIsDownloaded(item: filter, isDownloaded: true)
                }
                contents.setItemWith(.filter, withItemFilePath: targetPath.absoluteString, withItemID: uuid)
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
    
    public func clearFilter() {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        contents.clear(.filter)
    }
    
    public func setFilterLevel(_ level: Float) {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        contents.setFilterLevel(level)
    }
}
