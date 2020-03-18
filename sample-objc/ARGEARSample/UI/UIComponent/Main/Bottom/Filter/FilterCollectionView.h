//
//  FilterCollectionView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilterCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *filtersArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

- (void)setRatio:(ARGMediaRatio)ratio;

@end

NS_ASSUME_NONNULL_END
