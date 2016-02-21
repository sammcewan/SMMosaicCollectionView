//
//  SMImageCell.m
//  SMMosaicCollectionView
//
//  Created by Sam McEwan on 21/04/14.
//  Copyright (c) 2014 Sam McEwan. All rights reserved.
//

#import "SMImageCell.h"

@interface SMImageCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *overlayImageView;
@end

@implementation SMImageCell

- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.frame = frame;
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_imageView];
    
    _overlayImageView = [[UIImageView alloc] initWithFrame:frame];
    _overlayImageView.frame = frame;
    _overlayImageView.backgroundColor = [UIColor clearColor];
    _overlayImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_overlayImageView];
  }
  return self;
}

-(void)configureCell:(UIImage *)image size:(CGSize)size{
  [self configureCell:image overlay:nil size:size];
}

-(void)configureCell:(UIImage *)image overlay:(UIImage *)overlayImage size:(CGSize)size {
  [self sizeToFit];
  self.imageView.frame = (CGRect){{0,0}, size};
  [self.imageView setImage:image];
  [self.imageView setContentMode:UIViewContentModeScaleAspectFill];

  self.overlayImageView.frame = self.imageView.frame;
  if (overlayImage) {
    [self.overlayImageView setImage:overlayImage];
    [self.overlayImageView setContentMode:UIViewContentModeCenter];
    self.overlayImageView.hidden = NO;
  } else {
    self.overlayImageView.hidden = YES;
  }
}

-(void)setHighlighted:(BOOL)highlighted{
  if (highlighted) {
    self.imageView.alpha = 0.7;
  } else {
    self.imageView.alpha = 1.0;
  }
}

@end
