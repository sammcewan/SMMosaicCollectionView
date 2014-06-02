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
@property (nonatomic, assign) BOOL centered;
@end

@implementation SMMosaicCollectionView

-(id)initWithDelegate:(id<SMMosaicCollectionViewDelegate>)delegate centered:(BOOL)centered {
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
    _centered = centered;

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
  [cell configureCell:image overlay:overlayImage size:size];
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
  if (self.centered) {
    return UIEdgeInsetsMake(0, CGRectGetMidX(self.frame), 0, CGRectGetMidX(self.frame));
  }
  else {
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
  if (self.centered) {
    alignCell = self.centerCell;
  } else {
    alignCell = self.leftCell;
  }
  if (alignCell && self.centered) {
    [self setContentOffset:CGPointMake(alignCell.center.x - CGRectGetMidX(self.frame), 0)
                  animated:animated];
  } else if (alignCell) {
    if (ceil(self.contentOffset.x + self.frame.size.width) >= self.contentSize.width) {
      [self setContentOffset:CGPointMake(self.contentSize.width - self.frame.size.width, 0)
                    animated:animated];
    } else {
      [self setContentOffset:CGPointMake(CGRectGetMinX(alignCell.frame), 0)
                    animated:animated];
    }
  }
}

-(UICollectionViewCell *)leftCell {
  CGPoint leftPoint = CGPointMake(self.contentOffset.x, 0);

  CGRect cellFrame;
  for (UICollectionViewCell *cell in [self visibleCells]) {
    cellFrame = CGRectMake(floorf(CGRectGetMinX(cell.frame))-1, floorf(CGRectGetMinY(cell.frame))-1,
                           ceilf(CGRectGetWidth(cell.frame))+2, ceilf(CGRectGetHeight(cell.frame))+2);
    if (  CGRectContainsPoint(cellFrame, leftPoint)) {
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
    if (  CGRectContainsPoint(cellFrame, centerPoint)) {
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
