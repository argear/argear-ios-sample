//
//  ModeSelectView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "ModeSelectView.h"

@implementation ModeSelectView

#define kModeSelectViewFullEnableColor [UIColor whiteColor]
#define kModeSelectViewFullDisableColor [[UIColor whiteColor] colorWithAlphaComponent:0.5f]
#define kModeSelectViewEnablePinkColor [UIColor colorWithRed:48.f/255.f green:99.f/255.f blue:230.f/255.f alpha:1.f]
#define kModeSelectViewDisableGrayColor [UIColor colorWithRed:189.f/255.f green:189.f/255.f blue:189.f/255.f alpha:1.f]

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _mode = ARGMediaModePhoto;
    
    NSString *photoString = [@"photo" localized];
    NSString *videoString = [@"video" localized];
    
    [_pictureButton setTitle:photoString forState:UIControlStateNormal];
    [_videoButton setTitle:videoString forState:UIControlStateNormal];
    
    CGSize photoStringSize = [photoString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"NotoSansKR-Regular" size:13.f]}];
    CGSize videoStringSize = [videoString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"NotoSansKR-Regular" size:13.f]}];

    CGFloat viewWidth = 1.5f * photoStringSize.width + 1.5f * videoStringSize.width + 18 * 2 + 5 * 2 + 4;
    [_viewWidth setConstant:viewWidth];
    
    [_pictureButtonWidth setConstant:photoStringSize.width + 2];
    [_videoButtonWidth setConstant:videoStringSize.width + 2];
    
    CGFloat modeButtonsViewWidth = [_pictureButtonWidth constant] + 18.f + [_videoButtonWidth constant];
    [_modeButtonsViewWidth setConstant:modeButtonsViewWidth];
    
    [_underlineViewWidth setConstant:[_pictureButtonWidth constant] + 10];
}

- (IBAction)pictureButtonAction:(UIButton *)sender {
    if (_mode == ARGMediaModeVideo) {
        [self changePhotoMode];
    }
}

- (IBAction)videoButtonAction:(UIButton *)sender {
    if (_mode == ARGMediaModePhoto) {
        [self changeVideoMode];
    }
}

- (IBAction)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer {
    
    if ([recognizer direction] == UISwipeGestureRecognizerDirectionLeft) {
        if (_mode == ARGMediaModePhoto) {
            [self changeVideoMode];
        }
    } else if ([recognizer direction] == UISwipeGestureRecognizerDirectionRight) {
        if (_mode == ARGMediaModeVideo) {
            [self changePhotoMode];
        }
    }
}

// change to photo mode
- (void)changePhotoMode {
    [self setMode:ARGMediaModePhoto];
    
    __weak ModeSelectView *weakSelf = self;
    CGFloat trailing = [[[[_pictureButton titleLabel] text] lowercaseString] isEqualToString:@"photo"] ? 4 : 2;

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[weakSelf modeButtonsViewTrailing] setConstant:trailing];
        [[weakSelf underlineViewWidth] setConstant:[[weakSelf pictureButtonWidth] constant] + 10];

        [weakSelf changeModeColor];
        
        [self layoutIfNeeded];
    } completion:nil];
}

// change to video mode
- (void)changeVideoMode {
    [self setMode:ARGMediaModeVideo];
    
    __weak ModeSelectView *weakSelf = self;
    CGFloat trailing = [[[[_pictureButton titleLabel] text] lowercaseString] isEqualToString:@"photo"] ? 2 : 0;

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[weakSelf modeButtonsViewTrailing] setConstant:2 + [[weakSelf pictureButtonWidth] constant]/2 + 18 + [[weakSelf videoButtonWidth] constant]/2 + trailing];
        [[weakSelf underlineViewWidth] setConstant:[[weakSelf videoButtonWidth] constant] + 10];
        
        [weakSelf changeModeColor];
        
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)changeModeColor {
    if ([[_underlineView backgroundColor] isEqual:kModeSelectViewFullEnableColor]) {
        // full
        if (_mode == ARGMediaModePhoto) {
            
            [_pictureButton setTitleColor:kModeSelectViewFullEnableColor forState:UIControlStateNormal];
            [_videoButton setTitleColor:kModeSelectViewFullDisableColor forState:UIControlStateNormal];
        } else {

            [_pictureButton setTitleColor:kModeSelectViewFullDisableColor forState:UIControlStateNormal];
            [_videoButton setTitleColor:kModeSelectViewFullEnableColor forState:UIControlStateNormal];
        }
    } else {
        // 4:3, 1:1
        if (_mode == ARGMediaModePhoto) {
            
            [_pictureButton setTitleColor:kModeSelectViewEnablePinkColor forState:UIControlStateNormal];
            [_videoButton setTitleColor:kModeSelectViewDisableGrayColor forState:UIControlStateNormal];
        } else {
            
            [_pictureButton setTitleColor:kModeSelectViewDisableGrayColor forState:UIControlStateNormal];
            [_videoButton setTitleColor:kModeSelectViewEnablePinkColor forState:UIControlStateNormal];
        }
    }
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    if (ratio == ARGMediaRatio_16x9) {
        
        [_underlineView setBackgroundColor:kModeSelectViewFullEnableColor];
    } else {

        [_underlineView setBackgroundColor:kModeSelectViewEnablePinkColor];
    }
    [self changeModeColor];
}

@end
