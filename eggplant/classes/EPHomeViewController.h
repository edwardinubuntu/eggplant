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
#import "EPSearchKeywordViewController.h"
#import "EPQueryViewController.h"
#import "EPIQEnginesViewController.h"

@interface EPHomeViewController : EPViewController <
  EPIQEnginesViewControllerDelegate,
  iCarouselDataSource,
  iCarouselDelegate,
  NIPagingScrollViewDelegate,
  NIPagingScrollViewDataSource,
  UITableViewDataSource,
  UITableViewDelegate
>

@property (nonatomic, strong) iCarousel *headerCarousel;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIView *buttonSectionsView;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *writeButton;

@property (nonatomic, strong) NSMutableArray *headerTermKeys;
@property (nonatomic, strong) NSMutableArray *contentDictData;

@property (nonatomic, strong) NIPagingScrollView *pagingScrollView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *recycledTableView;

@property (nonatomic, strong) EPSearchKeywordViewController *searchKeywordViewController;

@property (nonatomic, strong) EPQueryViewController *queryViewController;

@end
