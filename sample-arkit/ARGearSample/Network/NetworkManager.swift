//
//  NetworkManager.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/07.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import Foundation
import ARGear

let API_HOST = "https://apis.argear.io/api/v3/"
let API_KEY = "48cdd456621ebddb5283f516"
let API_SECRET_KEY = "e0ea29ce12178111d2a5e6093a6e048a2a6248b921f092f68c93992ca29a45ee"
let API_AUTH_KEY = "U2FsdGVkX19DguB6YrrW+9R193+Jsekcvt38I7dROnYZ7NkmCuCff843TkNC4CWTgYVplAnXjirwOxK/uAGVqQ=="

class NetworkManager {

    static let shared = NetworkManager()
    
    var argSession: ARGSession?
    
    init() {
    }
    
    func connectAPI() {
        
        let urlString = API_HOST + API_KEY
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print(dataString)
                }
            }
        }
        task.resume()
    }

    func downloadItem(url: String?, title: String?, type: String?) {

        let authCallback: ARGAuthCallback = ARGAuthCallback(Success: { (url: String?) in

            let downloadUrl = URL(string: url!)!
            let task = URLSession.shared.downloadTask(with: downloadUrl) { (url, response, error) in

                if let error = error {
                    print("error: \(error)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                    }

                    var cachesDirectory: URL? = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first
                    cachesDirectory?.appendPathComponent((response?.suggestedFilename)!)

                    if let targetPath = url, let caches = cachesDirectory {

                        let fileManager = FileManager.default
                        do {
                            try fileManager.copyItem(at: targetPath, to: caches)
                        } catch _ {
                        }

                        if let session = self.argSession, let contents = session.contents {

                            var itemType: ARGContentItemType = .sticker
                            if let typeString = type {
                                if typeString == "filter" {
                                    itemType = .filter
                                }
                            }
                            contents.setItemWith(itemType, withItemFilePath: caches.absoluteString, withItemID: caches.deletingPathExtension().lastPathComponent)
                        }
                    }
                }
            }
            task.resume()

        }) { (code: ARGStatusCode) in

        }

        if let session = self.argSession, let auth = session.auth {
            auth.requestSignedUrl(withUrl: url ?? "", itemTitle: title ?? "", itemType: type ?? "", completion: authCallback)
        }
    }
}
