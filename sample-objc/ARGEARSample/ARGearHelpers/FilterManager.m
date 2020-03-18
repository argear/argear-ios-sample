//
//  FilterManager.m
//  ARGEARSample
//
//  Created by Jihye on 14/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "FilterManager.h"

@implementation FilterManager

+ (FilterManager *)shared {
    static dispatch_once_t pred;
    static FilterManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[FilterManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setFilter:(Item *)item success:(void (^)(void))successBlock fail:(void (^)(void))failBlock {
    
    if ([[RealmManager shared] getDownloadFlag:item]) {
        [_session.contents setItemWithType:ARGContentItemTypeFilter
                                             withItemFilePath:nil
                                                   withItemID:[item uuid]];
        
        
        successBlock();
    } else {
        [ARGLoading show];
        [[NetworkManager shared] downloadItem:item success:^(NSString * _Nonnull uuid, NSURL * _Nonnull targetPath) {
            
            [[RealmManager shared] setDownloadFlag:item isDownload:YES];

            [_session.contents setItemWithType:ARGContentItemTypeFilter
                                                 withItemFilePath:[targetPath absoluteString]
                                                       withItemID:[item uuid]];

            
            [ARGLoading hide];
            successBlock();
        } fail:^{
            [ARGLoading hide];
            failBlock();
        }];
    }
}

- (void)clearFilter {
    [_session.contents setItemWithType:ARGContentItemTypeFilter
                                         withItemFilePath:nil
                                               withItemID:nil];
}

- (void)setFilterLevel:(float)level {
    [_session.contents setFilterLevel:level];
}

@end
