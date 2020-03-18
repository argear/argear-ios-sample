//
//  StickerManager.h
//  ARGEARSample
//
//  Created by Jihye on 15/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARGear/ARGear.h>

NS_ASSUME_NONNULL_BEGIN

@interface StickerManager : NSObject
@property (nonatomic, assign) ARGSession *session;
@property (nonatomic, strong) NSString *selectedItemId;

+ (StickerManager *)shared;

- (void)setSticker:(Item *)item success:(void (^)(BOOL exist))successBlock fail:(void (^)(void))failBlock;
- (void)clearSticker;

@end

NS_ASSUME_NONNULL_END
