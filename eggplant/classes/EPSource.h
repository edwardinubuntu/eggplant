//
//  EPSource.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/31.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  EPSourceTypeiCook,
  EPSourceTypeYKnowledge,
  EPSourceTypeWiki,
  EPSourceTypeInstagram
} EPSourceType;

@interface EPSource : NSObject <NSCoding>

@property (nonatomic, assign) EPSourceType type;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURL *sourceURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSNumber *randomNum;

- (NSString *)sourceURLText;

@end
