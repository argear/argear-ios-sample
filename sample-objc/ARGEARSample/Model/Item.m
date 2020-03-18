//
//  Item.m
//  ARGEARSample
//
//  Created by Jihye on 08/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "Item.h"

@implementation Item

+ (NSString *)primaryKey {
    return @"uuid";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             @"uuid" : @"",
             @"title" : @"",
             @"i_description" : @"",
             @"thumbnail" : @"",
             @"zip_file" : @"",
             @"num_stickers" : @0,
             @"num_effects" : @0,
             @"num_bgms" : @0,
             @"num_filters" : @0,
             @"num_masks" : @0,
             @"has_trigger" : @NO,
             @"status" : @"",
             @"updated_at" : @0,
             @"big_thumbnail" : @"",
             @"myitem_status" : @"",
             @"isDownloaded" : @NO,
             };
}

@end
