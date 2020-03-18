//
//  FilterManager.h
//  ARGEARSample
//
//  Created by Jihye on 14/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARGear/ARGear.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterManager : NSObject
@property (nonatomic, assign) ARGSession *session;

+ (FilterManager *)shared;

- (void)setFilter:(Item *)item success:(void (^)(void))successBlock fail:(void (^)(void))failBlock;
- (void)clearFilter;
- (void)setFilterLevel:(float)level;

@end

NS_ASSUME_NONNULL_END
