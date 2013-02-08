//
//  ICMRecipeTests.m
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import "CoreDataStack.h"
#import "ICMRecipeTests.h"
#import "ICMRecipe+Config.h"
#import "ICMPhoto.h"
#import "ICMUser.h"
#import "EPRESTClient.h"

@interface ICMRecipeTests ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSDictionary *testObject;
@end

@implementation ICMRecipeTests

- (NSManagedObjectContext *)managedObjectContext
{
  if (_managedObjectContext == nil) {
    CoreDataStack *testStack = [CoreDataStack coreDataStackWithModelName:@"eggplant" fileName:@"EggplantTest"];
    _managedObjectContext = testStack.managedObjectContext;
  }
  return _managedObjectContext;
}

#pragma mark - Test Cases

- (void)setUp
{
  [super setUp];

  // Set-up code here.
}

- (void)tearDown
{
  // Tear-down code here.

  [super tearDown];
}

- (void)testCoreDataEnvironment
{
  STAssertNotNil([self managedObjectContext], @"Get managed object context");
}

- (void)testInsertion
{
  // Grab response object from search
  NSString *path = @"/api/v1/recipes.json?page=1";

  __block BOOL done = NO;
  __weak typeof(self) weakSelf = self;
  [[EPRESTClient sharediCookClient] getPath:path
                                 parameters:[[NSMutableDictionary alloc] init]
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSArray *recipes = [responseObject objectForKey:@"recipes"];
                                      weakSelf.testObject = [recipes lastObject];
                                      done = YES;
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NIDPRINT(@"Error %@", error.description);
                                      STAssertTrue(NO, @"Load with Error");
                                      done = YES;
                                    }];

  while (!done) {
    // This executes another run loop.
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    NSLog(@"%s \n[Line:%03d] %@", __PRETTY_FUNCTION__, __LINE__, @"waiting...");
    // Sleep 1/100th sec
    usleep(1000);
  }

  ICMRecipe *newRecipe = [ICMRecipe recipeWithResponseObject:self.testObject inManagedObjectContext:self.managedObjectContext];
  STAssertEqualObjects(([NSString stringWithFormat:@"%@", newRecipe.recipeObjectID]),
                       ([NSString stringWithFormat:@"%@", self.testObject[@"id"]]),
                       @"Assert recipeObjectID");
  STAssertEqualObjects(newRecipe.name, self.testObject[@"name"], @"Assert name");
  STAssertEqualObjects(newRecipe.recipeDescription, self.testObject[@"description"], @"Assert recipeDescription");
  STAssertEqualObjects(newRecipe.tips, self.testObject[@"tips"], @"Assert tips");
  STAssertEqualObjects(newRecipe.url, self.testObject[@"url"], @"Assert url");

  STAssertEquals([newRecipe.favoritesCount integerValue], [self.testObject[@"favorites_count"] integerValue], @"Assert favoritesCount");
  STAssertEquals([newRecipe.likesCount integerValue], [self.testObject[@"likes_count"] integerValue], @"Assert likesCount");
  STAssertEquals([newRecipe.dishesCount integerValue], [self.testObject[@"dishes_count"] integerValue], @"Assert dishesCount");
  STAssertEquals([newRecipe.viewsCount integerValue], [self.testObject[@"views_count"] integerValue], @"Assert viewsCount");
  STAssertEquals([newRecipe.ranking floatValue], [self.testObject[@"ranking"] floatValue], @"Assert ranking");

  if ([newRecipe.hasDoneByLoginUser boolValue]) {
    STAssertEqualObjects(@"yes", self.testObject[@"done_by_login_user"], @"Assert hasDoneByLoginUser");
  } else {
    STAssertEqualObjects(@"no", self.testObject[@"done_by_login_user"], @"Assert hasDoneByLoginUser");
  }

  if ([newRecipe.isFavoritedByUser boolValue]) {
    STAssertEqualObjects(@"yes", self.testObject[@"favorited_by_login_user"], @"Assert isFavoritedByUser");
  } else {
    STAssertEqualObjects(@"no", self.testObject[@"favorited_by_login_user"], @"Assert isFavoritedByUser");
  }

}

@end
