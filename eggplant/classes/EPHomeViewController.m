//
//  EPHomeViewController.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/15.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPHomeViewController.h"
#import "UIControl+BlocksKit.h"
#import "EPTermsStorageManager.h"
#import "EPScrollPageView.h"
#import "UIImageView+AFNetworking.h"
#import "EPWikiCell.h"
#import "EPICookCell.h"
#import "EPWebViewController.h"
#import "EPSourceImageCell.h"
#import "DDProgressView.h"
#import "EPRESTClient.h"
#import "EPAttributedSourceCell.h"
#import "EPSearchKeywordViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "EPIQEnginesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "EPAcknowledgementsViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface EPHomeViewController ()

@end

@implementation EPHomeViewController

CGFloat adjustX = 0;
CGFloat spacing = 80;
CGFloat backViewHeight = 30;
CGFloat smallMoving = 25;

#define kSVProgressHUDAfterDelaySecs  1

#define kCountAbout 1
#define kCountHome  1

#define kIndexAbout 0
#define kIndexHome  1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    _recycledTableView = [[NSMutableDictionary alloc] init];
  }
  return self;
}

#pragma mark - UIViewController

- (void)loadView {
  [super loadView];
  lastContentOffset = 0;
  __block EPHomeViewController *tempSelf = self;
  
  _queryViewController = [[EPQueryViewController alloc] init];
  UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-purple"]];
  _termBrowseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  [_termBrowseTableView setBackgroundView:bgView];
  [self.view addSubview:_termBrowseTableView];
  
  _searchKeywordViewController = [[EPSearchKeywordViewController alloc] init];
  self.searchKeywordViewController.delegate = self;
  
  _headerCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.f)];
  self.headerCarousel.scrollSpeed = 1;
  self.headerCarousel.decelerationRate = 5;
  self.headerCarousel.delegate = self;
  self.headerCarousel.dataSource = self;
  self.headerCarousel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navy_blue_"]];
  [self.view addSubview:self.headerCarousel];
  
  CGFloat spacing = 7;
  _searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  _searchButton.layer.cornerRadius = 7.f;
  _searchButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
  _searchButton.layer.borderWidth = 3.f;
  
  [self.searchButton setImage:[UIImage imageNamed:@"06-magnify"] forState:UIControlStateNormal];
  [self.searchButton sizeToFit];
  self.searchButton.center = CGPointMake(spacing + self.searchButton.frame.size.width / 2, self.view.frame.size.height - self.searchButton.frame.size.height / 2 - spacing);
  self.searchButton.tintColor = [UIColor clearColor];
  [self.view addSubview:self.searchButton];
  
  _buttonSectionsView = [[UIView alloc] init];
  self.buttonSectionsView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.buttonSectionsView];
  
  _cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  _cameraButton.layer.cornerRadius = 7.f;
  _cameraButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
  _cameraButton.layer.borderWidth = 3.f;
  
  [self.cameraButton setImage:[UIImage imageNamed:@"86-camera"] forState:UIControlStateNormal];
  [self.cameraButton addEventHandler:^(id sender) {
    [tempSelf foldSearchButtonsWithCurrentButton:tempSelf.searchButton];
    EPIQEnginesViewController *iqEngineViewController = [[EPIQEnginesViewController alloc] initWithNibName:nil bundle:nil];
    iqEngineViewController.delegate = self;
    [tempSelf presentModalViewController:iqEngineViewController animated:YES];
    
  } forControlEvents:UIControlEventTouchUpInside];
  [self.buttonSectionsView addSubview:self.cameraButton];
  
  _writeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  _writeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
  _writeButton.layer.borderWidth = 3.f;
  _writeButton.layer.cornerRadius = 7.f;
  [self.writeButton setImage:[UIImage imageNamed:@"187-pencil"] forState:UIControlStateNormal];
  [self.writeButton addEventHandler:^(id sender) {
    
    [tempSelf.navigationController presentModalViewController:tempSelf.searchKeywordViewController animated:NO];
    
    [tempSelf foldSearchButtonsWithCurrentButton:tempSelf.searchButton];
  } forControlEvents:UIControlEventTouchUpInside];
  [self.buttonSectionsView addSubview:self.writeButton];
  
  _pagingScrollView = [[NIPagingScrollView alloc] initWithFrame:CGRectMake(0, self.headerCarousel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.headerCarousel.frame.size.height)];
  self.pagingScrollView.delegate = self;
  self.pagingScrollView.dataSource = self;
  [self.view addSubview:self.pagingScrollView];
  
  _tableView = [[UITableView alloc] init];
  
  [self loadData];
  
  //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTermsArray:) name:kNOTIFICATION_FOUND_TERMS object:nil];
  
  _yknowledgeSearchModel = [[EPYKnowledgeSearchModel alloc] init];
  _recipesSearchModel = [[ICRecipesSearchModel alloc] init];
  _privateTranslateModel = [[EPPrivateTranslateModel alloc] init];
  _instgramTagsMediaModel = [[EPInstagramTagsMediaModel alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self searchBarPressHandleAnimations];
  [self.view bringSubviewToFront:self.searchButton];
  [self.view bringSubviewToFront:self.buttonSectionsView];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  //[[NSNotificationCenter defaultCenter] removeObserver:self name:kNOTIFICATION_FOUND_TERMS object:nil];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)saveContentData {
  [[EPTermsStorageManager defaultManager] load];
  [[EPTermsStorageManager defaultManager] setInformationFromUserSaved:self.information];
  [[EPTermsStorageManager defaultManager] save];
}

