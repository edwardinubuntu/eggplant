//
//  ICModel.h
//  iCook
//
//  Created by Edward Chiang on 12/6/19.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPRESTClient.h"
#import "NSDictionary+ICObjects.h"

typedef void(^requestDidFinishLoadBolck)(void);
typedef void(^requestLoadWithErrorBlock)(NSError *error);

@interface ICModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL canLoadMore;

/**
 *  Load the url, and parse into array
 */
- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadBolck)requestDidFinishLoad
   loadWithError:(requestLoadWithErrorBlock)requestLoadWithError;

- (NSError *)retrieveErrorResponseData:(AFHTTPRequestOperation *)operation error:(NSError *)error;

@end
