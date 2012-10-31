//
//  EPSource.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/31.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPSource.h"

@implementation EPSource

- (NSString *)sourceURLText {
  NSString *sourceURL = [self.sourceURL.absoluteURL.absoluteString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
  sourceURL = [sourceURL stringByReplacingOccurrencesOfString:@"https://" withString:@""];
  return sourceURL;
}

- (BOOL)isEqual:(id)object {
  if ([object isKindOfClass:[EPSource class]]) {
    EPSource *otherSource = (EPSource *)object;
    return [self.title isEqual: otherSource.title] && self.type == otherSource.type && [self.URL isEqual:otherSource.URL];
  }
  return NO;
}

- (NSString *)description {
  NSMutableString *description = [[NSMutableString alloc] init];
  [description appendFormat:@"title: %@, ", self.title];
  [description appendFormat:@"detail: %@, ", self.detail];
  [description appendFormat:@"type: %i, ", self.type];
  [description appendFormat:@"imageURL: %@, ", self.imageURL.absoluteString];
  [description appendFormat:@"URL: %@, ", self.URL.absoluteString];
  [description appendFormat:@"sourceURL: %@, ", self.sourceURL.absoluteString];
  [description appendFormat:@"randomNum: %i, ", self.randomNum.integerValue];
  return description;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self->_type = [aDecoder decodeIntForKey:@"type"];
    self->_imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
    self->_URL = [aDecoder decodeObjectForKey:@"URL"];
    self->_sourceURL = [aDecoder decodeObjectForKey:@"sourceURL"];
    self->_title = [aDecoder decodeObjectForKey:@"title"];
    self->_detail = [aDecoder decodeObjectForKey:@"detail"];
    self->_randomNum = [NSNumber numberWithInteger:[aDecoder decodeIntegerForKey:@"randomNum"]];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeInt:self->_type forKey:@"type"];
  [aCoder encodeObject:self->_imageURL forKey:@"imageURL"];
  [aCoder encodeObject:self->_URL forKey:@"URL"];
  [aCoder encodeObject:self->_sourceURL forKey:@"sourceURL"];
  [aCoder encodeObject:self->_title forKey:@"title"];
  [aCoder encodeObject:self->_detail forKey:@"detail"];
  [aCoder encodeInteger:self->_randomNum.integerValue forKey:@"randomNum"];
}

@end