- (void)performTranslateInstagramTerm:(NSString *)searchingTerm {
  __block EPHomeViewController *tempSelf = self;
  
  // Chinse term to English Term show wiki
  self.privateTranslateModel.keyword = searchingTerm;
  self.privateTranslateModel.sourceLang = @"zh-TW";
  self.privateTranslateModel.targetLang = @"en";
  [self.privateTranslateModel loadMore:NO didFinishLoad:^{
    [tempSelf performInstagramAPISearhTerm:tempSelf.privateTranslateModel.targetLang];
  } loadWithError:^(NSError *error) {
    // Handle Error
  }];
}

- (void)performWikiSearchTerm:(NSString *)searchingTerm {
  
  __block EPHomeViewController *tempSelf = self;
  
  // Chinse term to English Term show wiki
  self.privateTranslateModel.keyword = searchingTerm;
  self.privateTranslateModel.sourceLang = @"zh-TW";
  self.privateTranslateModel.targetLang = @"en";
  
  [self.privateTranslateModel loadMore:NO didFinishLoad:^{

    EPSource *source = [[EPSource alloc] init];
    source.type = EPSourceTypeWiki;
    source.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", tempSelf.privateTranslateModel.keywordTranslation]];
    source.title = tempSelf.privateTranslateModel.keywordTranslation;
    source.sourceURL = [NSURL URLWithString:@"http://wikipedia.org"];
    float randomNum = arc4random() % 100;
    source.randomNum = [NSNumber numberWithFloat:randomNum];
    
    EPTerm *currentTerm = [tempSelf retrieveTermFromName:searchingTerm];
    [currentTerm.sources addObject:source];
    
    [tempSelf.tableView reloadData];
  } loadWithError:^(NSError *error) {
    // Handle Error
  }];
}

- (void)performiCookSearchTerm:(NSString *)searchingTerm {
  // YKNowledge
  __block EPHomeViewController *tempSelf = self;
  self.recipesSearchModel.text = searchingTerm;
  
  [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLocalizedString(@"Prepare iCook", @"Prepare iCook"), searchingTerm]];
  [self.recipesSearchModel loadMore:NO didFinishLoad:^{
    [SVProgressHUD dismissWithSuccess:[NSString stringWithFormat:NSLocalizedString(@"Prepare iCook finished", @"Prepare iCook finished"), searchingTerm] afterDelay:kSVProgressHUDAfterDelaySecs];
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    for (ICRecipe *eachRecipe in tempSelf.recipesSearchModel.recipes) {
      EPSource *source = [[EPSource alloc] init];
      source.type = EPSourceTypeiCook;
      source.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://icook.tw/recipes/%i", eachRecipe.objectID]];
      source.title = eachRecipe.name;
      source.detail = eachRecipe.recipeDescription;
      source.sourceURL = [NSURL URLWithString:@"http://icook.tw"];
      source.imageURL = eachRecipe.photos.smallURL;
      float randomNum = arc4random() % 100;
      source.randomNum = [NSNumber numberWithFloat:randomNum];
      
      [sources addObject:source];
    }
    EPTerm *currentTerm = [tempSelf retrieveTermFromName:searchingTerm];
    [currentTerm.sources addObjectsFromArray:sources];
    [tempSelf sortWithRandomNum:currentTerm];
    [tempSelf saveContentData];
    
    [tempSelf.tableView reloadData];
  } loadWithError:^(NSError *error) {
    // Handle Error
    [SVProgressHUD dismissWithError:[NSString stringWithFormat:NSLocalizedString(@"Prepare iCook failure", @"Prepare iCook failure"), searchingTerm] afterDelay:kSVProgressHUDAfterDelaySecs];
  }];
}

