//
//  ICUpload.m
//  iCook
//
//  Created by Edward Chiang on 12/7/25.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "ICUpload.h"

@implementation ICUpload

@synthesize image = _image;

- (id)init {
  if (self = [super init]) {
    _image = [[UIImage alloc] init];
  }
  return self;
}

@end
