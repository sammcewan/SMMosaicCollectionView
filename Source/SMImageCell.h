//
//  SMImageCell.h
//  SMMosaicCollectionView
//
//  Created by Sam McEwan on 21/04/14.
//  Copyright (c) 2014 Sam McEwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMImageCell : UICollectionViewCell

/**
 Configures an SMImageCell with a given image and size
 
 @param image to display
 @param size  to set image
 */
-(void)configureCell:(UIImage *)image size:(CGSize)size;

/**
 Configures an SMImageCell with a given image, overlay and size
 
 @param image        to display
 @param overlayImage image to place on top. Useful for repeating an image.
 @param size         to set image
 */
-(void)configureCell:(UIImage *)image overlay:(UIImage *)overlayImage size:(CGSize)size;

@end