- (void)performInstagramAPISearhTerm:(NSString *)searchingTerm {
  // YKNowledge
  __block EPHomeViewController *tempSelf = self;
  self.instgramTagsMediaModel.keyword = searchingTerm;
  [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLocalizedString(@"Prepare Instagream", @"Prepare Instagream"), searchingTerm]];
  [self.instgramTagsMediaModel loadMore:NO didFinishLoad:^{
        NSMutableArray *sources = [[NSMutableArray alloc] init];
    for (EPInstagram *eachInstagram in tempSelf.instgramTagsMediaModel.instagrams) {
      EPSource *source = [[EPSource alloc] init];
      source.type = EPSourceTypeInstagram;
      source.URL = eachInstagram.link;
      source.sourceURL = [NSURL URLWithString:@"http://instagr.am"];
      float randomNum = arc4random() % 100;
      source.randomNum = [NSNumber numberWithFloat:randomNum];

      for (NSString *key in eachInstagram.images.keyEnumerator.allObjects) {
        EPImage *eachImage = [eachInstagram.images objectForKey:key];
        if (eachImage.imageType == EPImageTypeThumbnail) {
          source.imageURL = eachImage.url;
        }
      }
      
      [sources addObject:source];
    }
    
    [SVProgressHUD dismissWithSuccess:[NSString stringWithFormat:NSLocalizedString(@"Prepare Instagream finished", @"Prepare Instagream finished"), searchingTerm, sources.count] afterDelay:kSVProgressHUDAfterDelaySecs];

    
    EPTerm *currentTerm = [tempSelf retrieveTermFromName:searchingTerm];
    [currentTerm.sources addObjectsFromArray:sources];
    [tempSelf sortWithRandomNum:currentTerm];
    [tempSelf saveContentData];
    
    [tempSelf.tableView reloadData];
  } loadWithError:^(NSError *error) {
    // Handle Error
    [SVProgressHUD dismissWithError:[NSString stringWithFormat:NSLocalizedString(@"Prepare Instagream failure", @"Prepare Instagream failure"), searchingTerm] afterDelay:kSVProgressHUDAfterDelaySecs];
  }];
}

- (void)performYKAPISearhTerm:(NSString *)searchingTerm {
  // YKNowledge
  __block EPHomeViewController *tempSelf = self;
  self.yknowledgeSearchModel.keywords = searchingTerm;
  
  [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLocalizedString(@"Prepare knowledge", @"Prepare knowledge"), searchingTerm]];
  [self.yknowledgeSearchModel loadMore:NO didFinishLoad:^{
    [SVProgressHUD dismissWithSuccess:[NSString stringWithFormat:NSLocalizedString(@"Prepare knowledge finished", @"Prepare knowledge finished"), searchingTerm] afterDelay:kSVProgressHUDAfterDelaySecs];
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    for (EPYKnowledge *eachKnow in tempSelf.yknowledgeSearchModel.knowledges) {
      EPSource *source = [[EPSource alloc] init];
      source.type = EPSourceTypeYKnowledge;
      source.URL = eachKnow.url;
      source.title = eachKnow.subject;
      source.detail = eachKnow.content;
      source.sourceURL = [NSURL URLWithString:@"http://knowledge.yahoo.com.tw"];

      float randomNum = arc4random() % 100;
      source.randomNum = [NSNumber numberWithFloat:randomNum];
      
      [sources addObject:source];
    }
    
    EPTerm *currentTerm = [tempSelf retrieveTermFromName:searchingTerm];
    [currentTerm.sources addObjectsFromArray:sources];
    [tempSelf sortWithRandomNum:currentTerm];
    [tempSelf saveContentData];

    [tempSelf.tableView reloadData];
  } loadWithError:^(NSError *error) {
    // Handle Error
    [SVProgressHUD dismissWithError:[NSString stringWithFormat:NSLocalizedString(@"Prepare knowledge failure", @"Prepare knowledge failure"), searchingTerm] afterDelay:kSVProgressHUDAfterDelaySecs];
  }];
}

