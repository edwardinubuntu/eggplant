//
//  NSString+Encode.m
//  iCook
//
//  Created by Edward Chiang on 12/7/4.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (Encode)

- (NSString *)encodeString:(NSStringEncoding)encoding {
  return (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self,
                                                              NULL, (CFStringRef)@";/?:@&=$+{}<>,",
                                                              CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString*)decodedString:(NSStringEncoding)encoding {
  return (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                             (__bridge CFStringRef)self,
                                                                             CFSTR(""),
                                                                             encoding);
}

@end
