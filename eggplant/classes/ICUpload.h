//
//  ICUpload.h
//  iCook
//
//  Created by Edward Chiang on 12/7/25.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICUpload : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSUInteger recipedID;
@property (nonatomic, strong) NSString *dishName;
@property (nonatomic, strong) NSString *dishDescription;

@end
