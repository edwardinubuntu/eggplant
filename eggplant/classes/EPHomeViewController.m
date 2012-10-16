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
  
  _headerCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.f)];
  self.headerCarousel.delegate = self;
  self.headerCarousel.dataSource = self;
  self.headerCarousel.backgroundColor = [UIColor grayColor];
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
  [self.buttonSectionsView addSubview:self.cameraButton];
  
  _writeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.writeButton setImage:[UIImage imageNamed:@"187-pencil"] forState:UIControlStateNormal];
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

- (void)searchBarPressHandleAnimations {

  __block EPHomeViewController *tempSelf = self;
  [self.searchButton addEventHandler:^(id sender) {
    UIButton *currentButton = (UIButton *)sender;
    currentButton.selected = !currentButton.selected;
    
    CGFloat adjustX = 0;
    CGFloat spacing = 80;
    CGFloat backViewHeight = 30;
    CGFloat smallMoving = 25;
    
    // After switch
    if (currentButton.selected) {
      
      tempSelf.buttonSectionsView.frame = CGRectMake(currentButton.frame.origin.x + currentButton.frame.size.width + adjustX, currentButton.frame.origin.y + (currentButton.frame.size.height - backViewHeight) / 2, 0, backViewHeight);
      
      [UIView animateWithDuration:0.3 animations:^{
        tempSelf.buttonSectionsView.frame = CGRectMake(currentButton.frame.origin.x + currentButton.frame.size.width + adjustX,  currentButton.frame.origin.y + (currentButton.frame.size.height - backViewHeight) / 2, tempSelf.view.frame.size.width, backViewHeight);
        [tempSelf.cameraButton sizeToFit];
        [tempSelf.writeButton sizeToFit];
        
        CGFloat currentButtonRight = spacing;
        currentButtonRight += smallMoving;
        // Righter
        tempSelf.cameraButton.center = CGPointMake(currentButtonRight, tempSelf.buttonSectionsView.frame.size.height / 2);
        tempSelf.writeButton.center = CGPointMake(currentButtonRight + spacing + tempSelf.cameraButton.frame.size.width / 2, tempSelf.buttonSectionsView.frame.size.height / 2);
        
        [tempSelf.searchButton setImage:[UIImage imageNamed:@"06-magnify-right"] forState:UIControlStateNormal];
        
      } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
          // Lefter
          CGFloat currentButtonRight = spacing;
          tempSelf.cameraButton.center = CGPointMake(currentButtonRight, tempSelf.buttonSectionsView.frame.size.height / 2);
          tempSelf.writeButton.center = CGPointMake(currentButtonRight + spacing + tempSelf.cameraButton.frame.size.width / 2, tempSelf.buttonSectionsView.frame.size.height / 2);
          
        }];
      }];
      
    } else {
      
      
      [UIView animateWithDuration:0.3 animations:^{
        
        CGFloat currentButtonRight = spacing;
        currentButtonRight += smallMoving;
        // Righter
        tempSelf.cameraButton.center = CGPointMake(currentButtonRight, tempSelf.buttonSectionsView.frame.size.height / 2);
        tempSelf.writeButton.center = CGPointMake(currentButtonRight + spacing + tempSelf.cameraButton.frame.size.width / 2, tempSelf.buttonSectionsView.frame.size.height / 2);
        
        tempSelf.buttonSectionsView.frame = CGRectMake(currentButton.frame.origin.x + currentButton.frame.size.width + adjustX,  currentButton.frame.origin.y + (currentButton.frame.size.height - backViewHeight) / 2, 0, backViewHeight);
        
      } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
          // Lefter
          CGFloat currentButtonRight = 0;
          tempSelf.cameraButton.center = CGPointMake(currentButtonRight, tempSelf.buttonSectionsView.frame.size.height / 2);
          tempSelf.writeButton.center = CGPointMake(currentButtonRight, tempSelf.buttonSectionsView.frame.size.height / 2);
          
          [tempSelf.searchButton setImage:[UIImage imageNamed:@"06-magnify"] forState:UIControlStateNormal];
          
        } completion:^(BOOL finished) {
          tempSelf.cameraButton.frame = CGRectZero;
          tempSelf.writeButton.frame = CGRectZero;
        }];
        
      }];
    }
  } forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - iCarouselDelegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
  return 5;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
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

@end
