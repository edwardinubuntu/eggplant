//
//  EPWikiSearchContentModelTests.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/15.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPWikiSearchContentModelTests.h"

@implementation EPWikiSearchContentModelTests

- (void)setUp {
  [super setUp];
  // Set-up code here.
  _searchContentModel = [[EPWikiSearchContentModel alloc] init];
}

- (void)tearDown {
  // Tear-down code here.
  [super tearDown];
}

- (void)testSearch {
  self.searchContentModel.keywords = @"马铃薯";
  
  __block BOOL done = NO;
  __block EPWikiSearchContentModelTests *tempSelf = self;
  [self.searchContentModel loadMore:NO didFinishLoad:^{
    done = YES;
    STAssertTrue(tempSelf.searchContentModel.isLoaded, @"Must be loaded");
    
  } loadWithError:^(NSError *error) {
    done = YES;
    NIDPRINT(@"testSearchEnglish got Error %@", error.localizedDescription);
    STAssertTrue(NO, @"Load with Error");
  }];
  
  while (!done) {
    // This executes another run loop.
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    // Sleep 1/100th sec
    usleep(1000);
  }

}

@end
