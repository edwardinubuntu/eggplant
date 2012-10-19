//
//  ICList.h
//  iCook
//
//  Created by Chih-Wei Lee on 6/17/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICList : NSObject

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger recipesCount;

@end
