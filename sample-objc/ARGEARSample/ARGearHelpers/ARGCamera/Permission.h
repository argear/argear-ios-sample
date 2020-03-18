//
//  Permission.h
//  ARGEARSample
//
//  Created by Jihye on 19/08/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PermissionGrantedBlock)(void);
typedef void (^PermissionEndBlock) (void);

typedef NS_ENUM(NSInteger, PermissionActionType) {
    PermissionActionTypeCamera          = 0,
    PermissionActionTypeLibrary         = 1,
    PermissionActionTypeMic             = 2,
};

typedef NS_ENUM(NSInteger, PermissionLevel) {
    PermissionLevelGranted      = 0,            
    PermissionLevelRestricted   = 1,            
    PermissionLevelNone         = 2,            
};

@interface Permission : NSObject

@property (copy, nonatomic) PermissionEndBlock permissionGrantedBlock;
@property (copy, nonatomic) PermissionEndBlock permissionRestrictedBlock;

@property (copy, nonatomic) PermissionGrantedBlock granted;

- (void)permissionAllAllowAction:(PermissionEndBlock)endedBlock;
- (void)openSettings;
- (PermissionLevel)getPermissionLevel;

@end

NS_ASSUME_NONNULL_END
