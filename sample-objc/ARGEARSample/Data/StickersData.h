//
//  StickersData.h
//  ARGEARSample
//
//  Created by Jihye on 11/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StickersData : NSObject

- (void)getStickersData:(void (^)(NSArray *stickers, NSArray *titles))completionHandler;
- (void)getItemsData:(Category *)category completion:(void (^)(NSArray *items))completionHandler;

@end

NS_ASSUME_NONNULL_END
