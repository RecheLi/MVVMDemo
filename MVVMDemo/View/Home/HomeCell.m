//
//  HomeCell.m
//  RFTestDemo
//
//  Created by linitial on 2018/3/29.
//  Copyright © 2018年 redfinge. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell()

@property (nonatomic , readwrite , strong) HomeCellViewModel *viewModel;

@end

@implementation HomeCell

- (void)bindViewModel:(HomeCellViewModel *)viewModel {
    self.viewModel = viewModel;
    self.titleLabel.text = self.viewModel.model.title;
    self.subtitleLabel.text = self.viewModel.model.subtitle;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
