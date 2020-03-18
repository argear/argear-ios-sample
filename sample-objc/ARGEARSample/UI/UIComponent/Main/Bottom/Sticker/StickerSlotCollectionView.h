//
//  StickerSlotCollectionView.h
//  ARGEARSample
//
//  Created by Jihye on 02/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickerSlotCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface StickerSlotCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSArray *itemsArray;

- (void)clearSticker;

@end

NS_ASSUME_NONNULL_END
