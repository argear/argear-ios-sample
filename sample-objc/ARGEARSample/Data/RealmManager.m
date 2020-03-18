//
//  RealmManager.m
//  ARGEARSample
//
//  Created by Jihye on 30/08/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "RealmManager.h"
#import <AFNetworking/AFNetworking.h>
#import <Realm/Realm.h>

@implementation RealmManager

const int REALM_SCHEME_VERSION = 1;

+ (RealmManager *)shared {
    static dispatch_once_t pred;
    static RealmManager *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[RealmManager alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)checkAndMigration {
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion  = REALM_SCHEME_VERSION;
    
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
//        NSLog(@"Realm migration ver %d", REALM_SCHEME_VERSION);
    };
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
}

#pragma mark - Set data
- (void)setAPIData:(NSDictionary *)data {
    
    if (!data) {
        return;
    }
    
    NSNumber *apiLastUpdatedAt = data[@"last_updated_at"];
    NSNumber *localLastUpdatedAt = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_updated_at"];
    
    if (localLastUpdatedAt && [apiLastUpdatedAt longValue] == [localLastUpdatedAt longValue]) {
        return;
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        NSMutableArray *categories = [NSMutableArray array];
        NSMutableArray *filters = [NSMutableArray array];
        NSArray *categoriesArray = data[@"categories"];
        
        // insert categories
        for (int c = 0; c < [categoriesArray count]; c++) {
            
            NSString *categoryTitle = categoriesArray[c][@"title"];
            if (categoryTitle && [categoryTitle isEqualToString:@"filters"]) {
                
                Filter *filter = [[Filter alloc] initWithValue:categoriesArray[c]];
                [filter setF_description:categoriesArray[c][@"description"]];
    
                // insert items
                for (int i = 0; i < [[filter items] count]; i++) {
                    Item *item = [[filter items] objectAtIndex:i];
                    [item setI_description:categoriesArray[c][@"items"][i][@"description"]];
    
                    NSString *query = [NSString stringWithFormat:@"uuid == '%@'", [item uuid]];
                    Item *queryResult = [[Item objectsWhere:query] firstObject];
                    if (queryResult) {
                        if ([queryResult updated_at] == [item updated_at]) {
                            [item setIsDownloaded:[queryResult isDownloaded]];
                        } else {
                            [item setIsDownloaded:NO];
                        }
                    } else {
                        [item setIsDownloaded:NO];
                    }
                }
    
                [filters addObject:filter];
            } else {
                
                Category *category = [[Category alloc] initWithValue:categoriesArray[c]];
                [category setC_description:categoriesArray[c][@"description"]];
                
                // insert items
                for (int i = 0; i < [[category items] count]; i++) {
                    Item *item = [[category items] objectAtIndex:i];
                    [item setI_description:categoriesArray[c][@"items"][i][@"description"]];
                    
                    NSString *query = [NSString stringWithFormat:@"uuid == '%@'", [item uuid]];
                    Item *queryResult = [[Item objectsWhere:query] firstObject];
                    if (queryResult) {
                        if ([queryResult updated_at] == [item updated_at]) {
                            [item setIsDownloaded:[queryResult isDownloaded]];
                        } else {
                            [item setIsDownloaded:NO];
                        }
                    } else {
                        [item setIsDownloaded:NO];
                    }
                }
                
                [categories addObject:category];
            }
        }
        
        [realm deleteObjects:[Category allObjects]];
        [realm deleteObjects:[Filter allObjects]];
        [realm deleteObjects:[Item allObjects]];
        
        for (Category *category in categories) {
            [realm addOrUpdateObject:category];
        }
        
        for (Filter *filter in filters) {
            [realm addOrUpdateObject:filter];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:apiLastUpdatedAt forKey:@"last_updated_at"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

#pragma mark - Get data
- (NSArray *)getAllCategories {
    NSMutableArray *categoriesArray = [[NSMutableArray alloc] init];
    RLMResults *categories = [Category allObjects];
    
    for (Category *category in categories) {
        [categoriesArray addObject:category];
    }
    
    return categoriesArray;
}

- (NSArray *)getAllFilters {
    NSMutableArray *filterssArray = [[NSMutableArray alloc] init];
    RLMResults *filters = [Filter allObjects];
    
    for (Filter *filter in filters) {
        [filterssArray addObject:filter];
    }
    
    return filterssArray;
}

// isDownload flag
- (void)setDownloadFlag:(Item *)item isDownload:(BOOL)flag {
    [[RLMRealm defaultRealm] transactionWithBlock:^{
        [item setIsDownloaded:flag];
    }];
}

- (BOOL)getDownloadFlag:(Item *)item {
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid = %@ AND status = %@", itemId, kRealmStatusLIVE];
    NSString *uuid = [item uuid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
    RLMResults<Item *> *result = [Item objectsWithPredicate:predicate];
    
    BOOL isDownloaded = NO;
    if ([result firstObject]) {
        isDownloaded = [[result firstObject] isDownloaded];
    }
    
    return isDownloaded;
}

@end
