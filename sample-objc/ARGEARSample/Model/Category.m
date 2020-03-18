//
//  Category.m
//  ARGEARSample
//
//  Created by Jihye on 10/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "Category.h"

@implementation Category

+ (NSString *)primaryKey {
    return @"uuid";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{
             @"uuid" : @"",
             @"parentCategoryUuid" : @"",
             @"title" : @"",
             @"c_description" : @"",
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
