//
//  EPSearchKeywordViewController.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EPSearchKeywordViewControllerDelegate;

@interface EPSearchKeywordViewController : UITableViewController <
  UISearchDisplayDelegate,
  UISearchBarDelegate
>

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;

@end

@protocol EPSearchKeywordViewControllerDelegate <NSObject>

- (void)searchKeywordViewController:(EPSearchKeywordViewController *)searchKeywordViewController didinishEnterSearchKeyword:(NSString *)searchKeyword;

@end