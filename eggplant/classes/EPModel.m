//
//  EPModel.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPModel.h"

@implementation EPModel

- (id)init {
  if (self = [super init]) {
    _isLoaded = NO;
    _isLoading = NO;
    _canLoadMore = NO;
    _page = 1;
    _limit = 10;
    _offset = 0;
  }
  return self;
}

#pragma mark - Public

- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadEPBolck)requestDidFinishLoad
   loadWithError:(requestLoadWithErrorEPBlock)requestLoadWithError {
  self.isLoading = YES;
}

@end
