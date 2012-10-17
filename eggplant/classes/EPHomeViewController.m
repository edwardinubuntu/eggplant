//
//  EPHomeViewController.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/15.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPHomeViewController.h"
#import "UIControl+BlocksKit.h"
#import "EPTermsStorageManager.h"
#import "EPDataSourceObject.h"
#import "EPScrollPageView.h"

@interface EPHomeViewController ()

@end

@implementation EPHomeViewController

CGFloat adjustX = 0;
CGFloat spacing = 80;
CGFloat backViewHeight = 30;
CGFloat smallMoving = 25;

#define kCountAbout 1
#define kCountHome  1

#define kIndexAbout 0
#define kIndexHome  1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

#pragma mark - UIViewController

- (void)loadView {
  [super loadView];
  
  __block EPHomeViewController *tempSelf = self;
  
  _headerCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.f)];
  self.headerCarousel.delegate = self;
  self.headerCarousel.dataSource = self;
  self.headerCarousel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navy_blue"]];
  [self.view addSubview:self.headerCarousel];
  
  CGFloat spacing = 3;
  _searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.searchButton setImage:[UIImage imageNamed:@"06-magnify"] forState:UIControlStateNormal];
  [self.searchButton sizeToFit];
  self.searchButton.center = CGPointMake(spacing + self.searchButton.frame.size.width, self.view.frame.size.height - self.searchButton.frame.size.height - spacing);
  self.searchButton.tintColor = [UIColor clearColor];
  [self.view addSubview:self.searchButton];
  
  _buttonSectionsView = [[UIView alloc] init];
  self.buttonSectionsView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.buttonSectionsView];
  
  _cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.cameraButton setImage:[UIImage imageNamed:@"86-camera"] forState:UIControlStateNormal];
  [self.cameraButton addEventHandler:^(id sender) {
    [tempSelf foldSearchButtonsWithCurrentButton:tempSelf.searchButton];
  } forControlEvents:UIControlEventTouchUpInside];
  [self.buttonSectionsView addSubview:self.cameraButton];
  
  _writeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.writeButton setImage:[UIImage imageNamed:@"187-pencil"] forState:UIControlStateNormal];
  [self.writeButton addEventHandler:^(id sender) {
    [tempSelf foldSearchButtonsWithCurrentButton:tempSelf.searchButton];
  } forControlEvents:UIControlEventTouchUpInside];
  [self.buttonSectionsView addSubview:self.writeButton];
  
  _pagingScrollView = [[NIPagingScrollView alloc] initWithFrame:CGRectMake(0, self.headerCarousel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.headerCarousel.frame.size.height)];
  self.pagingScrollView.delegate = self;
  self.pagingScrollView.dataSource = self;
  [self.view addSubview:self.pagingScrollView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self searchBarPressHandleAnimations];
  [self.view bringSubviewToFront:self.searchButton];
  
  [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)loadData {
  
  // Default
  [[EPTermsStorageManager defaultManager] load];
  NSDictionary *termsDictData = [[EPTermsStorageManager defaultManager] termsFromDefault];
  NSArray *termKeys = [termsDictData objectForKey:@"termKeys"];
  self.termsFromDefault = [[NSArray alloc] initWithArray:termKeys];
  
  // User Saved
  NSDictionary *termsUserSavedDictData = [[EPTermsStorageManager defaultManager] termsFromUserSaved];
  NSArray *termUserSavedKeys = [termsUserSavedDictData objectForKey:@"termKeys"];
  self.termsFromUserSaved = [[NSMutableArray alloc] initWithArray:termUserSavedKeys];
  
  [self.headerCarousel reloadData];
  [self.pagingScrollView reloadData];
  
  if (self.termsFromDefault.count > 0) {
    // Scroll to First Data
    [self.headerCarousel scrollToItemAtIndex:(kCountAbout + kCountHome + 0) animated:YES];
  }
  
}

