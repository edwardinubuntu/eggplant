//
//  EPWikiTerm.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/17.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPWikiLangLink.h"

@interface EPWikiTerm : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *langLinks;

@end
