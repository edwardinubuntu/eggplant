//
//  EPInstagramTagsMediaModelTests.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/19.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPInstagramTagsMediaModelTests.h"

@implementation EPInstagramTagsMediaModelTests

- (void)setUp {
  [super setUp];
  // Set-up code here.
  _tagsMediaModel = [[EPInstagramTagsMediaModel alloc] init];
}

- (void)tearDown {
  // Tear-down code here.
  [super tearDown];
}

- (void)testSearchTags {
  self.tagsMediaModel.keyword = @"eggplant";
  
  __block BOOL done = NO;
  __block EPInstagramTagsMediaModelTests *tempSelf = self;
  [self.tagsMediaModel loadMore:NO didFinishLoad:^{
    done = YES;
    STAssertTrue(tempSelf.tagsMediaModel.isLoaded, @"Must be loaded");
    
    STAssertTrue(tempSelf.tagsMediaModel.instagrams.count > 0, @"Must have photo media");
    for (EPInstagram *eachData in tempSelf.tagsMediaModel.instagrams) {
      NIDPRINT(@"eachData.name: %@", eachData.name);
      NIDPRINT(@"eachData.link: %@", eachData.link);
      for (NSString *key in eachData.images.keyEnumerator.allObjects) {
        EPImage *eachImage = [eachData.images objectForKey:key];
        if (eachImage.imageType == EPImageTypeThumbnail) {
          NIDPRINT(@"EPImageTypeThumbnail eachImage.url.absoluteString: %@", eachImage.url.absoluteString);
          STAssertTrue(NIIsStringWithAnyText(eachImage.url.absoluteString), @"Must be loaded");
        }
      }
      
    }
    
  } loadWithError:^(NSError *error) {
    done = YES;
    NIDPRINT(@"tagsMediaModel got Error %@", error.localizedDescription);
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
