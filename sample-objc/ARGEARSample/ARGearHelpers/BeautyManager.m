//
//  BeautyManager.m
//  ARGEARSample
//
//  Created by Jihye on 24/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "BeautyManager.h"

@interface BeautyManager() {
    float _beautyValue[ARGContentItemBeautyNum];
}

@end

@implementation BeautyManager

+ (BeautyManager *)shared {
    static dispatch_once_t pred;
    static BeautyManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[BeautyManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _beautyRange200Array = @[
            @(ARGContentItemBeautyChin),
            @(ARGContentItemBeautyEyeGap),
            @(ARGContentItemBeautyNoseLength),
            @(ARGContentItemBeautyMouthSize),
            @(ARGContentItemBeautyEyeCorner),
            @(ARGContentItemBeautyLipSize)
        ];

        [self loadBeautyValue];
    }
    return self;
}


- (void)start {
    [[_session contents] setBulge:ARGContentItemBulgeNONE];
    [[_session contents] setDefaultBeauty];
}

- (void)setDefault {
    [[_session contents] setDefaultBeauty];
}

- (void)off {
    [self loadBeautyValue];
    
    [[_session contents] setBeautyOn:NO];
}

- (void)on {
    [[_session contents] setBeautyValues:_beautyValue];
}


- (void)setBeauty:(ARGContentItemBeauty)type value:(CGFloat)value {
    value = [self convertSliderValueToBeautyValue:type value:value];
    
    [[_session contents] setBeauty:type value:value];
}

- (CGFloat)getBeautyValue:(ARGContentItemBeauty)type {
    CGFloat value = [[_session contents] getBeautyValue:type];
    
    return [self convertBeautyValueToSliderValue:type value:value];
}

- (void)loadBeautyValue {
    for (NSInteger i = 0; i < ARGContentItemBeautyNum; i++) {
        _beautyValue[i] = [[_session contents] getBeautyValue:i];
    }
}

// 0 ~ 1 -> 0 ~ 100 or -100 ~ 100
- (CGFloat)convertSliderValueToBeautyValue:(ARGContentItemBeauty)type value:(CGFloat)value {
    
    if (value < 0) {
        value = 0.0f;
    }
    
    if (value > 1) {
        value = 1.0f;
    }
    
    if ([_beautyRange200Array containsObject:@(type)]) {
        value = (value * 200.f) - 100.f;
    } else {
        value = value * 100.f;
    }
    
    return value;
}

// 0 ~ 100 or -100 ~ 100 -> 0 ~ 1
- (CGFloat)convertBeautyValueToSliderValue:(ARGContentItemBeauty)type value:(CGFloat)value {
    
    if ([_beautyRange200Array containsObject:@(type)]) {
        value = (value + 100.f) / 200.f;
    } else {
        value = value / 100.f;
    }
    
    return value;
}

@end
