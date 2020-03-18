//
//  BulgeManager.m
//  ARGEARSample
//
//  Created by Jihye on 24/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "BulgeManager.h"

@implementation BulgeManager

+ (BulgeManager *)shared {
    static dispatch_once_t pred;
    static BulgeManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[BulgeManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)on {
}

- (void)off {
    [_session.contents setBulge:ARGContentItemBulgeNONE];
}

- (void)setFunMode:(NSInteger)mode {
    [_session.contents setBulge:mode];
}

@end
