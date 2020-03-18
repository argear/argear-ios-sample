//
//  PreviewBottomFunctionView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "PreviewBottomFunctionView.h"

@implementation PreviewBottomFunctionView

#define kPreviewBottomFunctionBackButtonName @"icBack"
#define kPreviewBottomFunctionSaveButtonName @"btnDownload"
#define kPreviewBottomFunctionCheckButtonName @"btnCheck"
#define kPreviewBottomFunctionShareButtonName @"icShare"

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImages:(ARGMediaRatio)ratio {
    NSMutableString *backButtonImageString = [NSMutableString stringWithString:kPreviewBottomFunctionBackButtonName];
    NSMutableString *saveButtonImageString = [NSMutableString stringWithString:kPreviewBottomFunctionSaveButtonName];
    NSMutableString *checkButtonImageString = [NSMutableString stringWithString:kPreviewBottomFunctionCheckButtonName];
    NSMutableString *shareButtonImageString = [NSMutableString stringWithString:kPreviewBottomFunctionShareButtonName];
    
    if (ratio == ARGMediaRatio_16x9) {
        // white
        [backButtonImageString appendString:@"White"];
        [saveButtonImageString appendString:@"White"];
        [checkButtonImageString appendString:@"White"];
        [shareButtonImageString appendString:@"White"];
    } else {
        // pink
        [backButtonImageString appendString:@"Black"];
        [saveButtonImageString appendString:@"Pink"];
        [checkButtonImageString appendString:@"Pink"];
        [shareButtonImageString appendString:@"Black"];
    }
    
    [_backButton setImage:[UIImage imageNamed:[NSString stringWithString:backButtonImageString]] forState:UIControlStateNormal];
    [_saveButton setImage:[UIImage imageNamed:[NSString stringWithString:saveButtonImageString]] forState:UIControlStateNormal];
    [_checkButton setImage:[UIImage imageNamed:[NSString stringWithString:checkButtonImageString]] forState:UIControlStateNormal];
    [_shareButton setImage:[UIImage imageNamed:[NSString stringWithString:shareButtonImageString]] forState:UIControlStateNormal];
}

- (void)showCheckButton {
    [_saveButton setHidden:YES];
    [_checkButton setHidden:NO];
}

- (IBAction)backButtonAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(backButtonAction)]) {
        [_delegate backButtonAction];
    }
}

- (IBAction)saveButtonAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(saveButtonAction)]) {
        [_delegate saveButtonAction];
    }
}

- (IBAction)checkButtonAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(checkButtonAction)]) {
        [_delegate checkButtonAction];
    }
}

- (IBAction)shareButtonAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(shareButtonAction)]) {
        [_delegate shareButtonAction];
    }
}

@end
