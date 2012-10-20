//
//  EPAtlas.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPAtlas.h"

@implementation EPAtlas

NSString* EPRetina4Name(NSString *imageName) {
  NSMutableString *retina4Name = [[NSMutableString alloc] initWithString:imageName];
  if (EPISRetina4()) {
    [retina4Name appendString:@"-568h"];
    return retina4Name;
  }
  return retina4Name;
}

BOOL EPISRetina4() {
  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
  return ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f);
}


@end