- (void)foldSearchButtonsWithCurrentButton:(UIButton *)currentButton {
  [UIView animateWithDuration:0.3 animations:^{
    
    CGFloat currentButtonRight = spacing;
    currentButtonRight += smallMoving;
    // Righter
    self.cameraButton.center = CGPointMake(currentButtonRight, self.buttonSectionsView.frame.size.height / 2);
    self.writeButton.center = CGPointMake(currentButtonRight + spacing + self.cameraButton.frame.size.width / 2, self.buttonSectionsView.frame.size.height / 2);
    
    self.buttonSectionsView.frame = CGRectMake(currentButton.frame.origin.x + currentButton.frame.size.width + adjustX,  currentButton.frame.origin.y + (currentButton.frame.size.height - backViewHeight) / 2, 0, backViewHeight);
    
  } completion:^(BOOL finished) {
    
    [UIView animateWithDuration:0.3 animations:^{
      // Lefter
      CGFloat currentButtonRight = 0;
      self.cameraButton.center = CGPointMake(currentButtonRight, self.buttonSectionsView.frame.size.height / 2);
      self.writeButton.center = CGPointMake(currentButtonRight, self.buttonSectionsView.frame.size.height / 2);
      
      [self.searchButton setImage:[UIImage imageNamed:@"06-magnify"] forState:UIControlStateNormal];
      
    } completion:^(BOOL finished) {
      self.cameraButton.frame = CGRectZero;
      self.writeButton.frame = CGRectZero;
    }];
    
  }];
  currentButton.selected = NO;
}

- (void)explandSearchButtonsWithCurrentButton:(UIButton *)currentButton {
  self.buttonSectionsView.frame = CGRectMake(currentButton.frame.origin.x + currentButton.frame.size.width + adjustX, currentButton.frame.origin.y + (currentButton.frame.size.height - backViewHeight) / 2, 0, backViewHeight);
  
  [UIView animateWithDuration:0.3 animations:^{
    self.buttonSectionsView.frame = CGRectMake(currentButton.frame.origin.x + currentButton.frame.size.width + adjustX,  currentButton.frame.origin.y + (currentButton.frame.size.height - backViewHeight) / 2, self.view.frame.size.width, backViewHeight);
    [self.cameraButton sizeToFit];
    [self.writeButton sizeToFit];
    
    CGFloat currentButtonRight = spacing;
    currentButtonRight += smallMoving;
    // Righter
    self.cameraButton.center = CGPointMake(currentButtonRight, self.buttonSectionsView.frame.size.height / 2);
    self.writeButton.center = CGPointMake(currentButtonRight + spacing + self.cameraButton.frame.size.width / 2, self.buttonSectionsView.frame.size.height / 2);
    
    [self.searchButton setImage:[UIImage imageNamed:@"06-magnify-right"] forState:UIControlStateNormal];
    
  } completion:^(BOOL finished) {
    
    [UIView animateWithDuration:0.3 animations:^{
      // Lefter
      CGFloat currentButtonRight = spacing;
      self.cameraButton.center = CGPointMake(currentButtonRight, self.buttonSectionsView.frame.size.height / 2);
      self.writeButton.center = CGPointMake(currentButtonRight + spacing + self.cameraButton.frame.size.width / 2, self.buttonSectionsView.frame.size.height / 2);
      
    }];
  }];
  currentButton.selected = YES;
}

