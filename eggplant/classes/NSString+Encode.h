//
//  NSString+Encode.h
//  iCook
//
//  Created by Edward Chiang on 12/7/4.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encode)

- (NSString *)encodeString:(NSStringEncoding)encoding;
- (NSString*)decodedString:(NSStringEncoding)encoding;

@end
