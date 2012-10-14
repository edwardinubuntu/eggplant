//
//  EPYKnowledgeSearchModel.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPModel.h"
#import "EPYKnowledge.h"

@interface EPYKnowledgeSearchModel : EPModel

@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSMutableArray *knowledges;

@end
