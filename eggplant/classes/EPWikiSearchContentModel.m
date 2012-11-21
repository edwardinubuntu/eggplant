//
//  EPWikiSearchContentModel.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/15.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPWikiSearchContentModel.h"

@implementation EPWikiSearchContentModel

- (id)init {
  if (self = [super init]) {
  }
  return self;
}

- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadEPBolck)requestDidFinishLoad loadWithError:(requestLoadWithErrorEPBlock)requestLoadWithError {
  NSMutableString *path = [[NSMutableString alloc] init];
  [path appendString:@"w/api.php?action=query&prop=revisions&format=json&rvprop=content"];
  [path appendFormat:@"&titles=%@", [self.keyword encodeString:NSUTF8StringEncoding]];
  
  __block EPWikiSearchContentModel *tempSelf = self;
  if (!self.isLoading) {
    self.isLoading = YES;
    
    NIDPRINT(@"EPWikiSearchContentModel getPath: %@", path);
    
    [[EPRESTClient sharedWikiClient:@"zh"] getPath:path parameters:[[NSMutableDictionary alloc] init] success:^(AFHTTPRequestOperation *operation, id responseObject) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      
      NIDPRINT(@"EPWikiSearchContentModel: %@", responseObject);
      
      requestDidFinishLoad();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      requestLoadWithError(error);
    }];
  }
}


@end
