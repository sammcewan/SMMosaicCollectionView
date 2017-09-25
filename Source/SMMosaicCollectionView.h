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

@optional
/**
 Delegate method to return an overlay UIImage to be displayed
 
 @param index of overlay image to display
 
 @return the image to be displayed
 */
-(UIImage *)overlayImageForIndex:(NSInteger)index;


/**
 Return the accessibility label for a given index

 @param index index of image
 @return the string value of the accessibility label
 */
-(NSString *)accessibilityLabel:(NSInteger)index;

@end

/**
 *  Various attachment types
 */
typedef NS_ENUM(NSUInteger, SMMosaicCollectionAlignment) {
    /**
     *  Aligns left when more than one and center when one
     */
    SMMosaicCollectionAlignmentMixed,
    /**
     *  Aligns left always
     */
    SMMosaicCollectionAlignmentLeft,
    /**
     *  Aligns center always
     */
    SMMosaicCollectionAlignmentCenter
};

/**
 A subclass of UICollectionView with a predefined layout to suit the desired effect.
 */
@interface SMMosaicCollectionView : UICollectionView

/**
 Initalises with a delegate implementing SMMosaicCollectionViewDelegate
 
 @param delegate
 
 @return an instance of SMMosaicCollectionView
 */
-(id)initWithDelegate:(id<SMMosaicCollectionViewDelegate>)delegate alignment:(SMMosaicCollectionAlignment)alignment;

/**
 Scrolls to a given image
 
 @param index
 @param animated
 */
-(void)scrollToImageAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
 Centers the collection view on the middle cell
 
 @param animated
 */
-(void)alignCollectionView:(BOOL)animated;

/**
 *  Returns the index of the currently aligned cell
 */
@property (nonatomic, readonly) NSInteger currentAlignedIndex;

/**
 *  Returns the type of collection view alignment
 */
@property (nonatomic, readonly) SMMosaicCollectionAlignment alignment;

@end

