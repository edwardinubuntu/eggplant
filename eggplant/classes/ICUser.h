//
//  ICUser.h
//  iCook
//
//  Created by Chih-Wei Lee on 6/17/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICUser : NSObject <NSCoding>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSURL *blogURL;
@property (nonatomic, strong) NSString *userDescription;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) NSUInteger facebookUID;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, assign) NSInteger recipesCount;
@property (nonatomic, assign) NSInteger dishesCount;
@property (nonatomic, assign) NSInteger followersCount;

@end
