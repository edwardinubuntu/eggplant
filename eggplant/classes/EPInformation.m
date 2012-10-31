//
//  EPInformation.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/31.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPInformation.h"

@implementation EPInformation

- (id)init {
  if (self = [super init]) {
    _terms = [[NSMutableArray alloc] init];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"Terms count %i, terms %@", self.terms.count, self.terms];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self->_terms = [aDecoder decodeObjectForKey:@"terms"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self->_terms forKey:@"terms"];
}

@end
