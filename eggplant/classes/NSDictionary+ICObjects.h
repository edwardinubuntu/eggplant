//
//  NSDictionary+ICObjects.h
//  iCook
//
//  Created by Edward Chiang on 12/6/20.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICUser.h"
#import "ICRecipe.h"
#import "ICIngredient.h"
#import "ICStep.h"
#import "ICList.h"
#import "ICDish.h"
#import "ICCategory.h"
#import "ICRecipesList.h"
#import "ICRecipesListObject.h"

@interface NSDictionary (ICObjects)

- (ICRecipe *)extractRecipe;
- (ICUser *)extractUser;
- (ICStep *)extractStep;
- (ICIngredient *)extractIngredient;
- (ICList *)extractList;
- (ICDish *)extractDish;
- (ICCategory *)extractCategory;
- (ICRecipesListObject *)extractRecipesList;

@end
