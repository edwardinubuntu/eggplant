//
//  EPYKnowledge.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPYKnowledge : NSObject

@property (nonatomic, strong) NSDate *askDate;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSURL *url;

@end
