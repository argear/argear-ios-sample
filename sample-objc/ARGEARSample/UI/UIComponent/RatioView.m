//
//  RatioView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "RatioView.h"

#define kRatioViewTopBottomAlign169 -44
#define kRatioViewTopBottomAlign43 0
#define kRatioViewTopBottomAlign11 64

#define kRatioViewBottomViewTopAlign169 300
#define kRatioViewBottomViewTopAlign43 0
#define kRatioViewBottomViewTopAlign11 -([[UIScreen mainScreen] bounds].size.width * 4/3 - [[UIScreen mainScreen] bounds].size.width) + 64

@implementation RatioView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setRatio:ARGMediaRatio_4x3];
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    CGFloat screenRatio = [[UIScreen mainScreen] bounds].size.height / [[UIScreen mainScreen] bounds].size.width;
    
    switch (ratio) {
        case ARGMediaRatio_16x9:
            if (screenRatio > 2.f) {
                [_topViewBottomAlign setConstant:kRatioViewTopBottomAlign169];
            } else {
                [_topViewBottomAlign setConstant:0];
            }
            [_bottomView setHidden:YES];
            break;
        case ARGMediaRatio_4x3:
            if (screenRatio > 2.f) {
                [_topViewBottomAlign setConstant:kRatioViewTopBottomAlign11];
                [_bottomViewTopAlign setConstant:kRatioViewBottomViewTopAlign43 + 64.f];
            } else {
                [_topViewBottomAlign setConstant:kRatioViewTopBottomAlign43];
                [_bottomViewTopAlign setConstant:kRatioViewBottomViewTopAlign43];
            }
            [_bottomView setHidden:NO];
            break;
        case ARGMediaRatio_1x1:
            [_topViewBottomAlign setConstant:kRatioViewTopBottomAlign11];
            [_bottomViewTopAlign setConstant:kRatioViewBottomViewTopAlign11];
            [_bottomView setHidden:NO];
            break;
        default:
            break;
    }
}

@end
