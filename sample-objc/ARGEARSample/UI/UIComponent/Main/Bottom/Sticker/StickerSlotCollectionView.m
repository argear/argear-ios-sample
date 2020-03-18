//
//  StickerSlotCollectionView.m
//  ARGEARSample
//
//  Created by Jihye on 02/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "StickerSlotCollectionView.h"

#define kStickerSlotCellNibName @"StickerSlotCollectionViewCell"
#define kStickerSlotCellIdentifier @"stickerslotcell"

@implementation StickerSlotCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setDelegate:self];
    [self setDataSource:self];
    
    [self registerNib:[UINib nibWithNibName:kStickerSlotCellNibName bundle:nil] forCellWithReuseIdentifier:kStickerSlotCellIdentifier];
    
    _selectedIndexPath = nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    Item *item = _itemsArray[[indexPath row]];
    
    __weak StickerSlotCollectionView *weakSelf = self;
    [[StickerManager shared] setSticker:item success:^(BOOL exist) {

        [weakSelf setSelectedIndexPath:indexPath];
        [[StickerManager shared] setSelectedItemId:[item uuid]];

        [collectionView reloadData];
    } fail:^{
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_itemsArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StickerSlotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStickerSlotCellIdentifier forIndexPath:indexPath];
    
    Item *item = _itemsArray[[indexPath row]];
    NSString *selectedItemId = [[StickerManager shared] selectedItemId];

    [cell unchecked];
    if ([indexPath isEqual:_selectedIndexPath] && [selectedItemId isEqualToString:[item uuid]]) {
        [cell checked];
    }
    
    [cell setData:_itemsArray[[indexPath row]]];
    
    return cell;
}

- (void)clearSticker {
    _selectedIndexPath = nil;
    
    [self reloadData];
}

@end
