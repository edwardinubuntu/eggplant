//
//  ICIngredient.m
//  iCook
//
//  Created by Chih-Wei Lee on 6/19/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ICIngredient.h"

@implementation ICIngredient

#pragma mark - NSObject

- (NSString *)description {
  return [NSString stringWithFormat:@"ICIngredient %u %@", _objectID, _name];
}

- (NSUInteger)hash {
  return [[NSString stringWithFormat:@"ICIngredient %u", _objectID] hash];
}

- (BOOL)isEqual:(id)object {
  NSString *original = [NSString stringWithFormat:@"%i%@%@", self.recipeID, self.name, self.quantity];
  NSString *outside = [NSString stringWithFormat:@"%i%@%@", ((ICIngredient *)object).recipeID, ((ICIngredient *)object).name, ((ICIngredient *)object).quantity];
  return [original isEqualToString:outside];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self->_objectID = [aDecoder decodeIntegerForKey:@"objectID"];
    self->_recipeID = [aDecoder decodeIntegerForKey:@"recipeID"];
    self->_name = [aDecoder decodeObjectForKey:@"name"];
    self->_quantity = [aDecoder decodeObjectForKey:@"quantity"];
    self->_group = [aDecoder decodeObjectForKey:@"group"];
    self->_hasPurchased = [aDecoder decodeBoolForKey:@"hasPurchased"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeInteger:self->_recipeID forKey:@"recipeID"];
  [aCoder encodeInteger:self->_objectID forKey:@"objectID"];
  [aCoder encodeObject:self->_name forKey:@"name"];
  [aCoder encodeObject:self->_quantity forKey:@"quantity"];
  [aCoder encodeObject:self->_group forKey:@"group"];
  [aCoder encodeBool:self->_hasPurchased forKey:@"hasPurchased"];
}

@end
