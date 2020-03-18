//
//  MainTopFunctionView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "MainTopFunctionView.h"
#import "UIImage+Color.h"

@implementation MainTopFunctionView

#define kMainTopFunctionSettingButtonName @"icSetting"
#define kMainTopFunctionRotateButtonName @"icRotate"

#define kMainTopFunctionRatio11ButtonName @"ic11Black"
#define kMainTopFunctionRatio43ButtonName @"ic43"
#define kMainTopFunctionRatioFullButtonName @"icFullWhite"

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setButtons:[self tag]];
}

- (IBAction)settingButtonAction:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(settingButtonAction)]) {
        [_delegate settingButtonAction];
    }
}

- (IBAction)ratioButtonAction:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(ratioButtonAction)]) {
        [_delegate ratioButtonAction];
    }
}

- (IBAction)toggleButtonAction:(UIButton *)sender {
    [self setDisableButtons];
    
    if (_delegate && [_delegate respondsToSelector:@selector(toggleButtonAction)]) {
        [_delegate toggleButtonAction];
    } else {
        [self setEnableButtons];
    }
}

- (void)setEnableButtons {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self settingButton] setUserInteractionEnabled:YES];
        [[self ratioButton] setUserInteractionEnabled:YES];
        [[self toggleButton] setUserInteractionEnabled:YES];
    });
}

- (void)setDisableButtons {
    [_settingButton setUserInteractionEnabled:NO];
    [_ratioButton setUserInteractionEnabled:NO];
    [_toggleButton setUserInteractionEnabled:NO];
}

- (void)setButtons:(ARGMediaRatio)ratio {
    
    CGFloat screenRatio = [[UIScreen mainScreen] bounds].size.height / [[UIScreen mainScreen] bounds].size.width;

    NSMutableString *settingButtonImageString = [NSMutableString stringWithString:kMainTopFunctionSettingButtonName];
    NSMutableString *rotateButtonImageString = [NSMutableString stringWithString:kMainTopFunctionRotateButtonName];
    NSMutableString *ratioButtonImageString = [NSMutableString stringWithString:@""];
    
    switch (ratio) {
        case ARGMediaRatio_16x9:
            [settingButtonImageString appendString:@"White"];
            [rotateButtonImageString appendString:@"White"];
            [ratioButtonImageString appendString:kMainTopFunctionRatioFullButtonName];
            break;
        case ARGMediaRatio_4x3:
            if (screenRatio > 2.0f) {
                [settingButtonImageString appendString:@"Black"];
                [rotateButtonImageString appendString:@"Black"];
                [ratioButtonImageString appendString:kMainTopFunctionRatio43ButtonName];
                [ratioButtonImageString appendString:@"Black"];
            } else {
                [settingButtonImageString appendString:@"White"];
                [rotateButtonImageString appendString:@"White"];
                [ratioButtonImageString appendString:kMainTopFunctionRatio43ButtonName];
                [ratioButtonImageString appendString:@"White"];
            }
            break;
        case ARGMediaRatio_1x1:
            [settingButtonImageString appendString:@"Black"];
            [rotateButtonImageString appendString:@"Black"];
            [ratioButtonImageString appendString:kMainTopFunctionRatio11ButtonName];
            break;
        default:
            break;
    }
    
    [_settingButton setImage:[UIImage imageNamed:[NSString stringWithString:settingButtonImageString]] forState:UIControlStateNormal];
    [_settingButton setImage:[[UIImage imageNamed:[NSString stringWithString:settingButtonImageString]] imageWithAlphaComponent:BUTTON_HIGHLIGHTED_ALPHA] forState:UIControlStateHighlighted];

    [_ratioButton setImage:[UIImage imageNamed:[NSString stringWithString:ratioButtonImageString]] forState:UIControlStateNormal];
    [_ratioButton setImage:[[UIImage imageNamed:[NSString stringWithString:ratioButtonImageString]] imageWithAlphaComponent:BUTTON_HIGHLIGHTED_ALPHA] forState:UIControlStateHighlighted];

    [_toggleButton setImage:[UIImage imageNamed:[NSString stringWithString:rotateButtonImageString]] forState:UIControlStateNormal];
    [_toggleButton setImage:[[UIImage imageNamed:[NSString stringWithString:rotateButtonImageString]] imageWithAlphaComponent:BUTTON_HIGHLIGHTED_ALPHA] forState:UIControlStateHighlighted];
}

# pragma mark - Observers
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"currentRatio"]) {
        ARGMediaRatio ratio = [[change objectForKey:@"new"] integerValue];
        
        [self setButtons:ratio];
    }
}

@end