- (NSMutableArray *)sortByRandomNum:(EPTerm *)term {
  // Sort
  NSArray *newSortedArray =  [term.sources sortedArrayUsingComparator: ^(id obj1, id obj2) {
    
    NSNumber *p1 = ((EPSource *)obj1).randomNum;
    NSNumber *p2 = ((EPSource *)obj2).randomNum;
    
    if (p1.floatValue > p2.floatValue ) {
      return (NSComparisonResult)NSOrderedDescending;
      
    }
    
    if (p1.floatValue < p2.floatValue) {
      return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
  }];
  return [NSMutableArray arrayWithArray:newSortedArray];
}

- (EPTerm *)retrieveTermFromName:(NSString *)name {
  EPTerm *termData;
  for (EPTerm *eachTerms in self.information.terms) {
    if ([eachTerms.name isEqualToString:name]) {
      termData = eachTerms;
      break;
    }
  }
  return termData;
}

- (void)sortWithRandomNum:(EPTerm *)searchingTerm {
  for (EPTerm *eachTerms in self.information.terms) {
    if ([eachTerms.name isEqualToString:searchingTerm.name]) {
      eachTerms.sources = [self sortByRandomNum:searchingTerm];
      break;
    }
  }
}

- (void)checkPerpareQueryAPIData:(EPTerm *)searchingTerm {
  
  // Check if has term
  EPTerm *termData = [self retrieveTermFromName:searchingTerm.name];
  
  NSMutableArray *sources = termData.sources;
  
  // Start to add wiki
  //  BOOL hasWiki = NO;
  //  for (NSDictionary *eachSource in sources) {
  //    if ([[eachSource objectForKey:@"type"] isEqualToString:@"wiki"]) {
  //      hasWiki = YES;
  //    }
  //  }
  //  if (!hasWiki) {
  //    [self performWikiSearchTerm:searchingTerm withDataDict:termWithDataDict];
  //  }
  
  // Start with hasICook
  BOOL hasiCook = NO;
  BOOL hasYKnowledge = NO;
  BOOL hasInstagram = NO;
  for (EPSource *eachSource in sources) {
    switch (eachSource.type) {
      case EPSourceTypeiCook:
        hasiCook = YES;
        break;
      case EPSourceTypeInstagram:
        hasInstagram = YES;
        break;
      case EPSourceTypeWiki:
        break;
      case EPSourceTypeYKnowledge:
        hasYKnowledge = YES;
        break;
      default:
        break;
    }
  }
  if (!hasiCook) {
    [self performiCookSearchTerm:searchingTerm.name];
  }
  if (!hasYKnowledge) {
    [self performYKAPISearhTerm:searchingTerm.name];
  }
  if (!hasInstagram) {
    [self performInstagramAPISearhTerm:searchingTerm.name];
  }
}

- (void)requestImageFromCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath imageURL:(NSString *)imageURL {
  __block NSIndexPath *tempIndexPath = indexPath;
  __block EPHomeViewController *tempSelf = self;
  NIDPRINT(@"[currentSource objectForKey:imageURL] %@", imageURL);
  [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]] placeholderImage:[UIImage imageNamed:@"CellDefaultImage"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    UITableViewCell *currentLoadingCell = (UITableViewCell *)[tempSelf.tableView cellForRowAtIndexPath:tempIndexPath];
    currentLoadingCell.imageView.image = image;
    [currentLoadingCell setNeedsLayout];
    
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    // Handle error
    UITableViewCell *currentLoadingCell = (UITableViewCell *)[tempSelf.tableView cellForRowAtIndexPath:tempIndexPath];
    currentLoadingCell.imageView.image = nil;
    [currentLoadingCell setNeedsLayout];
  }];
}

- (void)requestImageRequestProgressFromCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath imageURL:(NSString *)imageURL {
  // Design progress view
  DDProgressView *progressView = [[DDProgressView alloc] init];
  progressView.frame = CGRectMake(0, 0, 250, 16);
  progressView.progress = 0.0;
  progressView.center = CGPointMake(160, 150);
  
  [cell.contentView addSubview:progressView];
  __block DDProgressView *tempProgressView = progressView;
  __block EPHomeViewController *tempSelf = self;
  __block NSIndexPath *tempIndexPath = indexPath;
  // Download Image and not to give a default image
  NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageURL]];
  AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:imageRequest];
  [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    if ([responseObject isKindOfClass:[UIImage class]]) {
      [tempProgressView removeFromSuperview];
      UIImage *downloadedImage  = (UIImage *)responseObject;
      UITableViewCell *currentLoadingCell = (UITableViewCell *)[tempSelf.tableView cellForRowAtIndexPath:tempIndexPath];
      currentLoadingCell.imageView.image = downloadedImage;
      [currentLoadingCell setNeedsLayout];
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    // Error handle
    tempProgressView.frame = CGRectZero;
    [tempProgressView removeFromSuperview];
    UITableViewCell *currentLoadingCell = (UITableViewCell *)[tempSelf.tableView cellForRowAtIndexPath:tempIndexPath];
    currentLoadingCell.imageView.image = [UIImage imageNamed:@"errorViewStateImage"];
    currentLoadingCell.imageView.contentMode = UIViewContentModeCenter;
    [currentLoadingCell setNeedsLayout];
  }];
  
  [requestOperation setDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
    float percentage = (float)totalBytesRead / (float)totalBytesExpectedToRead;
    tempProgressView.progress = percentage;
    
    if (tempProgressView.progress >= 1) {
      tempProgressView.frame = CGRectZero;
    }
  }];
  [[EPRESTClient sharedInstgramClient] enqueueHTTPRequestOperation:requestOperation];
}

- (UITableView *)dequeueReusableTableViewWithIdentifier:(NSString*)identifier {
  UITableView *cachedView = [self.recycledTableView objectForKey:identifier];
  if (!cachedView) {
    cachedView = [[UITableView alloc] init];
    [self.recycledTableView setObject:cachedView forKey:identifier];
  }
  return cachedView;
}

