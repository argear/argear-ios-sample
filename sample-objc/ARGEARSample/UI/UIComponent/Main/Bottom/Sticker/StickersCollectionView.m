//
//  StickerCollectionView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "StickersCollectionView.h"

#define kStickersCellNibName @"StickersCollectionViewCell"
#define kStickersCellIdentifier @"stickerscell"

@implementation StickersCollectionView

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
    
    [self registerNib:[UINib nibWithNibName:kStickersCellNibName bundle:nil] forCellWithReuseIdentifier:kStickersCellIdentifier];
    
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_stickersArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StickersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStickersCellIdentifier forIndexPath:indexPath];

    [cell stickerSlot:_stickersArray[[indexPath row]]];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self frame].size;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    float expectedOffset = targetContentOffset->x;
    NSInteger pageIndex = expectedOffset/[self frame].size.width;
    
    [self setSelectedIndexPath:[NSIndexPath indexPathForRow:pageIndex inSection:0]];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StickersCollectionViewCell *stickerCell = (StickersCollectionViewCell *)cell;
    if ([indexPath row] == 0) {

        [stickerCell setRatio:[self tag]];
    }
    
    [[stickerCell stickerSlotCollectionView] reloadData];
}

- (void)clearSticker {
    StickersCollectionViewCell *cell = (StickersCollectionViewCell *)[self cellForItemAtIndexPath:_selectedIndexPath];

    [[cell stickerSlotCollectionView] clearSticker];
    _selectedIndexPath = nil;
}

- (void)indexChanged:(NSIndexPath *)indexPath {
    _selectedIndexPath = indexPath;
    
    [self setContentOffset:CGPointMake([self frame].size.width * [indexPath row], 0) animated:YES];
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    [self setTag:ratio];
    
//    StickersCollectionViewCell *cell = (StickersCollectionViewCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

@end
