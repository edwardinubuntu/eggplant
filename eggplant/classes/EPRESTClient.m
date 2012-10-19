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
static EPRESTClient *gWikiSharedClient;

+ (EPRESTClient *)sharedYahooClient {
  static dispatch_once_t yahooOnceToken;
  dispatch_once(&yahooOnceToken, ^{
    gYahooSharedClient = (EPRESTClient *)[EPRESTClient clientWithBaseURL:[NSURL URLWithString:kYAHOO_BASE_URL]];
    [gYahooSharedClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
  });
  
  return gYahooSharedClient;
}

+ (EPRESTClient *)sharedWikiClient:(NSString *)lang {
  static dispatch_once_t yahooOnceToken;
  dispatch_once(&yahooOnceToken, ^{
    gWikiSharedClient = (EPRESTClient *)[EPRESTClient clientWithBaseURL:
                                         [NSURL URLWithString:
                                          [NSString stringWithFormat:@"http://%@.%@/", lang, kWIKI_BASE_URL]]];
    [gWikiSharedClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
  });
  
  return gWikiSharedClient;
}

+ (EPRESTClient *)sharedInstgramClient {
  static dispatch_once_t yahooOnceToken;
  dispatch_once(&yahooOnceToken, ^{
    gYahooSharedClient = (EPRESTClient *)[EPRESTClient clientWithBaseURL:[NSURL URLWithString:kINSTAGRAM_BASE_URL]];
    [gYahooSharedClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
  });
  
  return gYahooSharedClient;
}

@end
