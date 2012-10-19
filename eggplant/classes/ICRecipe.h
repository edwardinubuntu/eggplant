//
//  ICRecipe.h
//  iCook
//
//  Created by Chih-Wei Lee on 6/17/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICUser.h"
#import "ICPhoto.h"

@interface ICRecipe : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *recipeDescription; // avoid conflict to NSObject's description
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, assign) NSUInteger likesCount;
@property (nonatomic, assign) NSUInteger commentsCount;
@property (nonatomic, assign) NSUInteger dishesCount;
@property (nonatomic, assign) NSUInteger viewsCount;
@property (nonatomic, assign) NSUInteger favoritesCount;
@property (nonatomic, assign) long long facebookObjectID;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSArray *ingredients;
@property (nonatomic, strong) NSArray *steps;
@property (nonatomic, strong) ICUser *user;
@property (nonatomic, assign) float ranking;
@property (nonatomic, assign) BOOL hasDoneByCurrentUser;
@property (nonatomic, strong) ICPhoto *photos;

// User login part
@property (nonatomic, assign) BOOL isDoneByUser;
@property (nonatomic, assign) BOOL isFavoritedByUser;

// Reminde for shopping
@property (nonatomic, strong) NSDate *dateRemindToShopping;
@property (nonatomic, strong) UILocalNotification *remindNotfication;

@end
