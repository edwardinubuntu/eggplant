//
//  EPTerm.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/31.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPTerm.h"

@implementation EPTerm

- (id)init {
  if (self = [super init]) {
    _sources = [[NSMutableArray alloc] init];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"Sources count: %i, Sources: %@", self.sources.count, self.sources];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self->_name = [aDecoder decodeObjectForKey:@"name"];
    self->_key = [aDecoder decodeObjectForKey:@"key"];
    self->_sources = [aDecoder decodeObjectForKey:@"sources"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self->_sources forKey:@"sources"];
  [aCoder encodeObject:self->_key forKey:@"key"];
  [aCoder encodeObject:self->_name forKey:@"name"];
}

@end
