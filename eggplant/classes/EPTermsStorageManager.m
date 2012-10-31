//
//  EPTermsStorageManager.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/18.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPTermsStorageManager.h"

@implementation EPTermsStorageManager


static EPTermsStorageManager *gDefaultManager;

+ (EPTermsStorageManager *)defaultManager {
  if (!gDefaultManager) {
    gDefaultManager = [[EPTermsStorageManager alloc] init];
  }
  
  return gDefaultManager;
}

- (id)init {
  if (self = [super init]) {
    _termsFromDefault = [[NSMutableDictionary alloc] init];
    _informationFromUserSaved = [[EPInformation alloc] init];
  }
  return self;
}

- (void)load {
  
  // Append Default Data
  NSDictionary *defaultTermsDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"termsDefaultStorage" ofType:@"plist"]];
  [self.termsFromDefault addEntriesFromDictionary:defaultTermsDictionary];
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  // get the first directory
  NSString *dir = [paths objectAtIndex:0];
  NSString *informationFile = [[NSString alloc] initWithString:[dir stringByAppendingPathComponent:@"information.txt"]];
  NSData *infoData = [[NSData alloc] initWithContentsOfFile:informationFile];
  self.informationFromUserSaved = [NSKeyedUnarchiver unarchiveObjectWithData:infoData];
  
  if (!self.informationFromUserSaved) {
    self.informationFromUserSaved = [[EPInformation alloc] init];
  }

}

- (void)save {
  NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:self.informationFromUserSaved];
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  // get the first directory
  NSString *dir = [paths objectAtIndex:0];
  NSString *shoppingFile = [[NSString alloc] initWithString:[dir stringByAppendingPathComponent:@"information.txt"]];
  [infoData writeToFile:shoppingFile atomically:YES];
}

@end
