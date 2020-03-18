//
//  FilterCollectionView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "FilterCollectionView.h"
#import "NetworkManager.h"
#import "FilterManager.h"

#define kFilterCellNibName @"FilterCollectionViewCell"
#define kFilterCellIdentifier @"filtercell"

@implementation FilterCollectionView

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
    
    [self registerNib:[UINib nibWithNibName:kFilterCellNibName bundle:nil] forCellWithReuseIdentifier:kFilterCellIdentifier];
    
    _selectedIndexPath = nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_selectedIndexPath isEqual:indexPath]) {
        return;
    }
    
    Item *item = _filtersArray[[indexPath row]];
    
    __weak FilterCollectionView *weakSelf = self;
    [[FilterManager shared] setFilter:item success:^{
        [weakSelf setSelectedIndexPath:indexPath];

        [collectionView reloadData];
    } fail:^{
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_filtersArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFilterCellIdentifier forIndexPath:indexPath];

    [cell unchecked];
    if ([indexPath isEqual:_selectedIndexPath]) {
        [cell checked];
    }
    
    [cell setData:_filtersArray[[indexPath row]]];
    [cell setFilterNameLabelColor:[self tag]];
    
    return cell;
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    [self setTag:ratio];
    [self reloadData];
}

@end
