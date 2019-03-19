//
//  DDProjectListCell.h
//  GongChengDD
//
//  Created by xzx on 2018/5/23.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchProjectListModel.h"

@interface DDProjectListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *winLab;
@property (weak, nonatomic) IBOutlet UILabel *winBiddingLab;
@property (weak, nonatomic) IBOutlet UIButton *winBiddingBtn;
@property (weak, nonatomic) IBOutlet UILabel *managerLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UILabel *biddingPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *launchLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;

-(void)loadDataWithModel:(DDSearchProjectListModel *)model;

@end
