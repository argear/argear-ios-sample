//
//  ARGPreferences.h
//  ARGEARSample
//
//  Created by Jihye on 13/11/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kARGPreferencesShowLandmark @"kARGPreferencesShowLandmark"
#define kARGPreferencesVideoBitrate @"kARGPreferencesVideoBitrate"

@interface ARGPreferences : NSObject

@property (nonatomic, assign) BOOL showLandmark;
@property (nonatomic, assign) NSInteger videoBitrate;

- (void)storeBoolValue:(BOOL)value key:(NSString *)key;
- (void)storeIntegerValue:(NSInteger)value key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
