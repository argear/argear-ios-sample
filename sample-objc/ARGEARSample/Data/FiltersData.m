//
//  FiltersData.m
//  ARGEARSample
//
//  Created by Jihye on 14/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "FiltersData.h"

@implementation FiltersData

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)getFiltersData:(void (^)(NSArray *filters))completionHandler {
    
    NSMutableArray *data = [[NSMutableArray alloc] init];

    Filter *filters = [[[RealmManager shared] getAllFilters] firstObject];
    for (Item *item in [filters items]) {
        [data addObject:item];
    }
    
    completionHandler(data);
}

@end
