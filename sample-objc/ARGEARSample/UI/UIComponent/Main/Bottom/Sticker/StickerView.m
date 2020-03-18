//
//  StickerView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "StickerView.h"
#import "StickersData.h"

@implementation StickerView

#define kStickerViewClearButtonName @"icDisabled"

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _gradient = [CAGradientLayer layer];
    [_gradient setFrame:[self bounds]];
    [_gradient setColors:@[(id)[_topGradientColor CGColor], (id)[_bottomGradientColor CGColor]]];
    
    [self addObservers];
}

- (void)dealloc {
    [self removeObservers];
}

- (void)open {
    [self load];

    [self setHidden:NO];
}

- (void)close {
    [self setHidden:YES];
}

- (void)load {
    __weak StickerView *weakSelf = self;

    StickersData *data = [[StickersData alloc] init];
    [data getStickersData:^(NSArray * _Nonnull stickers, NSArray * _Nonnull titles) {
        [[weakSelf stickersCollectionView] setStickersArray:stickers];
        [[weakSelf stickersCollectionView] reloadData];
        
        [[weakSelf stickerTitleListScrollView] setTitleListArray:titles];
    }];
}

- (void)setButtons:(ARGMediaRatio)ratio {
    
    NSMutableString *clearButtonImageString = [NSMutableString stringWithString:kStickerViewClearButtonName];

    if (ratio == ARGMediaRatio_16x9) {
        
        [clearButtonImageString appendString:@"White"];
    } else {
        
        [clearButtonImageString appendString:@"Black"];
    }
    [clearButtonImageString appendString:@"Off"];
    
    [_clearButton setImage:[UIImage imageNamed:clearButtonImageString] forState:UIControlStateNormal];
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    if (ratio == ARGMediaRatio_16x9) {

        [[self layer] insertSublayer:_gradient atIndex:0];
        [self setBackgroundColor:[UIColor clearColor]];
    } else {
        
        [_gradient removeFromSuperlayer];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    [self setButtons:ratio];
    
    [_stickerTitleListScrollView setRatio:ratio];
    [_stickersCollectionView setRatio:ratio];
}


- (void)addObservers {
    [_stickerTitleListScrollView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [_stickersCollectionView addObserver:self forKeyPath:@"selectedIndexPath" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObservers {
    [_stickerTitleListScrollView removeObserver:self forKeyPath:@"selectedIndex" context:nil];
    [_stickersCollectionView removeObserver:self forKeyPath:@"selectedIndexPath" context:nil];
}

- (IBAction)clearButtonAction:(UIButton *)sender {
    
    [[StickerManager shared] clearSticker];
    [_stickersCollectionView clearSticker];
}

# pragma mark - KVOs
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isKindOfClass:[StickerTitleListScrollView class]]) {
        
        if ([keyPath isEqualToString:@"selectedIndex"]) {
            NSNumber *selectedIndex = [change objectForKey:@"new"];
            NSInteger row = [selectedIndex integerValue];
            
            [_stickersCollectionView indexChanged:[NSIndexPath indexPathForRow:row inSection:0]];
        }
    } else if ([object isKindOfClass:[StickersCollectionView class]]) {
        
        if ([keyPath isEqualToString:@"selectedIndexPath"]) {
            NSIndexPath *indexPath = [change objectForKey:@"new"];
            
            [_stickerTitleListScrollView indexChanged:[NSNumber numberWithInteger:[indexPath row]]];
        }
    }
}

@end
