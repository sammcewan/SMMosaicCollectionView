//
//  SMViewController.m
//  SMMosaicCollectionView
//
//  Created by Sam McEwan on 21/04/14.
//  Copyright (c) 2014 Sam McEwan. All rights reserved.
//

#import "SMViewController.h"
#import "SMMosaicCollectionView.h"

@interface SMViewController () <SMMosaicCollectionViewDelegate>
@property (nonatomic, strong) SMMosaicCollectionView *mosaicCollectionView;
@property (nonatomic, strong) NSArray *imageArray;
@end

@implementation SMViewController

- (id)init {
  self = [super init];
  if (self) {
    _mosaicCollectionView = [[SMMosaicCollectionView alloc] initWithDelegate:self];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self buildImageArray];
  self.mosaicCollectionView.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 100);
  [self.view addSubview:self.mosaicCollectionView];
}

- (void)viewDidAppear:(BOOL)animated {
  [self.mosaicCollectionView centerCollectionView:NO];
}

#pragma mark - SMMosaicCollectionViewDelegate
-(NSInteger)numberOfImages {
  return self.imageArray.count;
}

-(UIImage *)imageForIndex:(NSInteger)index {
  return self.imageArray[index];
}

- (void)buildImageArray {
  NSMutableArray *mutableImageArray = [NSMutableArray array];
  for (NSInteger i = 0; i < 10; i++) {
    NSString *imageName = [NSString stringWithFormat:@"%i.jpeg", i];
    [mutableImageArray addObject:[UIImage imageNamed:imageName]];
  }
  self.imageArray = mutableImageArray;
}

@end
