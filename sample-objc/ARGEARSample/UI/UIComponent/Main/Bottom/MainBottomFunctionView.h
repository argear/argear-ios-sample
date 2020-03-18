//
//  MainBottomFunctionView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeSelectView.h"
#import "ShutterView.h"

#import "BeautyView.h"
#import "FilterView.h"
#import "StickerView.h"
#import "BulgeView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MainBottomFunctionDelegate <NSObject>
@optional
- (void)takePictureAction:(UIButton *)sender;
- (void)recordVideoAction:(UIButton *)sender;
@end

@interface MainBottomFunctionView : UIView

@property (nonatomic, unsafe_unretained) id <MainBottomFunctionDelegate> _Nullable delegate;

@property (weak, nonatomic) IBOutlet UIView *touchCancelView;

@property (weak, nonatomic) IBOutlet UIButton *beautyButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *stickerButton;
@property (weak, nonatomic) IBOutlet UIButton *bulgeButton;

@property (weak, nonatomic) IBOutlet ModeSelectView *modeSelectView;

@property (weak, nonatomic) IBOutlet UIButton *shutterButton;
@property (weak, nonatomic) IBOutlet ShutterView *shutterView;

@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;

@property (weak, nonatomic) IBOutlet BeautyView *beautyView;
@property (weak, nonatomic) IBOutlet FilterView *filterView;
@property (weak, nonatomic) IBOutlet StickerView *stickerView;
@property (weak, nonatomic) IBOutlet BulgeView *bulgeView;

- (void)setRecordTime:(CGFloat)time;

@end

NS_ASSUME_NONNULL_END
