//
//  Utils.m
//  ARGEARSample
//
//  Created by Jihye on 2020/03/20.
//  Copyright © 2020 Seerslab. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (Utils *)shared {
    static dispatch_once_t pred;
    static Utils *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[Utils alloc] init];
    });
    return sharedInstance;
}

- (void)setBoolValue:(NSString *)key value:(BOOL)value {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

- (BOOL)getBoolValue:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    return [userDefaults boolForKey:key];
}

@end
