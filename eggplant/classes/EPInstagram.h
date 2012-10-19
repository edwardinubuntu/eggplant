//
//  EPInstagram.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/19.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPImage.h"

@interface EPInstagram : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *images;
@property (nonatomic, strong) NSURL *link;

@end
