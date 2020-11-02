//
//  HomeCell.h
//  RFTestDemo
//
//  Created by linitial on 2018/3/29.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCellViewModel.h"
#import "RFReactView.h"

@interface HomeCell : UITableViewCell<RFReactView>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;


@end
