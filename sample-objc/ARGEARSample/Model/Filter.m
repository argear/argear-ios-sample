//
//  Filter.m
//  ARGEARSample
//
//  Created by Jihye on 11/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "Filter.h"

@implementation Filter

+ (NSString *)primaryKey {
    return @"uuid";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             @"uuid" : @"",
             @"parentCategoryUuid" : @"",
             @"title" : @"",
             @"f_description" : @"",
             @"slot_no" : @(-1),
             @"division" : @(-1),
             @"is_bundle" : @(-1),
             @"level" : @(-1),
             @"status" : @"",
             @"updated_at" : @0,
//             @"countries" : ,
//             @"items" : ,
             };
}

@end
