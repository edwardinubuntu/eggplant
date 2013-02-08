//
//  ICIngredientTermModel.h
//  iCook
//
//  Created by Edward Chiang on 12/10/4.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "EPModel.h"
#import "ICIngredientTerm.h"
#import "EPRESTClient.h"

@interface ICIngredientTermModel : EPModel

- (id)initWithTerm:(NSString *)term;

@property (nonatomic, strong) NSString *term;
@property (nonatomic, strong) NSMutableArray  *ingredientTerms;

@end
