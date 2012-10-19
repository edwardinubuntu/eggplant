//
//  ICRecipesSearchModel.m
//  iCook
//
//  Created by Edward Chiang on 12/7/4.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "ICRecipesSearchModel.h"
#import "NSString+Encode.h"

@implementation ICRecipesSearchModel

@synthesize text = _text;

- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadBolck)requestDidFinishLoad loadWithError:(requestLoadWithErrorBlock)requestLoadWithError {
  if (!more) {
    self.offset = 0;
    [self.recipes removeAllObjects];
  } else {
    self.offset = [self.recipes count];
  }
  self.page = self.offset / self.limit + 1;
  
  NSMutableString *path = [NSMutableString stringWithString:@"/api/v1/recipes/fulltext_search.json"];
  [path appendFormat:@"?page=%i", self.page];
  [path appendFormat:@"&query=%@", [self.text encodeString:NSUTF8StringEncoding]];
  [self loadRequestPath:path requestDidFinishLoad:requestDidFinishLoad requestLoadWithError:requestLoadWithError];
}

@end
