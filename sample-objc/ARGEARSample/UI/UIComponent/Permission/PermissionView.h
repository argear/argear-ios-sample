//
//  PermissionView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Permission.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PermissionDelegate <NSObject>
@optional
- (void)permissionStatusChanged:(PermissionLevel)permissionLevel;
@end

@interface PermissionView : UIView

@property (nonatomic, unsafe_unretained) id <PermissionDelegate> _Nullable permissionDelegate;

@property (weak, nonatomic) IBOutlet UIView *permissionAgreeView;
@property (weak, nonatomic) IBOutlet UILabel *permissionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *permissionAgreeMessageLabel;

@property (weak, nonatomic) IBOutlet UIView *permissionDeniedView;
@property (weak, nonatomic) IBOutlet UILabel *permissionDeniedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *permissionDeniedMessageLabel;

@property (weak, nonatomic) IBOutlet UIButton *permissionAgreeOKButton;
@property (weak, nonatomic) IBOutlet UIButton *permissionDeniedOKButton;

@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;
@property (weak, nonatomic) IBOutlet UILabel *storageLabel;
@property (weak, nonatomic) IBOutlet UILabel *microphoneLabel;

@property (nonatomic, strong) Permission *permission;

@property (nonatomic, assign) PermissionLevel status;

- (void)permissionCheck:(PermissionGrantedBlock)granted;

@end

NS_ASSUME_NONNULL_END
