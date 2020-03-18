//
//  BeautyCollectionView.h
//  ARGEARSample
//
//  Created by Jihye on 24/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeautyCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeautyCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *iconNameArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

- (void)setRatio:(ARGMediaRatio)ratio;

@end

NS_ASSUME_NONNULL_END
