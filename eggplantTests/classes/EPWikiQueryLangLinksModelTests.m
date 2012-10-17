//
//  EPWikiQueryLangLinksModelTests.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/17.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPWikiQueryLangLinksModelTests.h"

@implementation EPWikiQueryLangLinksModelTests

- (void)setUp {
  [super setUp];
  // Set-up code here.
  _wikiQueryLangLinksModel = [[EPWikiQueryLangLinksModel alloc] init];
}

- (void)tearDown {
  // Tear-down code here.
  [super tearDown];
}

- (void)queryToTestHasZhTerm:(NSString *)searchKeyword {
    self.wikiQueryLangLinksModel.keyword = searchKeyword;
    
    __block BOOL done = NO;
    __block EPWikiQueryLangLinksModelTests *tempSelf = self;
    [self.wikiQueryLangLinksModel loadMore:NO didFinishLoad:^{
        done = YES;
        STAssertTrue(tempSelf.wikiQueryLangLinksModel.isLoaded, @"Must be loaded");
        STAssertTrue(tempSelf.wikiQueryLangLinksModel.term.langLinks.count > 0, @"Must have lang");
        
        BOOL hasZHLang = NO;
        for (EPWikiLangLink *eachLangLink in tempSelf.wikiQueryLangLinksModel.term.langLinks) {
            if ([eachLangLink.lang isEqualToString:@"zh"] || [eachLangLink.lang isEqualToString:@"zh-yue"]) {
              hasZHLang = NIIsStringWithAnyText(eachLangLink.text);
              NIDPRINT(@"We got %@ in %@ : %@", tempSelf.wikiQueryLangLinksModel.keyword, eachLangLink.lang, eachLangLink.text);
              break;
            }
        }
        STAssertTrue(hasZHLang, @"Must have lang in Chinese");
        
    } loadWithError:^(NSError *error) {
        done = YES;
        NIDPRINT(@"testSearch got Error %@", error.localizedDescription);
        STAssertTrue(NO, @"Load with Error");
    }];
    
    while (!done) {
        // This executes another run loop.
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        // Sleep 1/100th sec
        usleep(1000);
    }
}

- (void)testSearchTextEggplant {
  [self queryToTestHasZhTerm:@"eggplant"];
}

- (void)testSearchTextTomato {
  [self queryToTestHasZhTerm:@"tomato"];
}

- (void)testSearchTextCarrot {
  [self queryToTestHasZhTerm:@"carrot"];
}

@end
