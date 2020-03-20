//
//  Utils.h
//  ARGEARSample
//
//  Created by Jihye on 2020/03/20.
//  Copyright © 2020 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define UTILS_PHOTOSAVE_NEED_SHOW_MESSAGE @"photoSaveShowMessage"

@interface Utils : NSObject

+ (Utils *)shared;

- (void)setBoolValue:(NSString *)key value:(BOOL)value;
- (BOOL)getBoolValue:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
