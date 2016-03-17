//
//  PTTableViewCell.m
//  tableViewOfLocalPhotos
//
//  Created by change009 on 16/3/15.
//  Copyright © 2016年 change009. All rights reserved.
//

#import "PTTableViewCell.h"

@implementation PTTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
