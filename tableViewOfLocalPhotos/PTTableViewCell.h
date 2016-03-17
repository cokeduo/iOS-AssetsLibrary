//
//  PTTableViewCell.h
//  tableViewOfLocalPhotos
//
//  Created by change009 on 16/3/15.
//  Copyright © 2016年 change009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end
