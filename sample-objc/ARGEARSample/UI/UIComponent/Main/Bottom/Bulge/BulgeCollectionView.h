//
//  BulgeCollectionView.h
//  ARGEARSample
//
//  Created by Jihye on 01/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BulgeCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
// width 374
@interface BulgeCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *iconNameArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

- (void)setRatio:(ARGMediaRatio)ratio;
- (void)reload;

@end

NS_ASSUME_NONNULL_END
