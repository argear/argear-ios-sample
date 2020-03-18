//
//  NSString+Localization.m
//  ARGEARSample
//
//  Created by Jihye on 07/11/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "NSString+Localization.h"

@implementation NSString(Localization)

- (NSString *)localized {

    return NSLocalizedString(self, @"");
}

- (NSString *)getLanguageCode {
    
    NSString *languageCode = @"";
    if (@available(iOS 10.0, *)) {
        languageCode = [[NSLocale currentLocale] languageCode];
    } else {
        // Fallback on earlier versions
        languageCode = [[[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2] lowercaseString];
    }
    
    return [languageCode isEqualToString:@"ko"] ? languageCode : @"en";
}

@end
