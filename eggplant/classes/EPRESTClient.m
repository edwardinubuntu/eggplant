//
//  EPRESTClient.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPRESTClient.h"

@implementation EPRESTClient

static EPRESTClient *gYahooSharedClient;

+ (EPRESTClient *)sharedYahooClient {
  static dispatch_once_t yahooOnceToken;
  dispatch_once(&yahooOnceToken, ^{
    gYahooSharedClient = (EPRESTClient *)[EPRESTClient clientWithBaseURL:[NSURL URLWithString:kYAHOO_BASE_URL]];
    [gYahooSharedClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
  });
  
  return gYahooSharedClient;
}

@end
