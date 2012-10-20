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
      _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
      _canEatResult = NO;
      _keywords = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithKeywords:(NSArray *)keywords {
  if (self = [self initWithNibName:nil bundle:nil]) {
    self.keywords = [[NSMutableArray alloc] initWithArray:keywords];
  }
  return self;
}

- (id)initWithKeyword:(NSString *)keyword{
  if (self = [self initWithNibName:nil bundle:nil]) {
    [self.keywords removeAllObjects];
    [self.keywords addObject:keyword];
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
  
  _privateTranslationModel = [[EPPrivateTranslateModel alloc] init];
  _yknowlegedSearchModel = [[EPYKnowledgeSearchModel alloc] init];
  
  [self.retryButton setTitle:NSLocalizedString(@"Retry", @"Retry") forState:UIControlStateNormal];
  self.retryButton.backgroundColor = [UIColor grayColor];
  [self.retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.retryButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  [self.retryButton.titleLabel setShadowColor: [UIColor blackColor]];
  [self.retryButton.titleLabel setShadowOffset:CGSizeMake(0, -1.0)];
  self.retryButton.hidden = YES;
  self.retryButton.frame = CGRectMake((self.view.frame.size.width - 100 ) / 2, self.view.frame.size.height - 60, 100, 30);
  [self.retryButton addEventHandler:^(id sender) {
    if (tempSelf.queryType == EPQueryTypeInput) {
      if (tempSelf.delegate && [tempSelf.delegate respondsToSelector:@selector(queryViewController:retryWithSearching:)]) {
        [tempSelf.delegate queryViewController:tempSelf retryWithSearching:nil];
      }
    }
    
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.retryButton];
  
  [self.doneButton setTitle:NSLocalizedString(@"Done", @"Done") forState:UIControlStateNormal];
  self.doneButton.backgroundColor = [UIColor grayColor];
  [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  [self.doneButton.titleLabel setShadowColor: [UIColor blackColor]];
  [self.doneButton.titleLabel setShadowOffset:CGSizeMake(0, -1.0)];
  self.doneButton.frame = CGRectMake((self.view.frame.size.width / 2 - 100 ) / 2 + self.view.frame.size.width / 2, self.view.frame.size.height - 60, 100, 30);
  [self.doneButton addEventHandler:^(id sender) {
    if (tempSelf.delegate && [tempSelf.delegate respondsToSelector:@selector(queryViewController:didFinishWithQuery:canEat:)]) {
      [tempSelf.delegate queryViewController:tempSelf didFinishWithQuery:tempSelf.canEatKeyword canEat:tempSelf.canEatResult];
    }
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.doneButton];
  
  [self.cancelButton setTitle:NSLocalizedString(@"Cancel", @"Cancel") forState:UIControlStateNormal];
  self.cancelButton.backgroundColor = [UIColor grayColor];
  [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  [self.cancelButton.titleLabel setShadowColor: [UIColor blackColor]];
  [self.cancelButton.titleLabel setShadowOffset:CGSizeMake(0, -1.0)];
  self.cancelButton.frame = CGRectMake((self.view.frame.size.width / 2 - 100 ) / 2, self.view.frame.size.height - 60, 100, 30);
  [self.cancelButton addEventHandler:^(id sender) {
    if (tempSelf.delegate && [tempSelf.delegate respondsToSelector:@selector(queryViewController:didCancelhWithQuery:)]) {
      [tempSelf.delegate queryViewController:tempSelf didCancelhWithQuery:tempSelf.canEatKeyword];
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

- (BOOL)performSearch {
  
  BOOL didPerFormSearch = NO;
  if (self.keywords.count > 0) {
    
    didPerFormSearch = YES;
    
    if (!self.loadingView) {
      self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    self.loadingView.frame = CGRectMake(0, 0, 20, 20);
    self.loadingView.center = CGPointMake(kTableViewFrameSizeWidth / 2, kTableViewFrameSizeHeight / 2);
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    [self.view bringSubviewToFront:self.loadingView];
    
    self.doneButton.hidden = YES;
    self.cancelButton.hidden = YES;
    
    self.resultLabel.frame = CGRectZero;
    
    if (self.needTranslate) {
      [self translateTermToZh:[self.keywords objectAtIndex:0]];
    } else {
      // Determine can eat
      [self queryTermForKnowledge:[self.keywords objectAtIndex:0]];
    }
  }
  return didPerFormSearch;
  
}

#pragma mark - private

- (void)translateTermToZh:(NSString *)keyword {
  // Translate
  __block EPQueryViewController *tempSelf = self;
  
  self.privateTranslationModel.keyword = keyword;
  __block BOOL hasZHLang = NO;
  [self.privateTranslationModel loadMore:NO didFinishLoad:^{
    
    hasZHLang = NIIsStringWithAnyText(tempSelf.privateTranslationModel.keywordTranslation);
    [tempSelf queryTermForKnowledge:tempSelf.privateTranslationModel.keywordTranslation];
   if (!hasZHLang) {
     if (tempSelf.keywords.count > 0) {
       [tempSelf.keywords removeObjectAtIndex:0];
     }
   }
  } loadWithError:^(NSError *error) {
    NIDPRINT(@"testSearch got Error %@", error.localizedDescription);
  }];
}

- (void)queryTermForKnowledge:(NSString *)keyword {
  
  __block EPQueryViewController *tempSelf = self;
  __block NSString *tempKeyowrd = keyword;
  self.yknowlegedSearchModel.keywords = keyword;
  
  if (self.keywords.count > 0) {
    [self.keywords removeObjectAtIndex:0];
  }
  
  [self.yknowlegedSearchModel loadMore:NO didFinishLoad:^{

    BOOL checkCategoryPass = NO;
    for (EPYKnowledge *eachKnowledge in tempSelf.yknowlegedSearchModel.knowledges) {
      NIDPRINT(@"eachKnowledge %@", eachKnowledge);
      
      NSRange textRangeCook = [eachKnowledge.category rangeOfString:kCategoryCook];
      NSRange textRangeIngredient= [eachKnowledge.category rangeOfString:kCategoryIngredient];
      
      NSRange unionRange = NSUnionRange(textRangeCook, textRangeIngredient);
      if(unionRange.location != NSNotFound) {
        checkCategoryPass = YES;
        break;
      }
    }
    
    // Present Result
    [tempSelf showQueryResultCanEat:checkCategoryPass withKeyword:tempKeyowrd];
    
  } loadWithError:^(NSError *error) {
    NIDPRINT(@"testSearchEnglish got Error %@", error.localizedDescription);
  }];
}

- (void)showQueryResultCanEat:(BOOL)canEat withKeyword:(NSString *)keyword {
  self.canEatResult = canEat;
  
  [self.view addSubview:self.loadingView];
  [self.loadingView stopAnimating];
  self.loadingView.hidden = YES;
  self.cancelButton.hidden = YES;
  self.doneButton.hidden = YES;
  self.retryButton.hidden = YES;

  NSString *canEatText = [NSString stringWithFormat:NSLocalizedString(@"Keyword Can  Eat", @"Can Eat"), keyword];
  NSString *canNotEatText = [NSString stringWithFormat:NSLocalizedString(@"Keyword Can Not Eat", @"Can Not Eat"), keyword];
  
  self.resultLabel.numberOfLines = 3;
  self.resultLabel.text = self.canEatResult ?  canEatText : canNotEatText;
  self.resultLabel.font = [UIFont systemFontOfSize:14.f];
  self.resultLabel.frame = CGRectMake((kTableViewFrameSizeHeight - 200) / 2, (kTableViewFrameSizeHeight - 64) / 2, 200, 64);
  self.resultLabel.textAlignment = UITextAlignmentCenter;
  
  if (canEat) {
    self.canEatKeyword = keyword;
    if (self.delegate && [self.delegate respondsToSelector:@selector(queryViewController:didFinishWithQuery:canEat:)]) {
      [self.delegate queryViewController:self didFinishWithQuery:keyword canEat:self.canEatResult];
    }
  } else {
    if (self.keywords.count == 0) {
      self.retryButton.hidden = NO;
    } else {
      [self performSearch];
    }
    
  }
}

@end