- (void)loadData {
  
  [[EPTermsStorageManager defaultManager] load];

  EPInformation *infoSaved = [[EPTermsStorageManager defaultManager] informationFromUserSaved];

  if (infoSaved.terms.count == 0) {
    
    infoSaved.terms = [[NSMutableArray alloc] init];
    
    NSDictionary *termDataFromDefault = [[EPTermsStorageManager defaultManager] termsFromDefault];
    NSArray *termsFromDefaultKeys = [termDataFromDefault objectForKey:@"termKeys"];
    NSArray *terms = [termDataFromDefault objectForKey:@"terms"];
    for (NSString *key in termsFromDefaultKeys) {
      EPTerm *newTerm = [[EPTerm alloc] init];
      newTerm.name = key;
      
      for (NSDictionary *eachTermsData in terms) {
        if ([[eachTermsData objectForKey:@"key"] isEqualToString:key]) {
          // Assign data
          newTerm.name = key;
          newTerm.key = [eachTermsData objectForKey:@"termInEN"];
          
          for (NSDictionary *eachSource in [eachTermsData objectForKey:@"sources"]) {
            EPSource *source = [[EPSource alloc] init];
            source.imageURL = [NSURL URLWithString:[eachSource objectForKey:@"imageURL"]];
            source.sourceURL = [NSURL URLWithString:[eachSource objectForKey:@"sourceURL"]];
            source.detail = [eachSource objectForKey:@"detail"];
            source.title = [eachSource objectForKey:@"title"];
            if ([[eachSource objectForKey:@"type"] isEqualToString:@"wiki"]) {
              source.type = EPSourceTypeWiki;
            } else if ([[eachSource objectForKey:@"type"] isEqualToString:@"icook"]) {
              source.type = EPSourceTypeiCook;
            } else if ([[eachSource objectForKey:@"type"] isEqualToString:@"YKnowledge"]) {
              source.type = EPSourceTypeYKnowledge;
            } else if ([[eachSource objectForKey:@"type"] isEqualToString:@"instagram"]) {
              source.type = EPSourceTypeInstagram;
            }
            
            [newTerm.sources addObject:source];
          }
          
          break;
        }
      }
      
      [infoSaved.terms addObject:newTerm];
    }
    [[EPTermsStorageManager defaultManager] setInformationFromUserSaved:infoSaved];
    [[EPTermsStorageManager defaultManager] save];
  }
  
  self.information = [[EPTermsStorageManager defaultManager] informationFromUserSaved];

  [self.headerCarousel reloadData];
  [self.pagingScrollView reloadData];

  if (self.information.terms.count > 0) {
    // Scroll to First Data
    [self.headerCarousel scrollToItemAtIndex:(kCountAbout + kCountHome + 0) animated:YES];
  }
  
}

- (void)foldSearchButtonsWithCurrentButton:(UIButton *)currentButton {
  [UIView animateWithDuration:0.3 animations:^{
    
    CGFloat currentButtonRight = spacing;
    currentButtonRight += smallMoving;
    // Righter
    self.cameraButton.center = CGPointMake(currentButtonRight, self.buttonSectionsView.frame.size.height / 2);
    self.writeButton.center = CGPointMake(currentButtonRight + spacing + self.cameraButton.frame.size.width / 2, self.buttonSectionsView.frame.size.height / 2);
    
    self.buttonSectionsView.frame = CGRectMake(currentButton.frame.origin.x + currentButton.frame.size.width + adjustX,  currentButton.frame.origin.y + (currentButton.frame.size.height - backViewHeight) / 2, 0, backViewHeight);
    
  } completion:^(BOOL finished) {
    
    [UIView animateWithDuration:0.3 animations:^{
      // Lefter
      CGFloat currentButtonRight = 0;
      self.cameraButton.center = CGPointMake(currentButtonRight, self.buttonSectionsView.frame.size.height / 2);
      self.writeButton.center = CGPointMake(currentButtonRight, self.buttonSectionsView.frame.size.height / 2);
      
      [self.searchButton setImage:[UIImage imageNamed:@"06-magnify"] forState:UIControlStateNormal];
      
    } completion:^(BOOL finished) {
      self.cameraButton.frame = CGRectZero;
      self.writeButton.frame = CGRectZero;
    }];
    
  }];
  currentButton.selected = NO;
}

- (void)explandSearchButtonsWithCurrentButton:(UIButton *)currentButton {
  self.buttonSectionsView.frame = CGRectMake(currentButton.frame.origin.x + currentButton.frame.size.width + adjustX, currentButton.frame.origin.y + (currentButton.frame.size.height - backViewHeight) / 2, 0, backViewHeight);
  
  [UIView animateWithDuration:0.3 animations:^{
    self.buttonSectionsView.frame = CGRectMake(currentButton.frame.origin.x + currentButton.frame.size.width + adjustX,  currentButton.frame.origin.y + (currentButton.frame.size.height - backViewHeight) / 2, self.view.frame.size.width, backViewHeight);
    [self.cameraButton sizeToFit];
    [self.writeButton sizeToFit];
    
    CGFloat currentButtonRight = spacing;
    currentButtonRight += smallMoving;
    // Righter
    self.cameraButton.center = CGPointMake(currentButtonRight, self.buttonSectionsView.frame.size.height / 2);
    self.writeButton.center = CGPointMake(currentButtonRight + spacing + self.cameraButton.frame.size.width / 2, self.buttonSectionsView.frame.size.height / 2);
    
    [self.searchButton setImage:[UIImage imageNamed:@"06-magnify-right"] forState:UIControlStateNormal];
    
  } completion:^(BOOL finished) {
    
    [UIView animateWithDuration:0.3 animations:^{
      // Lefter
      CGFloat currentButtonRight = spacing;
      self.cameraButton.center = CGPointMake(currentButtonRight, self.buttonSectionsView.frame.size.height / 2);
      self.writeButton.center = CGPointMake(currentButtonRight + spacing + self.cameraButton.frame.size.width / 2, self.buttonSectionsView.frame.size.height / 2);
      
    }];
  }];
  currentButton.selected = YES;
}

