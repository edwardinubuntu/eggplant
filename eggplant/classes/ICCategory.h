//
//  ICCategory.h
//  iCook
//
//  Created by Edward Chiang on 12/7/16.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICCategory : NSManagedObject

@property (nonatomic, strong) NSNumber *categoryRecipesCount;
@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSString *name;

@end
