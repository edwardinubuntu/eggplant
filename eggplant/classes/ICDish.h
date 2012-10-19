//
//  ICDish.h
//  iCook
//
//  Created by Chih-Wei Lee on 6/17/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICUser.h"
#import "ICPhoto.h"

@interface ICDish : NSObject

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *dishDescription; // To avoid name conflict
@property (nonatomic, assign) NSUInteger likesCount;
@property (nonatomic, assign) NSUInteger commentsCount;
@property (nonatomic, assign) NSUInteger viewsCount;
@property (nonatomic, strong) ICUser *user;
@property (nonatomic, strong) ICPhoto *photo;

@end
