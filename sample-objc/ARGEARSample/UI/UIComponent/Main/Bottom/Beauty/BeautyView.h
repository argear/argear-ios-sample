//
//  BeautyView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeautyManager.h"
#import "BeautyCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeautyView : UIView

@property (nonatomic) IBInspectable UIColor *topGradientColor;
@property (nonatomic) IBInspectable UIColor *bottomGradientColor;

@property (nonatomic, strong) CAGradientLayer *gradient;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UIButton *compareButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (weak, nonatomic) IBOutlet BeautyCollectionView *beautyCollectionView;

- (void)open;
- (void)close;

- (void)setRatio:(ARGMediaRatio)ratio;

@end

NS_ASSUME_NONNULL_END
