//
//  PreviewViewController.h
//  ARGEARSample
//
//  Created by Jihye on 06/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviewBottomFunctionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreviewViewController : UIViewController<PreviewBottomFunctionDelegate>

@property (nonatomic, assign) ARGMedia *media;

@property (nonatomic, assign) ARGMediaRatio ratio;
@property (nonatomic, assign) ARGMediaMode mode;

@property (nonatomic, strong) UIImage *previewImage;
@property (nonatomic, strong) NSDictionary *videoInfo;

@property (weak, nonatomic) IBOutlet UIView *topInsetView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topInsetViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *fullImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ratio43ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ratio11ImageView;
@property (weak, nonatomic) IBOutlet PreviewBottomFunctionView *previewBottomFunctionView;

@property (nonatomic, strong) AVPlayer *player;

@end

NS_ASSUME_NONNULL_END
