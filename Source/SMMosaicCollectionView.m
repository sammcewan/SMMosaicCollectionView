//
//  SMMosaicCollectionView.m
//  SMMosaicCollectionView
//
//  Created by Sam McEwan on 21/04/14.
//  Copyright (c) 2014 Sam McEwan. All rights reserved.
//

#import "SMMosaicCollectionView.h"
#import "SMImageCell.h"

@interface SMMosaicCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) id<SMMosaicCollectionViewDelegate> mosaicDelegate;
@property (nonatomic, assign) SMMosaicCollectionAlignment alignment;
@end

@implementation SMMosaicCollectionView

-(id)initWithDelegate:(id<SMMosaicCollectionViewDelegate>)delegate alignment:(SMMosaicCollectionAlignment)alignment {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    self = [super initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.showsHorizontalScrollIndicator = NO;
        self.alwaysBounceHorizontal = YES;
        
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[SMImageCell class] forCellWithReuseIdentifier:NSStringFromClass([SMImageCell class])];
        
        self.mosaicDelegate = delegate;
        self.alignment = alignment;
        
        [self reloadData];
    }
    return self;
}

-(CGSize)sizeToFit:(CGSize)size {
    CGSize fitSize = self.bounds.size;
    CGFloat width = (fitSize.height/size.height)*size.width;
    CGFloat height = fitSize.height;
    return CGSizeMake(floor(width), floor(height));
}

#pragma mark - UICollectionView methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfImages = [self.mosaicDelegate numberOfImages];
    return numberOfImages;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = [self.mosaicDelegate imageForIndex:indexPath.row];
    UIImage *overlayImage;
    if ([self.mosaicDelegate respondsToSelector:@selector(overlayImageForIndex:)]) {
        overlayImage = [self.mosaicDelegate overlayImageForIndex:indexPath.row];
    }
    CGSize size = [self sizeToFit:image.size];
    SMImageCell *cell = (SMImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SMImageCell class])
                                                                                 forIndexPath:indexPath];
    if (image == nil) {
        return cell;
    }
    [cell configureCell:image overlay:overlayImage size:size];
    cell.isAccessibilityElement = true;
    if ([self.mosaicDelegate respondsToSelector:@selector(accessibilityLabel:)]) {
        NSString *accessibilityLabel = [self.mosaicDelegate accessibilityLabel:indexPath.row];
        cell.accessibilityLabel = accessibilityLabel;
    }
    else {
        cell.accessibilityLabel = @"Image";
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = [self.mosaicDelegate imageForIndex:indexPath.row];
    return [self sizeToFit:image.size];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    switch (self.alignment) {
        case SMMosaicCollectionAlignmentMixed: {
            if (self.mosaicDelegate.numberOfImages == 1) {
                return UIEdgeInsetsMake(0, CGRectGetMidX(self.frame), 0, CGRectGetMidX(self.frame));
            } else {
                return UIEdgeInsetsMake(0, 0, 0, 0);
            }
            break;
        }
        case SMMosaicCollectionAlignmentCenter: {
            return UIEdgeInsetsMake(0, CGRectGetMidX(self.frame), 0, CGRectGetMidX(self.frame));
            break;
        }
        case SMMosaicCollectionAlignmentLeft: {
            return UIEdgeInsetsMake(0, 0, 0, 0);
            break;
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.mosaicDelegate respondsToSelector:@selector(didSelectImageAtIndex:)]) {
        [self.mosaicDelegate didSelectImageAtIndex:indexPath.row];
    }
}

#pragma mark - Methods to implement centered scrolling
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self alignCollectionView:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self alignCollectionView:YES];
}

-(void)alignCollectionView:(BOOL)animated {
    UICollectionViewCell *alignCell;
    switch (self.alignment) {
        case SMMosaicCollectionAlignmentMixed: {
            if (self.mosaicDelegate.numberOfImages == 1) {
                [self scrollToImageAtIndex:0 animated:animated];
            } else {
                alignCell = self.leftCell;
                if (self.contentSize.width > self.frame.size.width &&
                    ceil(self.contentOffset.x + self.frame.size.width) >= self.contentSize.width) {
                    [self setContentOffset:CGPointMake(self.contentSize.width - self.frame.size.width, 0)
                                  animated:animated];
                    _currentAlignedIndex = [self numberOfItemsInSection:0] - 1;
                } else {
                    [self setContentOffset:CGPointMake(CGRectGetMinX(alignCell.frame), 0)
                                  animated:animated];
                    if (alignCell) {
                        _currentAlignedIndex = [self indexPathForCell:alignCell].row;
                    }
                }
            }
            break;
        }
        case SMMosaicCollectionAlignmentCenter: {
            alignCell = self.centerCell;
            [self setContentOffset:CGPointMake(alignCell.center.x - CGRectGetMidX(self.frame), 0)
                          animated:animated];
            _currentAlignedIndex = [self indexPathForCell:alignCell].row;
            break;
        }
        case SMMosaicCollectionAlignmentLeft: {
            alignCell = self.leftCell;
            if (self.contentSize.width > self.frame.size.width &&
                ceil(self.contentOffset.x + self.frame.size.width) >= self.contentSize.width) {
                [self setContentOffset:CGPointMake(self.contentSize.width - self.frame.size.width, 0)
                              animated:animated];
                _currentAlignedIndex = [self numberOfItemsInSection:0] - 1;
            } else {
                [self setContentOffset:CGPointMake(CGRectGetMinX(alignCell.frame), 0)
                              animated:animated];
                if (alignCell) {
                    _currentAlignedIndex = [self indexPathForCell:alignCell].row;
                }
            }
            break;
        }
    }
}

-(UICollectionViewCell *)leftCell {
    CGPoint leftPoint = CGPointMake(self.contentOffset.x, 0);
    
    CGRect cellFrame;
    for (UICollectionViewCell *cell in [self visibleCells]) {
        cellFrame = CGRectMake(floorf(CGRectGetMinX(cell.frame))-1, floorf(CGRectGetMinY(cell.frame))-1,
                               ceilf(CGRectGetWidth(cell.frame))+2, ceilf(CGRectGetHeight(cell.frame))+2);
        if (CGRectContainsPoint(cellFrame, leftPoint)) {
            return cell;
        }
    }
    return nil;
}

-(UICollectionViewCell *)centerCell {
    CGPoint centerPoint = CGPointMake(self.contentOffset.x + CGRectGetMidX(self.frame), 0);
    CGRect cellFrame;
    for (UICollectionViewCell *cell in [self visibleCells]) {
        cellFrame = CGRectMake(floorf(CGRectGetMinX(cell.frame))-1, floorf(CGRectGetMinY(cell.frame))-1,
                               ceilf(CGRectGetWidth(cell.frame))+2, ceilf(CGRectGetHeight(cell.frame))+2);
        if (CGRectContainsPoint(cellFrame, centerPoint)) {
            return cell;
        }
    }
    return nil;
}

-(void)scrollToImageAtIndex:(NSInteger)index animated:(BOOL)animated {
    if ([self numberOfItemsInSection:0] > 0) {
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                     atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                             animated:animated];
    }
}

#pragma mark Rotation handling
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self alignCollectionView:YES];
}

@end

