//
//  EPSearchKeywordViewController.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICIngredientTermModel.h"

@protocol EPSearchKeywordViewControllerDelegate;

@interface EPSearchKeywordViewController : UITableViewController <
  UISearchDisplayDelegate,
  UISearchBarDelegate
> {
@private
  NSTimer *_timerToLoadTerm;
  BOOL _isLoadingTermModel;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplay;
@property (nonatomic, strong) ICIngredientTermModel *termModel;
@end

@protocol EPSearchKeywordViewControllerDelegate <NSObject>

- (void)searchKeywordViewController:(EPSearchKeywordViewController *)searchKeywordViewController didFinishEnterSearchKeyword:(NSString *)searchKeyword;

@end