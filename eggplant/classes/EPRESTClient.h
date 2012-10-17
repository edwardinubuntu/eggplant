//
//  EPRESTClient.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "AFRESTClient.h"

@interface EPRESTClient : AFRESTClient

+ (EPRESTClient *)sharedYahooClient;

+ (EPRESTClient *)sharedWikiClient:(NSString *)lang;

@end
