//
//  ICList.m
//  iCook
//
//  Created by Chih-Wei Lee on 6/17/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ICList.h"

@implementation ICList

@synthesize objectID = _objectID;
@synthesize URL = _URL;
@synthesize name = _name;
@synthesize recipesCount = _recipesCount;

#pragma mark - NSObject

- (NSString *)description {
  return [NSString stringWithFormat:@"ICList %u %@", _objectID, _name];
}

- (NSUInteger)hash {
  return [[NSString stringWithFormat:@"ICList %d", _objectID] hash];
}


@end
