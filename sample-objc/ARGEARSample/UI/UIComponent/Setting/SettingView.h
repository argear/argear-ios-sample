//
//  SettingView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingView : UIView

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *touchView;
@property (weak, nonatomic) IBOutlet UIView *radiusView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuViewLeading;   // 243

@property (weak, nonatomic) IBOutlet UISwitch *autoSaveSwitch;
@property (weak, nonatomic) IBOutlet UILabel *autoSaveLabel;
@property (weak, nonatomic) IBOutlet UISwitch *faceLandmarkSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bitrateSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *segmentedControlThumb;
@property (weak, nonatomic) IBOutlet UILabel *segmentedControlThumbTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentedControlThumbLeading;
@property (weak, nonatomic) IBOutlet UILabel *appInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;

- (void)setPreferencesWithAutoSave:(BOOL)autoSave showLandmark:(BOOL)showLandmark videoBitrate:(NSInteger)videoBitrate;

- (void)open;

@end

NS_ASSUME_NONNULL_END
