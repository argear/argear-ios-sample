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
    
    public func setFilter(_ filter: Item, successBlock: @escaping FilterCompletion, failBlock: @escaping FilterCompletion) {
        guard let session = self.argSession, let contents = session.contents, let uuid = filter.uuid
            else {
                failBlock()
                return
        }
        
        if RealmManager.shared.getIsDownloaded(item: filter) {
            contents.setItemWith(.filter, withItemFilePath: nil, withItemID: uuid) { (success, msg) in
                if (success) {
                    successBlock()
                } else {
                    failBlock()
                }
            }
        } else {
            ARGLoading.show()
            NetworkManager.shared.downloadItem(filter) { (result: Result<URL, DownloadError>) in

                switch result {
                case .success(let targetPath):
                    DispatchQueue.main.async {
                        RealmManager.shared.setIsDownloaded(item: filter, isDownloaded: true)
                    }
                    contents.setItemWith(.filter, withItemFilePath: targetPath.absoluteString, withItemID: uuid) { (success, msg) in
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
    
    public func clearFilter() {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        contents.clear(.filter)
    }
    
    public func setFilterLevel(_ level: Float) {
        guard let session = self.argSession, let contents = session.contents
            else { return }
        
        contents.setFilterLevel(convertSliderValueToFilterLevel(value: level))
    }
    
    private func convertSliderValueToFilterLevel(value: Float) -> Float {
        var filterLevel = value
        if (value < 0) {
            filterLevel = 0.0
        }
        
        if (value > 1) {
            filterLevel = 1.0
        }
        
        filterLevel = filterLevel * 100.0
        
        return filterLevel;
    }
}
