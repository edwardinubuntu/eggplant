//
//  EPSearchKeywordViewController.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPSearchKeywordViewController.h"

@interface EPSearchKeywordViewController ()

@end

@implementation EPSearchKeywordViewController

#define kLoadingTermsDelay  1
#define kSectionIndexTerms 0

- (void)loadView {
  [super loadView];
  _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.f)];
  self.searchBar.delegate = self;
  self.searchBar.placeholder = NSLocalizedString(@"Search Placeholder", @"Search") ;
  for (id img in _searchBar.subviews) {
    if ([img isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
      [img removeFromSuperview];
    }
  }
  
  _searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
  _searchDisplay.delegate = self;
  _searchDisplay.searchResultsDataSource = self;
  _searchDisplay.searchResultsTableView.delegate = self;
  
  [self.view addSubview:self.searchBar];
  _termModel = [[ICIngredientTermModel alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.searchBar.text = nil;
  [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return 1;
  } else {
    // Return the number of sections.
    return 0;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    if (section == kSectionIndexTerms) {
      if (_isLoadingTermModel) {
        return 0;
      }
      if (self.termModel.ingredientTerms.count > 5) {
        return 5;
      } else {
        return self.termModel.ingredientTerms.count;
      }
    } 
  }

  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // Configure the cell...
  if (tableView == self.searchDisplayController.searchResultsTableView && indexPath.section == kSectionIndexTerms) {
    if (indexPath.row < self.termModel.ingredientTerms.count) {
      ICIngredientTerm *term = (ICIngredientTerm *)[self.termModel.ingredientTerms objectAtIndex:indexPath.row];
      NSString *Identifier = [NSString stringWithFormat:@"Term%@", term.name];
      UITableViewCell *keywordCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
      if (!keywordCell) {
        keywordCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        keywordCell.textLabel.text = term.name;
      }
      keywordCell.textLabel.backgroundColor = [UIColor clearColor ];
      keywordCell.selectionStyle = UITableViewCellSelectionStyleGray;
      
      return keywordCell;
      
    } else if (_isLoadingTermModel) {
      NSString *Identifier = @"Loading";
      UITableViewCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
      if (!loadingCell) {
        loadingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
      }
      return loadingCell;
    }
  }

  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
  
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NIDPRINT(@"Searching Text :%@", cell.textLabel.text);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchKeywordViewController:didFinishEnterSearchKeyword:)]) {
      [self.delegate searchKeywordViewController:self didFinishEnterSearchKeyword:cell.textLabel.text];
    }

  }

}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NIDPRINT(@"Searching Text :%@", searchBar.text);
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(searchKeywordViewController:didFinishEnterSearchKeyword:)]) {
    [self.delegate searchKeywordViewController:self didFinishEnterSearchKeyword:searchBar.text];
  }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//  [self loadKeyword];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  [self.termModel.ingredientTerms removeAllObjects];
  if (_timerToLoadTerm) {
    [_timerToLoadTerm invalidate];
  }
  _timerToLoadTerm = [NSTimer scheduledTimerWithTimeInterval:kLoadingTermsDelay target:self selector:@selector(loadIntredientTermFromSearchBarText) userInfo:nil repeats:NO];
  
//  [self.termModel.ingredientTerms removeAllObjects];
//  if (_timerToLoadTerm) {
//    [_timerToLoadTerm invalidate];
//  }
//  _timerToLoadTerm = [NSTimer scheduledTimerWithTimeInterval:kLoadingTermsDelay target:self selector:@selector(loadIntredientTermFromSearchBarText) userInfo:nil repeats:NO];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
  
  _searchBar.showsCancelButton = YES;
  //Iterate the searchbar sub views
//  for (UIView *subView in _searchBar.subviews) {
//    //Find the button
//    if([subView isKindOfClass:[UIButton class]])
//    {
//      //Change its properties
//      UIButton *cancelButton = (UIButton *)[_searchBar.subviews lastObject];
//      if ([cancelButton respondsToSelector:@selector(setBackgroundImage:forState:)]){
//        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 6, 7, 6)] forState:UIControlStateNormal ];
//        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"buttonPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 6, 7, 6)] forState:UIControlStateHighlighted ];
//      }
//      //cancelButton.titleLabel.text = @"Changed";
//    }
//  }
  
  return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  [self dismissModalViewControllerAnimated:YES];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
  [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
  UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
  sectionHeader.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SerachTableSectionHeader"]];
  UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 300, 20)];
  
  sectionTitle.font = [UIFont boldSystemFontOfSize:16];
  sectionTitle.backgroundColor = [UIColor clearColor];
  sectionTitle.textColor = [UIColor whiteColor];
  sectionTitle.shadowColor = [UIColor grayColor];
  sectionTitle.shadowOffset = CGSizeMake(0, -1.0);
  sectionTitle.textAlignment = UITextAlignmentLeft;
  
  sectionTitle.text = nil;
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    if (section == kSectionIndexTerms) {
      sectionTitle.text = @"推薦搜尋";
    }
  }
  
  
  [sectionHeader addSubview:sectionTitle];
  return sectionHeader;
  
}

- (void)loadIntredientTermFromSearchBarText {
  [self loadIntredientTerm:self.searchBar.text];
}

- (void)loadIntredientTerm:(NSString*)text {
  
  if (!NIIsStringWithAnyText(text)) {
    return;
  }
  _isLoadingTermModel = YES;
  NSIndexSet *indextSet = [NSIndexSet indexSetWithIndex:kSectionIndexTerms];
  [self.searchDisplayController.searchResultsTableView reloadSections:indextSet withRowAnimation:UITableViewRowAnimationAutomatic];
  
  self.termModel.term = text;
  __block EPSearchKeywordViewController *tempSelf = self;
  [self.termModel loadMore:NO didFinishLoad:^{
    _isLoadingTermModel = NO;
    if (tempSelf.termModel.ingredientTerms.count > 0) {
      NSIndexSet *indextSet = [NSIndexSet indexSetWithIndex:kSectionIndexTerms];
      [tempSelf.searchDisplayController.searchResultsTableView reloadSections:indextSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
  } loadWithError:^(NSError *error) {
    // Handle error
    _isLoadingTermModel = NO;
  }];
}


@end
