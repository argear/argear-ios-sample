//
//  LoadingView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "Loading.h"

@implementation Loading

#define rootView [[[[UIApplication sharedApplication] keyWindow] rootViewController] view]
#define animationImageName @"loading_80x80_"
#define backgroundViewSize CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)
#define background43RatioViewSize CGSizeMake([[UIScreen mainScreen] bounds].size.width, ([[UIScreen mainScreen] bounds].size.width * 4)/3)
#define roundViewSize CGSizeMake(120.f, 120.f)
#define animationImageSize CGSizeMake(120.f, 120.f)
#define animationTime 2.5f

#define screenRatio [[UIScreen mainScreen] bounds].size.height / [[UIScreen mainScreen] bounds].size.width

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (Loading *)shared {
    static dispatch_once_t pred;
    static Loading *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[Loading alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _isReady = NO;
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backgroundViewSize.width, backgroundViewSize.height)];
        [_backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_backgroundView setBackgroundColor:[UIColor clearColor]];
        [_backgroundView setUserInteractionEnabled:YES];
        
        CGFloat safeAreaTopAnchor = 0;
        if (@available(iOS 11.0, *)) {
            safeAreaTopAnchor = [rootView safeAreaInsets].top;
        }
        
        if (screenRatio > 2.f) {
            safeAreaTopAnchor += 64.f;
        }
        
        _background43RatioView = [[UIView alloc] initWithFrame:CGRectMake(0, safeAreaTopAnchor, background43RatioViewSize.width, background43RatioViewSize.height)];
        [_background43RatioView setBackgroundColor:[UIColor clearColor]];
        [_backgroundView addSubview:_background43RatioView];
        
        _roundView = [[UIView alloc] initWithFrame:CGRectMake(background43RatioViewSize.width/2 - roundViewSize.width/2, background43RatioViewSize.height/2 - roundViewSize.height/2, roundViewSize.width, roundViewSize.height)];
        [_roundView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.75f]];
        [[_roundView layer] setCornerRadius:roundViewSize.width/2];
        [[_roundView layer] setMasksToBounds:YES];
        [_background43RatioView addSubview:_roundView];
        
        _loadingAnimationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(background43RatioViewSize.width/2 - animationImageSize.width/2, background43RatioViewSize.height/2 - animationImageSize.height/2, animationImageSize.width, animationImageSize.height)];
        [_loadingAnimationImageView setBackgroundColor:[UIColor clearColor]];
        [[_loadingAnimationImageView layer] setCornerRadius:animationImageSize.width/2];
        [[_loadingAnimationImageView layer] setMasksToBounds:YES];
        [_background43RatioView addSubview:_loadingAnimationImageView];
    }
    return self;
}

- (void)prepare {
    
    if (_isReady) {
        return;
    }
    
    __weak Loading *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *images = [[NSMutableArray alloc] init];
        
        for (int i = 0; i <= 150; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%04d", i]];
            
            if(image) {
                [images addObject:image];
            } else {
            }
        }
        
        // Normal Animation
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[weakSelf loadingAnimationImageView] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0001"]]];
            [[weakSelf loadingAnimationImageView] setAnimationImages:images];
            [[weakSelf loadingAnimationImageView] setAnimationDuration:animationTime];
            [[weakSelf loadingAnimationImageView] setAnimationRepeatCount:0];
        });
        
        [weakSelf setIsReady:YES];
    });
}

- (void)show {
    
    [rootView addSubview:_backgroundView];
    
    [_loadingAnimationImageView startAnimating];
}

- (void)hide {
    
    [_backgroundView removeFromSuperview];
    
    [_loadingAnimationImageView stopAnimating];
    [_loadingAnimationImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"0001"]]];
}

@end
