//
//  ICRecipesSearchModelTests.m
//  iCook
//
//  Created by Edward Chiang on 12/7/4.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "ICRecipesSearchModelTests.h"

@implementation ICRecipesSearchModelTests

@synthesize recipesSearchModel = _recipesSearchModel;

- (void)setUp {
  [super setUp];
  _recipesSearchModel = [[ICRecipesSearchModel alloc] init];
}

- (void)tearDown {
  // Tear-down code here.
  [super tearDown];
}

- (void)testSearchChinese {
  NSString *keywordText = @"茄子";
  
  self.recipesSearchModel.text = keywordText;
  
  __block BOOL done = NO;
  __block ICRecipesSearchModelTests *tempSelf = self;
  [self.recipesSearchModel loadMore:NO didFinishLoad:^{
    done = YES;
    STAssertTrue(tempSelf.recipesSearchModel.isLoaded, @"Must be loaded");
    STAssertEquals(tempSelf.recipesSearchModel.code, 113, @"HTTP status must be 113");
    STAssertTrue([tempSelf.recipesSearchModel.recipes count] > 0 , @"Must more than one");
    STAssertTrue(tempSelf.recipesSearchModel.page == 1 , @"Must be first page");
    if ([tempSelf.recipesSearchModel.recipes count] > 0) {
      for (ICRecipe *eachRecipe in tempSelf.recipesSearchModel.recipes) {
        STAssertTrue(NIIsStringWithAnyText(eachRecipe.name), @"Recipe must have name");
        NIDPRINT(@"recipesSearchModel eachRecipe.name %@", eachRecipe.name);
        NIDPRINT(@"recipesSearchModel eachRecipe.objectID %i", eachRecipe.objectID);
        NIDPRINT(@"eachRecipe.photos.smallURL.absoluteString %@", eachRecipe.photos.smallURL.absoluteString);
        NIDPRINT(@"eachRecipe.photos.recipeDescription %@", eachRecipe.recipeDescription);
      }
    }
    NIDPRINT(@"In testSearchChinese we found how many? %i", [tempSelf.recipesSearchModel.recipes count]);
  } loadWithError:^(NSError *error) {
    done = YES;
    NIDPRINT(@"testSearchChinese got Error %@", error.localizedDescription);
    STAssertTrue(NO, @"Load with Error");
  }];
  
  while (!done) {
    // This executes another run loop.
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    // Sleep 1/100th sec
    usleep(1000);
  }
}

- (void)testSearchEnglish {
  NSString *keywordText = @"chocolate";
  
  self.recipesSearchModel.text = keywordText;
  
  __block BOOL done = NO;
  __block ICRecipesSearchModelTests *tempSelf = self;
  [self.recipesSearchModel loadMore:NO didFinishLoad:^{
    done = YES;
    STAssertTrue(tempSelf.recipesSearchModel.isLoaded, @"Must be loaded");
    STAssertEquals(tempSelf.recipesSearchModel.code, 113, @"HTTP status must be 113");
    
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
