//
//  EPDataSourceObject.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/18.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPDataSourceObject.h"

@implementation EPDataSourceObject

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSMutableString *cellWithId = [NSMutableString stringWithFormat:@"cell%@%i%i", @"term", indexPath.section, indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellWithId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  cell.textLabel.text = @"Text";
  cell.detailTextLabel.text = @"Detail";
  
  return cell;
}

@end
