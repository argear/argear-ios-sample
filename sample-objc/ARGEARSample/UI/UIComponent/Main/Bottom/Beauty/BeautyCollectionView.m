//
//  BeautyCollectionView.m
//  ARGEARSample
//
//  Created by Jihye on 24/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "BeautyCollectionView.h"

#define kBeautyCellNibName @"BeautyCollectionViewCell"
#define kBeautyCellIdentifier @"beautycell"

@implementation BeautyCollectionView

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
        @"icVline",
        @"icFacewidth",
        @"icFacelength",
        @"icChinlength",
        @"icEyesize",
        @"icEyewidth",
        @"icNosenarrow",
        @"icAla",
        @"icNoselength",
        @"icMouthsize",
        @"icEyeback",
        @"icEyeangle",
        @"icLips",
        @"icSkin",
        @"icDarkcircle",
        @"icWrinkle",
    ];
    
    [self setDelegate:self];
    [self setDataSource:self];
    
    [self registerNib:[UINib nibWithNibName:kBeautyCellNibName bundle:nil] forCellWithReuseIdentifier:kBeautyCellIdentifier];
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
    BeautyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBeautyCellIdentifier forIndexPath:indexPath];

    [[cell actionImage] setImage:[UIImage imageNamed:[self getIconName:[indexPath row]]]];
    
    return cell;
}

- (NSString *)getIconName:(NSInteger)index {
    
    NSMutableString *iconName = [NSMutableString stringWithFormat:@"%@", _iconNameArray[index]];
    
    if ([self tag] == ARGMediaRatio_16x9) {
        [iconName appendString:@"White"];
    } else {
        [iconName appendString:@"Black"];
    }
    
    if (index != [_selectedIndexPath row]) {
        [iconName appendString:@"Off"];
    }
    
    [iconName appendString:[NSString stringWithFormat:@"_%@", [@"" getLanguageCode]]];
    
    return iconName;
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    [self setTag:ratio];
    [self reloadData];
}

@end
