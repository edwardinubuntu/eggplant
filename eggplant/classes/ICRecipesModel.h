//
//  ICRecipesModel.h
//  iCook
//
//  Created by Edward Chiang on 12/6/19.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "ICModel.h"

@interface ICRecipesModel : ICModel

@property (nonatomic, strong) NSMutableArray *recipes;

- (void)loadRequestPath:(NSMutableString *)path requestDidFinishLoad:(requestDidFinishLoadBolck)requestDidFinishLoad requestLoadWithError:(requestLoadWithErrorBlock)requestLoadWithError;

@end
