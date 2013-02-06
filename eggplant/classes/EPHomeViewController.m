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

@interface EPHomeViewController ()

@end

@implementation EPHomeViewController

CGFloat adjustX = 0;
CGFloat spacing = 80;
CGFloat backViewHeight = 30;
CGFloat smallMoving = 25;

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
  __weak typeof(self) weakSelf = self;
  [self.cameraButton addEventHandler:^(id sender) {
    [tempSelf foldSearchButtonsWithCurrentButton:tempSelf.searchButton];
    EPIQEnginesViewController *iqEngineViewController = [[EPIQEnginesViewController alloc] initWithNibName:nil bundle:nil];
    iqEngineViewController.delegate = weakSelf;
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
  // Finish, save
  NSMutableDictionary *termsUserSavedDictData = [[EPTermsStorageManager defaultManager] termsFromUserSaved];
  [termsUserSavedDictData setObject:self.contentDictData forKey:@"term"];
  [[EPTermsStorageManager defaultManager] save];
}

- (void)performTranslateInstagramTerm:(NSString *)searchingTerm withDataDict:(NSMutableDictionary *)termWithDataDict {
  __block EPHomeViewController *tempSelf = self;
  __block NSMutableDictionary *tempTermWithDataDict = termWithDataDict;
  
  // Chinse term to English Term show wiki
  self.privateTranslateModel.keyword = searchingTerm;
  self.privateTranslateModel.sourceLang = @"zh-TW";
  self.privateTranslateModel.targetLang = @"en";
  [self.privateTranslateModel loadMore:NO didFinishLoad:^{
    [tempSelf performInstagramAPISearhTerm:tempSelf.privateTranslateModel.targetLang withDataDict:tempTermWithDataDict];
  } loadWithError:^(NSError *error) {
    // Handle Error
  }];
}

- (void)performWikiSearchTerm:(NSString *)searchingTerm withDataDict:(NSMutableDictionary *)termWithDataDict {
  
  __block EPHomeViewController *tempSelf = self;
  __block NSMutableDictionary *tempTermWithDataDict = termWithDataDict;
  
  // Chinse term to English Term show wiki
  self.privateTranslateModel.keyword = searchingTerm;
  self.privateTranslateModel.sourceLang = @"zh-TW";
  self.privateTranslateModel.targetLang = @"en";
  [self.privateTranslateModel loadMore:NO didFinishLoad:^{
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *recipeDict = [[NSMutableDictionary alloc] init];
    [recipeDict setObject:@"wiki" forKey:@"type"];
    [recipeDict setObject:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", tempSelf.privateTranslateModel.keywordTranslation] forKey:@"url"];
    [recipeDict setObject:tempSelf.privateTranslateModel.keywordTranslation forKey:@"title"];
    [recipeDict setObject:@"wikipedia.org" forKey:@"sourceURL"];
    float randomNum = arc4random() % 100;
    [recipeDict setObject:[NSNumber numberWithFloat:randomNum] forKey:@"randomNum"];
    
    [sources addObject:recipeDict];
    
    // Add to data
    NSMutableArray *sourcesOriginal = [tempTermWithDataDict objectForKey:@"sources"];
    if (!sourcesOriginal) {
      sourcesOriginal = [[NSMutableArray alloc] init];
    }
    [sourcesOriginal addObjectsFromArray:sources];
    [tempTermWithDataDict setObject:sourcesOriginal forKey:@"sources"];
    
    // TODO: Save
    
    [tempSelf.tableView reloadData];
  } loadWithError:^(NSError *error) {
    // Handle Error
  }];
}

- (void)performiCookSearchTerm:(NSString *)searchingTerm withDataDict:(NSMutableDictionary *)termWithDataDict {
  // YKNowledge
  __block EPHomeViewController *tempSelf = self;
  __block NSMutableDictionary *tempTermWithDataDict = termWithDataDict;
  self.recipesSearchModel.text = searchingTerm;
  [self.recipesSearchModel loadMore:NO didFinishLoad:^{
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    for (ICRecipe *eachRecipe in tempSelf.recipesSearchModel.recipes) {
      NSMutableDictionary *recipeDict = [[NSMutableDictionary alloc] init];
      [recipeDict setObject:@"icook" forKey:@"type"];
      [recipeDict setObject:[NSString stringWithFormat:@"http://icook.tw/recipes/%i", eachRecipe.objectID] forKey:@"url"];
      [recipeDict setObject:eachRecipe.name forKey:@"title"];
      [recipeDict setObject:eachRecipe.recipeDescription forKey:@"detail"];
      [recipeDict setObject:@"icook.tw" forKey:@"sourceURL"];
      if (NIIsStringWithAnyText(eachRecipe.photos.smallURL.absoluteString)) {
        [recipeDict setObject:eachRecipe.photos.smallURL.absoluteString forKey:@"imageURL"];
      }
      
      float randomNum = arc4random() % 100;
      [recipeDict setObject:[NSNumber numberWithFloat:randomNum] forKey:@"randomNum"];
      
      [sources addObject:recipeDict];
    }
    
    // Add to data
    NSMutableArray *sourcesOriginal = [tempTermWithDataDict objectForKey:@"sources"];
    if (!sourcesOriginal) {
      sourcesOriginal = [[NSMutableArray alloc] init];
    }
    [sourcesOriginal addObjectsFromArray:sources];
    [tempTermWithDataDict setObject:sourcesOriginal forKey:@"sources"];
    
    NSMutableArray *newSortedArray = [tempSelf sortByRandomNum:tempTermWithDataDict];
    [tempTermWithDataDict setObject:newSortedArray forKey:@"sources"];
    
    // TODO: Save
    
    [tempSelf.tableView reloadData];
  } loadWithError:^(NSError *error) {
    // Handle Error
  }];
}

- (void)performInstagramAPISearhTerm:(NSString *)searchingTerm withDataDict:(NSMutableDictionary *)termWithDataDict {
  // YKNowledge
  __block EPHomeViewController *tempSelf = self;
  __block NSMutableDictionary *tempTermWithDataDict = termWithDataDict;
  self.instgramTagsMediaModel.keyword = searchingTerm;
  [self.instgramTagsMediaModel loadMore:NO didFinishLoad:^{
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    for (EPInstagram *eachInstagram in tempSelf.instgramTagsMediaModel.instagrams) {
      NSMutableDictionary *knowDict = [[NSMutableDictionary alloc] init];
      [knowDict setObject:@"instagram" forKey:@"type"];
      [knowDict setObject:eachInstagram.link.absoluteString forKey:@"url"];
      [knowDict setObject:@"instagr.am" forKey:@"sourceURL"];
      float randomNum = arc4random() % 100;
      [knowDict setObject:[NSNumber numberWithFloat:randomNum] forKey:@"randomNum"];
      
      for (NSString *key in eachInstagram.images.keyEnumerator.allObjects) {
        EPImage *eachImage = [eachInstagram.images objectForKey:key];
        if (eachImage.imageType == EPImageTypeThumbnail) {
          NIDPRINT(@"EPImageTypeThumbnail eachImage.url.absoluteString: %@", eachImage.url.absoluteString);
          [knowDict setObject:eachImage.url.absoluteString forKey:@"imageURL"];
        }
      }
      
      [sources addObject:knowDict];
    }
    
    // Add to data
    NSMutableArray *sourcesOriginal = [tempTermWithDataDict objectForKey:@"sources"];
    if (!sourcesOriginal) {
      sourcesOriginal = [[NSMutableArray alloc] init];
    }
    [sourcesOriginal addObjectsFromArray:sources];
    [tempTermWithDataDict setObject:sourcesOriginal forKey:@"sources"];
    
    NSMutableArray *newSortedArray = [tempSelf sortByRandomNum:tempTermWithDataDict];
    [tempTermWithDataDict setObject:newSortedArray forKey:@"sources"];
    // TODO: Save
    
    [tempSelf.tableView reloadData];
  } loadWithError:^(NSError *error) {
    // Handle Error
  }];
}

- (void)performYKAPISearhTerm:(NSString *)searchingTerm withDataDict:(NSMutableDictionary *)termWithDataDict {
    // YKNowledge
    __block EPHomeViewController *tempSelf = self;
    __block NSMutableDictionary *tempTermWithDataDict = termWithDataDict;
    self.yknowledgeSearchModel.keywords = searchingTerm;
    [self.yknowledgeSearchModel loadMore:NO didFinishLoad:^{
        NSMutableArray *sources = [[NSMutableArray alloc] init];
        for (EPYKnowledge *eachKnow in tempSelf.yknowledgeSearchModel.knowledges) {
            NSMutableDictionary *knowDict = [[NSMutableDictionary alloc] init];
            [knowDict setObject:@"YKnowledge" forKey:@"type"];
            [knowDict setObject:eachKnow.url.absoluteString forKey:@"url"];
            [knowDict setObject:eachKnow.subject forKey:@"title"];
            [knowDict setObject:eachKnow.content forKey:@"detail"];
            [knowDict setObject:@"knowledge.yahoo.com.tw" forKey:@"sourceURL"];
          float randomNum = arc4random() % 100;
          [knowDict setObject:[NSNumber numberWithFloat:randomNum] forKey:@"randomNum"];
            
            [sources addObject:knowDict];
        }
        
        // Add to data
        NSMutableArray *sourcesOriginal = [tempTermWithDataDict objectForKey:@"sources"];
        if (!sourcesOriginal) {
            sourcesOriginal = [[NSMutableArray alloc] init];
        }
        [sourcesOriginal addObjectsFromArray:sources];
      
      
        [tempTermWithDataDict setObject:sourcesOriginal forKey:@"sources"];
      
      
      NSMutableArray *newSortedArray = [tempSelf sortByRandomNum:tempTermWithDataDict];
      sourcesOriginal = newSortedArray;
        // TODO: Save
      
      
      // From original root find this source, set, save
      
      
        [tempSelf.tableView reloadData];
    } loadWithError:^(NSError *error) {
        // Handle Error
    }];
}

- (NSMutableArray *)sortByRandomNum:(NSMutableDictionary *)termWithDataDict {
    // Sort
  NSArray *newSortedArray =  [[termWithDataDict objectForKey:@"sources"] sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        NSNumber *p1 = [obj1 objectForKey:@"randomNum"];
        NSNumber *p2 = [obj2 objectForKey:@"randomNum"];
        
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

- (void)checkPerpareQueryAPIData:(NSString *)searchingTerm {

  // Check if has term
  NSMutableDictionary *termWithDataDict = nil;
  for (NSMutableDictionary *eachDict in self.contentDictData) {
    if ([eachDict objectForKey:@"key"] && [[eachDict objectForKey:@"key"] isEqualToString:searchingTerm]) {
      termWithDataDict = eachDict;
    }
  }
  
  NSMutableArray *sources = [termWithDataDict objectForKey:@"sources"];
  
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
  for (NSDictionary *eachSource in sources) {
    if ([[eachSource objectForKey:@"type"] isEqualToString:@"icook"]) {
      hasiCook = YES;
    }
  }
  if (!hasiCook) {
    [self performiCookSearchTerm:searchingTerm withDataDict:termWithDataDict];
  }
  
  // Start with hasYKnowledge
  BOOL hasYKnowledge = NO;
  for (NSDictionary *eachSource in sources) {
    if ([[eachSource objectForKey:@"type"] isEqualToString:@"YKnowledge"]) {
      hasYKnowledge = YES;
    }
  }
  if (!hasYKnowledge) {
    [self performYKAPISearhTerm:searchingTerm withDataDict:termWithDataDict];
  }
  
  // Start with Instagram
  BOOL hasInstagram = NO;
  for (NSDictionary *eachSource in sources) {
    if ([[eachSource objectForKey:@"type"] isEqualToString:@"instagram"]) {
      hasInstagram = YES;
    }
  }
  if (!hasInstagram) {
    [self performInstagramAPISearhTerm:searchingTerm withDataDict:termWithDataDict];
  }
  
  // Final saved
  
  
  // Call at the end
//  [self.pagingScrollView reloadData];
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

- (NSArray *)sourceWithGivenDefaultDataSet:(NSInteger)pageIndex {
  NSArray *sources;
  if (pageIndex < self.headerTermKeys.count) {
    
    NSString *key = [self.headerTermKeys objectAtIndex:(pageIndex)];
    // Check data
    
    for (NSDictionary *eachDataTerm  in self.contentDictData) {
      if ([[eachDataTerm objectForKey:@"key"] isEqualToString:key]) {
        sources = [eachDataTerm objectForKey:@"sources"];
        break;
      }
    }
  }
  return sources;
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
  
  NSMutableDictionary *termsFromSavedRoot = [[EPTermsStorageManager defaultManager] termsFromUserSaved];
  NSMutableArray *termsFromSavedKeys = [termsFromSavedRoot objectForKey:@"termKeys"];
  
  if (termsFromSavedKeys.count == 0) {
    NSDictionary *termDataFromDefault = [[EPTermsStorageManager defaultManager] termsFromDefault];
    NSArray *termsFromDefaultKeys = [termDataFromDefault objectForKey:@"termKeys"];
    self.headerTermKeys = [termsFromDefaultKeys copy];
    self.contentDictData = [NSMutableArray arrayWithArray:[termDataFromDefault objectForKey:@"terms"]];
    
    [termsFromSavedRoot setObject:self.headerTermKeys forKey:@"termKeys"];
    [termsFromSavedRoot setObject:self.contentDictData forKey:@"terms"];
    [[EPTermsStorageManager defaultManager] save];
  }
  
  // Load again
  [[EPTermsStorageManager defaultManager] load];
  termsFromSavedRoot = [[EPTermsStorageManager defaultManager] termsFromUserSaved];
  termsFromSavedKeys = [termsFromSavedRoot objectForKey:@"termKeys"];
  
  self.headerTermKeys = termsFromSavedKeys;
  self.contentDictData = [termsFromSavedRoot objectForKey:@"terms"];
  
  [self.headerCarousel reloadData];
  [self.pagingScrollView reloadData];
  
  if (self.headerTermKeys.count > 0) {
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
    NSInteger numberOfitems = kCountAbout + kCountHome + self.headerTermKeys.count;
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
    NSInteger termSavedIndex = termIndex - self.contentDictData.count -1;
    
    NIDPRINT(@"iCarousel viewForItemAtIndex termIndex %i", termIndex);
    NIDPRINT(@"iCarousel viewForItemAtIndex termSavedIndex %i", termSavedIndex);
    
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
    if (termIndex >= 0 &&  termIndex < self.headerTermKeys.count) {
      NSString *termFromDefault = [self.headerTermKeys objectAtIndex:(termIndex)];
      sectionHeaderLabel.text = termFromDefault;
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
  return kCountAbout + kCountHome + self.headerTermKeys.count;
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
      coverLabel.text = @"Edward's WikiIngredients";
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
      if (termIndex < self.headerTermKeys.count) {
        NSString *termFromDefault = [self.headerTermKeys objectAtIndex:(termIndex)];
        _tableView = [self dequeueReusableTableViewWithIdentifier:[NSString stringWithFormat:@"TableViewID%@", termFromDefault]];
        _tableView = [[UITableView alloc] init];
        _tableView.tag = termIndex;
        _tableView.frame = contentHeaderView.frame;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [contentHeaderView addSubview:_tableView];
        
        // if empty need to loading
        [self checkPerpareQueryAPIData:[self.headerTermKeys objectAtIndex:termIndex]];
        
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
    return self.headerTermKeys.count;
  }
  
  NSInteger pageIndex = tableView.tag;
  NSArray *sources = [self sourceWithGivenDefaultDataSet:pageIndex];
  if (sources.count > 0) {
    return sources.count;
  }
  
  NSInteger numberOfRows = 0;
  return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  __block EPHomeViewController *tempSelf = self;
  __block NSIndexPath *tempIndexPath = indexPath;
  
  // Home
  if (tableView == self.termBrowseTableView) {
    NSString *term = [self.headerTermKeys objectAtIndex:indexPath.row];
    NSString *CellWithIdentifier = [NSString stringWithFormat:@"term%@", term];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = term;
    return cell;
  }
  
  NSInteger pageIndex = tableView.tag;
  if (pageIndex < self.headerTermKeys.count) {
    
    NSString *key = [self.headerTermKeys objectAtIndex:(pageIndex)];
    // Check data
    
    for (NSDictionary *eachDataTerm  in self.contentDictData) {
      if ([[eachDataTerm objectForKey:@"key"] isEqualToString:key]) {
        NSDictionary *currentSource = [[eachDataTerm objectForKey:@"sources"] objectAtIndex:indexPath.row];
        NSString *title = [currentSource objectForKey:@"title"];
        
        NSMutableString *cellWithId = [NSMutableString stringWithFormat:@"cell-%i-%@%i%i", pageIndex, title, indexPath.section, indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithId];
        if (!cell) {
          NSString *sourceType = [currentSource objectForKey:@"type"];
          if ([sourceType isEqualToString:@"wiki"]) {
            cell = [[EPWikiCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
            ((EPWikiCell *)cell).sourceLabel.text = [currentSource objectForKey:@"sourceURL"];
          } else if ([sourceType isEqualToString:@"icook"]) {
            cell = [[EPICookCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
            ((EPICookCell *)cell).sourceLabel.text = [currentSource objectForKey:@"sourceURL"];
          } else if ([sourceType isEqualToString:@"instagram"]) {
            cell = [[EPSourceImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
            ((EPSourceImageCell *)cell).sourceLabel.text = [currentSource objectForKey:@"sourceURL"];
          } else if ([sourceType isEqualToString:@"YKnowledge"]) {
            cell = [[EPAttributedSourceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
            ((EPAttributedSourceCell *)cell).sourceLabel.text = [currentSource objectForKey:@"sourceURL"];
          } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellWithId];
            
          }
          cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        cell.textLabel.text = title;
        cell.detailTextLabel.text = [currentSource objectForKey:@"detail"];
        
        [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[currentSource objectForKey:@"imageURL"]]] placeholderImage:[UIImage imageNamed:@"CellDefaultImage"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
          UITableViewCell *currentLoadingCell = (UITableViewCell *)[tempSelf.tableView cellForRowAtIndexPath:tempIndexPath];
          currentLoadingCell.imageView.image = image;
          [currentLoadingCell setNeedsLayout];
          
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
          // Handle error
        }];
        return cell;
      }
      
      
      
    }
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
    NSArray *currentSourceArray = [self sourceWithGivenDefaultDataSet:tableView.tag];
    NSDictionary *currentSource = [currentSourceArray objectAtIndex:indexPath.row];
    
    NSString *imageURL = [currentSource objectForKey:@"imageURL"];
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
  
  NSInteger pageIndex = tableView.tag;
  if (pageIndex < self.headerTermKeys.count) {
    NSString *key = [self.headerTermKeys objectAtIndex:(pageIndex)];
    // Check data
    for (NSDictionary *eachDataTerm  in self.contentDictData) {
      if ([[eachDataTerm objectForKey:@"key"] isEqualToString:key]) {
        NSDictionary *currentSource = [[eachDataTerm objectForKey:@"sources"] objectAtIndex:indexPath.row];
        NSString *sourceType = [currentSource objectForKey:@"type"];
        if ([sourceType isEqualToString:@"wiki"]) {
          return [EPWikiCell cellHeight];
        } else if ([sourceType isEqualToString:@"icook"]) {
          return [EPICookCell cellHeight:[currentSource objectForKey:@"title"] detail:[currentSource objectForKey:@"detail"]];
        } else if ([sourceType isEqualToString:@"instagram"]) {
          return [EPSourceImageCell cellHeight:[currentSource objectForKey:@"title"] detail:[currentSource objectForKey:@"detail"]];
        } else if ([sourceType isEqualToString:@"YKnowledge"]) {
          return [EPAttributedSourceCell cellHeight:[currentSource objectForKey:@"title"] detail:[currentSource objectForKey:@"detail"]];
        }
      }
    }
  }
  return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
  currentCell.selected = NO;
  
  if (tableView == self.termBrowseTableView) {
    [self.headerCarousel scrollToItemAtIndex:indexPath.row + kCountAbout + kCountHome animated:YES];
  } else {
    NSArray *currentSourceArray = [self sourceWithGivenDefaultDataSet:tableView.tag];
    NSDictionary *currentSource = [currentSourceArray objectAtIndex:indexPath.row];
    if ([currentSource objectForKey:@"url"]) {
      NSURL *openURL = [NSURL URLWithString:[currentSource objectForKey:@"url"]];
      EPWebViewController *webController = [[EPWebViewController alloc] init];
      [webController openURL:openURL];
      [self.navigationController pushViewController:webController animated:YES];
    }
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
  if (![self.headerTermKeys containsObject:searchKeyword]) {
    [self.headerTermKeys addObject:searchKeyword];
    
    NSMutableDictionary *termWithDataDict = [[NSMutableDictionary alloc] init];
    [termWithDataDict setObject:searchKeyword forKey:@"key"];
    [self.contentDictData addObject:termWithDataDict];
    
    [[EPTermsStorageManager defaultManager] load];
    NSMutableDictionary *termsUserSavedDictData = [[EPTermsStorageManager defaultManager] termsFromUserSaved];
    [termsUserSavedDictData setObject:self.headerTermKeys forKey:@"termKeys"];
    [termsUserSavedDictData setObject:self.contentDictData forKey:@"terms"];
    [[EPTermsStorageManager defaultManager] save];
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
