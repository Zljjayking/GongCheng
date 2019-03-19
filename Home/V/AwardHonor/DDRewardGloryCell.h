//
//  DDRewardGloryCell.h
//  GongChengDD
//
//  Created by xzx on 2018/6/4.
//  Copyright © 2018年 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDSearchRewardGloryListModel.h"
#import "DDCultureWorkSiteModel.h"

@interface DDRewardGloryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *rewardLab1;
@property (weak, nonatomic) IBOutlet UILabel *rewardLab2;
@property (weak, nonatomic) IBOutlet UILabel *deptLab1;
@property (weak, nonatomic) IBOutlet UILabel *deptLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;
//获奖荣誉使用
-(void)loadDataWithModel:(DDSearchRewardGloryListModel *)model;
//文明公司,绿色工地,使用
- (void)loadWithCultureWorkSiteModel:(DDCultureWorkSiteModel*)model;

@end
