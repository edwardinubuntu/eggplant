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
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NIDPRINT(@"Searching Text :%@", searchBar.text);
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(searchKeywordViewController:didinishEnterSearchKeyword:)]) {
    [self.delegate searchKeywordViewController:self didinishEnterSearchKeyword:searchBar.text];
  }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//  [self loadKeyword];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
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

@end
