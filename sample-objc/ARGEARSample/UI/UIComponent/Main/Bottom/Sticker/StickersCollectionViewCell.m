//
//  StickerCollectionViewCell.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "StickersCollectionViewCell.h"
#import "StickersData.h"

@implementation StickersCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)stickerSlot:(Category *)category {
    [_stickerSlotCollectionView setHidden:NO];
    
    __weak StickersCollectionViewCell *weakSelf = self;
    
    StickersData *itemsData = [[StickersData alloc] init];
    [itemsData getItemsData:category completion:^(NSArray * _Nonnull items) {
        [[weakSelf stickerSlotCollectionView] setItemsArray:items];
        [[weakSelf stickerSlotCollectionView] reloadData];
    }];
}

- (void)setRatio:(ARGMediaRatio)ratio {

}

@end
