//
//  EPModel.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPRESTClient.h"
#import "NSDictionary+EPObject.h"
#import "NSString+Encode.h"
#import "NSDictionary+ICObjects.h"

typedef void(^requestDidFinishLoadEPBolck)(void);
typedef void(^requestLoadWithErrorEPBlock)(NSError *error);

@interface EPModel : NSObject

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
- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadEPBolck)requestDidFinishLoad
   loadWithError:(requestLoadWithErrorEPBlock)requestLoadWithError;


@end
