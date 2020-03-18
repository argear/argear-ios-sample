//
//  StickerCollectionView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickersCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface StickersCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *stickersArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

- (void)clearSticker;
- (void)indexChanged:(NSIndexPath *)indexPath;

- (void)setRatio:(ARGMediaRatio)ratio;

@end

NS_ASSUME_NONNULL_END
