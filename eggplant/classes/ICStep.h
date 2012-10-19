//
//  ICStep.h
//  iCook
//
//  Created by Chih-Wei Lee on 6/17/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICPhoto.h"

@interface ICStep : NSObject <NSCoding>

@property (nonatomic, assign) NSUInteger position;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, strong) ICPhoto *photos;

@end
