//
//  EPYKnowledgeSearchModel.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPYKnowledgeSearchModel.h"
#import "NSString+Encode.h"

@implementation EPYKnowledgeSearchModel

- (id)init {
  if (self = [super init]) {
    _knowledges = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadBolck)requestDidFinishLoad loadWithError:(requestLoadWithErrorBlock)requestLoadWithError {
  NSMutableString *path = [[NSMutableString alloc] init];
  [path appendFormat:@"v1/SEARCH?appid=%@", kYAHOO_APP_ID];
  [path appendFormat:@"&p=%@", [self.keywords encodeString:NSUTF8StringEncoding]];
  [path appendString:@"&intl=tw&format=json"];

  NIDPRINT(@"Query with %@", path);
  
  __block EPYKnowledgeSearchModel *tempSelf = self;
  if (!self.isLoading) {
    self.isLoading = YES;
    
    NIDPRINT(@"baseURL %@", [[EPRESTClient sharedYahooClient] baseURL]);
    
    [[EPRESTClient sharedYahooClient] getPath:path parameters:[[NSMutableDictionary alloc] init] success:^(AFHTTPRequestOperation *operation, id responseObject) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      
      NIDPRINT(@"ICYKnowledgeSearchModel: %@", responseObject);
      
      NSArray *results = [[responseObject objectForKey:@"SearchResult"] objectForKey:@"Results"];
      for (NSDictionary *eachResult in results) {
        EPYKnowledge *knowledge = [eachResult extractYKnowledge];
        [tempSelf.knowledges addObject:knowledge];
      }
      
      requestDidFinishLoad();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      requestLoadWithError(error);
    }];
  }
}

@end
