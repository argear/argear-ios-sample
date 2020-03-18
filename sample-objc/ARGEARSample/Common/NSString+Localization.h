//
//  NSString+Localization.h
//  ARGEARSample
//
//  Created by Jihye on 07/11/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Localization)

- (NSString *)localized;
- (NSString *)getLanguageCode;

@end

NS_ASSUME_NONNULL_END
