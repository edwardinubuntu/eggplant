//
//  EPHomeViewController.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/15.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPHomeViewController.h"
#import "UIControl+BlocksKit.h"

@interface EPHomeViewController ()

@end

@implementation EPHomeViewController

CGFloat adjustX = 0;
CGFloat spacing = 80;
CGFloat backViewHeight = 30;
CGFloat smallMoving = 25;

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
  self.headerCarousel.backgroundColor = [UIColor grayColor];
  [self.view addSubview:self.headerCarousel];
  
  _contentCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 44.f, self.view.frame.size.width, self.view.frame.size.height - 44.f)];
  self.contentCarousel.delegate = self;
  self.contentCarousel.dataSource = self;
  self.contentCarousel.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.contentCarousel];
  
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
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self searchBarPressHandleAnimations];
  [self.view bringSubviewToFront:self.searchButton];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - private

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
    return 5;
  }
  if (carousel == self.contentCarousel) {
    return 5;
  }
  return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
  if (carousel == self.headerCarousel) {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 38)];
    UILabel *sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 36)];
    sectionHeaderLabel.textAlignment = UITextAlignmentCenter;
    sectionHeaderLabel.text = [NSString stringWithFormat:@"Sections %i", index];
    sectionHeaderLabel.textColor = [UIColor whiteColor];
    sectionHeaderLabel.backgroundColor = [UIColor clearColor];
    sectionHeaderLabel.center = sectionHeaderView.center;
    
    [sectionHeaderView setBackgroundColor:[UIColor blackColor]];
    [sectionHeaderView addSubview:sectionHeaderLabel];
    return sectionHeaderView;
  }
  if (carousel == self.contentCarousel) {
    UIView *contentHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.contentCarousel.frame.size.height)];
    
    UILabel *sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 36)];
    sectionHeaderLabel.textAlignment = UITextAlignmentCenter;
    sectionHeaderLabel.text = [NSString stringWithFormat:@"Content %i", index];
    sectionHeaderLabel.textColor = [UIColor whiteColor];
    sectionHeaderLabel.backgroundColor = [UIColor lightGrayColor];
    sectionHeaderLabel.center = contentHeaderView.center;
    
    [contentHeaderView setBackgroundColor:[UIColor whiteColor]];
    [contentHeaderView addSubview:sectionHeaderLabel];
    
    return contentHeaderView;
  }
  return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - iCarouselDelegate

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
  if (carousel == self.headerCarousel) {
    [self.contentCarousel scrollToItemAtIndex:carousel.currentItemIndex duration:0.5];
  }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
  if (carousel == self.contentCarousel) {
    [self.headerCarousel scrollToItemAtIndex:carousel.currentItemIndex duration:0.3];
  }
}

@end
