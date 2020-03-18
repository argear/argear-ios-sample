//
//  AccessAgreeView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "PermissionView.h"

@implementation PermissionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _permission = [[Permission alloc] init];
    
    [_permissionTitleLabel setText:[@"application_permissions" localized]];
    [_permissionAgreeMessageLabel setText:[@"permission_message" localized]];

    [_permissionDeniedTitleLabel setText:[@"application_denied" localized]];
    [_permissionDeniedMessageLabel setText:[@"denied_message" localized]];

    [_cameraLabel setText:[@"camera" localized]];
    [_storageLabel setText:[@"storage" localized]];
    [_microphoneLabel setText:[@"microphone" localized]];
    
    [_permissionAgreeOKButton setTitle:[@"allow" localized] forState:UIControlStateNormal];
    [_permissionDeniedOKButton setTitle:[@"allow" localized] forState:UIControlStateNormal];
}

- (void)permissionCheck:(PermissionGrantedBlock)granted {
    
    [_permission setGranted:granted];
    
    [self permissionCheck];
}

- (void)permissionCheck {
    [self setStatus:[_permission getPermissionLevel]];
}

- (void)setStatus:(PermissionLevel)status {
    
    _status = status;
    
    switch (status) {
        case PermissionLevelGranted:
            // Hidden
            [_permission granted]();
            [self removeFromSuperview];
            break;
        case PermissionLevelRestricted:
            // show AccessDeniedView
            [_permissionAgreeView setHidden:YES];
            [_permissionDeniedView setHidden:NO];
            break;
        case PermissionLevelNone:
            // show AccessAgreeView
            [_permissionAgreeView setHidden:NO];
            [_permissionDeniedView setHidden:YES];
            break;
        default:
            [self removeFromSuperview];
            break;
    }
}

- (IBAction)permissionAgreeOKButtonAction:(UIButton *)sender {
    
    [_permission permissionAllAllowAction:^{
        [self permissionCheck];
    }];
}

- (IBAction)permissionDeniedOKButtonAction:(UIButton *)sender {

    [_permission openSettings];
}

@end
