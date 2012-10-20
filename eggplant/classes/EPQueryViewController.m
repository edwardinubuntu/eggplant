//
//  EPQueryViewController.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPQueryViewController.h"
#import "UIControl+BlocksKit.h"

@interface EPQueryViewController ()

@end

@implementation EPQueryViewController

#define kTableViewFrameSizeHeight 280.f
#define kTableViewFrameSizeWidth 280.f

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      _needTranslate = YES;
      _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
      _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
      _canEatResult = NO;
    }
    return self;
}

- (id)initWithKeyword:(NSString *)keyword{
  if (self = [self initWithNibName:nil bundle:nil]) {
    self.keyword = keyword;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  __block EPQueryViewController *tempSelf = self;
  
  _resultLabel = [[UILabel alloc] init];
  [self.view addSubview:self.resultLabel];
  
  self.view.frame = CGRectMake(0, 0, kTableViewFrameSizeWidth, kTableViewFrameSizeHeight);
  self.view.backgroundColor = [UIColor whiteColor];
  
  _wikiQueryLangLinksModel = [[EPWikiQueryLangLinksModel alloc] init];
  _yknowlegedSearchModel = [[EPYKnowledgeSearchModel alloc] init];
  
  [self.doneButton setTitle:NSLocalizedString(@"Done", @"Done") forState:UIControlStateNormal];
//  [self.doneButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 6, 7, 6)] forState:UIControlStateNormal];
//  [self.doneButton setBackgroundImage:[[UIImage imageNamed:@"buttonPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 6, 7, 6)] forState:UIControlStateHighlighted];
  self.doneButton.backgroundColor = [UIColor grayColor];
  [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  [self.doneButton.titleLabel setShadowColor: [UIColor blackColor]];
  [self.doneButton.titleLabel setShadowOffset:CGSizeMake(0, -1.0)];
  self.doneButton.frame = CGRectMake((self.view.frame.size.width / 2 - 100 ) / 2 + self.view.frame.size.width / 2, self.view.frame.size.height - 60, 100, 30);
  [self.doneButton addEventHandler:^(id sender) {
    if (tempSelf.delegate && [tempSelf.delegate respondsToSelector:@selector(queryViewController:didFinishWithQuery:canEat:)]) {
      [tempSelf.delegate queryViewController:tempSelf didFinishWithQuery:tempSelf.keyword canEat:tempSelf.canEatResult];
    }
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.doneButton];
  
  [self.cancelButton setTitle:NSLocalizedString(@"Cancel", @"Cancel") forState:UIControlStateNormal];
//  [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 6, 7, 6)] forState:UIControlStateNormal];
//  [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"buttonPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 6, 7, 6)] forState:UIControlStateHighlighted];
  self.cancelButton.backgroundColor = [UIColor grayColor];
  [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  [self.cancelButton.titleLabel setShadowColor: [UIColor blackColor]];
  [self.cancelButton.titleLabel setShadowOffset:CGSizeMake(0, -1.0)];
  self.cancelButton.frame = CGRectMake((self.view.frame.size.width / 2 - 100 ) / 2, self.view.frame.size.height - 60, 100, 30);
  [self.cancelButton addEventHandler:^(id sender) {
    if (tempSelf.delegate && [tempSelf.delegate respondsToSelector:@selector(queryViewController:didCancelhWithQuery:)]) {
      [tempSelf.delegate queryViewController:tempSelf didCancelhWithQuery:tempSelf.keyword];
    }
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.cancelButton];
  

  

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public

- (void)performSearch {
  
  if (NIIsStringWithAnyText(self.keyword)) {
    self.loadingView.frame = CGRectMake(0, 0, 20, 20);
    self.loadingView.center = CGPointMake(kTableViewFrameSizeWidth / 2, kTableViewFrameSizeHeight / 2);
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    [self.view bringSubviewToFront:self.loadingView];
    
    self.doneButton.hidden = YES;
    self.cancelButton.hidden = YES;
  }
  
  self.resultLabel.frame = CGRectZero;
  
  if (self.needTranslate) {
    [self translateTermToZh];
  } else {
    // Determine can eat
    [self queryTermForKnowledge:self.keyword];
  }
}

#pragma mark - private

- (void)translateTermToZh {
  // Translate
  __block EPQueryViewController *tempSelf = self;
  
  self.wikiQueryLangLinksModel.keyword = self.keyword;
  [self.wikiQueryLangLinksModel loadMore:NO didFinishLoad:^{
    BOOL hasZHLang = NO;
    for (EPWikiLangLink *eachLangLink in tempSelf.wikiQueryLangLinksModel.term.langLinks) {
      if ([eachLangLink.lang isEqualToString:@"zh"] || [eachLangLink.lang isEqualToString:@"zh-yue"]) {
        hasZHLang = NIIsStringWithAnyText(eachLangLink.text);
        NIDPRINT(@"We got %@ in %@ : %@", tempSelf.wikiQueryLangLinksModel.keyword, eachLangLink.lang, eachLangLink.text);
        break;
      }
    }
  } loadWithError:^(NSError *error) {
    NIDPRINT(@"testSearch got Error %@", error.localizedDescription);
  }];
}

- (void)queryTermForKnowledge:(NSString *)keyword {
  
  __block EPQueryViewController *tempSelf = self;
  self.yknowlegedSearchModel.keywords = keyword;
  [self.yknowlegedSearchModel loadMore:NO didFinishLoad:^{

    BOOL checkCategoryPass = NO;
    for (EPYKnowledge *eachKnowledge in tempSelf.yknowlegedSearchModel.knowledges) {
      NIDPRINT(@"eachKnowledge %@", eachKnowledge);
      
      NSRange textRangeCook = [eachKnowledge.category rangeOfString:kCategoryCook];
      NSRange textRangeIngredient= [eachKnowledge.category rangeOfString:kCategoryIngredient];
      NSRange textRangePlant = [eachKnowledge.category rangeOfString:kCategoryPlant];
      
      NSRange unionRange = NSUnionRange(textRangeCook, NSUnionRange(textRangeIngredient, textRangePlant));
      if(unionRange.location != NSNotFound) {
        checkCategoryPass = YES;
        break;
      }
    }
    
    // Present Result
    [tempSelf showQueryResultCanEat:checkCategoryPass];
    
  } loadWithError:^(NSError *error) {
    NIDPRINT(@"testSearchEnglish got Error %@", error.localizedDescription);
  }];
}

- (void)showQueryResultCanEat:(BOOL)canEat {
  self.canEatResult = canEat;
  [self.loadingView stopAnimating];
  self.loadingView.hidden = YES;

  NSString *canEatText = [NSString stringWithFormat:NSLocalizedString(@"Keyword Can  Eat", @"Can Eat"), self.keyword];
  NSString *canNotEatText = [NSString stringWithFormat:NSLocalizedString(@"Keyword Can Not Eat", @"Can Not Eat"), self.keyword];
  
  self.resultLabel.text = self.canEatResult ?  canEatText : canNotEatText;
  self.resultLabel.font = [UIFont systemFontOfSize:14.f];
  self.resultLabel.frame = CGRectMake((kTableViewFrameSizeHeight - 200) / 2, (kTableViewFrameSizeHeight - 44) / 2, 200, 44);
  self.resultLabel.textAlignment = UITextAlignmentCenter;
  
  
  self.doneButton.hidden = NO;
  self.cancelButton.hidden = NO;
}

@end
