//
//  MainViewController.h
//  ARGEARSample
//
//  Created by Jihye on 05/08/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SplashView.h"
#import "PermissionView.h"
#import "MainTopFunctionView.h"
#import "MainBottomFunctionView.h"
#import "SettingView.h"
#import "RatioView.h"
 
@interface MainViewController : UIViewController
<PermissionDelegate, MainTopFunctionDelegate, MainBottomFunctionDelegate>

@property (weak, nonatomic) IBOutlet SplashView *splashView;
@property (weak, nonatomic) IBOutlet RatioView *ratioView;
@property (weak, nonatomic) IBOutlet UIView *touchLockView;
@property (weak, nonatomic) IBOutlet PermissionView *permissionView;
@property (weak, nonatomic) IBOutlet MainTopFunctionView *mainTopFunctionView;
@property (weak, nonatomic) IBOutlet MainBottomFunctionView *mainBottomFunctionView;
@property (weak, nonatomic) IBOutlet SettingView *settingView;

@end