- (void)searchBarPressHandleAnimations {
  __block EPHomeViewController *tempSelf = self;
  [self.searchButton addEventHandler:^(id sender) {
    UIButton *currentButton = (UIButton *)sender;
    currentButton.selected = !currentButton.selected;
    // After switch
    if (currentButton.selected) {
      [tempSelf explandSearchButtonsWithCurrentButton:currentButton];
      
    } else {
      [tempSelf foldSearchButtonsWithCurrentButton:currentButton];
    }
  } forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark - iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
  if (carousel == self.headerCarousel) {
    NSInteger numberOfitems = kCountAbout + kCountHome + self.information.terms.count;
    NIDPRINT(@"iCarousel numberOfitems %i", numberOfitems);
    return numberOfitems;
  }
  return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
  if (carousel == self.headerCarousel) {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 34)];
    UILabel *sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 32)];
    sectionHeaderLabel.textAlignment = UITextAlignmentCenter;
    
    NIDPRINT(@"iCarousel viewForItemAtIndex %i", index);
    
    NSInteger termIndex = index - kCountAbout - kCountHome;
    
    NIDPRINT(@"iCarousel viewForItemAtIndex termIndex %i", termIndex);
    
    switch (index) {
      case kIndexAbout:
        sectionHeaderLabel.text = NSLocalizedString(@"About", @"About");
        break;
      case kIndexHome:
        sectionHeaderLabel.text = NSLocalizedString(@"Sections", @"Sections");
        break;
      default:
        break;
    }
    if (termIndex >= 0 &&  termIndex < self.information.terms.count) {
      EPTerm *term = [self.information.terms objectAtIndex:(termIndex)];
      sectionHeaderLabel.text = term.name;
    }
    
    sectionHeaderLabel.textColor = [UIColor whiteColor];
    sectionHeaderLabel.backgroundColor = [UIColor clearColor];
    sectionHeaderLabel.font = [UIFont boldSystemFontOfSize:20.f];
    sectionHeaderLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    sectionHeaderLabel.shadowOffset = CGSizeMake(0, -1);
    sectionHeaderLabel.center = sectionHeaderView.center;
    
    [sectionHeaderView setBackgroundColor:[UIColor clearColor]];
    [sectionHeaderView addSubview:sectionHeaderLabel];
    return sectionHeaderView;
  }
  return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - iCarouselDelegate

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel {
  self.searchButton.hidden = YES;
  self.buttonSectionsView.hidden = YES;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
  if (carousel == self.headerCarousel) {
    [self.pagingScrollView moveToPageAtIndex:carousel.currentItemIndex animated:YES];
    
    if (self.headerCarousel.currentItemIndex < kCountAbout + kCountHome) {
      self.searchButton.hidden = YES;
      self.buttonSectionsView.hidden = YES;
    } else {
      self.searchButton.hidden = NO;
      self.buttonSectionsView.hidden = NO;
    }
  }
}

