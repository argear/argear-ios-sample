//
//  RealmManager.h
//  ARGEARSample
//
//  Created by Jihye on 30/08/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RealmManager : NSObject

+ (RealmManager *)shared;

- (void)checkAndMigration;

- (void)setAPIData:(NSDictionary *)data;

- (NSArray *)getAllCategories;
- (NSArray *)getAllFilters;

- (void)setDownloadFlag:(Item *)item isDownload:(BOOL)flag;
- (BOOL)getDownloadFlag:(Item *)item;

@end

NS_ASSUME_NONNULL_END
