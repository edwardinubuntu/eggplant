//
//  EPYKnowledgeSearchModelTests.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/15.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPYKnowledgeSearchModelTests.h"

@implementation EPYKnowledgeSearchModelTests

- (void)setUp {
  [super setUp];
  // Set-up code here.
  _searchModel = [[EPYKnowledgeSearchModel alloc] init];
}

- (void)tearDown {
  // Tear-down code here.
  [super tearDown];
}

- (void)testSearch {
  self.searchModel.keywords = @"馬鈴薯沙拉";
  
  __block BOOL done = NO;
  __block EPYKnowledgeSearchModelTests *tempSelf = self;
  [self.searchModel loadMore:NO didFinishLoad:^{
    done = YES;
    STAssertTrue(tempSelf.searchModel.isLoaded, @"Must be loaded");
    
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

- (void)testSearchAnotherKeywords {
  self.searchModel.keywords = @"馬鈴薯";
  
  __block BOOL done = NO;
  __block EPYKnowledgeSearchModelTests *tempSelf = self;
  [self.searchModel loadMore:NO didFinishLoad:^{
    done = YES;
    STAssertTrue(tempSelf.searchModel.isLoaded, @"Must be loaded");
    
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
