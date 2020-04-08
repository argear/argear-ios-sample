//
//  BulgeView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "BulgeView.h"
#import "BulgeManager.h"

@implementation BulgeView

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
    [self setHidden:NO];
    
    [[StickerManager shared] clearSticker];

    if ([[BulgeManager shared] mode] == ARGContentItemBulgeNONE) {
        [_bulgeCollectionView setSelectedIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    [_bulgeCollectionView reload];
}

- (void)close {
    [self setHidden:YES];
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    if (ratio == ARGMediaRatio_16x9) {

        [[self layer] insertSublayer:_gradient atIndex:0];
        [self setBackgroundColor:[UIColor clearColor]];
    } else {
        
        [_gradient removeFromSuperlayer];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    [_bulgeCollectionView setRatio:ratio];
}

- (void)addObservers {
    [_bulgeCollectionView addObserver:self forKeyPath:@"selectedIndexPath" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObservers {
    [_bulgeCollectionView removeObserver:self forKeyPath:@"selectedIndexPath" context:nil];
}

# pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isKindOfClass:[BulgeCollectionView class]]) {
        
        if ([keyPath isEqualToString:@"selectedIndexPath"]) {
            NSIndexPath *indexPath = [change objectForKey:@"new"];
            
            if ([indexPath row] == 0) {
                // disable button
                [[BulgeManager shared] off];
            } else {
                [[BulgeManager shared] setFunMode:[indexPath row]];
            }
        }
    }
}


@end
