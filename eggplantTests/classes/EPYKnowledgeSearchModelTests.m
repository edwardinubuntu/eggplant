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

- (void)testSearchList {
  self.searchModel.keywords = @"茄子";
  
  __block BOOL done = NO;
  __block EPYKnowledgeSearchModelTests *tempSelf = self;
  [self.searchModel loadMore:NO didFinishLoad:^{
    done = YES;
    STAssertTrue(tempSelf.searchModel.isLoaded, @"Must be loaded");
    for (EPYKnowledge *eachknowledge in self.searchModel.knowledges) {
      NIDPRINT(@"EPYKnowledge :%@", eachknowledge);
    }
    
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

- (void)queryTermForKnowledge:(NSString *)keyword canEat:(BOOL)canEat {
    self.searchModel.keywords = keyword;
    
    __block BOOL done = NO;
    __block EPYKnowledgeSearchModelTests *tempSelf = self;
    [self.searchModel loadMore:NO didFinishLoad:^{
        done = YES;
        STAssertTrue(tempSelf.searchModel.isLoaded, @"Must be loaded");
        STAssertTrue(tempSelf.searchModel.knowledges.count > 0, @"Must have knowledges");
        
        BOOL checkCategoryPass = NO;
        for (EPYKnowledge *eachKnowledge in tempSelf.searchModel.knowledges) {
            NIDPRINT(@"eachKnowledge %@", eachKnowledge);
            
            NSRange textRangeCook = [eachKnowledge.category rangeOfString:kCategoryCook];
            NSRange textRangeIngredient= [eachKnowledge.category rangeOfString:kCategoryIngredient];
            NSRange textRangePlant = [eachKnowledge.category rangeOfString:kCategoryPlant];
            
            NSRange unionRange = NSUnionRange(textRangeCook, NSUnionRange(textRangeIngredient, textRangePlant));
            if(unionRange.location != NSNotFound) {
                checkCategoryPass = YES;
                break;
            }
        }
        STAssertTrue(checkCategoryPass == canEat, @"Must pass category check");
        
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

- (void)testSearchPotato {
  [self queryTermForKnowledge:@"馬鈴薯" canEat:YES];
}

- (void)testSearchTomato {
  [self queryTermForKnowledge:@"番茄" canEat:YES];
}

- (void)testSearchGreenPeppers {
  [self queryTermForKnowledge:@"青椒" canEat:YES];
}

- (void)testSearchPhone {
  [self queryTermForKnowledge:@"手機" canEat:NO];
}

- (void)testSearchScreen {
  [self queryTermForKnowledge:@"螢幕" canEat:NO];
}

@end
