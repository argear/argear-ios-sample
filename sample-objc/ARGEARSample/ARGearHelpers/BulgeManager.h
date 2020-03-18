//
//  BulgeManager.h
//  ARGEARSample
//
//  Created by Jihye on 24/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARGear/ARGear.h>

NS_ASSUME_NONNULL_BEGIN

@interface BulgeManager : NSObject
@property (nonatomic, assign) ARGSession *session;

+ (BulgeManager *)shared;

- (void)on;
- (void)off;
- (void)setFunMode:(NSInteger)mode;

@end

NS_ASSUME_NONNULL_END
