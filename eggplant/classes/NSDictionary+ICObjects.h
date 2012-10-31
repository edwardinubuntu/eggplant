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

@interface NSDictionary (ICObjects)

- (ICRecipe *)extractRecipe;
- (ICUser *)extractUser;

@end
