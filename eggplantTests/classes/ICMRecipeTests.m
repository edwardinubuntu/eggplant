//
//  ICMRecipeTests.m
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import "CoreDataStack.h"
#import "ICMRecipeTests.h"

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

@end
