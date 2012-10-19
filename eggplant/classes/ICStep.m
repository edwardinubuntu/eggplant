//
//  ICStep.m
//  iCook
//
//  Created by Chih-Wei Lee on 6/17/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ICStep.h"

@implementation ICStep

@synthesize position = _position;
@synthesize body = _body;
@synthesize objectID = _objectID;

- (id)init {
  self = [super init];
  if (self) {
    _photos = [[ICPhoto alloc] init];
  }
  return self;
}

#pragma mark - NSObject

- (NSString *)description {
  return [NSString stringWithFormat:@"ICStep %u %@", _position, _body];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self->_objectID = [aDecoder decodeIntegerForKey:@"objectID"];
    self->_body = [aDecoder decodeObjectForKey:@"body"];
    self->_photos = [aDecoder decodeObjectForKey:@"photos"];
    self->_position = [aDecoder decodeIntegerForKey:@"position"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeInteger:self->_objectID forKey:@"objectID"];
  [aCoder encodeObject:self->_body forKey:@"body"];
  [aCoder encodeObject:self->_photos forKey:@"photos"];
  [aCoder encodeInteger:self->_position forKey:@"position"];
}


@end
