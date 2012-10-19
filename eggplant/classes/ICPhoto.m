//
//  ICPhoto.m
//  iCook
//
//  Created by Edward Chiang on 12/8/8.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "ICPhoto.h"

@implementation ICPhoto

- (id)init {
  if (self = [super init]) {
    _mediumURL = [[NSURL alloc] init];
    _squareURL = [[NSURL alloc] init];
    _smallURL = [[NSURL alloc] init];
    _largeURL = [[NSURL alloc] init];
  }
  return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self->_mediumURL = [aDecoder decodeObjectForKey:@"mediumURL"];
    self->_squareURL = [aDecoder decodeObjectForKey:@"squareURL"];
    self->_smallURL = [aDecoder decodeObjectForKey:@"smallURL"];
    self->_largeURL = [aDecoder decodeObjectForKey:@"largeURL"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self->_mediumURL forKey:@"mediumURL"];
  [aCoder encodeObject:self->_squareURL forKey:@"squareURL"];
  [aCoder encodeObject:self->_smallURL forKey:@"smallURL"];
  [aCoder encodeObject:self->_largeURL forKey:@"largeURL"];
}

@end
