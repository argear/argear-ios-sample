//
//  ARGPreferences.m
//  ARGEARSample
//
//  Created by Jihye on 13/11/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "ARGPreferences.h"

@implementation ARGPreferences

- (id)init {
    self = [super init];
    if (self) {
        _showLandmark = [self loadBoolValue:kARGPreferencesShowLandmark];
        _videoBitrate = [self loadIntegerValue:kARGPreferencesVideoBitrate];
    }
    
    return self;
}

// load
- (BOOL)loadBoolValue:(NSString *)key {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

- (NSInteger)loadIntegerValue:(NSString *)key {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:key];
}

// store
- (void)storeBoolValue:(BOOL)value key:(NSString *)key {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
}

- (void)storeIntegerValue:(NSInteger)value key:(NSString *)key {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:key];
}

- (void)setShowLandmark:(BOOL)showLandmark {
    
    _showLandmark = showLandmark;
    
    [self storeBoolValue:showLandmark key:kARGPreferencesShowLandmark];
}

- (void)setVideoBitrate:(NSInteger)videoBitrate {
    
    _videoBitrate = videoBitrate;
    
    [self storeIntegerValue:videoBitrate key:kARGPreferencesVideoBitrate];
}

@end
