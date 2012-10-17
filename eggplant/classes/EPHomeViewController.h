//
//  EPHomeViewController.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/15.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPViewController.h"
#import "iCarousel.h"
#import "NIPagingScrollView.h"
#import "NIPagingScrollViewDataSource.h"
#import "NIPagingScrollViewDelegate.h"

@interface EPHomeViewController : EPViewController <
  iCarouselDataSource,
  iCarouselDelegate,
  NIPagingScrollViewDelegate,
  NIPagingScrollViewDataSource
>

@property (nonatomic, strong) iCarousel *headerCarousel;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIView *buttonSectionsView;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *writeButton;
@property (nonatomic, strong) NSArray *termsFromDefault;
@property (nonatomic, strong) NSMutableArray *termsFromUserSaved;
@property (nonatomic, strong) NIPagingScrollView *pagingScrollView;

@end
