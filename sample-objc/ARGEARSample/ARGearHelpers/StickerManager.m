//
//  StickerManager.m
//  ARGEARSample
//
//  Created by Jihye on 15/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "StickerManager.h"

@implementation StickerManager

+ (StickerManager *)shared {
    static dispatch_once_t pred;
    static StickerManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[StickerManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setSticker:(Item *)item success:(void (^)(BOOL exist))successBlock fail:(void (^)(void))failBlock {
    
    if ([[RealmManager shared] getDownloadFlag:item]) {

        [_session.contents setItemWithType:ARGContentItemTypeSticker
                                             withItemFilePath:nil
                                                   withItemID:[item uuid]];
        
        successBlock(YES);
    } else {
        [ARGLoading show];
        [[NetworkManager shared] downloadItem:item success:^(NSString * _Nonnull uuid, NSURL * _Nonnull targetPath) {
            [[RealmManager shared] setDownloadFlag:item isDownload:YES];
            
            [_session.contents setItemWithType:ARGContentItemTypeSticker
                                                 withItemFilePath:[targetPath absoluteString]
                                                       withItemID:[item uuid]];
            
            [ARGLoading hide];
            successBlock(NO);
        } fail:^{
            [ARGLoading hide];
            failBlock();
        }];
    }
}

- (void)clearSticker {
    [_session.contents setItemWithType:ARGContentItemTypeSticker
                                         withItemFilePath:nil
                                               withItemID:nil];
    
    _selectedItemId = @"";
}

@end
