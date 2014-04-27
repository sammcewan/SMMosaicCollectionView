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
@end

@implementation SMMosaicCollectionView

-(id)initWithDelegate:(id<SMMosaicCollectionViewDelegate>)delegate {
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  [flowLayout setMinimumInteritemSpacing:0.0f];
  [flowLayout setMinimumLineSpacing:0.0f];
  self = [super initWithFrame:CGRectZero collectionViewLayout:flowLayout];
  if (self) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[SMImageCell class] forCellWithReuseIdentifier:NSStringFromClass([SMImageCell class])];
    
    self.mosaicDelegate = delegate;
    [self reloadData];
  }
  return self;
}

-(CGSize)sizeToFit:(CGSize)size {
  CGSize fitSize = self.bounds.size;
  CGFloat width = (fitSize.height/size.height)*size.width;
  CGFloat height = fitSize.height;
  return CGSizeMake(width, height);
}

#pragma mark - UICollectionView methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSInteger numberOfImages = [self.mosaicDelegate numberOfImages];
  if (numberOfImages == 1) {
    self.scrollEnabled = NO;
  } else {
    self.scrollEnabled = YES;
  }
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
  return UIEdgeInsetsMake(0, CGRectGetMidX(self.frame),
                          0, CGRectGetMidX(self.frame));
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.mosaicDelegate respondsToSelector:@selector(didSelectImageAtIndex:)]) {
    [self.mosaicDelegate didSelectImageAtIndex:indexPath.row];
  }
}

#pragma mark - Methods to implement centered scrolling
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    [self centerCollectionView:YES];
  }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  [self centerCollectionView:YES];
}

-(void)centerCollectionView:(BOOL)animated {
  UICollectionViewCell *centerCell;
  centerCell = self.centerCell;
  if (centerCell) {
    [self setContentOffset:CGPointMake(centerCell.center.x - CGRectGetMidX(self.frame), 0)
                  animated:animated];
  }
}

-(UICollectionViewCell *)centerCell {
  CGPoint centerPoint = CGPointMake(self.contentOffset.x + CGRectGetMidX(self.frame), 0);
  for (UICollectionViewCell *cell in [self visibleCells]) {
    if (CGRectContainsPoint(cell.frame, centerPoint)) {
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
  [self centerCollectionView:YES];
}

@end
