//
//  DDNewPeopleBelongPunishCell.h
//  GongChengDD
//
//  Created by hou qiangqiang on 2019/1/22.
//  Copyright © 2019 Koncendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPeopleBelongPunishModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDNewPeopleBelongPunishCell : UITableViewCell
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *relativeLab1;
@property (strong, nonatomic) UILabel *relativeLab2;
@property (strong, nonatomic) UILabel *fireLab1;
@property (strong, nonatomic) UILabel *fireLab2;
@property (strong, nonatomic) UILabel *kindLab1;
@property (strong, nonatomic) UILabel *kindLab2;
@property (strong, nonatomic) UILabel *deptLab1;
@property (strong, nonatomic) UILabel *deptLab2;
@property (strong, nonatomic) UILabel *timeLab1;
@property (strong, nonatomic) UILabel *timeLab2;

//加载数据
-(void)loadDataWithModel:(DDPeopleBelongPunishModel *)model;
@end

NS_ASSUME_NONNULL_END
