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
#import "EPScrollPageView.h"
#import "UIImageView+AFNetworking.h"
#import "EPWikiCell.h"
#import "EPWebViewController.h"

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
    _recycledTableView = [[NSMutableDictionary alloc] init];
    _termDataFromDefault = [[NSDictionary alloc] init];
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
  
  _tableView = [[UITableView alloc] init];
  
  [self loadData];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self searchBarPressHandleAnimations];
  [self.view bringSubviewToFront:self.searchButton];
  [self.view bringSubviewToFront:self.buttonSectionsView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (NSArray *)sourceWithGivenDefaultDataSet:(NSInteger)pageIndex {
  NSArray *sources;
  if (pageIndex < self.termKeysFromDefault.count) {
    
    NSString *key = [self.termKeysFromDefault objectAtIndex:(pageIndex)];
    // Check data
    NSArray *dataFromTerms = [self.termDataFromDefault objectForKey:@"terms"];
    
    for (NSDictionary *eachDataTerm  in dataFromTerms) {
      if ([[eachDataTerm objectForKey:@"key"] isEqualToString:key]) {
        sources = [eachDataTerm objectForKey:@"sources"];
        break;
      }
    }
  }
  return sources;
}

- (UITableView *)dequeueReusableTableViewWithIdentifier:(NSString*)identifier {
  UITableView *cachedView = [self.recycledTableView objectForKey:identifier];
  if (!cachedView) {
    cachedView = [[UITableView alloc] init];
    [self.recycledTableView setObject:cachedView forKey:identifier];
  }
  return cachedView;
}

- (void)loadData {
  
  // Default
  [[EPTermsStorageManager defaultManager] load];
  self.termDataFromDefault = [[EPTermsStorageManager defaultManager] termsFromDefault];
  NSArray *termKeys = [self.termDataFromDefault objectForKey:@"termKeys"];
  self.termKeysFromDefault = [termKeys copy];
  
  // User Saved
  NSDictionary *termsUserSavedDictData = [[EPTermsStorageManager defaultManager] termsFromUserSaved];
  NSArray *termUserSavedKeys = [termsUserSavedDictData objectForKey:@"termKeys"];
  self.termsFromUserSaved = [[NSMutableArray alloc] initWithArray:termUserSavedKeys];
  
  [self.headerCarousel reloadData];
  [self.pagingScrollView reloadData];
  
  if (self.termKeysFromDefault.count > 0) {
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
    return kCountAbout + kCountHome + self.termKeysFromDefault.count + self.termsFromUserSaved.count;
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
        
        if ((index - kCountAbout - kCountHome) < self.termKeysFromDefault.count) {
          NSString *termFromDefault = [self.termKeysFromDefault objectAtIndex:((index - kCountAbout - kCountHome))];
          sectionHeaderLabel.text = termFromDefault;
        } else {
          sectionHeaderLabel.text = [NSString stringWithFormat:@"Sections %i", index];
        }
        break;
    }
    
    sectionHeaderLabel.textColor = [UIColor whiteColor];
    sectionHeaderLabel.backgroundColor = [UIColor clearColor];
    sectionHeaderLabel.font = [UIFont systemFontOfSize:20.f];
    sectionHeaderLabel.shadowColor = [UIColor lightGrayColor];
    sectionHeaderLabel.shadowOffset = CGSizeMake(0, 1);
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
  return kCountAbout + kCountHome + self.termKeysFromDefault.count + self.termsFromUserSaved.count;
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex {
  
  EPScrollPageView *contentHeaderView = [[EPScrollPageView alloc] initWithFrame:CGRectMake(0, 0, pagingScrollView.frame.size.width,pagingScrollView.frame.size.height)];
  [contentHeaderView setBackgroundColor:[UIColor lightGrayColor]];
  
  NSInteger termIndex = pageIndex - kCountAbout - kCountHome;
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
    default: {
      
      if (termIndex < self.termKeysFromDefault.count) {
        NSString *termFromDefault = [self.termKeysFromDefault objectAtIndex:(termIndex)];
        _tableView = [self dequeueReusableTableViewWithIdentifier:[NSString stringWithFormat:@"TableViewID%@", termFromDefault]];
        _tableView = [[UITableView alloc] init];
        _tableView.tag = termIndex;
        _tableView.frame = contentHeaderView.frame;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [contentHeaderView addSubview:_tableView];
      } else {
      }
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSInteger pageIndex = tableView.tag;
  NSArray *sources = [self sourceWithGivenDefaultDataSet:pageIndex];
  if (sources.count > 0) {
    return sources.count;
  }
  
  NSInteger numberOfRows = 0;
  switch (pageIndex) {
    case 1:
      numberOfRows = 5;
      break;
    default:
      numberOfRows = 20;
      break;
  }
  return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  __block EPHomeViewController *tempSelf = self;
  __block NSIndexPath *tempIndexPath = indexPath;
  
  NSInteger pageIndex = tableView.tag;
  if (pageIndex < self.termKeysFromDefault.count) {
    
    NSString *key = [self.termKeysFromDefault objectAtIndex:(pageIndex)];
    // Check data
    NSArray *dataFromTerms = [self.termDataFromDefault objectForKey:@"terms"];
    
    for (NSDictionary *eachDataTerm  in dataFromTerms) {
      if ([[eachDataTerm objectForKey:@"key"] isEqualToString:key]) {
        NSDictionary *currentSource = [[eachDataTerm objectForKey:@"sources"] objectAtIndex:indexPath.row];
          NSString *title = [currentSource objectForKey:@"title"];
          
          NSMutableString *cellWithId = [NSMutableString stringWithFormat:@"cell%@%i%i", title, indexPath.section, indexPath.row];
          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithId];
          if (!cell) {
            NSString *sourceType = [currentSource objectForKey:@"type"];
            if ([sourceType isEqualToString:@"wiki"]) {
              cell = [[EPWikiCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
              
              ((EPWikiCell *)cell).sourceLabel.text = [currentSource objectForKey:@"sourceURL"];
            } else {
              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
              
            }
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
          }
          cell.textLabel.text = title;
          cell.detailTextLabel.text = [currentSource objectForKey:@"detail"];
          
          // TODO: Add placeholder image
          [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[currentSource objectForKey:@"imageURL"]]] placeholderImage:[UIImage imageNamed:@"CellDefaultImage"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            UITableViewCell *currentLoadingCell = (UITableViewCell *)[tempSelf.tableView cellForRowAtIndexPath:tempIndexPath];
            currentLoadingCell.imageView.image = image;
            [currentLoadingCell setNeedsLayout];
            
          } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            // Handle error
          }];
          return cell;
      }
      
      
      
    }
  }
  
  NSMutableString *cellWithId = [NSMutableString stringWithFormat:@"cell%@%i%i", @"term", indexPath.section, indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  cell.textLabel.text = @"Text";
  cell.detailTextLabel.text = @"Detail";
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *currentSourceArray = [self sourceWithGivenDefaultDataSet:tableView.tag];
  NSDictionary *currentSource = [currentSourceArray objectAtIndex:indexPath.row];
  
  __block UITableView *tempTableView = tableView;
  __block NSIndexPath *tempIndexPath = indexPath;
  // TODO: Add placeholder image
  [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[currentSource objectForKey:@"imageURL"]]] placeholderImage:[UIImage imageNamed:@"CellDefaultImage"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    UITableViewCell *currentLoadingCell = (UITableViewCell *)[tempTableView cellForRowAtIndexPath:tempIndexPath];
    currentLoadingCell.imageView.image = image;
    [currentLoadingCell setNeedsLayout];
    
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    // Handle error
  }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger pageIndex = tableView.tag;
  if (pageIndex < self.termKeysFromDefault.count) {
    NSString *key = [self.termKeysFromDefault objectAtIndex:(pageIndex)];
    // Check data
    NSArray *dataFromTerms = [self.termDataFromDefault objectForKey:@"terms"];
    for (NSDictionary *eachDataTerm  in dataFromTerms) {
      if ([[eachDataTerm objectForKey:@"key"] isEqualToString:key]) {
         NSDictionary *currentSource = [[eachDataTerm objectForKey:@"sources"] objectAtIndex:indexPath.row];
        NSString *sourceType = [currentSource objectForKey:@"type"];
        if ([sourceType isEqualToString:@"wiki"]) {
          return [EPWikiCell cellHeight];
        }
      }
    }
  }
  return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
  currentCell.selected = NO;
  NSArray *currentSourceArray = [self sourceWithGivenDefaultDataSet:tableView.tag];
  NSDictionary *currentSource = [currentSourceArray objectAtIndex:indexPath.row];
  if ([currentSource objectForKey:@"url"]) {
    NSURL *openURL = [NSURL URLWithString:[currentSource objectForKey:@"url"]];
    EPWebViewController *webController = [[EPWebViewController alloc] init];
    [webController openURL:openURL];
    [self.navigationController pushViewController:webController animated:YES];
  }
}

@end
