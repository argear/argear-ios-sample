//
//  Category.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/04.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    // api
    @objc dynamic var uuid: String?
    @objc dynamic var parentCategoryUuid: String?
    @objc dynamic var title: String?
    @objc dynamic var c_description: String?
    @objc dynamic var slot_no: Int = -1
    @objc dynamic var division: Int = 0
    @objc dynamic var is_bundle: Bool = false
    @objc dynamic var level: Int = 0
    @objc dynamic var status: String?
    @objc dynamic var updated_at: Int = 0

//    @objc dynamic var countries:[String] = [String]()
//    @objc dynamic var items:[Item] = [Item]()
    var countries: List<String> = List<String>()
    var items: List<Item> = List<Item>()

    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    public var data: Any? {
        didSet {
            guard let d = data as? NSDictionary else {
                return
            }
            
            is_bundle = d["is_bundle"] as? Bool ?? false
            c_description = d["description"] as? String ?? ""
            uuid = d["uuid"] as? String ?? ""

            if let itemdatas = d["items"] as? Array<Any> {
                for itemdata in itemdatas {
                    let item = Item()
                    item.data = itemdata
                    items.append(item)
                }
            }
            
            slot_no = d["slot_no"] as? Int ?? 0
            status = d["status"] as? String ?? ""
            title = d["title"] as? String ?? ""
            updated_at = d["updated_at"] as? Int ?? 0
        }
    }
}
