//
//  StickerCollectionViewCell.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerSlotCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface StickersCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet StickerSlotCollectionView *stickerSlotCollectionView;

- (void)stickerSlot:(Category *)category;

- (void)setRatio:(ARGMediaRatio)ratio;

@end

NS_ASSUME_NONNULL_END
