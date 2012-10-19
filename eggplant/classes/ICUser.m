//
//  ICUser.m
//  iCook
//
//  Created by Chih-Wei Lee on 6/17/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ICUser.h"

@implementation ICUser

@synthesize username = _username;
@synthesize avatarURL = _avatarURL;
@synthesize nickname = _nickname;
@synthesize email = _email;
@synthesize birthday = _birthday;
@synthesize blogURL = _blogURL;
@synthesize userDescription = _userDescription;
@synthesize gender = _gender;
@synthesize facebookUID = _facebookUID;
@synthesize provider = _provider;
@synthesize recipesCount = _recipesCount;
@synthesize dishesCount = _dishesCount;
@synthesize followersCount = _followersCount;

#pragma mark - NSObject

- (NSString *)description {
  return [NSString stringWithFormat:@"ICUser %@", self.username];
}

- (NSUInteger)hash {
  return _username ? [_username hash] : [super hash];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self->_facebookUID = [aDecoder decodeIntegerForKey:@"facebookUID"];
    self->_username = [aDecoder decodeObjectForKey:@"username"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeInteger:self->_facebookUID forKey:@"facebookUID"];
  [aCoder encodeObject:self->_username forKey:@"username"];
}

@end
