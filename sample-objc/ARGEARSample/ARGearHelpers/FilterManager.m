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
                                withItemID:[item uuid]
                                completion:^(BOOL success, NSString * _Nullable msg) {
            if (success) {
                successBlock();
            } else {
                failBlock();
            }
        }];
    } else {
        [ARGLoading show];
        [[NetworkManager shared] downloadItem:item success:^(NSString * _Nonnull uuid, NSURL * _Nonnull targetPath) {
            
            [[RealmManager shared] setDownloadFlag:item isDownload:YES];

            [self->_session.contents setItemWithType:ARGContentItemTypeFilter
                                    withItemFilePath:[targetPath absoluteString]
                                          withItemID:[item uuid]
                                          completion:^(BOOL success, NSString * _Nullable msg) {
                [ARGLoading hide];
                if (success) {
                    successBlock();
                } else {
                    failBlock();
                }
            }];
        } fail:^{
            [ARGLoading hide];
            failBlock();
        }];
    }
}

- (void)clearFilter {
    [_session.contents setItemWithType:ARGContentItemTypeFilter
                      withItemFilePath:nil
                            withItemID:nil
                            completion:nil];
}

- (void)setFilterLevel:(float)level {
    [_session.contents setFilterLevel:[self convertSliderValueToFilterLevel:level]];
}

// 0 ~ 1 -> 0 ~ 100
- (CGFloat)convertSliderValueToFilterLevel:(CGFloat)value {
    
    if (value < 0) {
        value = 0.0f;
    }
    
    if (value > 1) {
        value = 1.0f;
    }
    
    value = value * 100.f;
    
    return value;
}

@end
