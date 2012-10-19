//
//  ICRecipe.m
//  iCook
//
//  Created by Chih-Wei Lee on 6/17/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ICRecipe.h"

@implementation ICRecipe

- (id)init {
  if (self = [super init]) {
    _dateRemindToShopping = [[NSDate alloc] init];
    _remindNotfication = [[UILocalNotification alloc] init];
    _photos = [[ICPhoto alloc] init];
  }
  return self;
}

#pragma mark - NSObject

- (NSString *)description {
  return [NSString stringWithFormat:@"ICRecipe %u %@", _objectID, _name];
}

- (NSUInteger)hash {
  return [[NSString stringWithFormat:@"ICRecipe %u", _objectID] hash];
}

- (BOOL)isEqual:(id)object {
  if ([object isKindOfClass:[ICRecipe class]]) {
    ICRecipe *outSideRecipe = (ICRecipe *)object;
    return self.objectID == outSideRecipe.objectID;
  }
  return NO;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self->_objectID = [aDecoder decodeIntegerForKey:@"objectID"];
    self->_name = [aDecoder decodeObjectForKey:@"name"];
    self->_photos = [aDecoder decodeObjectForKey:@"photos"];
    self->_recipeDescription = [aDecoder decodeObjectForKey:@"recipeDescription"];
    self->_tips = [aDecoder decodeObjectForKey:@"tips"];
    self->_ingredients = [aDecoder decodeObjectForKey:@"ingredients"];
    self->_steps = [aDecoder decodeObjectForKey:@"steps"];
    self->_user = [aDecoder decodeObjectForKey:@"user"];
    self->_dateRemindToShopping = [aDecoder decodeObjectForKey:@"dateRemindToShopping"];
    self->_remindNotfication = [aDecoder decodeObjectForKey:@"remindNotfication"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeInteger:self->_objectID forKey:@"objectID"];
  [aCoder encodeObject:self->_name forKey:@"name"];
  [aCoder encodeObject:self->_photos forKey:@"photos"];
  [aCoder encodeObject:self->_recipeDescription forKey:@"recipeDescription"];
  [aCoder encodeObject:self->_tips forKey:@"tips"];
  [aCoder encodeObject:self->_ingredients forKey:@"ingredients"];
  [aCoder encodeObject:self->_steps forKey:@"steps"];
  [aCoder encodeObject:self->_user forKey:@"user"];
  
  [aCoder encodeInteger:self->_likesCount forKey:@"likesCount"];
  [aCoder encodeInteger:self->_commentsCount forKey:@"commentsCount"];
  [aCoder encodeInteger:self->_dishesCount forKey:@"dishesCount"];
  [aCoder encodeInteger:self->_viewsCount forKey:@"viewsCount"];
  [aCoder encodeInteger:self->_favoritesCount forKey:@"favoritesCount"];
  
  [aCoder encodeInt64:self->_facebookObjectID forKey:@"facebookObjectID"];
  
  [aCoder encodeFloat:self->_ranking forKey:@"ranking"];
  
  [aCoder encodeBool:self->_hasDoneByCurrentUser forKey:@"hasDoneByCurrentUser"];
  [aCoder encodeBool:self->_isDoneByUser forKey:@"isDoneByUser"];
  [aCoder encodeBool:self->_isFavoritedByUser forKey:@"isFavoritedByUser"];
  
  [aCoder encodeObject:self->_dateRemindToShopping forKey:@"dateRemindToShopping"];
  [aCoder encodeObject:self->_remindNotfication forKey:@"remindNotfication"];
}

@end
