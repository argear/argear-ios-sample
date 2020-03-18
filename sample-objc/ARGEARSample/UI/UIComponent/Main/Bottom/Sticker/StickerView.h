//
//  StickerView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerTitleListScrollView.h"
#import "StickersCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface StickerView : UIView

@property (nonatomic) IBInspectable UIColor *topGradientColor;
@property (nonatomic) IBInspectable UIColor *bottomGradientColor;

@property (nonatomic, strong) CAGradientLayer *gradient;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet StickerTitleListScrollView *stickerTitleListScrollView;
@property (weak, nonatomic) IBOutlet StickersCollectionView *stickersCollectionView;

- (void)open;
- (void)close;

- (void)setRatio:(ARGMediaRatio)ratio;

@end

NS_ASSUME_NONNULL_END
