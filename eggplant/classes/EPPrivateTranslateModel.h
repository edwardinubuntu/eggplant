//
//  EPPrivateTranslateModel.h
//  eggplant
//
//  Created by Anderson Lin on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPModel.h"
#import <Foundation/Foundation.h>

@interface EPPrivateTranslateModel : EPModel

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *keywordTranslation;

@property (nonatomic, strong) NSString *sourceLang;
@property (nonatomic, strong) NSString *targetLang;

@end
