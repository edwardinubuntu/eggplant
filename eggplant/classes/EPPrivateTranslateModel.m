//
//  EPPrivateTranslateModel.m
//  eggplant
//
//  Created by Anderson Lin on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPPrivateTranslateModel.h"

@implementation EPPrivateTranslateModel

- (id)init {
  if (self = [super init]) {
    
  }
  return self;
}

- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadBolck)requestDidFinishLoad loadWithError:(requestLoadWithErrorBlock)requestLoadWithError {

  NSMutableString *path = [[NSMutableString alloc] init];
  [path appendFormat:kTRANSLATE_PARAMATER_FORMAT, [self.keyword encodeString:NSUTF8StringEncoding]];
  
  
  __block EPPrivateTranslateModel *tempSelf = self;
  if (!self.isLoading) {
    self.isLoading = YES;
    
    NIDPRINT(@"EPPrivateTranslateModel getPath: %@", path);
    NIDPRINT(@"%@",[EPRESTClient sharedTranslateClient].baseURL.absoluteString);
    [[EPRESTClient sharedTranslateClient] getPath:path parameters:[[NSMutableDictionary alloc] init] success:^(AFHTTPRequestOperation *operation, id responseObject) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      
      NIDPRINT(@"EPInstagramTagsMediaModel: %@", responseObject);
      
      NSString *translation  = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
      translation = [translation substringToIndex:[translation rangeOfString:@"]" ].location];
      translation = [translation substringFromIndex:3];
      translation = [[translation componentsSeparatedByString:@","] objectAtIndex:0];
      translation = [[translation substringFromIndex:1] substringToIndex:translation.length-2];
      tempSelf.keywordTranslation = translation;
      NIDPRINT(@"%@",tempSelf.keywordTranslation);
      requestDidFinishLoad();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      requestLoadWithError(error);
    }];
  }
}


@end
