//
//  EPHomeViewController.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/15.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPViewController.h"
#import "iCarousel.h"

@interface EPHomeViewController : EPViewController <
  iCarouselDataSource,
  iCarouselDelegate
>

@property (nonatomic, strong) iCarousel *headerCarousel;
@property (nonatomic, strong) iCarousel *contentCarousel;

@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIView *buttonSectionsView;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *writeButton;

@property (nonatomic, strong) NSArray *termsFromDefault;
@property (nonatomic, strong) NSMutableArray *termsFromUserSaved;

@end
