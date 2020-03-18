//
//  BulgeCollectionView.m
//  ARGEARSample
//
//  Created by Jihye on 01/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "BulgeCollectionView.h"

#define kBulgeCellNibName @"BulgeCollectionViewCell"
#define kBulgeCellIdentifier @"bulgecell"

@implementation BulgeCollectionView

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
    
    _iconNameArray = @[
        @"icDisabled",
        @"icFun1",
        @"icFun2",
        @"icFun3",
        @"icFun4",
        @"icFun5",
        @"icFun6",
    ];
    
    [self setDelegate:self];
    [self setDataSource:self];
    
    [self registerNib:[UINib nibWithNibName:kBulgeCellNibName bundle:nil] forCellWithReuseIdentifier:kBulgeCellIdentifier];
    
    _selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_selectedIndexPath isEqual:indexPath]) {
        return;
    }
    
    [self setSelectedIndexPath:indexPath];
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_iconNameArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BulgeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBulgeCellIdentifier forIndexPath:indexPath];

    [[cell bulgeImage] setImage:[UIImage imageNamed:[self getIconName:[indexPath row]]]];

    return cell;
}

- (NSString *)getIconName:(NSInteger)index {
    
    NSMutableString *iconName = [NSMutableString stringWithFormat:@"%@", _iconNameArray[index]];
    
    if ([self tag] == ARGMediaRatio_16x9) {
        [iconName appendString:@"White"];
    } else {
        [iconName appendString:@"Black"];
    }
    
    if (index > 0 && (index != [_selectedIndexPath row])) {
        [iconName appendString:@"Off"];
    }
    
    return iconName;
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    [self setTag:ratio];
    [self reloadData];
}

@end
