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
    _termsFromUserSaved = [[NSMutableDictionary alloc] init];
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
  // concatenate the file name "tagsIndex.plist" to the path
  _filePath = [[NSString alloc] initWithString:[dir stringByAppendingPathComponent:@"termsUserStorage.plist"]];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  // if the file does not exist, create an empty NSMutableDictionary;
  // otherwise, initialize an NSDictionary with the file's contents
  if ([fileManager fileExistsAtPath:_filePath] == NO && !_termsFromUserSaved) {
    _termsFromUserSaved = [[NSMutableDictionary alloc] init];
  }
  else {
    [_termsFromUserSaved addEntriesFromDictionary:[[NSMutableDictionary alloc] initWithContentsOfFile:_filePath]];
  } // end else
}

- (void)save {
  [self.termsFromUserSaved writeToFile:_filePath atomically:NO];
}

@end
