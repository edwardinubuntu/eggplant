//
//  EPYKnowledge.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPYKnowledge.h"

@implementation EPYKnowledge

- (NSString *)description {
  NSMutableString *description = [NSMutableString string];
  [description appendFormat:@"category: %@,", self.category];
  [description appendFormat:@"content: %@,", self.content];
  [description appendFormat:@"status: %@,", self.status];
  [description appendFormat:@"subject: %@,", self.subject];
  [description appendFormat:@"URL: %@", self.url.absoluteString];
  return description;
}

@end
