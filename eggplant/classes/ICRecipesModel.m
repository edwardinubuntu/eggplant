//
//  ICRecipesModel.m
//  iCook
//
//  Created by Edward Chiang on 12/6/19.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "ICRecipesModel.h"
#import "ICRecipe.h"

@implementation ICRecipesModel

@synthesize recipes = _recipes;

- (id)init {
  if (self = [super init]) {
    _recipes = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadBolck)requestDidFinishLoad loadWithError:(requestLoadWithErrorBlock)requestLoadWithError {
  
  if (!more) {
    self.offset = 0;
    [self.recipes removeAllObjects];
  } else {
    self.offset = [self.recipes count];
  }
  self.page = self.offset / self.limit + 1;
  
  NSMutableString *path = [NSMutableString stringWithString:@"/api/v1/recipes.json"];
  [path appendFormat:@"?page=%i", self.page];
  [self loadRequestPath:path requestDidFinishLoad:requestDidFinishLoad requestLoadWithError:requestLoadWithError];
}

- (void)loadRequestPath:path requestDidFinishLoad:(requestDidFinishLoadBolck)requestDidFinishLoad requestLoadWithError:(requestLoadWithErrorBlock)requestLoadWithError {
  __block ICRecipesModel *tempSelf = self;
  if (!self.isLoading) {
    self.isLoading = YES;

    [[EPRESTClient sharediCookClient] getPath:path parameters:[[NSMutableDictionary alloc] init] success:^(AFHTTPRequestOperation *operation, id responseObject) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      NIDPRINT(@"responseObject: %@", responseObject);
      tempSelf.code = [[responseObject objectForKey:@"code"] intValue];
      NSArray *recipes = [responseObject objectForKey:@"recipes"];
      for (NSDictionary *eachRecipe in recipes) {
        ICRecipe *recipe = [eachRecipe extractRecipe];
        
        NSDictionary *userDict = [eachRecipe objectForKey:@"user"];
        ICUser *user = [userDict extractUser];
        recipe.user = user;
        
        // Add to recipes
        [tempSelf.recipes addObject:recipe];
      }
      tempSelf.canLoadMore = recipes.count >= self.limit;
      requestDidFinishLoad();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      NIDPRINT(@"Error %@", error.description);
      NSError *newError = [tempSelf retrieveErrorResponseData:operation error:error];
      requestLoadWithError(newError);
    }];
  }
}

@end
