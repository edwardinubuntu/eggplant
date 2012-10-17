//
//  EPWikiQueryLangLinksModel.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/17.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPWikiSearchContentModel.h"
#import "EPWikiTerm.h"
#import "EPWikiLangLink.h"

@interface EPWikiQueryLangLinksModel : EPWikiSearchContentModel

@property (nonatomic, strong) EPWikiTerm *term;

@end
