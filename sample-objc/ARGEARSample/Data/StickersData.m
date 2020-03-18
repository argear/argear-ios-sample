//
//  StickersData.m
//  ARGEARSample
//
//  Created by Jihye on 11/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "StickersData.h"

@implementation StickersData

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)getStickersData:(void (^)(NSArray *stickers, NSArray *titles))completionHandler {

    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    [data addObjectsFromArray:[[RealmManager shared] getAllCategories]];
    
    NSMutableArray *titlesArray = [[NSMutableArray alloc] init];
    for (Category *category in data) {
        [titlesArray addObject:[category title]];
    }
    
    completionHandler(data, titlesArray);
}

- (void)getItemsData:(Category *)category completion:(void (^)(NSArray *items))completionHandler {
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    for (Item *item in [category items]) {
        [data addObject:item];
    }
    
    completionHandler(data);
}

@end
