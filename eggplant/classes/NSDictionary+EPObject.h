//
//  NSDictionary+EPObject.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPYKnowledge.h"

@interface NSDictionary (EPObject)

- (EPYKnowledge *)extractYKnowledge;

@end
