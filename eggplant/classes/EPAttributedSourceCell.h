//
//  EPAttributedSourceCell.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPSourceCell.h"
#import "NIAttributedLabel.h"

@interface EPAttributedSourceCell : EPSourceCell

@property (nonatomic, strong) NIAttributedLabel *titleAttributedLabel;
@property (nonatomic, strong) NIAttributedLabel *detailAttributedLabel;

@end
