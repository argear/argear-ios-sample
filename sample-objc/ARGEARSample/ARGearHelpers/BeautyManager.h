//
//  BeautyManager.h
//  ARGEARSample
//
//  Created by Jihye on 24/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARGear/ARGear.h>

NS_ASSUME_NONNULL_BEGIN

@interface BeautyManager : NSObject
@property (nonatomic, assign) ARGSession *session;
@property (nonatomic, strong) NSArray *beautyRange200Array; // -100 ~ 100 range beauty type

+ (BeautyManager *)shared;

- (void)start;
- (void)setDefault;
- (void)off;
- (void)on;

- (void)setBeauty:(ARGContentItemBeauty)type value:(CGFloat)value;
- (CGFloat)getBeautyValue:(ARGContentItemBeauty)type;

@end

NS_ASSUME_NONNULL_END
