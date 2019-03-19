//
//  DDTelephoneListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/6/13.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchTelephoneListModel.h"

@interface DDTelephoneListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *peopleLab1;
@property (weak, nonatomic) IBOutlet UILabel *peopleLab2;
@property (weak, nonatomic) IBOutlet UILabel *telLab1;
@property (weak, nonatomic) IBOutlet UILabel *telLab2;
@property (weak, nonatomic) IBOutlet UIButton *telBtn;

-(void)loadDataWithModel:(DDSearchTelephoneListModel *)model;

@end
