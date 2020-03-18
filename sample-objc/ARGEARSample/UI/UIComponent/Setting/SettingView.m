//
//  SettingView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

#define MENU_LEADING -243
#define kSettingSegmentedControlBackgroundColor [UIColor colorWithRed:41.f/255.f green:52.f/255.f blue:80.f/255.f alpha:1.0f]

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];

    [_autoSaveLabel setText:[@"auto_save" localized]];
    
    UIView *segmentedControlBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 31)];
    [segmentedControlBackView setBackgroundColor:kSettingSegmentedControlBackgroundColor];
    [[segmentedControlBackView layer] setCornerRadius:15.5f];
    UIImage *clearImage = [self getImage:[UIColor clearColor]];
    [_bitrateSegmentedControl setBackgroundImage:clearImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_bitrateSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor], NSFontAttributeName: [UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    [_bitrateSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor], NSFontAttributeName: [UIFont systemFontOfSize:13]} forState:UIControlStateSelected];
    [_bitrateSegmentedControl setDividerImage:clearImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_bitrateSegmentedControl addSubview:segmentedControlBackView];

    [_bitrateSegmentedControl addSubview:_segmentedControlThumb];
    
    [_appInfoLabel setText:[@"application_info" localized]];
    
    [_appVersionLabel setText:[NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
}

- (UIImage *)getImage:(UIColor *)color {
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, 1.f, 1.f);
    UIGraphicsBeginImageContext(imageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, imageRect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setPreferencesWithAutoSave:(BOOL)autoSave showLandmark:(BOOL)showLandmark videoBitrate:(NSInteger)videoBitrate {
    
    [_autoSaveSwitch setOn:autoSave];
    [_autoSaveSwitch setTag:[_autoSaveSwitch isOn]];
    
    [_faceLandmarkSwitch setOn:showLandmark];
    [_faceLandmarkSwitch setTag:[_faceLandmarkSwitch isOn]];
    
    [_bitrateSegmentedControl setSelectedSegmentIndex:videoBitrate];
    [_bitrateSegmentedControl setTag:videoBitrate];
    [self animateBitrateSegmentedControl:videoBitrate];
}

- (void)open {
    [self setHidden:NO];
    
    __weak SettingView *weakSelf = self;
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[weakSelf radiusView] setAlpha:1];
        [[weakSelf menuViewLeading] setConstant:0];

        [self layoutIfNeeded];
    } completion:nil];
}

- (void)close {
    
    __weak SettingView *weakSelf = self;
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[weakSelf radiusView] setAlpha:0];
        [[weakSelf menuViewLeading] setConstant:MENU_LEADING];

        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}

- (IBAction)handleTapFrom:(UITapGestureRecognizer*)tap {
    if ([tap state] == UIGestureRecognizerStateEnded) {
        
        [self close];
    }
}

- (IBAction)autoSaveSwitchAction:(UISwitch *)sender {
    
    [sender setTag:[sender isOn]];
}

- (IBAction)faceLandmarkSwitchAction:(UISwitch *)sender {
    
    [sender setTag:[sender isOn]];
}

- (IBAction)bitrateSegmentedControlAction:(UISegmentedControl *)sender {
    
    NSInteger selectedSeg = [sender selectedSegmentIndex];
    
    [self animateBitrateSegmentedControl:selectedSeg];

    [sender setTag:selectedSeg];
}

- (void)animateBitrateSegmentedControl:(NSInteger)selectedSeg {

    CGFloat xPosition = 2 + 27 * selectedSeg;
    
    NSArray *segmentTitles = @[@"4M bps",
                               @"2M bps",
                               @"1M bps"
    ];

    __weak SettingView *weakSelf = self;
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[weakSelf segmentedControlThumbLeading] setConstant:xPosition];
        [[weakSelf segmentedControlThumbTitleLabel] setText:segmentTitles[selectedSeg]];

        [self layoutIfNeeded];
    } completion:nil];
}

@end
