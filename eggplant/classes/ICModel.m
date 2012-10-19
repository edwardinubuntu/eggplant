//
//  ICModel.m
//  iCook
//
//  Created by Edward Chiang on 12/6/19.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "ICModel.h"

@implementation ICModel

@synthesize isLoading = _isLoading;
@synthesize isLoaded = _isLoaded;
@synthesize canLoadMore = _canLoadMore;
@synthesize code = _code;
@synthesize page = _page;
@synthesize limit = _limit;
@synthesize offset = _offset;

- (id)init {
  if (self = [super init]) {
    _isLoaded = NO;
    _isLoading = NO;
    _canLoadMore = NO;
    _page = 1;
    _limit = 10;
    _offset = 0;
  }
  return self;
}

#pragma mark - Public

- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadBolck)requestDidFinishLoad
   loadWithError:(requestLoadWithErrorBlock)requestLoadWithError {
  self.isLoading = YES;
}

- (NSError *)retrieveErrorResponseData:(AFHTTPRequestOperation *)operation error:(NSError *)error {
  if (operation.responseData && operation.responseData.length > 0) {
    
    NSString *responseText = [NSString stringWithUTF8String:[operation.responseData bytes]];
    
    if (NIIsStringWithAnyText(responseText)) {
      NSRange rangeOfLastChar = [responseText rangeOfString:@"}"];
      
      if (rangeOfLastChar.location + 1 < responseText.length) {
        NSString *responseCleanText = [responseText substringToIndex:rangeOfLastChar.location + 1];
        
        NIDPRINT(@"responseText %@", responseCleanText);

        NSError *error;
        NSDictionary *jsonDict =
        [NSJSONSerialization JSONObjectWithData: [responseCleanText dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &error];
        
        NIDPRINT(@"jsonDict %@", jsonDict);
        NSMutableDictionary *errorUserInfo = [[NSMutableDictionary alloc] initWithDictionary:error.userInfo];
        [errorUserInfo addEntriesFromDictionary:jsonDict];
        
        if (error.domain && error.code) {
          NSError *newError = [NSError errorWithDomain:error.domain code:error.code userInfo:errorUserInfo];
           NIDPRINT(@"retrieveErrorResponseData newError %@", newError);
          return newError;
        }
      }
    }
  }
  return error;
}

@end
