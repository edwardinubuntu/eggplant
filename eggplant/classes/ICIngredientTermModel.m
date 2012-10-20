//
//  ICIngredientTermModel.m
//  iCook
//
//  Created by Edward Chiang on 12/10/4.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "ICIngredientTermModel.h"
#import "NSString+Encode.h"

@implementation ICIngredientTermModel

- (id)init {
  if (self = [super init]) {
    _ingredientTerms = [[NSMutableArray alloc] init];
  }
  return self;
}

- (id)initWithTerm:(NSString *)term {
  if (self = [super init]) {
    self.term = term;
  }
  return self;
}

- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadBolck)requestDidFinishLoad loadWithError:(requestLoadWithErrorBlock)requestLoadWithError {
  
  if (!more) {
    self.offset = 0;
    [self.ingredientTerms removeAllObjects];
  } else {
    self.offset = [self.ingredientTerms count];
  }
  self.page = self.offset / self.limit + 1;
  
  NSMutableString *path = [NSMutableString stringWithString:@"/ingredients/autocomplete.json"];
  [path appendFormat:@"?term=%@", [self.term encodeString:NSUTF8StringEncoding]];
  
  __block ICIngredientTermModel *tempSelf = self;
  if (!self.isLoading) {
    self.isLoading = YES;
    NIDPRINT(@"Term Start Load API: %@", path);
    [[EPRESTClient sharediCookClient] getPath:path parameters:[[NSMutableDictionary alloc] init] success:^(AFHTTPRequestOperation *operation, id responseObject) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      
      NIDPRINT(@"operation.response.allHeaderFields: %@", operation.response.allHeaderFields);
      NSString *runTime = [operation.response.allHeaderFields objectForKey:@"X-Runtime"];
      runTime = [NSString stringWithFormat:@"%.03f", [runTime floatValue]];
      
      NIDPRINT(@"ICIngredientTermModel: %@", responseObject);
      
      tempSelf.code = [[responseObject objectForKey:@"code"] intValue];

      NSArray *termsDict = [responseObject objectForKey:@"results"];
      for (NSDictionary *eachTermDict in termsDict) {
        ICIngredientTerm *term = [[ICIngredientTerm alloc] init];
        term.name = [eachTermDict objectForKey:@"name"];
        
        [tempSelf.ingredientTerms addObject:term];
      }
      tempSelf.canLoadMore = tempSelf.ingredientTerms.count >= self.limit;
      requestDidFinishLoad();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      NIDPRINT(@"New Error %@", error.localizedDescription);
    }];
  }
}

@end
