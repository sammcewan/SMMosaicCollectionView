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
@end

@implementation SMImageCell

- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.frame = frame;
    _imageView.backgroundColor = [UIColor blueColor];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_imageView];
  }
  return self;
}

-(void)configureCell:(UIImage *)image size:(CGSize)size{
  [self sizeToFit];
  self.imageView.frame = (CGRect){{0,0}, size};
  [self.imageView setImage:image];
  [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

-(void)setHighlighted:(BOOL)highlighted{
  if (highlighted) {
    self.imageView.alpha = 0.7;
  } else {
    self.imageView.alpha = 1.0;
  }
}

@end
