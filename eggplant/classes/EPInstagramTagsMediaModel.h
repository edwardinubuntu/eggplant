//
//  EPInstagramTagsMediaModel.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/19.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPModel.h"
#import "EPInstagram.h"

@interface EPInstagramTagsMediaModel : EPModel

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSMutableArray *instagrams;

@end
