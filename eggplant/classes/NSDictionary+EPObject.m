//
//  NSDictionary+EPObject.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "NSDictionary+EPObject.h"

@implementation NSDictionary (EPObject)

- (EPYKnowledge *)extractYKnowledge {
  EPYKnowledge *knowledge = [[EPYKnowledge alloc] init];
  knowledge.category = [self objectForKey:@"Category"];
  knowledge.content = [self objectForKey:@"Content"];
  knowledge.subject = [self objectForKey:@"Subject"];
  knowledge.status = [self objectForKey:@"Status"];
  if ([self objectForKey:@"Url"]) {
    knowledge.url = [[NSURL alloc] initWithString:[self objectForKey:@"Url"]];
  }
  return knowledge;
}

@end
