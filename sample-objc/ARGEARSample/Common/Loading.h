//
//  LoadingView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ARGLoading [Loading shared]

@interface Loading : NSObject

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *background43RatioView;
@property (nonatomic, strong) UIView *roundView;
@property (nonatomic, strong) UIImageView *loadingAnimationImageView;
@property (nonatomic, assign) BOOL isReady;

+ (Loading *)shared;

- (void)prepare;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
