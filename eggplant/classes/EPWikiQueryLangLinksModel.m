//
//  EPWikiQueryLangLinksModel.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/17.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPWikiQueryLangLinksModel.h"

@implementation EPWikiQueryLangLinksModel

- (id)init {
  if (self = [super init]) {
    _term = [[EPWikiTerm alloc] init];
    
  }
  return self;
}

- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadBolck)requestDidFinishLoad loadWithError:(requestLoadWithErrorBlock)requestLoadWithError {
  NSMutableString *path = [[NSMutableString alloc] init];
  [path appendString:@"w/api.php?action=query&prop=langlinks&lllimit=500&format=json"];
  [path appendFormat:@"&titles=%@", [self.keyword encodeString:NSUTF8StringEncoding]];
  
  self.term.name = self.keyword;
  
  __block EPWikiQueryLangLinksModel *tempSelf = self;
  if (!self.isLoading) {
    self.isLoading = YES;
    
    NIDPRINT(@"EPWikiQueryLangLinksModel getPath: %@", path);
    
    [[EPRESTClient sharedWikiClient:@"en"] getPath:path parameters:[[NSMutableDictionary alloc] init] success:^(AFHTTPRequestOperation *operation, id responseObject) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      
      NIDPRINT(@"EPWikiQueryLangLinksModel: %@", responseObject);
      NSDictionary *queryDict = [responseObject objectForKey:@"query"];
      NSDictionary *pagesDict = [queryDict objectForKey:@"pages"];
      
      NSEnumerator *keyEnumrator = [pagesDict keyEnumerator];
      NSDictionary *pageDict = [pagesDict objectForKey:[keyEnumrator nextObject]];
      
      NSArray *langlinksArray = [pageDict objectForKey:@"langlinks"];
      NSMutableArray *langLinks = [[NSMutableArray alloc] initWithCapacity:langlinksArray.count];
      for (NSDictionary *eachLangLink in langlinksArray) {
        EPWikiLangLink *eachLangObject = [[EPWikiLangLink alloc] init];
        eachLangObject.text = [eachLangLink objectForKey:@"*"];
        eachLangObject.lang = [eachLangLink objectForKey:@"lang"];
        [langLinks addObject:eachLangObject];
      }
      tempSelf.term.langLinks = [NSArray arrayWithArray:langLinks];
      
      requestDidFinishLoad();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      requestLoadWithError(error);
    }];
  }
}

@end
