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

@end
