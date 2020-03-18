//
//  PreviewBottomFunctionView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PreviewBottomFunctionDelegate <NSObject>
@optional
- (void)backButtonAction;
- (void)saveButtonAction;
- (void)checkButtonAction;
- (void)shareButtonAction;
@end

@interface PreviewBottomFunctionView : UIView

@property (nonatomic, unsafe_unretained) id <PreviewBottomFunctionDelegate> _Nullable delegate;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (void)setImages:(ARGMediaRatio)ratio;
- (void)showCheckButton;

@end

NS_ASSUME_NONNULL_END
