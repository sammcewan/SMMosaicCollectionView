//
//  SMMosaicCollectionView.h
//  SMMosaicCollectionView
//
//  Created by Sam McEwan on 21/04/14.
//  Copyright (c) 2014 Sam McEwan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Delegate to be implemented by any classes implementing SMMosaicCollectionView
 */
@protocol SMMosaicCollectionViewDelegate <NSObject>

/**
 Set the number of images to be displayed in the mosaic view
 
 @return number of images
 */
-(NSInteger)numberOfImages;

/**
 Delegate method to return the UIImage to be displayed
 
 @param index of image to display
 
 @return the image to be displayed
 */
-(UIImage *)imageForIndex:(NSInteger)index;

/**
 When an image is selected this call is made
 
 @param index
 */
-(void)didSelectImageAtIndex:(NSInteger)index;

@end

/**
 A subclass of UICollectionView with a predefined layout to suit the desired effect.
 */
@interface SMMosaicCollectionView : UICollectionView

/**
 Initalises with a delegate implementing SMMosaicCollectionViewDelegate
 
 @param delegate
 
 @return an instance of SMMosaicCollectionView
 */
-(id)initWithDelegate:(id<SMMosaicCollectionViewDelegate>)delegate;

/**
 Centers the collection view on the middle cell
 
 @param animated
 */
-(void)centerCollectionView:(BOOL)animated;

/**
 Scrolls to a given image
 */
-(void)scrollToImageAtIndex:(NSInteger)index;

@end
