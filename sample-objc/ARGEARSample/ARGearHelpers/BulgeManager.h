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
@property (nonatomic, assign) ARGContentItemBulge mode;

+ (BulgeManager *)shared;

- (void)off;
- (void)setFunMode:(ARGContentItemBulge)mode;

@end

NS_ASSUME_NONNULL_END
