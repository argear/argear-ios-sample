//
//  StickerTitleListScrollView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StickerTitleListScrollView : UIScrollView<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleButtonsArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (nonatomic, strong) NSNumber *selectedIndex;

- (void)setTitleListArray:(NSArray *)titles;
- (void)indexChanged:(NSNumber *)selectedIndex;

- (void)setRatio:(ARGMediaRatio)ratio;

@end

NS_ASSUME_NONNULL_END
