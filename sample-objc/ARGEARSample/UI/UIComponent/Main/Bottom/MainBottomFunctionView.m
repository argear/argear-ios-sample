//
//  MainBottomFunctionView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "MainBottomFunctionView.h"
#import "UIImage+Color.h"

@implementation MainBottomFunctionView

#define kMainBottomFunctionBeautyButtonName @"icBeauty"
#define kMainBottomFunctionFilterButtonName @"icFilter"
#define kMainBottomFunctionStickerButtonName @"icSticker"
#define kMainBottomFunctionBulgeButtonName @"icBulge"

#define kMainBottomFunctionRecordTimeLabelRatioFullColor [UIColor whiteColor]
#define kMainBottomFunctionRecordTimeLabelColor [UIColor colorWithRed:97.f/255.f green:97.f/255.f blue:97.f/255.f alpha:1.f]
#define kMainBottomFunctionRecordTimeLabelShadowColor [UIColor colorWithRed:97.f/255.f green:97.f/255.f blue:97.f/255.f alpha:1.f]

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addObservers];
    
    [self setButtons:[self tag]];
}

- (void)dealloc {
    [self removeObservers];
}

- (void)addObservers {
    [_modeSelectView addObserver:_shutterView forKeyPath:@"mode" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObservers {
    [_modeSelectView removeObserver:_shutterView forKeyPath:@"mode"];
}

- (void)setRecordTime:(CGFloat)time {
    int min = time / 60.f;
    int sec = time - min * 60.f;
    
    [_recordTimeLabel setText:[NSString stringWithFormat:@"%02d:%02d", min, sec]];
}

- (IBAction)beautyButtonAction:(UIButton *)sender {
    
    [self openBottomFunctions];
    
    [_beautyView open];
}

- (IBAction)filterButtonAction:(UIButton *)sender {
    
    [self openBottomFunctions];
    
    [_filterView open];
}

- (IBAction)stickerButtonAction:(UIButton *)sender {
    
    [self openBottomFunctions];
    
    [_stickerView open];
}

- (IBAction)bulgeButtonAction:(UIButton *)sender {
    [self openBottomFunctions];
    
    [_bulgeView open];
}

- (IBAction)shutterButtonAction:(UIButton *)sender {
    
    switch ([_modeSelectView mode]) {
        case ARGMediaModePhoto:
            if (_delegate && [_delegate respondsToSelector:@selector(takePictureAction:)]) {
                [_delegate takePictureAction:sender];
            }
            break;
        case ARGMediaModeVideo:
            [_recordTimeLabel setHidden:[sender tag]];
            [self setModeSelectViewDisable:[sender tag]];

            if (_delegate && [_delegate respondsToSelector:@selector(recordVideoAction:)]) {
                [_delegate recordVideoAction:sender];
            }
            break;
        default:
            break;
    }
}

- (void)openBottomFunctions {
    [_touchCancelView setHidden:NO];
    
    [self setHidden:YES];
}

- (void)closeBottomFunctions {
    [_touchCancelView setHidden:YES];
    
    [_beautyView close];
    [_filterView close];
    [_stickerView close];
    [_bulgeView close];
    
    [self setHidden:NO];
}

- (void)setModeSelectViewDisable:(BOOL)disable {
    [_modeSelectView setUserInteractionEnabled:disable];
}

- (IBAction)handleTapFrom:(UITapGestureRecognizer*)tap {
    if ([tap state] == UIGestureRecognizerStateEnded) {
        
        [self closeBottomFunctions];
    }
}

- (void)setButtons:(ARGMediaRatio)ratio {
    
    NSMutableString *beautyButtonImageString = [NSMutableString stringWithString:kMainBottomFunctionBeautyButtonName];
    NSMutableString *filterButtonImageString = [NSMutableString stringWithString:kMainBottomFunctionFilterButtonName];
    NSMutableString *stickerButtonImageString = [NSMutableString stringWithString:kMainBottomFunctionStickerButtonName];
    NSMutableString *bulgeButtonImageString = [NSMutableString stringWithString:kMainBottomFunctionBulgeButtonName];
    
    if (ratio == ARGMediaRatio_16x9) {
        [beautyButtonImageString appendString:@"White"];
        [filterButtonImageString appendString:@"White"];
        [stickerButtonImageString appendString:@"White"];
        [bulgeButtonImageString appendString:@"White"];
    } else {
        [beautyButtonImageString appendString:@"Black"];
        [filterButtonImageString appendString:@"Black"];
        [stickerButtonImageString appendString:@"Black"];
        [bulgeButtonImageString appendString:@"Black"];
    }
    
    [beautyButtonImageString appendString:[NSString stringWithFormat:@"_%@", [@"" getLanguageCode]]];
    [filterButtonImageString appendString:[NSString stringWithFormat:@"_%@", [@"" getLanguageCode]]];
    [stickerButtonImageString appendString:[NSString stringWithFormat:@"_%@", [@"" getLanguageCode]]];
    [bulgeButtonImageString appendString:[NSString stringWithFormat:@"_%@", [@"" getLanguageCode]]];
    
    [_beautyButton setImage:[UIImage imageNamed:[NSString stringWithString:beautyButtonImageString]] forState:UIControlStateNormal];
    [_beautyButton setImage:[[UIImage imageNamed:[NSString stringWithString:beautyButtonImageString]] imageWithAlphaComponent:BUTTON_HIGHLIGHTED_ALPHA] forState:UIControlStateHighlighted];

    [_filterButton setImage:[UIImage imageNamed:[NSString stringWithString:filterButtonImageString]] forState:UIControlStateNormal];
    [_filterButton setImage:[[UIImage imageNamed:[NSString stringWithString:filterButtonImageString]] imageWithAlphaComponent:BUTTON_HIGHLIGHTED_ALPHA] forState:UIControlStateHighlighted];

    [_stickerButton setImage:[UIImage imageNamed:[NSString stringWithString:stickerButtonImageString]] forState:UIControlStateNormal];
    [_stickerButton setImage:[[UIImage imageNamed:[NSString stringWithString:stickerButtonImageString]] imageWithAlphaComponent:BUTTON_HIGHLIGHTED_ALPHA] forState:UIControlStateHighlighted];

    [_bulgeButton setImage:[UIImage imageNamed:[NSString stringWithString:bulgeButtonImageString]] forState:UIControlStateNormal];
    [_bulgeButton setImage:[[UIImage imageNamed:[NSString stringWithString:bulgeButtonImageString]] imageWithAlphaComponent:BUTTON_HIGHLIGHTED_ALPHA] forState:UIControlStateHighlighted];
}

- (void)setRecordTimeLabelColor:(ARGMediaRatio)ratio {
    
    UIColor *textColor = [UIColor clearColor];
    UIColor *shadowColor = [UIColor clearColor];

    if (ratio == ARGMediaRatio_16x9) {
        
        textColor = kMainBottomFunctionRecordTimeLabelRatioFullColor;
        shadowColor = kMainBottomFunctionRecordTimeLabelShadowColor;
    } else {
        
        textColor = kMainBottomFunctionRecordTimeLabelColor;
    }
    
    [_recordTimeLabel setTextColor:textColor];
    
    [[_recordTimeLabel layer] setShadowOffset:CGSizeZero];
    [[_recordTimeLabel layer] setShadowRadius:1.f];
    [[_recordTimeLabel layer] setShadowOpacity:0.5f];
    [[_recordTimeLabel layer] setMasksToBounds:NO];
    [[_recordTimeLabel layer] setShouldRasterize:YES];
    [[_recordTimeLabel layer] setShadowColor:[shadowColor CGColor]];
}

- (void)changeRatio:(ARGMediaRatio)ratio {
    
    [self setButtons:ratio];
    [self setRecordTimeLabelColor:ratio];
    
    [_modeSelectView setRatio:ratio];
    [_shutterView setRatio:ratio];
    
    [_beautyView setRatio:ratio];
    [_filterView setRatio:ratio];
    [_stickerView setRatio:ratio];
    [_bulgeView setRatio:ratio];
}

# pragma mark - Observers
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"currentRatio"]) {
        ARGMediaRatio ratio = [[change objectForKey:@"new"] integerValue];
        
        [self changeRatio:ratio];
    }
}

@end
