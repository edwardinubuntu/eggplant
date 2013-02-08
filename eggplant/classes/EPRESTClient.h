//
//  EPRESTClient.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "AFHTTPClient.h"

@interface EPRESTClient : AFHTTPClient

+ (EPRESTClient *)sharedYahooClient;
+ (EPRESTClient *)sharedWikiClient:(NSString *)lang;
+ (EPRESTClient *)sharedInstgramClient;
+ (EPRESTClient *)sharediCookClient;
+ (EPRESTClient *)sharedTranslateClient;

@end
