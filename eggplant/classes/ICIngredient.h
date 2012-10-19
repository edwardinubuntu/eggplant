//
//  ICIngredient.h
//  iCook
//
//  Created by Chih-Wei Lee on 6/19/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICIngredient : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger recipeID;
@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, assign) BOOL hasPurchased;

@end
