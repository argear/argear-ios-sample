//
//  RatioView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RatioView : UIView

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewBottomAlign;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewTopAlign;

- (void)setRatio:(ARGMediaRatio)ratio;

@end

NS_ASSUME_NONNULL_END
