//
//  RealmManager.swift
//  ARGearSample
//
//  Created by Jihye on 2020/02/05.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import Foundation
import RealmSwift

typealias RealmCompletion = (_ result: Bool) -> Void

class RealmManager {
    
    let REALM_SCHEME_VERSION: UInt64 = 2;

    static let shared = RealmManager()
    
    init() {
    }
    
    func checkAndMigration() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: REALM_SCHEME_VERSION,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    func setARGearData(_ data: Dictionary<String, Any>?, completion: RealmCompletion?) {
        guard
            let data = data,
            let apiLastUpdatedAt = data["last_updated_at"] as? Int,
            let categoriesData = data["categories"] as? [[String: Any]]
        else {
            if let completion = completion {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
            return
        }

        // check last_updated_at
        let localLastUpdatedAt = UserDefaults.standard.integer(forKey: "last_updated_at")
        if localLastUpdatedAt > 0, apiLastUpdatedAt == localLastUpdatedAt {
            if let completion = completion {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
            return
        }
        
        let realm = try! Realm()

        try! realm.write {
            var categories = [Category]()
            var filters = [Filter]()
                
            // insert categoriesData
            for (_, category) in categoriesData.enumerated() {
                guard let title = category["title"] as? String
                    else { return }
                
                if title == "filters" {
                    // insert filter category
                    let filtersData = Filter()
                    filtersData.data = category
                    
                    for (_, item) in filtersData.items.enumerated() {
                        guard let uuid = item.uuid else { return }
                        
                        // compare db's data and api's data
                        let predicate = NSPredicate(format: "uuid = %@", uuid)
                        let dbItems = realm.objects(Item.self).filter(predicate)
                        if let dbItem = dbItems.first {
                            let dbUpdatedAt = dbItem.updated_at
                            let apiUpdatedAt = item.updated_at
                            
                            if dbUpdatedAt == apiUpdatedAt {
                                item.isDownloaded = dbItem.isDownloaded
                            }
                        }
                    }
                    filters.append(filtersData)
                } else {
                    // insert category
                    let categoriesData = Category()
                    categoriesData.data = category
                    
                    for (_, item) in categoriesData.items.enumerated() {
                        guard let uuid = item.uuid else { return }

                        // compare db's data and api's data
                        let predicate = NSPredicate(format: "uuid = %@", uuid)
                        let dbItems = realm.objects(Item.self).filter(predicate)
                        if let dbItem = dbItems.first {
                            let dbUpdatedAt = dbItem.updated_at
                            let apiUpdatedAt = item.updated_at
                            
                            if dbUpdatedAt == apiUpdatedAt {
                                item.isDownloaded = dbItem.isDownloaded
                            }
                        }
                    }
                    categories.append(categoriesData)
                }
            }
            
            // delete categories
            let dbCategories = realm.objects(Category.self)
            for dbCategory in dbCategories {
                realm.delete(dbCategory)
            }
            // delete filters
            let dbFilters = realm.objects(Filter.self)
            for dbFilter in dbFilters {
                realm.delete(dbFilter)
            }
            // delete items
            let dbItems = realm.objects(Item.self)
            for dbItem in dbItems {
                realm.delete(dbItem)
            }
            
            realm.add(categories)
            realm.add(filters)
            
            // save last_updated_at
            UserDefaults.standard.set(apiLastUpdatedAt, forKey: "last_updated_at")
            UserDefaults.standard.synchronize()
        }
        
        if let completion = completion {
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
    func getCategories() -> [Category] {
        let realm = try! Realm()
        
        var categories: [Category] = [Category]()
        for category in realm.objects(Category.self) {
            categories.append(category)
        }
        
        return categories
    }
    
    func getFilters() -> [Item] {
        let realm = try! Realm()
        
        var filters: [Item] = [Item]()
        for filter in realm.objects(Filter.self) {
            for item in filter.items {
                filters.append(item)
            }
        }
        
        return filters
    }
    
    func getIsDownloaded(item: Item) -> Bool {
        guard let uuid = item.uuid else {
            return false
        }
        
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "uuid = %@", uuid)
        let dbItems = realm.objects(Item.self).filter(predicate)
        
        var isDownloaded = false
        if let dbItem = dbItems.first {
            isDownloaded = dbItem.isDownloaded
        }
        
        return isDownloaded
    }
    
    func setIsDownloaded(item: Item, isDownloaded: Bool) {
        let realm = try! Realm()
        
        try! realm.write {
            item.isDownloaded = isDownloaded
        }
    }
}
