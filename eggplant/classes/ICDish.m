//
//  ICDish.m
//  iCook
//
//  Created by Chih-Wei Lee on 6/17/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ICDish.h"

@implementation ICDish

@synthesize objectID = _objectID;
@synthesize name = _name;
@synthesize dishDescription = _dishDescription;
@synthesize likesCount = _likesCount;
@synthesize commentsCount = _commentsCount;
@synthesize viewsCount = _viewsCount;
@synthesize user = _user;

- (id)init {
  if (self = [super init]) {
    _photo = [[ICPhoto alloc] init];
  }
  return self;
}

#pragma mark - NSObject

- (NSString *)description {
  return [NSString stringWithFormat:@"ICDish %u %@", _objectID, _name];
}

- (NSUInteger)hash {
  return [[NSString stringWithFormat:@"ICDish %u", _objectID] hash];
}

@end
