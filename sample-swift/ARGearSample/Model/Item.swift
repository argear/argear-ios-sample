//
//  Item.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/04.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    // api
    @objc dynamic var uuid: String?
    @objc dynamic var title: String?
    @objc dynamic var i_description: String?
    @objc dynamic var thumbnail: String?
    @objc dynamic var zip_file: String?
    @objc dynamic var num_stickers: Int = 0
    @objc dynamic var num_effects: Int = 0
    @objc dynamic var num_bgms: Int = 0
    @objc dynamic var num_filters: Int = 0
    @objc dynamic var num_masks: Int = 0
    @objc dynamic var has_trigger: Bool = false
    @objc dynamic var status: String?
    @objc dynamic var updated_at: Int = 0
    @objc dynamic var big_thumbnail: String?
    @objc dynamic var type: String?
    // local
    @objc dynamic var isDownloaded: Bool = false
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    public var data: Any? {
        didSet {
            guard let d = data as? Dictionary<String, Any> else {
                return
            }
            
            uuid = d["uuid"] as? String ?? ""
            
            title = d["title"] as? String ?? ""
            i_description = d["description"] as? String ?? ""
            thumbnail = d["thumbnail"] as? String ?? ""
            zip_file = d["zip_file"] as? String ?? ""
            num_stickers = d["num_stickers"] as? Int ?? 0
            num_effects = d["num_effects"] as? Int ?? 0
            num_bgms = d["num_bgms"] as? Int ?? 0
            num_filters = d["num_filters"] as? Int ?? 0
            num_masks = d["num_masks"] as? Int ?? 0
            has_trigger = d["has_trigger"] as? Bool ?? false
            status = d["status"] as? String ?? ""
            updated_at = d["updated_at"] as? Int ?? 0
            big_thumbnail = d["big_thumbnail"] as? String ?? ""
            type = d["type"] as? String ?? ""

            isDownloaded = false
        }
    }
}
