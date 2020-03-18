//
//  MainTopFunctionView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MainTopFunctionDelegate <NSObject>
@optional
- (void)settingButtonAction;
- (void)ratioButtonAction;
- (void)toggleButtonAction;
@end

@interface MainTopFunctionView : UIView

@property (nonatomic, unsafe_unretained) id <MainTopFunctionDelegate> _Nullable delegate;

@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *ratioButton;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;

- (void)setEnableButtons;
- (void)setDisableButtons;

@end

NS_ASSUME_NONNULL_END