- (void)searchBarPressHandleAnimations {
  __block EPHomeViewController *tempSelf = self;
  [self.searchButton addEventHandler:^(id sender) {
    UIButton *currentButton = (UIButton *)sender;
    currentButton.selected = !currentButton.selected;
    // After switch
    if (currentButton.selected) {
      [tempSelf explandSearchButtonsWithCurrentButton:currentButton];
      
    } else {
      [tempSelf foldSearchButtonsWithCurrentButton:currentButton];
    }
  } forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
  if (carousel == self.headerCarousel) {
    return kCountAbout + kCountHome + self.termsFromDefault.count + self.termsFromUserSaved.count;
  }
  return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
  if (carousel == self.headerCarousel) {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 34)];
    UILabel *sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 32)];
    sectionHeaderLabel.textAlignment = UITextAlignmentCenter;
    
    switch (index) {
      case kIndexAbout:
        sectionHeaderLabel.text = NSLocalizedString(@"About", @"About");
        break;
      case kIndexHome:
        sectionHeaderLabel.text = NSLocalizedString(@"Sections", @"Sections");
        break;
      default:
        
        if ((index - kCountAbout - kCountHome) < self.termsFromDefault.count) {
          NSString *termFromDefault = [self.termsFromDefault objectAtIndex:((index - kCountAbout - kCountHome))];
          sectionHeaderLabel.text = termFromDefault;
        } else {
          sectionHeaderLabel.text = [NSString stringWithFormat:@"Sections %i", index];
        }
        break;
    }
    
    sectionHeaderLabel.textColor = [UIColor whiteColor];
    sectionHeaderLabel.backgroundColor = [UIColor grayColor];
    sectionHeaderLabel.center = sectionHeaderView.center;
    
    [sectionHeaderView setBackgroundColor:[UIColor clearColor]];
    [sectionHeaderView addSubview:sectionHeaderLabel];
    return sectionHeaderView;
  }
  return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - iCarouselDelegate

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
  if (carousel == self.headerCarousel) {
    [self.pagingScrollView moveToPageAtIndex:carousel.currentItemIndex animated:YES];
  }
}

#pragma mark - NIPagingScrollViewDataSource

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView {
  return kCountAbout + kCountHome + self.termsFromDefault.count + self.termsFromUserSaved.count;
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex {
  
  EPScrollPageView *contentHeaderView = [[EPScrollPageView alloc] initWithFrame:CGRectMake(0, 0, pagingScrollView.frame.size.width,pagingScrollView.frame.size.height)];
 [contentHeaderView setBackgroundColor:[UIColor lightGrayColor]];

      switch (pageIndex) {
        case kIndexAbout: {
          UILabel *contentHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 36)];
          contentHeaderLabel.textAlignment = UITextAlignmentCenter;
          contentHeaderLabel.text = [NSString stringWithFormat:@"Content %i", pageIndex];
          contentHeaderLabel.textColor = [UIColor whiteColor];
          contentHeaderLabel.backgroundColor = [UIColor grayColor];
          contentHeaderLabel.center = contentHeaderView.center;
          [contentHeaderView addSubview:contentHeaderLabel];
        }
          break;
        case kIndexHome: {
          UILabel *contentHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 36)];
          contentHeaderLabel.textAlignment = UITextAlignmentCenter;
          contentHeaderLabel.text = [NSString stringWithFormat:@"Content %i", pageIndex];
          contentHeaderLabel.textColor = [UIColor whiteColor];
          contentHeaderLabel.backgroundColor = [UIColor grayColor];
          contentHeaderLabel.center = contentHeaderView.center;
          [contentHeaderView addSubview:contentHeaderLabel];
        }
          break;
        default:
  
          if ((pageIndex - kCountAbout - kCountHome) < self.termsFromDefault.count) {
//            NSString *termFromDefault = [self.termsFromDefault objectAtIndex:((pageIndex - kCountAbout - kCountHome))];
            UITableView *dataSourceView = [[UITableView alloc] initWithFrame:contentHeaderView.frame];
            EPDataSourceObject *dataSourceObject = [[EPDataSourceObject alloc] init];
            dataSourceView.dataSource = dataSourceObject;
            dataSourceView.delegate = dataSourceObject;
//            [contentHeaderView addSubview:dataSourceView];
        } else {
          }
          break;
      }
  
      return contentHeaderView;
}

#pragma mark - NIPagingScrollViewDelegate

- (void)pagingScrollViewDidChangePages:(NIPagingScrollView *)pagingScrollView {
  if (pagingScrollView == self.pagingScrollView) {
      [self.headerCarousel scrollToItemAtIndex:self.pagingScrollView.centerPageIndex duration:0.5];
  }
}

@end
