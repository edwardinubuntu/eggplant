//
//  EPTerm.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/31.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPTerm : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSMutableArray *sources;

@end