#pragma mark - NIPagingScrollViewDataSource

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView {
  return kCountAbout + kCountHome + self.information.terms.count;
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex {
  
  EPScrollPageView *contentHeaderView = [[EPScrollPageView alloc] initWithFrame:CGRectMake(0, 0, pagingScrollView.frame.size.width,pagingScrollView.frame.size.height)];
  [contentHeaderView setBackgroundColor:[UIColor whiteColor]];
  
  NSInteger termIndex = pageIndex - kCountAbout - kCountHome;
  switch (pageIndex) {
    case kIndexAbout: {
      UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover"]];
      [imageView sizeToFit];
      imageView.center = contentHeaderView.center;
      [contentHeaderView addSubview:imageView];
      
      UILabel *coverLabel = [[UILabel alloc] init];
      coverLabel.text = @"WikiIngredients";
      coverLabel.frame = CGRectMake(0, 0, 300, 44);
      coverLabel.textColor = [UIColor whiteColor];
      coverLabel.textAlignment = UITextAlignmentCenter;
      coverLabel.font = [UIFont boldSystemFontOfSize:20.f];
      coverLabel.backgroundColor = [UIColor clearColor];
      coverLabel.center = contentHeaderView.center;
      [contentHeaderView addSubview:coverLabel];
      
      // Add Acknowledgements
      UIButton *knowledgementsInfoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
      knowledgementsInfoButton.center = CGPointMake(contentHeaderView.frame.size.width - 20, contentHeaderView.frame.size.height -20);
      
      __block EPHomeViewController *tempSelf = self;
      [knowledgementsInfoButton addEventHandler:^(id sender) {
        EPAcknowledgementsViewController *acknowView = [[EPAcknowledgementsViewController alloc] init];
        [tempSelf.navigationController pushViewController:acknowView animated:YES];
      } forControlEvents:UIControlEventTouchUpInside];
      
      [contentHeaderView addSubview:knowledgementsInfoButton];
      
      self.searchButton.hidden = YES;
      self.buttonSectionsView.hidden = YES;
    }
      break;
    case kIndexHome: {
      _termBrowseTableView.frame = contentHeaderView.frame;
      _termBrowseTableView.dataSource = self;
      _termBrowseTableView.delegate = self;
      [contentHeaderView addSubview:_termBrowseTableView];
      self.searchButton.hidden = YES;
      self.buttonSectionsView.hidden = YES;
    }
      break;
    default:
      if (termIndex < self.information.terms.count) {
        EPTerm *term = [self.information.terms objectAtIndex:(termIndex)];
        _tableView = [self dequeueReusableTableViewWithIdentifier:[NSString stringWithFormat:@"TableViewID%@", term.name]];
        _tableView = [[UITableView alloc] init];
        _tableView.tag = termIndex;
        _tableView.frame = contentHeaderView.frame;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [contentHeaderView addSubview:_tableView];
        
        // if empty need to loading
        [self checkPerpareQueryAPIData:[self.information.terms objectAtIndex:termIndex]];
        
        self.searchButton.hidden = NO;
        self.buttonSectionsView.hidden = NO;
      }
      break;
  }
  
  
  
  return contentHeaderView;
}

#pragma mark - NIPagingScrollViewDelegate

- (void)pagingScrollViewDidChangePages:(NIPagingScrollView *)pagingScrollView {
  if (pagingScrollView == self.pagingScrollView) {
    [self.headerCarousel scrollToItemAtIndex:self.pagingScrollView.centerPageIndex duration:0.5];
  }
  self.searchButton.hidden = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  // Home
  if (tableView == self.termBrowseTableView) {
    return self.information.terms.count;
  }
  
  NSInteger pageIndex = tableView.tag;
  EPTerm *term = [self.information.terms objectAtIndex:pageIndex];
  return term.sources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  __block EPHomeViewController *tempSelf = self;
  __block NSIndexPath *tempIndexPath = indexPath;
  
  // Home
  if (tableView == self.termBrowseTableView) {
    EPTerm *term = [self.information.terms objectAtIndex:indexPath.row];
    NSString *CellWithIdentifier = [NSString stringWithFormat:@"term%@", term.name];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = term.name;
    return cell;
  }
  
  NSInteger pageIndex = tableView.tag;
  if (pageIndex < self.information.terms.count) {
    
    EPTerm *key = [self.information.terms objectAtIndex:(pageIndex)];
    // Check data
    EPSource *source  =  [key.sources objectAtIndex:indexPath.row];
    
    NSMutableString *cellWithId = [NSMutableString stringWithFormat:@"cell-%i-%@%i%i", pageIndex, source.title, indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithId];
    if (!cell) {
      switch (source.type) {
        case EPSourceTypeWiki:
          cell = [[EPWikiCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
          ((EPWikiCell *)cell).sourceLabel.text = source.sourceURLText;
          break;
        case EPSourceTypeiCook:
          cell = [[EPICookCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
          ((EPICookCell *)cell).sourceLabel.text = source.sourceURLText;
          break;
        case  EPSourceTypeInstagram:
          cell = [[EPSourceImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
          ((EPSourceImageCell *)cell).sourceLabel.text = source.sourceURLText;
          break;
        case EPSourceTypeYKnowledge:
          cell = [[EPAttributedSourceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
          ((EPAttributedSourceCell *)cell).sourceLabel.text = source.sourceURLText;
        default:
          break;
      }
      cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text = source.title;
    cell.detailTextLabel.text = source.detail;
    
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:source.imageURL] placeholderImage:[UIImage imageNamed:@"CellDefaultImage"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
      UITableViewCell *currentLoadingCell = (UITableViewCell *)[tempSelf.tableView cellForRowAtIndexPath:tempIndexPath];
      currentLoadingCell.imageView.image = image;
      [currentLoadingCell setNeedsLayout];
      
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
      // Handle error
    }];
    return cell;
  }
  
  NSMutableString *cellWithId = [NSMutableString stringWithFormat:@"cell%@%i%i", @"term", indexPath.section, indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  cell.textLabel.text = @"Text";
  cell.detailTextLabel.text = @"Detail";
  
  return cell;
}

#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (tableView == self.tableView) {
    
    EPTerm *key = [self.information.terms objectAtIndex:tableView.tag];
    // Check data
    EPSource *source  =  [key.sources objectAtIndex:indexPath.row];

    NSString *imageURL = source.imageURL.absoluteString;
    if (NIIsStringWithAnyText(imageURL)) {
      if ([cell isKindOfClass:[EPSourceImageCell class]]) {
        [self requestImageRequestProgressFromCell:cell indexPath:indexPath imageURL:imageURL];
      } else {
        [self requestImageFromCell:cell indexPath:indexPath imageURL:imageURL];
      }
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (tableView == self.termBrowseTableView) {
    return 44.f;
  }
  
  EPTerm *key = [self.information.terms objectAtIndex:tableView.tag];
  // Check data
  EPSource *source  =  [key.sources objectAtIndex:indexPath.row];
  switch (source.type) {
    case EPSourceTypeWiki:
      return [EPWikiCell cellHeight];
      break;
    case EPSourceTypeiCook:
      return [EPICookCell cellHeight:source.title detail:source.detail];
      break;
    case  EPSourceTypeInstagram:
      return [EPSourceImageCell cellHeight:source.title detail:source.detail];
      break;
    case EPSourceTypeYKnowledge:
      return [EPAttributedSourceCell cellHeight:source.title detail:source.detail];
    default:
      break;
  }
  return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
  currentCell.selected = NO;
  
  if (tableView == self.termBrowseTableView) {
    [self.headerCarousel scrollToItemAtIndex:indexPath.row + kCountAbout + kCountHome animated:YES];
  } else {
    EPTerm *key = [self.information.terms objectAtIndex:tableView.tag];
    // Check data
    EPSource *source  =  [key.sources objectAtIndex:indexPath.row];
    
    EPWebViewController *webController = [[EPWebViewController alloc] init];
    [webController openURL:source.URL];
    [self.navigationController pushViewController:webController animated:YES];
  }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  if (self.pagingScrollView.centerPageIndex >= kCountAbout + kCountHome) {
    // No hide
  } else {
    self.searchButton.hidden = YES;
    self.buttonSectionsView.hidden = YES;
  }
  
  
  
  
}

#pragma mark - EPSearchKeywordViewControllerDelegate

- (void)searchKeywordViewController:(EPSearchKeywordViewController *)searchKeywordViewController didFinishEnterSearchKeyword:(NSString *)searchKeyword {
  [searchKeywordViewController dismissModalViewControllerAnimated:YES];
  
  self.queryViewController.queryType = EPQueryTypeInput;
  self.queryViewController.delegate = self;
  [self.queryViewController.keywords addObject:searchKeyword];
  self.queryViewController.needTranslate = NO;
  
  [self.queryViewController performSearch];
  [self.navigationController presentPopupViewController:self.queryViewController animationType:MJPopupViewAnimationSlideBottomTop];
}

#pragma mark - EPQueryViewControllerDelegate

- (void)queryViewController:(EPQueryViewController *)queryViewController didCancelhWithQuery:(NSString *)searchKeyword {
  [self.navigationController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}

- (void)queryViewController:(EPQueryViewController *)queryViewController didFinishWithQuery:(NSString *)searchKeyword canEat:(BOOL)canEat {
  
  // Saving result
  EPTerm *term = [self retrieveTermFromName:searchKeyword];
  if (!term) {
    term = [[EPTerm alloc] init];
    term.name = searchKeyword;
    [self.information.terms addObject:term];
    [self saveContentData];
  } else {
    NIDPRINT(@"Already exist");
  }
  
  [self.termBrowseTableView reloadData];
  [self.headerCarousel reloadData];
  [self.pagingScrollView reloadData];
  
  // Scroll to last one
  [self.headerCarousel scrollToItemAtIndex:self.headerCarousel.numberOfItems animated:YES];
  [self.navigationController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
}

- (void)queryViewController:(EPQueryViewController *)queryViewController retryWithSearching:(NSString *)searchKeyword {
  [self.navigationController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
  [self.navigationController presentModalViewController:self.searchKeywordViewController animated:NO];
}


#pragma mark - EPIQEnginesViewControllerDelegate

- (void)iqEnginesViewController:(EPIQEnginesViewController *)iqEnginesViewController didFinishWithLabels:(NSArray *)labelsArray{
  NSLog(@"Labels:%@",labelsArray);
  EPQueryViewController* imageQueryViewController = [[EPQueryViewController alloc] initWithKeywords:labelsArray];
  imageQueryViewController.queryType = EPQueryTypeCamera;
  imageQueryViewController.delegate = self;
  [imageQueryViewController performSearch];
  [self.navigationController presentPopupViewController:imageQueryViewController animationType:MJPopupViewAnimationSlideBottomTop];
  
}


@end
