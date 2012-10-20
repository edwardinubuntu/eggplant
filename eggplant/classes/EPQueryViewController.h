//
//  EPQueryViewController.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPViewController.h"
#import "EPWikiQueryLangLinksModel.h"
#import "EPYKnowledgeSearchModel.h"

@protocol EPQueryViewControllerDelegate;

@interface EPQueryViewController : EPViewController

- (id)initWithKeyword:(NSString *)keyword;

- (void)performSearch;

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, assign) BOOL needTranslate;

@property (nonatomic, strong) EPWikiQueryLangLinksModel *wikiQueryLangLinksModel;
@property (nonatomic, strong) EPYKnowledgeSearchModel *yknowlegedSearchModel;

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, assign) BOOL canEatResult;

@property (nonatomic, strong) UILabel *resultLabel;

@end

@protocol EPQueryViewControllerDelegate <NSObject>

- (void)queryViewController:(EPQueryViewController *)queryViewController didCancelhWithQuery:(NSString *)searchKeyword;
- (void)queryViewController:(EPQueryViewController *)queryViewController didFinishWithQuery:(NSString *)searchKeyword canEat:(BOOL)canEat;

@end
