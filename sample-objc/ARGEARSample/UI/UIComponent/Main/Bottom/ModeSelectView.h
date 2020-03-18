//
//  ModeSelectView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModeSelectView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSInteger mode;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modeButtonsViewWidth;

@property (weak, nonatomic) IBOutlet UIView *modeButtonsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modeButtonsViewTrailing;

@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

@property (weak, nonatomic) IBOutlet UIView *underlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineViewWidth;

- (void)setRatio:(ARGMediaRatio)ratio;

@end

NS_ASSUME_NONNULL_END
